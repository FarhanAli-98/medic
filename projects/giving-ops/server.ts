import { readFile } from 'node:fs/promises'
import { createServer, type ServerResponse } from 'node:http'
import { fileURLToPath } from 'node:url'
import { GivingStore } from './giving.ts'

const staticFiles: Record<string, [string, string]> = {
  '/': ['index.html', 'text/html; charset=utf-8'],
  '/styles.css': ['styles.css', 'text/css; charset=utf-8'],
  '/dashboard.js': ['dashboard.js', 'text/javascript; charset=utf-8'],
}

function json(response: ServerResponse, status: number, payload: unknown): void {
  response.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' })
  response.end(JSON.stringify(payload))
}

export function createApp(store: GivingStore) {
  const actions: Record<string, (url: URL) => void> = {
    '/api/run': () => store.run(),
    '/api/advance': () => { store.advanceDay(); store.run() },
    '/api/reset': () => store.reset(),
    '/api/replace-method': url => {
      store.replaceExpiredMethod(url.searchParams.get('gift') ?? '')
      store.run()
    },
  }

  return createServer(async (request, response) => {
    try {
      const url = new URL(request.url ?? '/', 'http://127.0.0.1')
      const path = url.pathname
      if (request.method === 'GET' && path === '/api/state') {
        json(response, 200, store.snapshot())
        return
      }
      if (request.method === 'POST' && Object.hasOwn(actions, path)) {
        if (request.headers['x-giving-demo'] !== '1') {
          json(response, 403, { error: 'Use the local dashboard or send the X-Giving-Demo header.' })
          return
        }
        actions[path](url)
        json(response, 200, store.snapshot())
        return
      }
      if (request.method === 'GET' && Object.hasOwn(staticFiles, path)) {
        const [file, type] = staticFiles[path]
        const contents = await readFile(new URL(`./public/${file}`, import.meta.url))
        response.writeHead(200, { 'Content-Type': type, 'X-Content-Type-Options': 'nosniff' })
        response.end(contents)
        return
      }
      json(response, 404, { error: 'Page or endpoint not found.' })
    } catch (error) {
      console.error(error)
      if (!response.headersSent) json(response, 500, { error: 'The demo could not finish this operation.' })
      else response.destroy()
    }
  })
}

if (import.meta.main) {
  const path = process.env.GIVING_DB ?? fileURLToPath(new URL('./giving.sqlite', import.meta.url))
  const port = Number(process.env.GIVING_PORT ?? 4317)
  const store = new GivingStore(path)
  const server = createApp(store)
  const run = setInterval(() => {
    try {
      store.run()
    } catch (error) {
      console.error('Scheduled processing failed. The worker will try again.', error)
    }
  }, 30_000)

  server.listen(port, '127.0.0.1', () => {
    console.log(`Giving Ops is running at http://127.0.0.1:${port}`)
  })

  function shutdown(): void {
    clearInterval(run)
    server.close(() => store.close())
  }
  process.once('SIGINT', shutdown)
  process.once('SIGTERM', shutdown)
}
