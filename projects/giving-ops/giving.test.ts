import assert from 'node:assert/strict'
import { once } from 'node:events'
import { mkdtempSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { test } from 'node:test'
import { DAY, DEMO_START, GivingStore, nextMonthly } from './giving.ts'
import { createApp } from './server.ts'

const totals = { gifts: 1, collected: 3500, retries: 1, attention: 1, processing: 0 }
const settledTotals = { gifts: 3, collected: 13200, retries: 0, attention: 1, processing: 0 }

function stateMap(store: GivingStore) {
  return Object.fromEntries(store.snapshot().gifts.map(item => [item.donor, item.state]))
}

test('monthly gifts keep their original anchor after shorter months', () => {
  const january = Date.parse('2026-01-31T10:00:00Z')
  const february = nextMonthly(january, 31)
  assert.equal(new Date(february).toISOString(), '2026-02-28T10:00:00.000Z')
  assert.equal(new Date(nextMonthly(february, 31)).toISOString(), '2026-03-31T10:00:00.000Z')
})

test('processes due gifts once, retries temporary declines and flags permanent declines', () => {
  const store = new GivingStore(':memory:')
  try {
    store.run()
    assert.deepEqual({ ...store.snapshot().total }, totals)
    assert.deepEqual(stateMap(store), {
      'Maya Fernandes': 'attention',
      'Jordan Reed': 'retry_scheduled',
      'Avery Brooks': 'paid',
    })
    const first = store.snapshot()
    store.run()
    assert.deepEqual(store.snapshot(), first)
    assert.equal(store.gatewayCaptures(), 1)

    store.advanceDay()
    store.run()
    assert.equal(store.now(), DEMO_START + DAY)
    assert.deepEqual({ ...store.snapshot().total }, settledTotals)
    assert.equal(store.snapshot().gifts.find(gift => gift.donor === 'Jordan Reed')?.attempts, 2)
    assert.equal(store.snapshot().gifts.find(gift => gift.donor === 'Maya Fernandes')?.attempts, 1)
    assert.equal(store.gatewayCaptures(), 3)
    assert.equal(store.snapshot().plans.length, 5)
  } finally {
    store.close()
  }
})

test('reopening an interrupted run reconciles the existing gateway receipt without a second capture', () => {
  const directory = mkdtempSync(join(tmpdir(), 'giving-ops-verify-'))
  const path = join(directory, 'demo.sqlite')
  let store = new GivingStore(path)
  const interrupted = new Error('worker stopped after charge')
  try {
    assert.throws(() => store.run({ afterGateway: () => { throw interrupted } }), interrupted)
    assert.equal(store.gatewayCaptures(), 1)
    assert.equal(store.snapshot().total?.gifts, 0)
    assert.equal(stateMap(store)['Avery Brooks'], 'processing')

    store.close()
    store = new GivingStore(path)
    store.run()
    store.run()
    assert.equal(store.gatewayCaptures(), 1)
    assert.deepEqual({ ...store.snapshot().total }, totals)
    assert.equal(store.snapshot().gifts.find(gift => gift.donor === 'Avery Brooks')?.attempts, 1)
  } finally {
    store.close()
    rmSync(directory, { recursive: true, force: true })
  }
})

test('serves the dashboard and state transitions over the normal HTTP routes', async () => {
  const store = new GivingStore(':memory:')
  const server = createApp(store).listen(0, '127.0.0.1')
  try {
    await once(server, 'listening')
    const address = server.address()
    assert.ok(address && typeof address === 'object')
    const base = `http://127.0.0.1:${address.port}`
    const post = (route: string) => fetch(`${base}/api/${route}`, { method: 'POST', headers: { 'X-Giving-Demo': '1' } })
    assert.match(await (await fetch(base)).text(), /Recurring gifts/)
    assert.equal((await fetch(`${base}/dashboard.js`)).status, 200)
    assert.equal((await fetch(`${base}/api/run`, { method: 'POST' })).status, 403)
    const runs = await Promise.all([post('run'), post('run')])
    for (const response of runs) assert.deepEqual((await response.json()).total, totals)
    const next = await (await post('advance')).json()
    assert.deepEqual(next.total, settledTotals)
    const expired = next.gifts.find((item: { donor: string }) => item.donor === 'Maya Fernandes')
    const query = new URLSearchParams({ gift: expired.id })
    const repair = await (await post(`replace-method?${query}`)).json()
    assert.equal(repair.total.collected, 15700)
    assert.equal(repair.total.attention, 0)
    assert.deepEqual(await (await post(`replace-method?${query}`)).json(), repair)
    const reset = await (await post('reset')).json()
    assert.equal(reset.now, DEMO_START)
    assert.equal(reset.gifts.length, 0)
  } finally {
    await new Promise<void>((resolve, reject) => server.close(error => error ? reject(error) : resolve()))
    store.close()
  }
})
