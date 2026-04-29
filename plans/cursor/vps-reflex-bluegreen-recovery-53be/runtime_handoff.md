# Runtime handoff — VPS Reflex blue-green recovery

_Update this file whenever the Reflex agent pauses, completes a breakpoint, or transfers ownership._

## Copy/paste handoff

- **Session / plan:** PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29
- **VPS SSH:** `dev@159.198.75.194` (shared with JS plan agent; coordinate lifecycle via Runtime Signup Sheet)
- **Stack in use (VPS 2026-04-29):** **Gated cutover** complete — public edge is **`fm-beta`** with `docker-compose.bluegreen.yml` + `docker-compose.bluegreen.cutover.yml` (external `finance_manager_postgres_data`), **not** the legacy `finance_manager` single-stack. Legacy single-stack is **down** for this window.
- **Active color (BG):** `blue` in `active_color.conf` on the server; Nginx `nginx.bluegreen.conf` (thehivemanager FQDNs) + TLS on **:8443** / HTTP **:8080** on `fm-beta_proxy_1`.
- **502 fix (Podman + variable `proxy_pass`):** Nginx was using Docker’s `resolver 127.0.0.11`, which is **unreachable in Podman**; upstream names (`api-blue`, `reflex-blue`, …) failed to resolve and returned **502**. Ecosystem **main** @ **`780a030`**: `proxy/docker-entrypoint.d/20-resolver-from-resolv.sh` writes `conf.d/00-resolver.conf` from the container’s first `/etc/resolv` nameserver (VPS: **`10.89.1.1`**) with optional `NGINX_RESOLVER` override. After **rebuild proxy image** and **recreate** `fm-beta_proxy_1`, `curl -kfsS -H "Host: api.thehivemanager.com" https://127.0.0.1:8443/api/health/` returns **`{"status":"ok"}`**.
- **Last lifecycle command:** Ecosystem `git push origin main` (**`780a030`**); on VPS, `podman build … fm-beta_proxy` + `podman stop/rm fm-beta_proxy_1` + `podman-compose up -d` for proxy.
- **Sibling JS plan status:** See [../finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) for CORS/Cloudflare; API CORS is on **API** `main` (merged earlier).
- **Breakpoint B (2026-04-30):** Re-verify **Reflex** websocket and dashboard through **`reflex-api.thehivemanager.com`** path after cloudflared; no longer blocked by nginx 502 to upstream.
- **Blockers / follow-up:** Re-validate **cloudflared** to **:8443** from outside; if proxy image is rebuilt again, use **`--build proxy`** and **recreate** the container so the new image is not skipped when compose falls back to `start` on existing names.

## VPS smoke env (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

## Minimum rules

See [design_docs/30_Releases/Runtime_Owner_Handoff_Template.md](../../../../design_docs/30_Releases/Runtime_Owner_Handoff_Template.md).
