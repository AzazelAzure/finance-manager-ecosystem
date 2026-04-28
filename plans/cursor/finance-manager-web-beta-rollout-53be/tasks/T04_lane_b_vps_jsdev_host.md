# T04 — Lane B: `jsdevtesting.thehivemanager.com` on VPS

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

API and proxy VPS changes: merged PR → execution plane **D** with `pre_deploy` per [deployment_protocol.md](../../_governance/deployment_protocol.md).
