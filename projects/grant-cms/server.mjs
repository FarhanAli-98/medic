import { createServer } from 'node:http';
import { randomUUID } from 'node:crypto';
import { mkdirSync, readFileSync, renameSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { initialState, sampleImport } from './data.mjs';
import { dashboard, directory, editor, importPage, messagePage, previewPage, publicGrant } from './views.mjs';

const root = dirname(fileURLToPath(import.meta.url));
const css = readFileSync(join(root, 'public', 'style.css'));
const textLimits = {
  title: 100, slug: 80, category: 60, summary: 280, opening: 10,
  deadline: 10, funding: 90, eligibility: 500, description: 5000
};
const slugPattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
const legacyPattern = /^\/funding\/[a-z0-9]+(?:-[a-z0-9]+)*$/;

function readState(file) {
  try {
    return JSON.parse(readFileSync(file, 'utf8'));
  } catch (error) {
    if (error.code !== 'ENOENT') throw error;
    return initialState();
  }
}

function writeState(file, state) {
  mkdirSync(dirname(file), { recursive: true });
  const temporaryFile = file + '.tmp';
  writeFileSync(temporaryFile, JSON.stringify(state, null, 2) + '\n');
  renameSync(temporaryFile, file);
}

function send(res, status, contents, type = 'text/html; charset=utf-8') {
  res.writeHead(status, {
    'Content-Type': type,
    'Content-Security-Policy': "default-src 'self'; object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'",
    'X-Content-Type-Options': 'nosniff',
    'Cache-Control': 'no-store',
    'Referrer-Policy': 'same-origin'
  });
  res.end(contents);
}

function redirect(res, status, location) {
  res.writeHead(status, { Location: location, 'Cache-Control': 'no-store' });
  res.end();
}

async function readForm(req) {
  if (!req.headers['content-type']?.startsWith('application/x-www-form-urlencoded')) {
    throw new FormError(415, 'This form uses an unsupported format.');
  }
  let length = 0;
  const chunks = [];
  for await (const chunk of req) {
    length += chunk.length;
    if (length <= 150_000) chunks.push(chunk);
  }
  if (length > 150_000) throw new FormError(413, 'The submission is too large.');
  return Object.fromEntries(new URLSearchParams(Buffer.concat(chunks).toString('utf8')));
}

class FormError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

function normalizedDraft(input) {
  return Object.fromEntries(Object.keys(textLimits).map(field => [
    field, typeof input[field] === 'string' ? input[field].trim() : ''
  ]));
}

function isDate(value) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const parsed = new Date(value + 'T00:00:00Z');
  return !Number.isNaN(parsed.valueOf()) && parsed.toISOString().slice(0, 10) === value;
}

function validate(draft, { complete = false } = {}) {
  const errors = {};
  const labels = {
    title: 'Title', slug: 'URL slug', category: 'Category', summary: 'Summary',
    opening: 'Opening date', deadline: 'Deadline', funding: 'Funding amount',
    eligibility: 'Eligibility', description: 'Application details'
  };
  for (const [field, maximum] of Object.entries(textLimits)) {
    if ((complete || field === 'title' || field === 'slug') && !draft[field]) {
      errors[field] = labels[field] + ' is required.';
    } else if (draft[field].length > maximum) {
      errors[field] = labels[field] + ' must have at most ' + maximum + ' characters.';
    }
  }
  if (draft.slug && !slugPattern.test(draft.slug)) errors.slug = 'Use lowercase letters, digits, and single hyphens.';
  for (const date of ['opening', 'deadline']) {
    if (draft[date] && !isDate(draft[date])) errors[date] = 'Enter a valid date.';
  }
  if (!errors.opening && !errors.deadline && draft.opening && draft.deadline && draft.deadline < draft.opening) {
    errors.deadline = 'The deadline must be on or after the opening date.';
  }
  return errors;
}

function slugTaken(grants, slug, exceptId) {
  return grants.some(grant => grant.id !== exceptId && (
    grant.draft.slug === slug || grant.live?.slug === slug || grant.redirects.includes(slug)
  ));
}

function migrate(grants, source) {
  let rows;
  try {
    rows = JSON.parse(source);
  } catch {
    throw new FormError(422, 'Enter a valid JSON array of grant records.');
  }
  if (!Array.isArray(rows) || !rows.length || rows.length > 50) {
    throw new FormError(422, 'Import an array containing 1 to 50 grant records.');
  }
  const prepared = [];
  const paths = new Set();
  let skipped = 0;
  for (const [index, row] of rows.entries()) {
    const label = 'Record ' + (index + 1) + ': ';
    if (!row || typeof row !== 'object' || Array.isArray(row)) {
      throw new FormError(422, label + 'Enter a JSON object.');
    }
    const draft = normalizedDraft(row);
    const legacyPath = typeof row.legacyPath === 'string' ? row.legacyPath.trim() : '';
    if (legacyPath.length > 100 || !legacyPattern.test(legacyPath)) {
      throw new FormError(422, label + 'Use a legacy path such as /funding/old-program.');
    }
    if (paths.has(legacyPath)) throw new FormError(422, label + 'This legacy path is repeated in the file.');
    paths.add(legacyPath);
    const errors = validate(draft);
    if (Object.keys(errors).length) throw new FormError(422, label + Object.values(errors).join(' '));
    if (grants.some(grant => grant.legacyPath === legacyPath)) {
      skipped++;
      continue;
    }
    if (slugTaken([...grants, ...prepared], draft.slug)) {
      throw new FormError(422, label + 'This URL slug already belongs to another opportunity.');
    }
    prepared.push({ id: randomUUID(), draft, live: null, legacyPath, redirects: [] });
  }
  return { prepared, skipped };
}

export function buildServer({ stateFile = join(root, '.local', 'content.json') } = {}) {
  return createServer(async (req, res) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      const path = url.pathname;
      if (req.method === 'GET' && path === '/style.css') return send(res, 200, css, 'text/css; charset=utf-8');
      if (req.method === 'POST') {
        const origin = req.headers.origin;
        if (origin && origin !== 'http://' + req.headers.host) {
          return send(res, 403, messagePage('Request blocked', 'Open the editor on this local address and try again.'));
        }
      }
      if (req.method === 'GET' && path === '/') {
        return send(res, 200, dashboard(readState(stateFile).grants, url.searchParams));
      }
      if (req.method === 'GET' && path === '/opportunities') {
        return send(res, 200, directory(readState(stateFile).grants));
      }
      const publicMatch = path.match(/^\/opportunities\/([a-z0-9-]+)$/);
      if (req.method === 'GET' && (publicMatch || legacyPattern.test(path))) {
        const grants = readState(stateFile).grants;
        const slug = publicMatch?.[1];
        const grant = grants.find(item => item.live?.slug === slug && item.live);
        if (grant) return send(res, 200, publicGrant(grant.live));
        const moved = grants.find(item => item.live && (item.legacyPath === path || (slug && item.redirects.includes(slug))));
        if (moved) return redirect(res, 301, '/opportunities/' + moved.live.slug);
      }
      if (path === '/admin/import') {
        if (req.method === 'GET') return send(res, 200, importPage(JSON.stringify(sampleImport, null, 2)));
        if (req.method === 'POST') {
          const form = await readForm(req);
          const state = readState(stateFile);
          try {
            const { prepared, skipped } = migrate(state.grants, form.records ?? '');
            if (prepared.length) writeState(stateFile, { grants: [...state.grants, ...prepared] });
            return redirect(res, 303, '/?imported=' + prepared.length + '&skipped=' + skipped);
          } catch (error) {
            if (!(error instanceof FormError)) throw error;
            return send(res, error.status, importPage(form.records ?? '', error.message));
          }
        }
      }
      const editMatch = path.match(/^\/admin\/grants\/([a-z0-9-]+)$/);
      if (editMatch && (req.method === 'GET' || req.method === 'POST')) {
        const id = editMatch[1];
        const form = req.method === 'POST' ? await readForm(req) : null;
        const state = readState(stateFile);
        const grant = id === 'new' ? null : state.grants.find(item => item.id === id);
        if (grant || id === 'new') {
          if (!form) return send(res, 200, editor(grant, grant?.draft ?? {}, {}, url.searchParams.get('notice')));
          const draft = normalizedDraft(form);
          const action = form.action;
          if (!['save', 'preview', 'publish'].includes(action)) throw new FormError(400, 'Choose a valid editor action.');
          const errors = validate(draft, { complete: action === 'publish' });
          if (!errors.slug && slugTaken(state.grants, draft.slug, grant?.id)) {
            errors.slug = 'This URL slug already belongs to another opportunity.';
          }
          if (Object.keys(errors).length) return send(res, 422, editor(grant, draft, errors));
          if (action === 'preview') return send(res, 200, previewPage(draft));
          const revision = grant?.revision ?? 0;
          if (form.revision !== String(revision)) {
            return send(res, 409, messagePage(
              'This opportunity changed while you were editing',
              'Open the latest draft from the workspace before saving or publishing.'
            ));
          }
          const next = grant ? { ...grant, draft } : {
            id: randomUUID(), draft, live: null, legacyPath: '', redirects: []
          };
          next.revision = revision + 1;
          if (action === 'publish') {
            if (next.live && next.live.slug !== draft.slug) {
              next.redirects = [...new Set([...next.redirects, next.live.slug])];
            }
            next.redirects = next.redirects.filter(slug => slug !== draft.slug);
            next.live = { ...draft };
          }
          const grants = grant ? state.grants.map(item => item.id === next.id ? next : item) : [...state.grants, next];
          writeState(stateFile, { grants });
          return redirect(res, 303, '/admin/grants/' + next.id + '?notice=' + (action === 'publish' ? 'published' : 'saved'));
        }
      }
      return send(res, 404, messagePage('Page not found', 'The requested opportunity may still be a draft.'));
    } catch (error) {
      if (error instanceof FormError) return send(res, error.status, messagePage('Check your submission', error.message));
      console.error(error);
      return send(res, 500, messagePage('Something went wrong', 'Grant Desk could not complete that request.'));
    }
  });
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const port = Number(process.env.PORT || 3030);
  buildServer().listen(port, '127.0.0.1', () => {
    console.log('Grant Desk is running at http://127.0.0.1:' + port);
  });
}
