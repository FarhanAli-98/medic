# Harborline Help Desk

A browser-based support assistant for a fictional fintech and donations platform. Ask about donation receipts, bank transfers, support requests, or account safety. Answers quote and link to the original help article. The assistant asks for clarification when the available articles give weak or conflicting matches.

All procedures and product names in the knowledge base are synthetic. Questions are evaluated locally and the server keeps no conversation history.

## Run

From this directory, use Python 3.10 or newer. The demo uses only the standard library.

```sh
python3 app.py
```

Open `http://127.0.0.1:8006/`. To change the local port, run `python3 app.py --port 8016`. The process listens on loopback.

## Try it

| Question | Expected result |
| --- | --- |
| Where can I download my donation receipt? | Quotes and links to **Find a donation receipt** |
| What does a pending bank transfer mean? | Quotes and links to **Check a pending bank transfer** |
| How do I track a support request? | Quotes and links to **Track a support request by reference** |
| How do I report suspicious account activity? | Quotes and links to **Report suspicious account activity** |
| What’s the status? | Asks for a more specific question |
| What’s the price of Bitcoin today? | Asks for a more specific question |

## How it works

`knowledge.json` contains twelve synthetic help articles. `support.py` indexes each title, keywords and passage. It ranks candidates with BM25, then checks that a match includes topic-specific evidence, covers enough of the question, and is sufficiently ahead of the next result. An accepted answer reproduces the selected passage verbatim and links to its source page. The local library makes every entry available for review.

This demo uses deterministic term-based retrieval. Rewordings outside the indexed vocabulary may need a more specific follow-up. The app runs offline without a model server, external API key, JavaScript dependency, or front-end build step.

## Verify

```sh
python3 -m unittest -v
```

The tests verify exact source passages, unknown and ambiguous requests, input boundaries, and the browser form’s citation links and escaped output.
