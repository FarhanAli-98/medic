# Dispatch Desk

Dispatch Desk is a local logistics portfolio demo. A dispatcher can add deliveries and assign drivers. The assigned driver can record pickup, report a failed attempt, or confirm a handoff with a recipient code. The queue, delivery totals, and activity history reflect each accepted action.

The implementation, businesses, drivers, addresses, and records are synthetic. The workflow is inspired by delivery status and driver confirmations Farhan has worked with professionally.

## Run locally

From this directory, use Python 3.10 or newer. The app uses only the Python standard library and SQLite.

```sh
python3 app.py
```

Open `http://127.0.0.1:8000/`. The application listens on loopback. Its first launch creates `dispatch.sqlite3` and adds five deliveries and three drivers. Restarting preserves changes. Use a different path for a fresh demo or select another local port.

```sh
python3 app.py --db ./fresh-demo.sqlite3 --port 8001
```

## Try the workflow

1. Open **Cedar Community Kitchen**, which starts pending, and assign a driver.
2. Use **Mark collected**. The acting-driver menu lets you try another name and see the request rejected.
3. Try a wrong recipient code, then confirm with `2714`. The activity history records the accepted handoff.
4. Open **Westfield Print Co.** to see a failed attempt. Use **Return to queue** to clear its assignment so you can dispatch it again.
5. Use **New delivery** to add a synthetic stop with your own four-digit code.

The pre-collected **Juniper Repair Studio** can also be confirmed with `5831`. **Oak & Finch Books** starts assigned and uses `1908` after collection. **Morrow Flower Shop** starts delivered. **Westfield Print Co.** uses `9436` after it is reopened, assigned, and collected.

## Rules and persistence

| Action | Required status | Result |
| --- | --- | --- |
| Assign or change driver | Pending or assigned | Assigned to a valid driver |
| Mark collected | Assigned | Collected by the assigned driver |
| Confirm delivery | Collected | Delivered after the assigned driver enters the matching recipient code |
| Report a failed attempt | Assigned or collected | Failed with a reason from the assigned driver |
| Return to queue | Failed | Pending with the driver assignment cleared |

SQLite writes each status update and its activity entry in one transaction. Repeated or out-of-order actions are rejected. Stored confirmation codes use salted digests, and browser forms carry an anti-CSRF token. Driver selection simulates actors in a single local session. A live deployment would need authenticated accounts, rate limiting, and an out-of-band recipient code workflow.

## Verify

```sh
python3 -m unittest -v
```

Tests use temporary SQLite databases and exercise delivery rules, audit history, persistence, concurrent retries, and the browser form handlers in memory.
