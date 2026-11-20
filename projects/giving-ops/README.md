# Giving Ops

Giving Ops is an independent portfolio demo for recurring donations. Five synthetic subscriptions fund three fictional community campaigns. The dashboard lets you run the scheduler, advance a simulated day, review the ledger, and replace a simulated expired payment method.

## Start locally

Use Node.js 24 or later. The runtime uses Node’s HTTP server, TypeScript support, and SQLite. It has no runtime dependencies or credentials.

```sh
npm start
```

Open `http://127.0.0.1:4317`. The server binds to loopback. `GIVING_PORT` overrides the port and `GIVING_DB` overrides the SQLite path. The default `giving.sqlite` file preserves state between launches.

## Walk through the demo

1. Click **Reset demo**, then **Run scheduler**. Three gifts are due. Avery’s $35 gift settles, Jordan’s $55 gift queues for retry, and Maya’s $25 gift requires a replacement method.
2. Run the scheduler again. The ledger and $35 total stay the same.
3. Click **Advance 1 day**. Jordan’s retry succeeds and Samira’s $42 gift is now due. The total reaches $132.
4. Click **Replace demo method** in Maya’s ledger row. The gift settles on its second attempt and the total reaches $157.

The background worker checks the simulated clock every 30 seconds. **Run scheduler** processes it immediately, and **Advance 1 day** moves the clock and processes due work in the same request.

## Verify

```sh
npm run verify
npm ci
npm run check
```

The test suite exercises month-end dates, repeated and overlapping HTTP requests, temporary declines, idempotent replacement of an expired demo method, and restart recovery after the simulated gateway records a charge but before the ledger settles it. The HTTP test starts an isolated loopback server with an in-memory database.

## Processing model

The scheduler materializes one installment per subscription and due date. It persists each attempt before calling the simulated gateway. The gateway commits a receipt using the attempt ID as its idempotency key. If processing stops before the ledger commits, the next run reuses the pending attempt and reconciles the same receipt.

Temporary declines trigger bounded exponential backoff. A permanent decline requires a replacement method. Amounts are integer cents. Recurrence is anchored to a UTC calendar day and clamps to the last day of shorter months.

The fictional gateway uses its own receipt table in the same SQLite file. The test simulates the interruption between the two commits. A production integration would use a real provider’s idempotency and reconciliation APIs. The demo uses fictional names and payment outcomes throughout.
