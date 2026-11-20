# Engineering case studies

## Sukuk Capital | Investment app and release engineering

The product handles investment opportunities, digital wallets, transactions, and portfolio activity. I led architecture and development for the mobile app, integrated PayFort and custodian bank APIs, and helped improve the reliability of transaction and portfolio workflows. I maintained the release pipeline with GitHub Actions and Shorebird and worked with engineering and compliance teams in the UAE and UK.

**Portfolio walkthrough.** Crescent Ledger models a wallet with exact minor-unit amounts. The verification suite checks whether allocations and activity reconcile to the available balance. Transaction Review Lab explores review queues on generated wallet activity. [Crescent Ledger](../projects/investment-wallet/) · [Transaction Review Lab](../projects/transaction-review/) · [Released app](https://apps.apple.com/us/app/id1664435903)

## Kynami | Recurring donations and scheduled processing

I developed donation features and recurring subscription management in the mobile app. I also implemented scheduled services in TypeScript and Node.js to connect payment events and subscription records.

**Portfolio walkthrough.** Giving Ops shows how a scheduled cycle, a retry, and recovery after an interrupted run interact. The local dashboard lets a reviewer advance time and observe what happens after a temporary gateway failure. [Giving Ops](../projects/giving-ops/)

## Devex IT | Delivery tracking and driver workflows

I developed cross-platform delivery features, including order status, driver workflows, and delivery confirmation. My work covered API integration, testing, and app releases.

**Portfolio walkthrough.** Dispatch Desk models assignment, pickup, confirmation, and retries using SQLite. A reviewer can reproduce these transitions in the web UI and inspect the resulting audit history. [Dispatch Desk](../projects/dispatch-ops/)

## Bespokely | Configurable hospitality features

I built reusable Flutter components and configurable features for multiple business needs. I integrated backend APIs, payment services, and third-party functionality into the shared mobile architecture. [Bespokely](https://bespokely.io/)
