from __future__ import annotations

import argparse
from contextlib import closing, contextmanager
from datetime import datetime, timezone
from hashlib import pbkdf2_hmac
from hmac import compare_digest
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import re
import secrets
import sqlite3
from urllib.parse import parse_qs

from views import render_dashboard


HERE = Path(__file__).resolve().parent
CODE_PATTERN = re.compile(r"[0-9]{4}")
TRANSITIONS = {
    "collect": (frozenset({"assigned"}), "collected"),
    "deliver": (frozenset({"collected"}), "delivered"),
    "fail": (frozenset({"assigned", "collected"}), "failed"),
    "reopen": (frozenset({"failed"}), "pending"),
}
SCHEMA = """
CREATE TABLE IF NOT EXISTS drivers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS deliveries (
    id INTEGER PRIMARY KEY,
    customer TEXT NOT NULL,
    address TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'assigned', 'collected', 'delivered', 'failed')),
    driver_id INTEGER REFERENCES drivers (id),
    code_salt BLOB NOT NULL,
    code_digest BLOB NOT NULL,
    updated_at TEXT NOT NULL,
    CHECK ((status = 'pending' AND driver_id IS NULL) OR (status <> 'pending' AND driver_id IS NOT NULL))
);
CREATE TABLE IF NOT EXISTS delivery_history (
    id INTEGER PRIMARY KEY,
    delivery_id INTEGER NOT NULL REFERENCES deliveries (id),
    action TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    actor TEXT NOT NULL,
    note TEXT NOT NULL,
    occurred_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS delivery_history_by_delivery ON delivery_history (delivery_id, id);
CREATE TABLE IF NOT EXISTS demo_setup (id INTEGER PRIMARY KEY CHECK (id = 1));
"""


class DispatchError(ValueError):
    """A dispatch request was rejected without changing the delivery."""


def timestamp() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def digest_code(salt: bytes, code: str) -> bytes:
    return pbkdf2_hmac("sha256", code.encode("ascii"), salt, 120_000)


def required_text(raw: str | None, field: str, limit: int) -> str:
    value = (raw or "").strip()
    if not value:
        raise DispatchError(f"Enter a {field}.")
    if len(value) > limit:
        raise DispatchError(f"Keep the {field} to {limit} characters or fewer.")
    return value


class DispatchStore:
    def __init__(self, database: Path):
        self.database = database

    @contextmanager
    def connection(self, *, write: bool = False):
        with closing(sqlite3.connect(self.database, timeout=5.0)) as connection, connection:
            connection.row_factory = sqlite3.Row
            connection.execute("PRAGMA foreign_keys = ON")
            if write:
                connection.execute("BEGIN IMMEDIATE")
            yield connection

    def initialize(self, seed: bool = True) -> None:
        with self.connection() as connection:
            connection.executescript(SCHEMA)
        if seed:
            self.seed_demo()

    def seed_demo(self) -> None:
        with self.connection(write=True) as connection:
            seeded = connection.execute("INSERT OR IGNORE INTO demo_setup VALUES (1)")
            if not seeded.rowcount:
                return
            connection.executemany(
                "INSERT INTO drivers (id, name, region) VALUES (?, ?, ?)",
                [(1, "Amina Reed", "North route"), (2, "Leo Santos", "Central route"), (3, "Maya Chen", "West route")],
            )
            fixtures = [
                ("Cedar Community Kitchen", "42 Alder Lane", "2714", ()),
                ("Oak & Finch Books", "11 Larch Row", "1908", ("assign",)),
                ("Juniper Repair Studio", "26 Elm Street", "5831", ("assign", "collect")),
                ("Morrow Flower Shop", "8 Ash Avenue", "6025", ("assign", "collect", "deliver")),
                ("Westfield Print Co.", "17 Birch Court", "9436", ("assign", "fail")),
            ]
            for customer, address, code, actions in fixtures:
                delivery_id = self._create(connection, customer, address, code)
                driver_id = delivery_id % 3 + 1
                for action in actions:
                    if action == "assign":
                        self._assign(connection, delivery_id, driver_id)
                    else:
                        self._advance(connection, delivery_id, action, driver_id, code, "Receiving desk was closed.")

    def drivers(self) -> list[dict]:
        with self.connection() as connection:
            return [dict(row) for row in connection.execute("SELECT * FROM drivers ORDER BY name")]

    def deliveries(self) -> list[dict]:
        with self.connection() as connection:
            rows = connection.execute(
                """
                SELECT deliveries.id, 'DL-' || printf('%04d', deliveries.id) AS reference,
                    customer, address, status, driver_id, drivers.name AS driver_name, updated_at
                FROM deliveries LEFT JOIN drivers ON drivers.id = deliveries.driver_id
                ORDER BY deliveries.id DESC
                """
            )
            return [dict(row) for row in rows]

    def history(self, delivery_id: int) -> list[dict]:
        with self.connection() as connection:
            self._delivery(connection, delivery_id)
            rows = connection.execute(
                """SELECT action, from_status, to_status, actor, note, occurred_at
                   FROM delivery_history WHERE delivery_id = ? ORDER BY id""",
                (delivery_id,),
            )
            return [dict(row) for row in rows]

    def create(self, customer: str, address: str, confirmation_code: str) -> int:
        customer = required_text(customer, "customer name", 100)
        address = required_text(address, "delivery address", 180)
        if not CODE_PATTERN.fullmatch(confirmation_code or ""):
            raise DispatchError("Enter a four-digit confirmation code.")
        with self.connection(write=True) as connection:
            return self._create(connection, customer, address, confirmation_code)

    def _create(self, connection, customer: str, address: str, code: str) -> int:
        salt = secrets.token_bytes(16)
        now = timestamp()
        cursor = connection.execute(
            """
            INSERT INTO deliveries (customer, address, status, code_salt, code_digest, updated_at)
            VALUES (?, ?, 'pending', ?, ?, ?)
            """,
            (customer, address, salt, digest_code(salt, code), now),
        )
        self._record(connection, cursor.lastrowid, "create", None, "pending", "Dispatcher", "", now)
        return cursor.lastrowid

    def assign(self, delivery_id: int, driver_id: int | None) -> None:
        with self.connection(write=True) as connection:
            self._assign(connection, delivery_id, driver_id)

    def _assign(self, connection, delivery_id: int, driver_id: int | None) -> None:
        delivery = self._delivery(connection, delivery_id)
        if delivery["status"] not in ("pending", "assigned"):
            raise DispatchError("You can assign or change the driver before collection.")
        driver = self._driver(connection, driver_id)
        if delivery["driver_id"] == driver_id:
            raise DispatchError("This driver is already assigned.")
        self._change(connection, delivery, "assign", "assigned", driver_id, "Dispatcher", f"Assigned to {driver['name']}.")

    def advance(self, delivery_id: int, action: str, driver_id: int | None, code: str | None = None,
                note: str | None = None) -> None:
        with self.connection(write=True) as connection:
            self._advance(connection, delivery_id, action, driver_id, code, note)

    def _advance(self, connection, delivery_id: int, action: str, driver_id: int | None,
                 code: str | None, note: str | None) -> None:
        delivery = self._delivery(connection, delivery_id)
        transition = TRANSITIONS.get(action)
        if not transition:
            raise DispatchError("Choose a valid delivery action.")
        from_statuses, to_status = transition
        if delivery["status"] not in from_statuses:
            raise DispatchError(f"This action is unavailable while the delivery is {delivery['status']}.")
        if action == "reopen":
            if driver_id is not None:
                raise DispatchError("A dispatcher must reopen a failed delivery.")
            self._change(connection, delivery, action, to_status, None, "Dispatcher", "Returned to the dispatch queue.")
            return
        if driver_id != delivery["driver_id"]:
            raise DispatchError("Only the assigned driver can update this delivery.")
        driver = self._driver(connection, driver_id)
        event_note = ""
        if action == "deliver":
            if not CODE_PATTERN.fullmatch(code or "") or not compare_digest(
                digest_code(delivery["code_salt"], code), delivery["code_digest"]
            ):
                raise DispatchError("The recipient code does not match. Check it and try again.")
            event_note = "Recipient confirmation accepted."
        elif action == "fail":
            event_note = required_text(note, "failure reason", 220)
        self._change(connection, delivery, action, to_status, driver_id, driver["name"], event_note)

    @staticmethod
    def _delivery(connection, delivery_id: int):
        delivery = connection.execute("SELECT * FROM deliveries WHERE id = ?", (delivery_id,)).fetchone()
        if delivery is None:
            raise DispatchError("Delivery not found.")
        return delivery

    @staticmethod
    def _driver(connection, driver_id: int | None):
        driver = connection.execute("SELECT * FROM drivers WHERE id = ?", (driver_id,)).fetchone()
        if driver is None:
            raise DispatchError("Choose an available driver.")
        return driver

    def _change(self, connection, delivery, action, status, driver_id, actor, note):
        now = timestamp()
        connection.execute(
            "UPDATE deliveries SET status = ?, driver_id = ?, updated_at = ? WHERE id = ?",
            (status, driver_id, now, delivery["id"]),
        )
        self._record(connection, delivery["id"], action, delivery["status"], status, actor, note, now)

    @staticmethod
    def _record(connection, delivery_id, action, from_status, to_status, actor, note, now):
        connection.execute(
            """
            INSERT INTO delivery_history (delivery_id, action, from_status, to_status, actor, note, occurred_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (delivery_id, action, from_status, to_status, actor, note, now),
        )


def parse_id(raw: str) -> int:
    if not re.fullmatch(r"[1-9][0-9]{0,17}", raw):
        raise DispatchError("Choose a valid delivery and driver.")
    return int(raw)


def make_handler(store: DispatchStore):
    csrf_token = secrets.token_urlsafe(32)
    stylesheet = (HERE / "style.css").read_bytes()

    class DispatchHTTPHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            path, _, query_string = self.path.partition("?")
            if path == "/style.css":
                self.respond(HTTPStatus.OK, stylesheet, "text/css; charset=utf-8")
                return
            if path != "/":
                self.send_error(HTTPStatus.NOT_FOUND)
                return
            try:
                query = parse_qs(query_string, max_num_fields=8)
                selected = parse_id(query["delivery"][0]) if "delivery" in query else None
            except ValueError:
                self.send_error(HTTPStatus.BAD_REQUEST)
                return
            self.dashboard(selected, query.get("filter", ["all"])[0])

        def do_POST(self):
            path, _, _ = self.path.partition("?")
            if path not in ("/action", "/delivery"):
                self.send_error(HTTPStatus.NOT_FOUND)
                return
            try:
                length = int(self.headers.get("Content-Length", "0"))
                if not 0 < length <= 8_192 or self.headers.get_content_type() != "application/x-www-form-urlencoded":
                    raise ValueError
                payload = parse_qs(self.rfile.read(length).decode("utf-8"), keep_blank_values=True, max_num_fields=12)
                if any(len(values) != 1 for values in payload.values()):
                    raise ValueError
                form = {key: values[0] for key, values in payload.items()}
            except ValueError:
                self.send_error(HTTPStatus.BAD_REQUEST)
                return
            if not secrets.compare_digest(form.get("csrf", "").encode(), csrf_token.encode()):
                self.send_error(HTTPStatus.FORBIDDEN)
                return

            delivery_id = None
            try:
                if path == "/delivery":
                    delivery_id = store.create(form.get("customer", ""), form.get("address", ""), form.get("confirmation_code", ""))
                else:
                    delivery_id = parse_id(form.get("delivery_id", ""))
                    operation = form.get("operation", "")
                    driver_id = parse_id(form["driver_id"]) if form.get("driver_id") else None
                    if operation == "assign":
                        store.assign(delivery_id, driver_id)
                    else:
                        store.advance(delivery_id, operation, driver_id, form.get("code"), form.get("note"))
            except DispatchError as error:
                self.dashboard(delivery_id, error=str(error), status=HTTPStatus.UNPROCESSABLE_ENTITY)
                return
            self.send_response(HTTPStatus.SEE_OTHER)
            self.send_header("Location", f"/?delivery={delivery_id}")
            self.send_header("Content-Length", "0")
            self.end_headers()

        def dashboard(self, delivery_id=None, selected_filter="all", *, error="", status=HTTPStatus.OK):
            deliveries = store.deliveries()
            selected = next((delivery for delivery in deliveries if delivery["id"] == delivery_id), None)
            if delivery_id is not None and selected is None and not error:
                error = "Delivery not found. Choose one from the queue."
                status = HTTPStatus.NOT_FOUND
            html = render_dashboard(deliveries, store.drivers(), store.history(selected["id"]) if selected else [],
                                    selected, selected_filter, csrf_token, error)
            self.respond(status, html.encode("utf-8"), "text/html; charset=utf-8")

        def respond(self, status, body, content_type):
            self.send_response(status)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.send_header("Content-Security-Policy", "default-src 'none'; style-src 'self'; form-action 'self'; frame-ancestors 'none'; base-uri 'none'")
            self.end_headers()
            self.wfile.write(body)

    return DispatchHTTPHandler


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the local Dispatch Desk demo.")
    parser.add_argument("--db", type=Path, default=HERE / "dispatch.sqlite3", help="SQLite database path")
    parser.add_argument("--port", type=int, default=8000, help="local HTTP port")
    arguments = parser.parse_args()
    store = DispatchStore(arguments.db)
    store.initialize()
    with ThreadingHTTPServer(("127.0.0.1", arguments.port), make_handler(store)) as server:
        print(f"Dispatch Desk is available at http://127.0.0.1:{server.server_port}", flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
