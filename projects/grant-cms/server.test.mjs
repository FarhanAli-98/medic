import assert from 'node:assert/strict';
import { mkdtempSync, rmSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { once } from 'node:events';
import { test } from 'node:test';
import { initialState, sampleImport } from './data.mjs';
import { buildServer } from './server.mjs';

test('editor, publishing and migration preserve live content and inbound links', async t => {
  const folder = mkdtempSync(fileURLToPath(new URL('.grant-cms-test-', import.meta.url)));
  const server = buildServer({ stateFile: join(folder, 'content.json') });
  server.listen(0, '127.0.0.1');
  t.after(async () => {
    await new Promise(resolve => server.close(resolve));
    rmSync(folder, { recursive: true, force: true });
  });
  await once(server, 'listening');

  const origin = 'http://127.0.0.1:' + server.address().port;
  const get = path => fetch(origin + path, { redirect: 'manual' });
  const post = (path, fields) => fetch(origin + path, {
    method: 'POST',
    redirect: 'manual',
    headers: { Origin: origin },
    body: new URLSearchParams(fields)
  });
  const seed = initialState().grants[0].draft;
  const oldPath = '/opportunities/' + seed.slug;
  const editorPath = '/admin/grants/spaces';

  const home = await get('/');
  assert.equal(home.status, 200);
  assert.match(await home.text(), /Unpublished changes/);
  const oldLegacy = await get('/funding/neighbourhood-2024');
  assert.equal(oldLegacy.status, 301);
  assert.equal(oldLegacy.headers.get('location'), oldPath);
  assert.equal((await get('/opportunities/community-makers')).status, 404);

  const updated = { ...seed, title: 'New & <safe> title', slug: 'updated-spaces' };
  const preview = await post(editorPath, { ...updated, action: 'preview' });
  assert.equal(preview.status, 200);
  assert.match(await preview.text(), /New &amp; &lt;safe&gt; title/);
  assert.doesNotMatch(await (await get(oldPath)).text(), /New &amp;/);

  const bad = await post(editorPath, { ...updated, action: 'publish', deadline: '2027-02-31', revision: '0' });
  assert.equal(bad.status, 422);
  assert.match(await bad.text(), /Enter a valid date/);
  const saved = await post(editorPath, { ...updated, action: 'save', revision: '0' });
  assert.equal(saved.status, 303);
  assert.match(await (await get(saved.headers.get('location'))).text(), /Draft saved/);
  assert.doesNotMatch(await (await get(oldPath)).text(), /New &amp;/);
  assert.equal((await post(editorPath, { ...updated, action: 'save', revision: '0' })).status, 409);

  const published = await post(editorPath, { ...updated, action: 'publish', revision: '1' });
  assert.equal(published.status, 303);
  const newPath = '/opportunities/' + updated.slug;
  for (const path of [oldPath, '/funding/neighbourhood-2024']) {
    const response = await get(path);
    assert.equal(response.status, 301);
    assert.equal(response.headers.get('location'), newPath);
  }
  assert.match(await (await get(newPath)).text(), /New &amp; &lt;safe&gt; title/);

  const batch = await post('/admin/import', {
    records: JSON.stringify([...sampleImport, { ...sampleImport[0], legacyPath: '/funding/duplicate' }])
  });
  assert.equal(batch.status, 422);
  assert.doesNotMatch(await (await get('/')).text(), /Community Energy Pilot/);

  const records = JSON.stringify(sampleImport);
  const imported = await post('/admin/import', { records });
  assert.equal(imported.status, 303);
  assert.equal(imported.headers.get('location'), '/?imported=1&skipped=0');
  const repeated = await post('/admin/import', { records });
  assert.equal(repeated.headers.get('location'), '/?imported=0&skipped=1');
  const legacyPath = sampleImport[0].legacyPath;
  assert.equal((await get(legacyPath)).status, 404);
  const listing = await (await get('/')).text();
  const importedEditor = listing.match(/href="(\/admin\/grants\/[a-f0-9-]+)">Community Energy Pilot/)[1];
  assert.equal((await post(importedEditor, { ...sampleImport[0], action: 'publish', revision: '0' })).status, 303);
  const migrated = await get(legacyPath);
  assert.equal(migrated.status, 301);
  assert.equal(migrated.headers.get('location'), '/opportunities/community-energy-pilot');
  assert.match(await (await get('/opportunities')).text(), /Community Energy Pilot/);
});
