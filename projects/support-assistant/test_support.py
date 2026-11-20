from html import escape
import json
from io import BytesIO
from pathlib import Path
from urllib.parse import urlencode
import unittest

from support import SupportAssistant


KNOWLEDGE_FILE = Path(__file__).resolve().with_name("knowledge.json")


class SupportAssistantTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.assistant = SupportAssistant.from_file(KNOWLEDGE_FILE)
        with KNOWLEDGE_FILE.open(encoding="utf-8") as file:
            cls.entries = {entry["id"]: entry for entry in json.load(file)}

    def assert_abstains(self, question):
        response = self.assistant.answer(question)
        self.assertIs(response.supported, False)
        self.assertFalse(response.sources)
        self.assertTrue(response.text.strip())

    def test_known_questions_quote_the_cited_passages(self):
        cases = [
            ("How can I get a receipt for my donation?", "donation-receipts"),
            ("My bank transfer is still pending. What should I check?", "bank-transfer-status"),
            ("I have a request reference. How do I track its status?", "request-tracking"),
            ("I noticed suspicious activity on my account. What should I do?", "account-safety"),
        ]
        for question, source_id in cases:
            with self.subTest(source=source_id):
                response = self.assistant.answer(question)
                self.assertIs(response.supported, True)
                self.assertTrue(response.sources)
                self.assertEqual(source_id, response.sources[0].id)
                self.assertEqual(self.entries[source_id]["passage"], response.text)
                for source in response.sources:
                    self.assertIn(source.id, self.entries)
                    entry = self.entries[source.id]
                    self.assertEqual(entry["title"], source.title)
                    self.assertEqual(entry["passage"], source.passage)

    def test_unknown_question_does_not_invent_sources(self):
        self.assert_abstains("How do I tune a carburetor on a 1974 motorcycle?")

    def test_ambiguous_questions_have_no_sources(self):
        for question in (
            "What's the status?",
            "Can you help with a transfer and a donation?",
            "I have a pending transfer and a missing receipt",
        ):
            with self.subTest(question=question):
                self.assert_abstains(question)

    def test_blank_question_has_no_sources(self):
        for question in ("", " \t\n "):
            with self.subTest(question=question):
                self.assert_abstains(question)

    def test_overlong_known_question_has_no_sources(self):
        prefix = "How can I get a receipt for my donation? "
        self.assert_abstains(prefix + "x" * (501 - len(prefix)))


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


class SupportBrowserTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from app import make_handler

        class QuietHandler(make_handler(SupportAssistant.from_file(KNOWLEDGE_FILE))):
            def log_message(self, format, *args):
                pass

        cls.handler = QuietHandler

    def request(self, path="/", *, question=None):
        method = "GET" if question is None else "POST"
        headers = [f"{method} {path} HTTP/1.0", "Host: localhost"]
        body = b""
        if question is not None:
            body = urlencode({"question": question}).encode("ascii")
            headers.extend([
                "Content-Type: application/x-www-form-urlencoded",
                f"Content-Length: {len(body)}",
            ])
        stream = InMemoryRequest("\r\n".join(headers + ["", ""]).encode("ascii") + body)
        self.handler(stream, ("127.0.0.1", 12345), None)
        response_headers, response_body = stream.output.getvalue().split(b"\r\n\r\n", 1)
        return int(response_headers.split(b" ", 2)[1]), response_body.decode("utf-8")

    def test_browser_answer_links_to_the_local_article(self):
        question = "How can I get a receipt for my donation?"
        path = "/articles/donation-receipts"
        evidence = SupportAssistant.from_file(KNOWLEDGE_FILE).answer(question).sources[0]

        status, page = self.request(question=question)
        self.assertEqual(200, status)
        self.assertIn(f'href="{path}"', page)
        self.assertIn(escape(evidence.passage), page)

        status, article = self.request(path)
        self.assertEqual(200, status)
        self.assertIn(escape(evidence.title), article)
        self.assertIn(escape(evidence.passage), article)

    def test_every_starter_question_is_grounded(self):
        from app import STARTERS

        expected_sources = ("donation-receipts", "bank-transfer-status", "request-tracking", "account-safety")
        for question, source_id in zip(STARTERS, expected_sources, strict=True):
            with self.subTest(question=question):
                status, page = self.request(question=question)
                self.assertEqual(200, status)
                self.assertIn(f'href="/articles/{source_id}"', page)

    def test_unsupported_browser_answer_escapes_question(self):
        status, page = self.request(question="Can a <fictional-tag> tune a carburetor?")
        self.assertEqual(200, status)
        self.assertNotIn('href="/articles/', page)
        self.assertIn("&lt;fictional-tag&gt;", page)
        self.assertNotIn("<fictional-tag>", page)


if __name__ == "__main__":
    unittest.main()
