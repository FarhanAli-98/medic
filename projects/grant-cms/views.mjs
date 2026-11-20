const escape = value => String(value ?? '').replace(/[&<>"']/g, character => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
})[character]);

function layout(title, content, active = '') {
  const nav = (label, href, key) =>
    `<a href="${href}"${active === key ? ' aria-current="page"' : ''}>${label}</a>`;
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escape(title)} | Grant Desk</title>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<a class="skip" href="#main">Skip to content</a>
<header class="bar">
  <div class="wrap bar-inner">
    <a class="brand" href="/"><span class="brand-mark" aria-hidden="true"><i></i><i></i><i></i><i></i></span>Grant Desk</a>
    <nav aria-label="Main navigation">${nav('Workspace', '/', 'workspace')}${nav('Legacy import', '/admin/import', 'import')}${nav('Public directory', '/opportunities', 'directory')}</nav>
  </div>
</header>
<main class="wrap main" id="main">${content}</main>
<footer class="wrap footer"><span>Grant Desk</span><span>Portfolio demo with fictional funding programs</span></footer>
</body>
</html>`;
}

function status(grant) {
  if (!grant.live) return ['Draft', 'draft'];
  if (Object.keys(grant.draft).some(key => grant.draft[key] !== grant.live[key])) {
    return ['Unpublished changes', 'pending'];
  }
  return ['Published', 'live'];
}

const chip = (text, tone) => `<span class="chip ${tone}">${escape(text)}</span>`;
const plural = (count, singular, multiple) => count + ' ' + (count === 1 ? singular : multiple);

function flash(message) {
  return message ? `<p class="flash" role="status">${escape(message)}</p>` : '';
}

function formatDate(date) {
  if (!date) return 'Not entered';
  return new Intl.DateTimeFormat('en', { dateStyle: 'medium', timeZone: 'UTC' }).format(new Date(date + 'T00:00:00Z'));
}

export function dashboard(grants, query) {
  const imported = Number(query.get('imported'));
  const skipped = Number(query.get('skipped'));
  const flashText = query.has('imported') && Number.isInteger(imported) && Number.isInteger(skipped) &&
    imported >= 0 && skipped >= 0
    ? `${plural(imported, 'draft', 'drafts')} imported. ${plural(skipped, 'existing record', 'existing records')} skipped.`
    : '';
  const liveCount = grants.filter(item => item.live).length;
  const legacy = grants.filter(item => item.legacyPath);
  const rows = grants.map(item => {
    const [label, tone] = status(item);
    return `<tr>
      <th scope="row"><a href="/admin/grants/${escape(item.id)}">${escape(item.draft.title)}</a><small>${escape(item.draft.category || 'Uncategorized')}</small></th>
      <td>${chip(label, tone)}</td>
      <td>${escape(formatDate(item.draft.deadline))}</td>
      <td class="row-action"><a class="text-link" href="/admin/grants/${escape(item.id)}" aria-label="Edit ${escape(item.draft.title)}">Edit</a></td>
    </tr>`;
  }).join('');
  const redirects = legacy.map(item => {
    const path = escape(item.legacyPath);
    return `<li><div>${item.live ? `<a class="code-link" href="${path}">${path}</a>` : `<code>${path}</code>`}</div>
      <span>${item.live ? 'Redirects to the published page' : 'Waiting for publication'}</span></li>`;
  }).join('');
  return layout('Workspace', `
    <section class="hero">
      <div><h1>Grant opportunities</h1><p>Review drafts, publish funding programs, and keep legacy links working.</p></div>
      <a class="button primary" href="/admin/grants/new"><span aria-hidden="true">+</span> New opportunity</a>
    </section>
    ${flash(flashText)}
    <dl class="metrics" aria-label="Publication overview">
      <div><dt>Opportunities</dt><dd>${grants.length}</dd></div>
      <div><dt>Public listings</dt><dd>${liveCount}</dd></div>
      <div><dt>Legacy URLs</dt><dd>${legacy.length}</dd></div>
    </dl>
    <div class="workspace-grid">
      <section class="panel" aria-labelledby="content-heading">
        <header class="panel-head"><h2 id="content-heading">Content library</h2></header>
        <div class="table-scroll" role="region" aria-label="Grant opportunities" tabindex="0">
          <table>
            <thead><tr><th scope="col">Opportunity</th><th scope="col">Status</th><th scope="col">Deadline</th><th scope="col"><span class="sr-only">Actions</span></th></tr></thead>
            <tbody>${rows}</tbody>
          </table>
        </div>
      </section>
      <aside class="panel" aria-labelledby="migration-heading">
        <header class="panel-head"><h2 id="migration-heading">Legacy redirects</h2><a class="text-link" href="/admin/import">Import</a></header>
        <ul class="redirects">${redirects || '<li>No legacy URLs have been imported.</li>'}</ul>
      </aside>
    </div>`, 'workspace');
}

function field(name, label, value, errors, { type = 'text', help = '', max, rows } = {}) {
  const error = errors[name];
  const descriptionIds = [help && name + '-help', error && name + '-error'].filter(Boolean).join(' ');
  const attributes = `id="${name}" name="${name}"${max ? ` maxlength="${max}"` : ''}${error ? ' aria-invalid="true"' : ''}${descriptionIds ? ` aria-describedby="${descriptionIds}"` : ''}`;
  const control = rows
    ? `<textarea ${attributes} rows="${rows}">${escape(value)}</textarea>`
    : `<input ${attributes} type="${type}" value="${escape(value)}">`;
  return `<div class="field"><label for="${name}">${label}</label>${help ? `<p class="hint" id="${name}-help">${help}</p>` : ''}${control}${error ? `<p class="error-field" id="${name}-error">${escape(error)}</p>` : ''}</div>`;
}

export function editor(grant, values, errors, notice) {
  const title = grant ? 'Edit opportunity' : 'New opportunity';
  const message = notice === 'published' ? 'Your changes are live in the public directory.'
    : notice === 'saved' ? 'Draft saved.' : '';
  const [label, tone] = grant ? status(grant) : ['Draft', 'draft'];
  const errorList = Object.entries(errors);
  const errorMessage = errorList.length ? `<div class="error-summary" role="alert"><h2>Review the form</h2>
    <ul>${errorList.map(([key, issue]) => `<li><a href="#${escape(key)}">${escape(issue)}</a></li>`).join('')}</ul></div>` : '';
  const legacyNotice = grant?.legacyPath
    ? `<p>Legacy link <code>${escape(grant.legacyPath)}</code></p>`
    : '';
  const publicLink = grant?.live ? `<p><a class="text-link" href="/opportunities/${escape(grant.live.slug)}">View published page</a></p>` : '';
  return layout(title, `
    <a href="/" class="back">Content library</a>
    <section class="editor-heading"><h1>${title}</h1>${chip(label, tone)}</section>
    ${flash(message)}${errorMessage}
    <form class="workspace-grid editor-grid" method="post">
      <input type="hidden" name="revision" value="${escape(grant?.revision ?? 0)}">
      <section class="panel form-panel" aria-labelledby="details-heading">
        <header class="panel-head"><h2 id="details-heading">Opportunity details</h2></header>
        <div class="panel-body">
          ${field('title', 'Title', values.title, errors, { max: 100 })}
          <div class="pair">
            ${field('slug', 'URL slug', values.slug, errors, { max: 80, help: 'Example: neighborhood-spaces' })}
            ${field('category', 'Category', values.category, errors, { max: 60, help: 'Example: Public spaces' })}
          </div>
          ${field('summary', 'Summary', values.summary, errors, { max: 280, rows: 3 })}
          <div class="pair">
            ${field('opening', 'Opening date', values.opening, errors, { type: 'date' })}
            ${field('deadline', 'Application deadline', values.deadline, errors, { type: 'date' })}
          </div>
          ${field('funding', 'Funding amount', values.funding, errors, { max: 90 })}
          ${field('eligibility', 'Eligibility', values.eligibility, errors, { max: 500, rows: 3 })}
          ${field('description', 'Application details', values.description, errors, { max: 5000, rows: 5 })}
        </div>
      </section>
      <section class="panel publish-panel" aria-labelledby="publish-heading">
        <header class="panel-head"><h2 id="publish-heading">Publishing</h2></header>
        <div class="panel-body">
          <p>Save a draft to keep editing. Publishing updates the public directory and activates the opportunity's legacy link.</p>
          ${publicLink}${legacyNotice}
          <button name="action" value="save" class="button secondary" type="submit">Save draft</button>
          <button name="action" value="preview" class="button secondary" type="submit" formtarget="_blank">Preview in new tab</button>
          <button name="action" value="publish" class="button primary" type="submit">${grant?.live ? 'Publish changes' : 'Publish opportunity'}</button>
        </div>
      </section>
    </form>`, 'workspace');
}

function publicContent(draft) {
  const paragraphs = draft.description?.split(/\n\s*\n/).filter(Boolean)
    .map(part => `<p>${escape(part)}</p>`).join('') || '<p>No application details entered.</p>';
  return `<article>
    <header class="grant-heading">
      ${draft.category ? `<p class="category">${escape(draft.category)}</p>` : ''}
      <h1>${escape(draft.title)}</h1>
      ${draft.summary ? `<p class="lede">${escape(draft.summary)}</p>` : ''}
    </header>
    <div class="public-grid">
      <section class="panel" aria-label="Grant details"><div class="panel-body readable">
        <h2>Who can apply</h2><p>${escape(draft.eligibility || 'No eligibility information entered.')}</p>
        <h2>Application details</h2>${paragraphs}</div>
      </section>
      <aside class="panel"><header class="panel-head"><h2>Funding and dates</h2></header><dl class="grant-facts panel-body">
        <div><dt>Award</dt><dd>${escape(draft.funding || 'Not entered')}</dd></div>
        <div><dt>Applications open</dt><dd>${escape(formatDate(draft.opening))}</dd></div>
        <div><dt>Deadline</dt><dd>${escape(formatDate(draft.deadline))}</dd></div>
      </dl></aside>
    </div>
  </article>`;
}

export function publicGrant(grant) {
  return layout(grant.title, `<a href="/opportunities" class="back">Public directory</a>${publicContent(grant)}`, 'directory');
}

export function previewPage(draft) {
  return layout('Draft preview', `<p class="flash">Draft preview. These changes are visible only in this tab.</p>${publicContent(draft)}`);
}

export function directory(grants) {
  const cards = grants.filter(item => item.live).map(({ live }) => `
    <article class="panel directory-card">
      <div class="panel-body">
        <p class="category">${escape(live.category)}</p>
        <h2><a href="/opportunities/${escape(live.slug)}">${escape(live.title)}</a></h2>
        <p>${escape(live.summary)}</p>
        <dl class="directory-facts">
          <div><dt>Award</dt><dd>${escape(live.funding)}</dd></div>
          <div><dt>Deadline</dt><dd>${escape(formatDate(live.deadline))}</dd></div>
        </dl>
      </div>
    </article>`).join('');
  return layout('Public directory', `
    <section class="hero"><div><h1>Funding directory</h1><p>Explore funding opportunities for local groups and nonprofits.</p></div></section>
    <section class="directory-grid" aria-label="Published opportunities">${cards || '<p>No opportunities have been published.</p>'}</section>
  `, 'directory');
}

export function importPage(records, issue) {
  return layout('Legacy import', `
    <a href="/" class="back">Content library</a>
    <h1>Import legacy grants</h1>
    <p class="lede">Paste a JSON export to create drafts. Legacy links start redirecting when a draft is published.</p>
    ${issue ? `<p class="error-summary" role="alert">${escape(issue)}</p>` : ''}
    <form class="panel import-form" method="post">
      <div class="panel-body">
        <label for="records">Grant records</label>
        <p class="hint" id="import-hint">The sample is ready to import. Each record needs a title, slug and unique legacy path under <code>/funding/</code>.</p>
        <textarea class="json-input" id="records" name="records" rows="13" aria-describedby="import-hint">${escape(records)}</textarea>
        <button class="button primary" type="submit">Import drafts</button>
      </div>
    </form>`, 'import');
}

export function messagePage(title, message) {
  return layout(title, `<h1>${escape(title)}</h1><p>${escape(message)}</p><a class="button secondary" href="/">Open workspace</a>`);
}
