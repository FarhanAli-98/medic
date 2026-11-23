import base64
import unittest
from io import BytesIO
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch

from PIL import Image

from returns_review.app import create_app
from returns_review.config import Settings
from returns_review.images import normalize_photo
from returns_review.models import InspectionReport
from returns_review.store import ReviewStore
from returns_review.vision import OpenAIVision, VisionUnavailable


def sample_report():
    return InspectionReport.model_validate({
        "summary": "The visible corner is compressed.",
        "findings": [{
            "view": "front-right", "verdict": "possible_damage",
            "observation": "A crease at the lower corner.",
            "box": {"x": 0.61, "y": 0.58, "width": 0.12, "height": 0.2},
        }],
    })


def image_bytes():
    buffer = BytesIO()
    Image.new("RGB", (640, 480), "#d4bdac").save(buffer, "PNG")
    return buffer.getvalue()


class SimulatedVision:
    def __init__(self):
        self.calls = 0
        self.fail = False

    def inspect(self, photos):
        self.calls += 1
        if self.fail:
            raise VisionUnavailable("Test outage")
        assert [photo.view for photo in photos] == ["front-right"]
        return sample_report()


class ReviewWorkspaceTests(unittest.TestCase):
    def setUp(self):
        temporary = TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.settings = Settings(Path(temporary.name) / "returns.sqlite3")
        self.store = ReviewStore(self.settings.database)

    def connect(self, provider=None):
        app = create_app(self.settings, vision=provider)
        app.testing = True
        self.client = app.test_client()
        self.client.get("/", follow_redirects=True)
        with self.client.session_transaction() as session:
            self.csrf = session["csrf"]

    def upload(self, data=None):
        return self.client.post("/returns", data={
            "csrf": self.csrf,
            "item": "Demo box",
            "front-right": (BytesIO(image_bytes() if data is None else data), "photo.png"),
        })

    def test_seed_and_manual_review_persist(self):
        self.connect()
        seeded = self.client.get("/returns/RT-1842")
        self.assertIn(b"Illustrative finding", seeded.data)
        self.assertIn(b"1 of 3 recommended views", seeded.data)
        photo = self.client.get("/returns/RT-1842/photos/front-right")
        self.assertEqual(photo.mimetype, "image/jpeg")
        self.assertEqual(photo.headers["Cache-Control"], "no-store")
        photo.close()

        upload = self.upload()
        self.assertEqual(upload.status_code, 303)
        path = upload.location
        self.assertIn(b"This case uses manual photo review.", self.client.get(path).data)
        self.client.post(path + "/review", data={"csrf": self.csrf,
                                                "outcome": "damage_confirmed", "note": "Saw a crease."})
        self.client.post(path + "/review", data={"csrf": self.csrf, "outcome": "inconclusive"})
        self.connect()
        reviewed = self.client.get(path).data
        self.assertIn(b"Damage confirmed", reviewed)
        self.assertIn(b"Saw a crease.", reviewed)
        self.assertEqual(len(self.store.list_cases()), 2)

    def test_reject_invalid_photo_and_missing_csrf(self):
        self.connect()
        bad = self.upload(b"<svg onload='anything'/>")
        self.assertEqual(bad.status_code, 400)
        self.assertIn(b"could not be opened as a photo", bad.data)
        no_token = self.client.post("/returns/RT-1842/review", data={"outcome": "damage_confirmed"})
        self.assertEqual(no_token.status_code, 400)
        self.assertEqual(len(self.store.list_cases()), 1)

    def test_analyze_retry_then_report_still_requires_review(self):
        vision = SimulatedVision()
        self.connect(vision)
        path = self.upload().location
        self.assertIn(b"This sends the photos to OpenAI.", self.client.get(path).data)
        vision.fail = True
        failure = self.client.post(path + "/analyze", data={"csrf": self.csrf}, follow_redirects=True)
        self.assertIn(b"Your photos are saved", failure.data)
        vision.fail = False
        result = self.client.post(path + "/analyze", data={"csrf": self.csrf}, follow_redirects=True)
        self.assertIn(b"AI suggestion", result.data)
        self.assertIn(b"A crease at the lower corner.", result.data)
        self.assertIn(b"Save review", result.data)
        self.client.post(path + "/analyze", data={"csrf": self.csrf})
        self.assertEqual(vision.calls, 2)

    def test_analysis_lease_and_late_provider_response(self):
        self.connect()
        case_id = self.upload().location.rsplit("/", 1)[1]
        self.assertTrue(self.store.claim_analysis(case_id, "first"))
        self.assertFalse(self.store.claim_analysis(case_id, "second"))
        self.assertTrue(self.store.record_review(case_id, "inconclusive", "Need another angle."))
        self.store.finish_analysis(case_id, "first", sample_report())
        case, _ = self.store.get_case(case_id)
        self.assertIsNone(case["report"])
        self.assertEqual(case["outcome"], "inconclusive")


class VisionAdapterTests(unittest.TestCase):
    @patch("returns_review.vision.OpenAI")
    def test_payload_uses_responses_with_normalized_image(self, openai):
        call = openai.return_value.responses.parse
        call.return_value.output_parsed = sample_report()
        photo = normalize_photo("front-right", image_bytes())
        report = OpenAIVision("test-key", "gpt-4.1-mini").inspect([photo])
        self.assertEqual(report.findings[0].view, "front-right")
        kwargs = call.call_args.kwargs
        self.assertFalse(kwargs["store"])
        self.assertIs(kwargs["text_format"], InspectionReport)
        attachment = kwargs["input"][0]["content"][1]
        self.assertEqual(attachment["image_url"], "data:image/jpeg;base64," +
                         base64.b64encode(photo.jpeg).decode())
        call.return_value.output_parsed = None
        with self.assertRaises(VisionUnavailable):
            OpenAIVision("test-key", "gpt-4.1-mini").inspect([photo])


if __name__ == "__main__":
    unittest.main()
