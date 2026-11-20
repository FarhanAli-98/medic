from concurrent.futures import ThreadPoolExecutor
from html.parser import HTMLParser
from io import BytesIO
from pathlib import Path
from tempfile import TemporaryDirectory
from threading import Barrier
from urllib.parse import urlencode
import unittest

from app import DispatchError, DispatchStore, make_handler


class InMemoryRequest:
    def __init__(self, data):
        self.input = BytesIO(data)
        self.output = BytesIO()

    def makefile(self, mode, buffering):
        if mode != "rb":
            raise ValueError(f"Unexpected request stream mode {mode}")
        return self.input

    def sendall(self, data):
        self.output.write(data)


class FormTokenParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.token = None

    def handle_starttag(self, tag, attrs):
        fields = dict(attrs)
        if tag == "input" and fields.get("name") == "csrf":
            self.token = fields.get("value")


class DispatchStoreTest(unittest.TestCase):
    code = "7084"

    def setUp(self):
        directory = TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.path = Path(directory.name) / "dispatch.sqlite3"
        self.store = DispatchStore(self.path)
        self.store.initialize(seed=True)
        self.driver, self.other_driver = [row["id"] for row in self.store.drivers()][:2]

    def create_delivery(self):
        return self.store.create("Test recipient", "15 Example Street", self.code)

    def get_delivery(self, delivery_id, store=None):
        store = store if store is not None else self.store
        return next(row for row in store.deliveries() if row["id"] == delivery_id)

    def collect_delivery(self):
        delivery = self.create_delivery()
        self.store.assign(delivery, self.driver)
        self.store.advance(delivery, "collect", self.driver)
        return delivery

    def assert_rejected_without_changes(self, delivery_id, operation):
        delivery_before = self.get_delivery(delivery_id)
        history_before = self.store.history(delivery_id)
        with self.assertRaises(DispatchError):
            operation()
        self.assertEqual(delivery_before, self.get_delivery(delivery_id))
        self.assertEqual(history_before, self.store.history(delivery_id))

    def test_seed_fixtures_survive_reinitialization(self):
        seeded = self.store.deliveries()
        seeded_drivers = self.store.drivers()
        self.assertTrue(seeded)
        self.assertGreaterEqual(len(seeded_drivers), 2)
        self.assertGreater(len({row["status"] for row in seeded}), 1)
        self.assertEqual(len(seeded), len({row["reference"] for row in seeded}))

        self.store.initialize(seed=True)

        self.assertEqual(seeded, self.store.deliveries())
        self.assertEqual(seeded_drivers, self.store.drivers())

    def test_delivery_progression_and_audit_trail_persist(self):
        delivery = self.create_delivery()
        record = self.get_delivery(delivery)
        self.assertEqual(("pending", None), (record["status"], record["driver_id"]))
        self.assertEqual("Test recipient", record["customer"])
        self.assertEqual("15 Example Street", record["address"])
        self.assertTrue(record["reference"])
        self.assertTrue(record["updated_at"])

        self.store.assign(delivery, self.driver)
        self.store.advance(delivery, "collect", self.driver)
        self.store.advance(delivery, "deliver", self.driver, code=self.code)

        reopened_store = DispatchStore(self.path)
        reopened_store.initialize(seed=False)
        final = self.get_delivery(delivery, reopened_store)
        self.assertEqual(("delivered", self.driver), (final["status"], final["driver_id"]))
        self.assertEqual(record["reference"], final["reference"])
        history = reopened_store.history(delivery)
        self.assertEqual(
            [("pending", "assigned"), ("assigned", "collected"), ("collected", "delivered")],
            [(event["from_status"], event["to_status"]) for event in history[-3:]],
        )
        self.assertEqual(["collect", "deliver"], [event["action"] for event in history[-2:]])
        self.assertTrue(all(event["actor"] for event in history[-3:]))
        self.assertNotIn(self.code, repr(history))

    def test_wrong_driver_and_confirmation_leave_state_untouched(self):
        delivery = self.collect_delivery()
        scenarios = [
            ("wrong driver", self.other_driver, self.code),
            ("missing confirmation", self.driver, None),
            ("incorrect confirmation", self.driver, "0000"),
        ]
        for description, driver_id, code in scenarios:
            with self.subTest(description=description):
                self.assert_rejected_without_changes(
                    delivery,
                    lambda: self.store.advance(delivery, "deliver", driver_id, code=code),
                )

    def test_reassignment_ends_when_driver_collects(self):
        delivery = self.create_delivery()
        self.store.assign(delivery, self.driver)
        self.assert_rejected_without_changes(delivery, lambda: self.store.assign(delivery, self.driver))

        self.store.assign(delivery, self.other_driver)
        self.assertEqual(self.other_driver, self.get_delivery(delivery)["driver_id"])
        self.assert_rejected_without_changes(
            delivery, lambda: self.store.advance(delivery, "collect", self.driver)
        )

        self.store.advance(delivery, "collect", self.other_driver)
        self.assert_rejected_without_changes(delivery, lambda: self.store.assign(delivery, self.driver))

    def test_fail_requires_note_and_dispatch_can_reopen(self):
        for should_collect in (False, True):
            with self.subTest(collected=should_collect):
                delivery = self.create_delivery()
                self.store.assign(delivery, self.driver)
                if should_collect:
                    self.store.advance(delivery, "collect", self.driver)

                self.assert_rejected_without_changes(
                    delivery, lambda: self.store.advance(delivery, "fail", self.driver, note="   ")
                )
                note = "Recipient unavailable at the delivery entrance"
                self.store.advance(delivery, "fail", self.driver, note=note)
                self.assertEqual("failed", self.get_delivery(delivery)["status"])
                self.assertEqual(note, self.store.history(delivery)[-1]["note"])

                self.store.advance(delivery, "reopen", None)
                record = self.get_delivery(delivery)
                self.assertEqual(("pending", None), (record["status"], record["driver_id"]))
                self.assertEqual("reopen", self.store.history(delivery)[-1]["action"])
                self.store.assign(delivery, self.other_driver)
                self.assertEqual(self.other_driver, self.get_delivery(delivery)["driver_id"])

    def test_skip_collection_and_unknown_driver_are_rejected(self):
        delivery = self.create_delivery()
        self.assert_rejected_without_changes(delivery, lambda: self.store.assign(delivery, 99999))
        self.assert_rejected_without_changes(
            delivery, lambda: self.store.advance(delivery, "collect", self.driver)
        )
        self.store.assign(delivery, self.driver)
        self.assert_rejected_without_changes(
            delivery, lambda: self.store.advance(delivery, "deliver", self.driver, code=self.code)
        )

    def test_competing_delivery_retries_add_one_audit_event(self):
        delivery = self.collect_delivery()
        ready = Barrier(2, timeout=5)

        def attempt_delivery():
            store = DispatchStore(self.path)
            ready.wait()
            try:
                store.advance(delivery, "deliver", self.driver, code=self.code)
            except DispatchError:
                return "rejected"
            return "accepted"

        with ThreadPoolExecutor(max_workers=2) as executor:
            outcomes = list(executor.map(lambda _: attempt_delivery(), range(2)))

        self.assertCountEqual(["accepted", "rejected"], outcomes)
        self.assertEqual("delivered", self.get_delivery(delivery)["status"])
        self.assertEqual(1, sum(event["action"] == "deliver" for event in self.store.history(delivery)))

    def test_http_form_flow_rejects_unverified_requests(self):
        class Handler(make_handler(self.store)):
            def log_message(self, format, *args):
                pass

        def request(method, path, form=None):
            headers = [f"{method} {path} HTTP/1.0", "Host: localhost"]
            body = b""
            if form is not None:
                body = urlencode(form).encode("ascii")
                headers.extend([
                    "Content-Type: application/x-www-form-urlencoded",
                    f"Content-Length: {len(body)}",
                ])
            stream = InMemoryRequest("\r\n".join(headers + ["", ""]).encode("ascii") + body)
            Handler(stream, ("127.0.0.1", 12345), None)
            response = stream.output.getvalue()
            response_headers, response_body = response.split(b"\r\n\r\n", 1)
            status = int(response_headers.split(b" ", 2)[1])
            return status, response_body.decode("utf-8")

        status, page = request("GET", "/")
        self.assertEqual(200, status)
        parser = FormTokenParser()
        parser.feed(page)
        self.assertTrue(parser.token)

        customer = "HTTP <example> recipient"
        new_delivery = {
            "customer": customer,
            "address": "15 Example Street",
            "confirmation_code": self.code,
        }
        count_before = len(self.store.deliveries())
        status, _ = request("POST", "/delivery", {**new_delivery, "csrf": "invalid"})
        self.assertEqual(403, status)
        self.assertEqual(count_before, len(self.store.deliveries()))

        status, _ = request("POST", "/delivery", {**new_delivery, "csrf": parser.token})
        self.assertEqual(303, status)
        created = next(row for row in self.store.deliveries() if row["customer"] == customer)
        self.assertEqual("pending", created["status"])

        fields = {
            "csrf": parser.token,
            "delivery_id": created["id"],
            "operation": "assign",
            "driver_id": self.driver,
        }
        status, _ = request("POST", "/action", fields)
        self.assertEqual(303, status)
        self.assertEqual("assigned", self.get_delivery(created["id"])["status"])

        status, _ = request("POST", "/action", {**fields, "operation": "collect"})
        self.assertEqual(303, status)
        confirmation = {**fields, "operation": "deliver"}
        status, _ = request("POST", "/action", {**confirmation, "code": "0000"})
        self.assertEqual(422, status)
        self.assertEqual("collected", self.get_delivery(created["id"])["status"])

        status, _ = request("POST", "/action", {**confirmation, "code": self.code})
        self.assertEqual(303, status)
        self.assertEqual("delivered", self.get_delivery(created["id"])["status"])

        status, page = request("GET", f"/?delivery={created['id']}")
        self.assertEqual(200, status)
        self.assertIn("HTTP &lt;example&gt; recipient", page)
        self.assertNotIn(customer, page)


if __name__ == "__main__":
    unittest.main()
