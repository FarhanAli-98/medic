from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
import json
from math import log1p
from pathlib import Path
import re


MAX_QUESTION_LENGTH = 500
WORD_PATTERN = re.compile(r"[a-z0-9]+")
ARTICLE_ID_PATTERN = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*")
STOP_WORDS = frozenset("""
    a about after am an and any are at be been before being can could did do does doing for from get got had
    has have having here how i if in is it its just me mean much my need never notice noticed of on or our please put
    recently s see should so t than
    that the their them then there these they this through to up ve us use used want was we were what when
    where which who why will with would you your
""".split())
BROAD_WORDS = frozenset("""
    account action activity application bank can case change confirmation contact detail donation email help
    information issue money number online payment process record reference report request screen select
    service status support ticket transaction transfer problem question
""".split())
NORMAL_FORMS = {
    "accounts": "account", "amounts": "amount", "arrived": "arrive", "arrives": "arrive",
    "attachments": "attachment", "banks": "bank", "cancelled": "cancel", "canceled": "cancel",
    "cancelling": "cancel", "cases": "case", "charged": "charge", "charges": "charge",
    "completed": "complete", "copies": "copy", "costs": "cost", "delayed": "delay",
    "donated": "donation", "donate": "donation", "donations": "donation", "donating": "donation",
    "downloading": "download", "duplicates": "duplicate", "fees": "fee", "files": "file", "fraudulent": "fraud",
    "gifts": "gift", "hacking": "hacked", "investments": "investment",
    "linked": "link", "linking": "link", "logs": "log", "numbers": "number", "payments": "payment",
    "processes": "process", "processed": "process", "processing": "process", "receipts": "receipt",
    "records": "record", "references": "reference", "replies": "reply", "reports": "report",
    "requests": "request", "scheduled": "schedule", "schedules": "schedule", "settings": "setting",
    "stopped": "stop", "stopping": "stop", "tickets": "ticket", "tracking": "track", "tracked": "track",
    "transactions": "transaction", "transfers": "transfer", "unrecognised": "unrecognized",
    "unauthorised": "unauthorized", "uploaded": "upload", "uploading": "upload", "withdrawals": "withdrawal",
}
ABSTENTION = "I couldn’t match that question to one help article. Try asking about one task and include a detail such as “donation receipt,” “pending bank transfer,” or “request reference.”"


@dataclass(frozen=True)
class Article:
    id: str
    title: str
    category: str
    keywords: tuple[str, ...]
    passage: str


@dataclass(frozen=True)
class Answer:
    supported: bool
    text: str
    sources: tuple[Article, ...] = ()


@dataclass(frozen=True)
class IndexedArticle:
    article: Article
    terms: Counter[str]
    anchors: frozenset[str]
    length: int


def tokenize(text: str) -> list[str]:
    words = WORD_PATTERN.findall(text.casefold())
    return [NORMAL_FORMS.get(word, word) for word in words if word not in STOP_WORDS and not word.isdecimal()]


class SupportAssistant:
    """Rank local articles and extract an answer only when one topic is supported."""

    def __init__(self, articles: tuple[Article, ...]):
        if not articles:
            raise ValueError("The knowledge base needs at least one article.")
        if len({article.id for article in articles}) != len(articles):
            raise ValueError("Knowledge article IDs must be unique.")
        if any(not ARTICLE_ID_PATTERN.fullmatch(article.id) for article in articles):
            raise ValueError("Knowledge article IDs must be lowercase URL slugs.")
        self.articles = articles
        self.articles_by_id = {article.id: article for article in articles}
        self.index = tuple(self.index_article(article) for article in articles)
        self.average_length = sum(document.length for document in self.index) / len(self.index)
        if not self.average_length:
            raise ValueError("Knowledge articles need searchable text.")
        frequencies = Counter(term for document in self.index for term in document.terms)
        self.idf = {
            term: log1p((len(self.index) - count + 0.5) / (count + 0.5))
            for term, count in frequencies.items()
        }

    @classmethod
    def from_file(cls, path: Path) -> SupportAssistant:
        data = json.loads(Path(path).read_text(encoding="utf-8"))
        return cls(tuple(Article(**{**record, "keywords": tuple(record["keywords"])}) for record in data))

    @staticmethod
    def index_article(article: Article) -> IndexedArticle:
        title = tokenize(article.title)
        keywords = set(tokenize(" ".join(article.keywords)))
        terms = Counter(title + sorted(keywords) + tokenize(article.passage))
        terms.update(title)
        anchors = frozenset(set(title).union(keywords) - BROAD_WORDS)
        return IndexedArticle(article, terms, anchors, sum(terms.values()))

    def score(self, document: IndexedArticle, query: set[str]) -> float:
        k1, b = 1.5, 0.75
        normalization = k1 * (1 - b + b * document.length / self.average_length)
        return sum(
            self.idf[term] * (document.terms[term] * (k1 + 1)) / (document.terms[term] + normalization)
            for term in sorted(query.intersection(document.terms))
        )

    def answer(self, question: str) -> Answer:
        if len(question) > MAX_QUESTION_LENGTH:
            return Answer(False, f"Keep your question to {MAX_QUESTION_LENGTH} characters or fewer.")
        if not question.strip():
            return Answer(False, "Enter a question about a donation, bank transfer, or support request.")

        query = set(tokenize(question))
        specific = query - BROAD_WORDS
        # Reference and status are useful together with an explicit ticket/request word.
        if "request" in query or "ticket" in query or "case" in query:
            specific.update(query.intersection({"reference", "status"}))
        if not specific:
            return Answer(False, ABSTENTION)
        candidates = [
            (self.score(document, query), document)
            for document in self.index
            if (specific & document.anchors) or self.is_request_status(document, query)
        ]
        candidates.sort(key=lambda item: (-item[0], item[1].article.id))
        if not candidates:
            return Answer(False, ABSTENTION)

        score, best = candidates[0]
        coverage = len(specific.intersection(best.terms)) / len(specific)
        close_match = len(candidates) > 1 and candidates[1][0] >= 0.80 * score
        if score < 1.5 or coverage < 0.60 or close_match:
            return Answer(False, ABSTENTION)
        return Answer(True, best.article.passage, (best.article,))

    @staticmethod
    def is_request_status(document: IndexedArticle, query: set[str]) -> bool:
        return (document.article.id == "request-tracking"
                and bool(query.intersection({"request", "ticket", "case"}))
                and bool(query.intersection({"reference", "status"})))
