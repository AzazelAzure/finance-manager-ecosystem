# T04 — Lane B: `jsdevtesting.thehivemanager.com` on VPS

## Local tunnel first (ready to test HTTPS hostname)

Before nginx on VPS, you can pipe **`jsdevtesting.thehivemanager.com`** to your laptop with **Cloudflare Tunnel** (`cloudflared`).

- **Private service URL in Cloudflare (localhost pointer):**
  - **`http://127.0.0.1:5173`** while running `npm run dev` in `finance_manager_web`
  - **`http://127.0.0.1:4173`** after `npm run build && npm run preview` (production bundle)
- **Env:** `.env.local` → `VITE_API_BASE_URL=https://api.thehivemanager.com`
- **Details:** `finance_manager_web/README.md` section *Lane B — jsdevtesting… via Cloudflare Tunnel*; `vite.config.ts` sets `allowedHosts` for the tunnel `Host` header.

VPS static hosting below is still the durable “team” path.

## Objective

Public HTTPS URL serves the **built** JS app while API remains `https://api.thehivemanager.com` (prod DB, no local DB fork).

## Steps

1. Build: `npm run build` in `finance_manager_web` (artifact: `dist/`).
2. Choose serving strategy (document in PR):
   - Static `root` on existing proxy container with new `server_name`, **or**
   - Small dedicated static container on internal port + nginx `proxy_pass`, **or**
   - Upload `dist/` to VPS path and nginx `alias`.
3. Cloudflare: DNS + tunnel route for `jsdevtesting.thehivemanager.com`.
4. API: add `https://jsdevtesting.thehivemanager.com` to `CORS_ALLOWED_ORIGINS` (and CSRF if needed later).
5. Smoke from **external** network (not only localhost on VPS).

## Preconditions

- Coordinate with Reflex agent via [Runtime Signup Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md) before editing root `proxy/nginx.conf` or reloading production-critical nginx.

## Handoff output

- URL
- nginx snippet location / PR
- Screenshot or HAR optional

## CPPR+D

API and proxy VPS changes: merged PR → execution plane **D** with `pre_deploy` per [deployment_protocol.md](../../../../governance/deployment_protocol.md).
