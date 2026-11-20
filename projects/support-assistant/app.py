from __future__ import annotations

import argparse
from html import escape
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs

from support import Answer, Article, MAX_QUESTION_LENGTH, SupportAssistant


HERE = Path(__file__).resolve().parent
STARTERS = (
    "Where can I download my donation receipt?",
    "What does a pending bank transfer mean?",
    "How do I track a support request?",
    "How do I report suspicious account activity?",
)


def page(title: str, content: str) -> str:
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="An offline support assistant for a synthetic fintech help center.">
  <title>{escape(title)} · Harborline Help Desk</title>
  <link rel="stylesheet" href="/style.css">
</head>
<body>
  <header class="topbar">
    <div class="topbar-inner">
      <a class="brand" href="/"><span class="mark" aria-hidden="true">H</span> Harborline <span class="brand-help">Help Desk</span></a>
      <span class="demo-status">Local demo</span>
    </div>
  </header>
  {content}
  <footer class="shell site-footer">Harborline is a fictional platform. Use sample questions and keep personal details out of the demo.</footer>
</body>
</html>"""


def article_url(article: Article) -> str:
    return "/articles/" + article.id


def render_answer(answer: Answer | None) -> str:
    if answer is None:
        return ""
    heading = "Answer" if answer.supported else "A little more detail would help"
    citations = ""
    if answer.sources:
        sources = "".join(f'<li><a href="{article_url(source)}">{escape(source.title)}</a></li>' for source in answer.sources)
        citations = f'<div class="citations"><h3>Source</h3><ul>{sources}</ul></div>'
    kind = "grounded" if answer.supported else "clarify"
    return f"""<section class="answer {kind}" aria-labelledby="answer-title" aria-live="polite">
      <h2 id="answer-title">{heading}</h2>
      <p>{escape(answer.text)}</p>
      {citations}
    </section>"""


def render_home(question: str, answer: Answer | None) -> str:
    starters = "".join(
        f'<button class="starter" name="question" value="{escape(prompt)}">{escape(prompt)}<span aria-hidden="true">↗</span></button>'
        for prompt in STARTERS
    )
    return page("Support assistant", f"""
  <main class="shell">
    <section class="hero" aria-labelledby="hero-title">
      <div><h1 id="hero-title">How can we help?</h1>
      <p>Ask about a donation, bank transfer, support request, or account safety.</p></div>
      <a class="library-link" href="/articles">Browse help articles <span aria-hidden="true">↗</span></a>
    </section>
    <div class="workspace">
      <div class="main-column">
        <form class="question card" action="/" method="post">
          <label for="question">Your question</label>
          <textarea id="question" name="question" rows="3" maxlength="{MAX_QUESTION_LENGTH}" required placeholder="e.g. Where can I find my donation receipt?">{escape(question)}</textarea>
          <div class="form-footer"><span>Up to {MAX_QUESTION_LENGTH} characters</span><button class="primary">Find an answer</button></div>
        </form>
        {render_answer(answer)}
      </div>
      <aside class="card starters" aria-labelledby="starter-heading">
        <h2 id="starter-heading">Try a question</h2>
        <form action="/" method="post">{starters}</form>
      </aside>
    </div>
  </main>""")


def render_library(articles: tuple[Article, ...]) -> str:
    categories = {}
    for article in articles:
        categories.setdefault(article.category, []).append(article)
    sections = []
    for category, entries in categories.items():
        links = "".join(f'<li><a href="{article_url(article)}">{escape(article.title)}</a></li>' for article in entries)
        sections.append(f'<section class="card catalog-section"><h2>{escape(category)}</h2><ul>{links}</ul></section>')
    return page("Help articles", f"""
  <main class="shell">
    <div class="breadcrumbs"><a href="/">Support assistant</a> <span aria-hidden="true">/</span> Help articles</div>
    <section class="hero"><div><h1>Help articles</h1><p>Read the articles the assistant uses for its answers.</p></div></section>
    <div class="catalog">{''.join(sections)}</div>
  </main>""")


def render_article(article: Article) -> str:
    return page(article.title, f"""
  <main class="shell">
    <div class="breadcrumbs"><a href="/">Support assistant</a> <span aria-hidden="true">/</span> <a href="/articles">Help articles</a></div>
    <article class="card article">
      <p class="category">{escape(article.category)}</p>
      <h1>{escape(article.title)}</h1>
      <p>{escape(article.passage)}</p>
    </article>
  </main>""")


def make_handler(assistant: SupportAssistant):
    stylesheet = (HERE / "style.css").read_bytes()

    class SupportHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            path, _, _ = self.path.partition("?")
            if path == "/":
                self.send_html(render_home("", None))
            elif path == "/style.css":
                self.respond(stylesheet, "text/css; charset=utf-8")
            elif path == "/articles":
                self.send_html(render_library(assistant.articles))
            elif path.startswith("/articles/"):
                article = assistant.articles_by_id.get(path.removeprefix("/articles/"))
                if article is None:
                    self.send_error(HTTPStatus.NOT_FOUND)
                else:
                    self.send_html(render_article(article))
            else:
                self.send_error(HTTPStatus.NOT_FOUND)

        def do_POST(self):
            if self.path.partition("?")[0] != "/":
                self.send_error(HTTPStatus.NOT_FOUND)
                return
            try:
                body_length = int(self.headers.get("Content-Length", "0"))
                if not 0 < body_length <= 8192 or self.headers.get_content_type() != "application/x-www-form-urlencoded":
                    raise ValueError
                payload = parse_qs(self.rfile.read(body_length).decode("utf-8"), keep_blank_values=True, max_num_fields=1)
                question, = payload["question"]
            except (ValueError, KeyError):
                self.send_error(HTTPStatus.BAD_REQUEST)
                return
            self.send_html(render_home(question[:MAX_QUESTION_LENGTH], assistant.answer(question)))

        def send_html(self, document: str):
            self.respond(document.encode("utf-8"), "text/html; charset=utf-8")

        def respond(self, body: bytes, content_type: str):
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.send_header("Content-Security-Policy", "default-src 'none'; style-src 'self'; form-action 'self'; frame-ancestors 'none'; base-uri 'none'")
            self.end_headers()
            self.wfile.write(body)

    return SupportHandler


def main():
    parser = argparse.ArgumentParser(description="Run the offline Harborline Help Desk demo.")
    parser.add_argument("--port", type=int, default=8006, help="local HTTP port")
    args = parser.parse_args()
    assistant = SupportAssistant.from_file(HERE / "knowledge.json")
    with ThreadingHTTPServer(("127.0.0.1", args.port), make_handler(assistant)) as server:
        print(f"Harborline Help Desk is available at http://127.0.0.1:{server.server_port}", flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
