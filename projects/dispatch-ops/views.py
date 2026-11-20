from datetime import datetime
from html import escape
from urllib.parse import urlencode


STATUS_LABELS = {
    "pending": "Pending",
    "assigned": "Assigned",
    "collected": "Collected",
    "delivered": "Delivered",
    "failed": "Failed",
}
EVENT_LABELS = {
    "create": "Delivery created",
    "assign": "Driver assigned",
    "collect": "Parcel collected",
    "deliver": "Delivery confirmed",
    "fail": "Attempt failed",
    "reopen": "Returned to queue",
}


def render_dashboard(deliveries, drivers, history, selected, selected_filter, csrf, error):
    selected_filter = selected_filter if selected_filter in STATUS_LABELS else "all"
    counts = {status: 0 for status in STATUS_LABELS}
    for delivery in deliveries:
        counts[delivery["status"]] += 1
    visible = [delivery for delivery in deliveries if selected_filter in ("all", delivery["status"])]
    filters = [("all", "All", len(deliveries)), *((status, label, counts[status]) for status, label in STATUS_LABELS.items())]
    filter_links = "".join(
        f'<a href="{page_url(status=status)}"{current(status == selected_filter)}>{label} <span>{count}</span></a>'
        for status, label, count in filters
    )
    rows = "".join(render_delivery_row(delivery, selected, selected_filter) for delivery in visible)
    rows = rows or '<li class="empty-row">No deliveries in this view.</li>'
    detail = render_detail(selected, drivers, history, csrf) if selected else """
        <div class="empty-detail">
          <span class="empty-icon" aria-hidden="true"></span>
          <h2>Select a delivery</h2>
          <p>Open a delivery to assign a driver, update its status, or review its history.</p>
        </div>
    """
    alert = f'<p class="alert" role="alert">{escape(error)}</p>' if error else ""
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="A local delivery dispatch and confirmation demo.">
  <title>Dispatch Desk</title>
  <link rel="stylesheet" href="/style.css">
</head>
<body>
<header class="topbar">
  <div class="topbar-inner">
    <a href="/" class="brand"><span class="brand-icon" aria-hidden="true"></span> Dispatch Desk</a>
    <span class="local"><span></span> Local demo</span>
  </div>
</header>
<main class="shell">
  <div class="page-title">
    <div><h1>Deliveries</h1><p>Assign drivers, track pickups, and confirm handoffs.</p></div>
    <a class="button primary" href="#new-delivery">New delivery</a>
  </div>
  <dl class="metrics" aria-label="Delivery totals">
    <div><dt>Awaiting driver</dt><dd>{counts['pending']}</dd></div>
    <div><dt>In progress</dt><dd>{counts['assigned'] + counts['collected']}</dd></div>
    <div><dt>Delivered</dt><dd>{counts['delivered']}</dd></div>
    <div><dt>Needs review</dt><dd>{counts['failed']}</dd></div>
  </dl>
  {alert}
  <div class="workspace">
    <section class="card queue" aria-labelledby="queue-title">
      <header class="card-head"><h2 id="queue-title">Delivery queue</h2></header>
      <nav class="filters" aria-label="Filter deliveries">{filter_links}</nav>
      <ul class="queue-list">{rows}</ul>
    </section>
    <section class="card detail" aria-label="Delivery details">{detail}</section>
  </div>
  <section id="new-delivery" class="card create" aria-labelledby="create-title">
    <header class="card-head"><h2 id="create-title">New delivery</h2></header>
    <form action="/delivery" method="post" class="new-form">
      {hidden('csrf', csrf)}
      <label>Customer <input name="customer" required maxlength="100" placeholder="e.g. Alder Workshop"></label>
      <label>Delivery address <input name="address" required maxlength="180" placeholder="e.g. 32 Alder Lane"></label>
      <label>Recipient code <input name="confirmation_code" required inputmode="numeric" pattern="[0-9]{{4}}" maxlength="4" autocomplete="off" placeholder="4 digits" aria-describedby="code-helper"></label>
      <button class="button primary">Add to queue</button>
      <p class="help" id="code-helper">The assigned driver will enter this code to confirm the handoff.</p>
    </form>
  </section>
</main>
</body>
</html>"""


def current(is_current):
    return ' aria-current="true"' if is_current else ""


def page_url(*, status="all", delivery_id=None):
    params = {}
    if status != "all":
        params["filter"] = status
    if delivery_id is not None:
        params["delivery"] = delivery_id
    return "/?" + escape(urlencode(params)) if params else "/"


def badge(status):
    return f'<span class="badge {status}">{STATUS_LABELS[status]}</span>'


def render_delivery_row(delivery, selected, selected_filter):
    url = page_url(status=selected_filter, delivery_id=delivery["id"])
    is_current = selected is not None and delivery["id"] == selected["id"]
    return f"""<li><a class="queue-item" href="{url}"{current(is_current)}>
      <span class="queue-meta"><span class="reference">{delivery['reference']}</span>{badge(delivery['status'])}</span>
      <strong>{escape(delivery['customer'])}</strong>
      <span class="queue-address">{escape(delivery['address'])}</span>
    </a></li>"""


def render_detail(delivery, drivers, history, csrf):
    forms = render_actions(delivery, drivers, csrf)
    events = "".join(render_event(event) for event in reversed(history))
    updated = delivery["updated_at"]
    return f"""<div class="detail-inner">
      <header class="detail-head">
        <span class="reference">{delivery['reference']}</span>
        {badge(delivery['status'])}
        <h2>{escape(delivery['customer'])}</h2>
        <p>{escape(delivery['address'])}</p>
      </header>
      <dl class="detail-data">
        <div><dt>Driver</dt><dd>{escape(delivery['driver_name'] or 'Unassigned')}</dd></div>
        <div><dt>Updated</dt><dd>{time_label(updated)}</dd></div>
      </dl>
      <div class="action-area">{forms}</div>
      <section class="history" aria-labelledby="history-title">
        <h3 id="history-title">Activity</h3>
        <ol class="events">{events}</ol>
      </section>
    </div>"""


def hidden(name, value):
    return f'<input type="hidden" name="{name}" value="{escape(str(value))}">'


def render_actions(delivery, drivers, csrf):
    status = delivery["status"]
    driver_id = delivery["driver_id"]
    prefix = hidden("csrf", csrf) + hidden("delivery_id", delivery["id"])
    forms = []
    if status in ("pending", "assigned"):
        choices = render_drivers(drivers, variant="assign", assigned=driver_id)
        label = "Change driver" if driver_id else "Assign driver"
        forms.append(f"""<form action="/action" method="post" class="action-form">
          {prefix}{hidden('operation', 'assign')}{choices}
          <button class="button primary">{label}</button>
        </form>""")
    if status in ("assigned", "collected"):
        operation = "collect" if status == "assigned" else "deliver"
        label = "Mark collected" if operation == "collect" else "Confirm delivery"
        choices = render_drivers(drivers, variant=operation, assigned=driver_id)
        confirm = "" if operation == "collect" else """
          <label>Recipient code
            <input name="code" required inputmode="numeric" pattern="[0-9]{4}" maxlength="4" autocomplete="off" placeholder="4 digits">
          </label>"""
        forms.append(f"""<form action="/action" method="post" class="action-form">
          {prefix}{hidden('operation', operation)}{choices}{confirm}
          <button class="button primary">{label}</button>
        </form>""")
        choices = render_drivers(drivers, variant="fail", assigned=driver_id)
        forms.append(f"""<details class="failure">
          <summary>Report failed attempt</summary>
          <form action="/action" method="post" class="action-form">
            {prefix}{hidden('operation', 'fail')}{choices}
            <label>Reason <input name="note" required maxlength="220" placeholder="e.g. Receiving desk was closed"></label>
            <button class="button">Mark failed</button>
          </form>
        </details>""")
    if status == "failed":
        forms.append(f"""<form action="/action" method="post" class="action-form">
          {prefix}{hidden('operation', 'reopen')}
          <p class="help">Reopen this delivery to assign a driver for another attempt.</p>
          <button class="button primary">Return to queue</button>
        </form>""")
    if status == "delivered":
        forms.append('<p class="complete">Recipient confirmation recorded.</p>')
    return "".join(forms)


def render_drivers(drivers, *, variant, assigned):
    label = "Driver" if variant == "assign" else "Acting driver"
    options = ['<option value="">Choose a driver</option>'] if variant == "assign" else []
    for driver in drivers:
        if variant == "assign" and driver["id"] == assigned:
            continue
        selected = " selected" if driver["id"] == assigned else ""
        description = escape(f"{driver['name']} · {driver['region']}")
        options.append(f'<option value="{driver["id"]}"{selected}>{description}</option>')
    return f'<label>{label}<select name="driver_id" required>{"".join(options)}</select></label>'


def time_label(value):
    date = datetime.fromisoformat(value)
    return f'<time datetime="{escape(value)}">{date:%b %d, %H:%M} UTC</time>'


def render_event(event):
    note = f"<p>{escape(event['note'])}</p>" if event["note"] else ""
    return f"""<li>
      <span class="event-dot {event['to_status']}" aria-hidden="true"></span>
      <span class="event-main"><strong>{EVENT_LABELS[event['action']]}</strong><span>{escape(event['actor'])}</span></span>
      {time_label(event['occurred_at'])}{note}
    </li>"""
