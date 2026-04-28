# Runtime handoff — VPS Reflex blue-green recovery

_Update this file whenever the Reflex agent pauses, completes a breakpoint, or transfers ownership._

## Copy/paste handoff

- **Session / plan:** PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29
- **VPS SSH:** `dev@159.198.75.194` (shared with JS plan agent; coordinate lifecycle via Runtime Signup Sheet)
- **Stack in use:** `docker-compose.yml` **single-stack** still serving traffic (project `finance_manager`). **Pseudo BG:** `proxy/nginx.bluegreen.conf` + `proxy/active_color.conf` (blue); **live** `proxy/nginx.conf` single-stack. **`docker-compose.bluegreen.yml` present** after bundle sync; `fm_server_beta.sh check` passes (tooling ready; BG stack not deployed yet).
- **Active color (if BG):** `blue` in `active_color.conf` only; not wired through running nginx/compose BG project yet.
- **Last lifecycle command:** `push_runtime_bundle.sh` → `/home/dev/finance_manager` (bundle `finance_manager_runtime_20260429_073503`).
- **Last status:** Single-stack `finance_manager` still serving. `docker-compose.bluegreen.yml` on disk after bundle. `FM_PUBLIC_*` for thehivemanager: `fm_server_beta.sh status` + `check` **pass** (compose config ok, nginx blue/green `nginx -t` ok). No `deploy` / `switch` run this session.
- **Sibling JS plan status:** See [../finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) before proxy edits.
- **Blockers:** None for `fm_server_beta.sh check`. Inactive-color **deploy/smoke** (Breakpoint C) not run yet; cutover still gated. Cloudflared config not verified (no passwordless sudo).

## VPS smoke env (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

## Minimum rules

See [design_docs/30_Releases/Runtime_Owner_Handoff_Template.md](../../../../design_docs/30_Releases/Runtime_Owner_Handoff_Template.md).
