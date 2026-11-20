import { DatabaseSync } from 'node:sqlite'

export const DAY = 86_400_000
export const DEMO_START = Date.parse('2026-04-16T10:00:00Z')
const MAX_ATTEMPTS = 3

type PaymentMethod = 'reliable' | 'temporary_decline' | 'expired'
type Decision = 'accepted' | 'try_again' | 'update_method'
type InstallmentState = 'queued' | 'processing' | 'retry_scheduled' | 'paid' | 'attention'
type Subscription = {
  id: string
  donor: string
  campaign: string
  amount: number
  method: PaymentMethod
  anchor_day: number
  next_due_at: number
}
type Installment = {
  id: string
  subscription_id: string
  due_at: number
  available_at: number
  amount: number
  method: PaymentMethod
  state: InstallmentState
}
type Attempt = {
  id: string
  installment_id: string
  ordinal: number
  decision: Decision | null
}
type RunOptions = { afterGateway?: (attemptId: string, decision: Decision) => void }

const subscriptions: Subscription[] = [
  { id: 'sub_01', donor: 'Avery Brooks', campaign: 'Neighborhood food boxes', amount: 3500, method: 'reliable', anchor_day: 14, next_due_at: DEMO_START - 2 * DAY },
  { id: 'sub_02', donor: 'Jordan Reed', campaign: 'Library on wheels', amount: 5500, method: 'temporary_decline', anchor_day: 15, next_due_at: DEMO_START - DAY },
  { id: 'sub_03', donor: 'Maya Fernandes', campaign: 'Neighborhood food boxes', amount: 2500, method: 'expired', anchor_day: 16, next_due_at: DEMO_START },
  { id: 'sub_04', donor: 'Samira Walker', campaign: 'Community garden kits', amount: 4200, method: 'reliable', anchor_day: 17, next_due_at: DEMO_START + DAY },
  { id: 'sub_05', donor: 'Riley Park', campaign: 'Library on wheels', amount: 7000, method: 'reliable', anchor_day: 21, next_due_at: DEMO_START + 5 * DAY },
]

export function nextMonthly(occurrence: number, anchorDay: number): number {
  const next = new Date(occurrence)
  next.setUTCDate(1)
  next.setUTCMonth(next.getUTCMonth() + 1)
  const lastDay = new Date(Date.UTC(next.getUTCFullYear(), next.getUTCMonth() + 1, 0)).getUTCDate()
  next.setUTCDate(Math.min(anchorDay, lastDay))
  return next.getTime()
}

export class GivingStore {
  private db: DatabaseSync

  constructor(path: string) {
    this.db = new DatabaseSync(path)
    this.db.exec(`
      PRAGMA foreign_keys = ON;
      PRAGMA journal_mode = WAL;
      PRAGMA busy_timeout = 5000;
      CREATE TABLE IF NOT EXISTS clock (id INTEGER PRIMARY KEY CHECK(id = 1), now INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS subscription (
        id TEXT PRIMARY KEY, donor TEXT NOT NULL, campaign TEXT NOT NULL,
        amount INTEGER NOT NULL CHECK(amount > 0), method TEXT NOT NULL,
        anchor_day INTEGER NOT NULL CHECK(anchor_day BETWEEN 1 AND 31), next_due_at INTEGER NOT NULL
      );
      CREATE TABLE IF NOT EXISTS installment (
        id TEXT PRIMARY KEY, subscription_id TEXT NOT NULL REFERENCES subscription(id),
        due_at INTEGER NOT NULL, available_at INTEGER NOT NULL,
        amount INTEGER NOT NULL CHECK(amount > 0), method TEXT NOT NULL,
        state TEXT NOT NULL CHECK(state IN ('queued', 'processing', 'retry_scheduled', 'paid', 'attention')),
        UNIQUE(subscription_id, due_at)
      );
      CREATE TABLE IF NOT EXISTS attempt (
        id TEXT PRIMARY KEY, installment_id TEXT NOT NULL REFERENCES installment(id),
        ordinal INTEGER NOT NULL CHECK(ordinal >= 1), decision TEXT,
        UNIQUE(installment_id, ordinal)
      );
      CREATE TABLE IF NOT EXISTS gateway_receipt (
        attempt_id TEXT PRIMARY KEY, decision TEXT NOT NULL
      );
      CREATE TABLE IF NOT EXISTS activity (
        id INTEGER PRIMARY KEY, installment_id TEXT REFERENCES installment(id),
        kind TEXT NOT NULL, created_at INTEGER NOT NULL, details TEXT NOT NULL
      );
      CREATE INDEX IF NOT EXISTS installment_schedule ON installment(state, available_at);
      CREATE INDEX IF NOT EXISTS subscription_schedule ON subscription(next_due_at);
    `)
    this.transaction(() => {
      if (!this.db.prepare('SELECT id FROM clock WHERE id = 1').get()) this.seed()
    })
  }

  close(): void {
    this.db.close()
  }

  private transaction<T>(work: () => T): T {
    this.db.exec('BEGIN IMMEDIATE')
    try {
      const result = work()
      this.db.exec('COMMIT')
      return result
    } catch (error) {
      this.db.exec('ROLLBACK')
      throw error
    }
  }

  private seed(): void {
    this.db.prepare('INSERT INTO clock VALUES (1, ?)').run(DEMO_START)
    const insert = this.db.prepare('INSERT INTO subscription VALUES (?, ?, ?, ?, ?, ?, ?)')
    for (const item of subscriptions) {
      insert.run(item.id, item.donor, item.campaign, item.amount, item.method, item.anchor_day, item.next_due_at)
    }
  }

  reset(): void {
    this.transaction(() => {
      this.db.exec('DELETE FROM activity; DELETE FROM gateway_receipt; DELETE FROM attempt; DELETE FROM installment; DELETE FROM subscription; DELETE FROM clock;')
      this.seed()
    })
  }

  now(): number {
    const clock = this.db.prepare('SELECT now FROM clock WHERE id = 1').get() as { now: number }
    return clock.now
  }

  advanceDay(): void {
    this.db.prepare('UPDATE clock SET now = now + ? WHERE id = 1').run(DAY)
  }

  replaceExpiredMethod(id: string): void {
    this.transaction(() => {
      const gift = this.db.prepare("SELECT subscription_id, method FROM installment WHERE id = ? AND state = 'attention'").get(id) as Pick<Installment, 'subscription_id' | 'method'> | undefined
      if (gift?.method !== 'expired') return

      const now = this.now()
      this.db.prepare("UPDATE subscription SET method = 'reliable' WHERE id = ?").run(gift.subscription_id)
      this.db.prepare("UPDATE installment SET method = 'reliable', state = 'queued', available_at = ? WHERE id = ?").run(now, id)
      this.addActivity(id, 'queued', now, 'A replacement payment method was recorded for the demo.')
    })
  }

  private addActivity(id: string, kind: string, at: number, details: string): void {
    this.db.prepare('INSERT INTO activity(installment_id, kind, created_at, details) VALUES (?, ?, ?, ?)').run(id, kind, at, details)
  }

  private enqueue(now: number): void {
    this.transaction(() => {
      const due = this.db.prepare('SELECT * FROM subscription WHERE next_due_at <= ? ORDER BY next_due_at, id').all(now) as Subscription[]
      const insert = this.db.prepare(`INSERT INTO installment (id, subscription_id, due_at, available_at, amount, method, state)
        VALUES (?, ?, ?, ?, ?, ?, 'queued') ON CONFLICT(subscription_id, due_at) DO NOTHING`)
      const update = this.db.prepare('UPDATE subscription SET next_due_at = ? WHERE id = ?')
      for (const item of due) {
        let occurrence = item.next_due_at
        while (occurrence <= now) {
          const id = `${item.id}:${occurrence}`
          const result = insert.run(id, item.id, occurrence, occurrence, item.amount, item.method)
          if (result.changes) this.addActivity(id, 'queued', now, 'Recurring gift was added to the processing queue.')
          occurrence = nextMonthly(occurrence, item.anchor_day)
        }
        update.run(occurrence, item.id)
      }
    })
  }

  private reserve(id: string, now: number): { installment: Installment; attempt: Attempt } | null {
    return this.transaction(() => {
      const installment = this.db.prepare('SELECT * FROM installment WHERE id = ?').get(id) as Installment | undefined
      if (!installment || installment.available_at > now || installment.state === 'paid' || installment.state === 'attention') return null

      const latest = this.db.prepare('SELECT * FROM attempt WHERE installment_id = ? ORDER BY ordinal DESC LIMIT 1').get(id) as Attempt | undefined
      if (latest && latest.decision === null) return { installment, attempt: latest }

      const ordinal = (latest?.ordinal ?? 0) + 1
      const attempt = { id: `${id}:${ordinal}`, installment_id: id, ordinal, decision: null }
      this.db.prepare('INSERT INTO attempt (id, installment_id, ordinal) VALUES (?, ?, ?)').run(attempt.id, id, ordinal)
      this.db.prepare("UPDATE installment SET state = 'processing' WHERE id = ?").run(id)
      return { installment, attempt }
    })
  }

  private charge(installment: Installment, attempt: Attempt): Decision {
    let decision: Decision = 'accepted'
    if (installment.method === 'expired') decision = 'update_method'
    if (installment.method === 'temporary_decline' && attempt.ordinal === 1) decision = 'try_again'

    // The simulated gateway commits its receipt independently of application settlement.
    this.db.prepare('INSERT INTO gateway_receipt VALUES (?, ?) ON CONFLICT(attempt_id) DO NOTHING').run(attempt.id, decision)
    const receipt = this.db.prepare('SELECT decision FROM gateway_receipt WHERE attempt_id = ?').get(attempt.id) as { decision: Decision }
    return receipt.decision
  }

  private settle(id: string, attempt: Attempt, decision: Decision, now: number): void {
    this.transaction(() => {
      const result = this.db.prepare('UPDATE attempt SET decision = ? WHERE id = ? AND decision IS NULL').run(decision, attempt.id)
      if (!result.changes) return

      let state: InstallmentState = 'attention'
      let available = now
      let message = 'Payment method expired. A replacement method is required.'
      if (decision === 'accepted') {
        state = 'paid'
        message = `Gift settled on attempt ${attempt.ordinal}.`
      }
      if (decision === 'try_again') {
        message = 'Retry limit reached. The gift needs review.'
        if (attempt.ordinal < MAX_ATTEMPTS) {
          state = 'retry_scheduled'
          available += DAY * 2 ** (attempt.ordinal - 1)
          message = `Temporary decline. Attempt ${attempt.ordinal + 1} is scheduled.`
        }
      }
      this.db.prepare('UPDATE installment SET state = ?, available_at = ? WHERE id = ?').run(state, available, id)
      this.addActivity(id, state, now, message)
    })
  }

  run(options: RunOptions = {}): void {
    const now = this.now()
    this.enqueue(now)
    const eligible = this.db.prepare(`SELECT id FROM installment
      WHERE state IN ('queued', 'processing', 'retry_scheduled') AND available_at <= ?
      ORDER BY due_at, id`).all(now) as Array<{ id: string }>
    for (const { id } of eligible) {
      const reserved = this.reserve(id, now)
      if (!reserved) continue
      const decision = this.charge(reserved.installment, reserved.attempt)
      options.afterGateway?.(reserved.attempt.id, decision)
      this.settle(id, reserved.attempt, decision, now)
    }
  }

  snapshot() {
    return this.transaction(() => {
      const now = this.now()
      const total = this.db.prepare(`SELECT
        COUNT(*) FILTER (WHERE state = 'paid') AS gifts,
        COALESCE(SUM(amount) FILTER (WHERE state = 'paid'), 0) AS collected,
        COUNT(*) FILTER (WHERE state = 'retry_scheduled') AS retries,
        COUNT(*) FILTER (WHERE state = 'attention') AS attention,
        COUNT(*) FILTER (WHERE state IN ('queued', 'processing')) AS processing
        FROM installment`).get()
      const plans = this.db.prepare('SELECT id, donor, campaign, amount, next_due_at FROM subscription ORDER BY next_due_at, id').all()
      const gifts = this.db.prepare(`SELECT s.donor, s.campaign, i.id, i.due_at, i.available_at, i.amount, i.state,
        i.state = 'attention' AND i.method = 'expired' AS can_replace_method,
        (SELECT COUNT(*) FROM attempt a WHERE a.installment_id = i.id) AS attempts
        FROM installment i JOIN subscription s ON s.id = i.subscription_id ORDER BY i.due_at DESC, i.id LIMIT 35`).all()
      const activity = this.db.prepare(`SELECT s.donor, a.kind, a.created_at, a.details
        FROM activity a JOIN installment i ON i.id = a.installment_id JOIN subscription s ON s.id = i.subscription_id
        ORDER BY a.id DESC LIMIT 20`).all()
      return { now, total, plans, gifts, activity }
    })
  }

  gatewayCaptures(): number {
    const row = this.db.prepare("SELECT COUNT(*) AS count FROM gateway_receipt WHERE decision = 'accepted'").get() as { count: number }
    return row.count
  }
}
