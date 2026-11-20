const price = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' })
const date = new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', timeZone: 'UTC' })
const fullDate = new Intl.DateTimeFormat('en-US', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'UTC' })
const status = {
  queued: 'Queued',
  processing: 'Processing',
  retry_scheduled: 'Retry scheduled',
  paid: 'Settled',
  attention: 'Needs attention',
}
const actionMessages = {
  run: 'Scheduler run complete.',
  advance: 'Advanced one day and processed due gifts.',
  reset: 'Demo reset to its starting state.',
  'replace-method': 'Updated the demo method and processed the gift.',
}
let busy = false
let actionVersion = 0
let lastState = ''

function node(tag, text, className) {
  const child = document.createElement(tag)
  if (text) child.textContent = text
  if (className) child.className = className
  return child
}

function put(id, text) {
  document.getElementById(id).textContent = text
}

function emptyRow(message) {
  const row = node('tr')
  const cell = node('td', message, 'empty')
  cell.colSpan = 4
  row.append(cell)
  return row
}

function badge(state) {
  return node('span', status[state], `badge ${state}`)
}

function render(data) {
  const state = JSON.stringify(data)
  if (state === lastState) return
  lastState = state
  const { now, total, plans, gifts, activity } = data
  const clock = document.getElementById('sim-time')
  clock.dateTime = new Date(now).toISOString()
  clock.textContent = `${fullDate.format(now)} UTC`
  put('collected', price.format(total.collected / 100))
  put('settled-count', `${total.gifts} settled ${total.gifts === 1 ? 'gift' : 'gifts'}`)
  put('subscriptions', String(plans.length))
  put('retries', String(total.retries))
  put('attention', String(total.attention))
  put('gift-count', gifts.length === 35 ? 'Latest 35 gifts' : `${gifts.length} ${gifts.length === 1 ? 'gift' : 'gifts'}`)

  const giftRows = gifts.map(gift => {
    const row = node('tr')
    const donor = node('th', gift.donor)
    donor.scope = 'row'
    donor.append(node('span', gift.campaign, 'cell-detail'))
    const result = node('td')
    result.append(badge(gift.state))
    if (gift.state === 'retry_scheduled') result.append(node('span', `Next try ${date.format(gift.available_at)}`, 'cell-detail'))
    else if (gift.attempts) result.append(node('span', `${gift.attempts} ${gift.attempts === 1 ? 'attempt' : 'attempts'}`, 'cell-detail'))
    if (gift.can_replace_method) {
      const replace = node('button', 'Replace demo method', 'replace')
      replace.type = 'button'
      replace.setAttribute('aria-label', `Replace ${gift.donor}'s demo payment method`)
      replace.dataset.action = 'replace-method'
      replace.dataset.gift = gift.id
      result.append(replace)
    }
    row.append(donor, node('td', date.format(gift.due_at)), node('td', price.format(gift.amount / 100)), result)
    return row
  })
  document.getElementById('gifts').replaceChildren(...(giftRows.length ? giftRows : [emptyRow('Run the scheduler to process the first batch.')]))

  const eventRows = activity.map(event => {
    const row = node('li', null, `event ${event.kind}`)
    row.append(node('strong', event.donor), node('p', event.details), node('time', `${fullDate.format(event.created_at)} UTC`))
    row.lastElementChild.dateTime = new Date(event.created_at).toISOString()
    return row
  })
  document.getElementById('events').replaceChildren(...(eventRows.length ? eventRows : [node('li', 'Processing events will appear here.', 'empty')]))

  const planRows = plans.map(plan => {
    const row = node('tr')
    const donor = node('th', plan.donor)
    donor.scope = 'row'
    const due = node('td', date.format(plan.next_due_at))
    if (plan.next_due_at <= now) due.append(node('span', 'Ready to process', 'cell-detail'))
    row.append(donor, node('td', plan.campaign), node('td', price.format(plan.amount / 100)), due)
    return row
  })
  document.getElementById('plans').replaceChildren(...planRows)
}

async function load(path = '/api/state', method = 'GET') {
  const response = await fetch(path, { method, headers: method === 'POST' ? { 'X-Giving-Demo': '1' } : {} })
  const data = await response.json()
  if (!response.ok) throw new Error(data.error ?? 'Request failed.')
  return data
}

document.addEventListener('click', async event => {
  const button = event.target.closest('button[data-action]')
  if (!button || busy) return
  const buttons = [...document.querySelectorAll('[data-action]')]
  busy = true
  actionVersion += 1
  buttons.forEach(item => { item.disabled = true })
  put('action-status', 'Updating…')
  try {
    const { action, gift } = button.dataset
    const query = gift ? `?${new URLSearchParams({ gift })}` : ''
    render(await load(`/api/${action}${query}`, 'POST'))
    put('action-status', actionMessages[action])
  } catch (error) {
    put('action-status', error.message)
  } finally {
    busy = false
    buttons.forEach(item => { item.disabled = false })
  }
})

async function refresh() {
  if (busy) return
  const version = actionVersion
  try {
    const data = await load()
    if (!busy && version === actionVersion) render(data)
  } catch (error) {
    if (!busy && version === actionVersion) put('action-status', error.message)
  }
}

await refresh()
setInterval(refresh, 5_000)
