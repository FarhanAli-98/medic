"""SQLite persistence for the review queue, photo evidence, and analysis leases."""

import sqlite3
import time
from contextlib import closing, contextmanager
from pathlib import Path

from .models import InspectionReport, Photo

SCHEMA = """
CREATE TABLE IF NOT EXISTS return_cases (
    id TEXT PRIMARY KEY,
    item TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    source TEXT NOT NULL CHECK (source IN ('sample', 'upload')),
    report TEXT,
    outcome TEXT CHECK (outcome IN ('damage_confirmed', 'no_visible_damage', 'inconclusive')),
    review_note TEXT,
    reviewed_at TEXT,
    analysis_lease TEXT,
    analysis_until INTEGER
);
CREATE TABLE IF NOT EXISTS photos (
    case_id TEXT NOT NULL REFERENCES return_cases(id) ON DELETE CASCADE,
    view TEXT NOT NULL CHECK (view IN ('front-right', 'top', 'back')),
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    jpeg BLOB NOT NULL,
    PRIMARY KEY (case_id, view)
);
"""


class ReviewStore:
    def __init__(self, path: Path):
        self.path = path

    @contextmanager
    def connection(self):
        with closing(sqlite3.connect(self.path)) as database:
            database.row_factory = sqlite3.Row
            database.execute("PRAGMA foreign_keys = ON")
            with database:
                yield database

    def initialize(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self.connection() as database:
            database.execute("PRAGMA journal_mode = WAL")
            database.executescript(SCHEMA)

    def add_case(
        self, case_id: str, item: str, photos: list[Photo],
        *, sample_report: InspectionReport | None = None,
    ) -> None:
        with self.connection() as database:
            result = database.execute(
                """INSERT INTO return_cases (id, item, source, report) VALUES (?, ?, ?, ?)
                   ON CONFLICT(id) DO NOTHING""",
                (case_id, item, "sample" if sample_report else "upload",
                 sample_report.model_dump_json() if sample_report else None),
            )
            if not result.rowcount:
                if sample_report:
                    return
                raise ValueError("A return with this ID already exists.")
            database.executemany(
                "INSERT INTO photos VALUES (?, ?, ?, ?, ?)",
                ((case_id, p.view, p.width, p.height, p.jpeg) for p in photos),
            )

    def list_cases(self) -> list[sqlite3.Row]:
        with self.connection() as database:
            return database.execute(
                """SELECT id, item, source, outcome FROM return_cases
                   ORDER BY outcome IS NOT NULL, created_at DESC, id DESC"""
            ).fetchall()

    def get_case(self, case_id: str):
        with self.connection() as database:
            case = database.execute("SELECT * FROM return_cases WHERE id = ?", (case_id,)).fetchone()
            views = database.execute("SELECT view FROM photos WHERE case_id = ?", (case_id,)).fetchall()
        return case, {row["view"] for row in views}

    def get_photos(self, case_id: str) -> list[Photo]:
        with self.connection() as database:
            rows = database.execute(
                "SELECT view, width, height, jpeg FROM photos WHERE case_id = ? ORDER BY view",
                (case_id,),
            ).fetchall()
        return [Photo(*row) for row in rows]

    def get_photo(self, case_id: str, view: str) -> bytes | None:
        with self.connection() as database:
            row = database.execute(
                "SELECT jpeg FROM photos WHERE case_id = ? AND view = ?", (case_id, view)
            ).fetchone()
        return row["jpeg"] if row else None

    def claim_analysis(self, case_id: str, token: str) -> bool:
        now = int(time.time())
        with self.connection() as database:
            result = database.execute(
                """UPDATE return_cases SET analysis_lease = ?, analysis_until = ?
                   WHERE id = ? AND source = 'upload' AND report IS NULL AND outcome IS NULL
                   AND (analysis_until IS NULL OR analysis_until <= ?)""",
                (token, now + 90, case_id, now),
            )
            return result.rowcount == 1

    def finish_analysis(self, case_id: str, token: str, report: InspectionReport | None) -> bool:
        with self.connection() as database:
            result = database.execute(
                """UPDATE return_cases SET report = ?, analysis_lease = NULL, analysis_until = NULL
                   WHERE id = ? AND analysis_lease = ? AND outcome IS NULL""",
                (report.model_dump_json() if report else None, case_id, token),
            )
            return result.rowcount == 1

    def record_review(self, case_id: str, outcome: str, note: str) -> bool:
        with self.connection() as database:
            result = database.execute(
                """UPDATE return_cases
                   SET outcome = ?, review_note = ?, reviewed_at = CURRENT_TIMESTAMP,
                       analysis_lease = NULL, analysis_until = NULL
                   WHERE id = ? AND outcome IS NULL""",
                (outcome, note, case_id),
            )
            return result.rowcount == 1
