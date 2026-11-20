# Grant Desk

Grant Desk is an independent portfolio demo for publishing grant opportunities and migrating a legacy funding directory. The sample organization, opportunities, and content are fictional.

## Run locally

Use Node.js 20 or later. The app uses Node's HTTP server and standard HTML and CSS. There are no dependencies to install.

```sh
npm start
```

Open [the workspace](http://127.0.0.1:3030/). Set `PORT` if 3030 is already in use.

## Try the workflow

1. Open **Legacy import** and select **Import drafts** to load the supplied JSON example. Try importing it again to see how an existing legacy URL is skipped.
2. Open **Community Energy Pilot** in the content library. Edit its summary and select **Preview in new tab** to review the public layout with your unsaved changes.
3. Save the draft or publish it. Publishing requires a category, summary, valid dates, award, eligibility and application details. A deadline cannot be earlier than its opening date.
4. Open **Public directory** and select the new opportunity. The [legacy link](http://127.0.0.1:3030/funding/community-energy-2025) now redirects to that page.
5. Change the opportunity’s URL slug and publish again. Both the old public URL and the legacy URL redirect to the current page. A saved edit leaves the previously published content live until the next publication.

The workspace loads with two published pages, one draft, and a pending edit to one published page. The public directory displays only published revisions.

## Import format and storage

The import accepts a JSON array of up to 50 records. Every record needs a `title`, `slug`, and unique `legacyPath` under `/funding/`. Optional keys are `category`, `summary`, `opening`, `deadline`, `funding`, `eligibility` and `description`. Use YYYY-MM-DD for dates. A failed validation blocks the whole batch.

The first edit or import writes `.local/content.json`. Existing draft writes use revision checks to prevent stale tabs from replacing newer work. The server saves changes by replacing the state file after a complete write. To reset the example, stop the app and remove `.local/content.json`.

The editor runs locally on the loopback interface and has no sign-in. This demo uses one Node process and a JSON store.

## Verify

```sh
npm test
```

The integration test covers preview isolation, date errors, stale form handling, preserving the live page during draft edits, atomic imports, duplicate detection, and permanent redirects.
