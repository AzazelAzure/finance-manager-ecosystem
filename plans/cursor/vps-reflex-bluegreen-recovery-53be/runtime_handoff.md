# Runtime handoff — VPS Reflex blue-green recovery

_Update this file whenever the Reflex agent pauses, completes a breakpoint, or transfers ownership._

## Copy/paste handoff

- **Session / plan:** PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29
- **VPS SSH:** `dev@159.198.75.194` (shared with JS plan agent; coordinate lifecycle via Runtime Signup Sheet)
- **Stack in use:** `docker-compose.yml` **single-stack** still serving **public** traffic (project `finance_manager`). **Parallel blue/green** app path: `docker-compose.bluegreen.parallel.yml` + `FM_BG_PARALLEL=1` (see [`tasks/T03_parallel_impl_notes.md`](./tasks/T03_parallel_impl_notes.md)); full `docker-compose.bluegreen.yml` + `fm_server_beta` without parallel still for standalone/edge-complete layouts.
- **Active color (if BG):** `blue` in `active_color.conf` on disk; live proxy still **single-stack** `nginx.conf` until cutover.
- **Last lifecycle command:** `push_runtime_bundle.sh` → `/home/dev/finance_manager` — bundle **`finance_manager_runtime_20260429_082826`**, **main** @ **`9495f5b`** (post–PR #18 merge), manifest clean.
- **Last status:** Ecosystem **main** merged; VPS tree refreshed from bundle. Re-run parallel **`deploy` / `smoke`** after pull if you recycled `fm-beta` containers. **Public `switch`:** still needs edge on `nginx.bluegreen.conf` (not in this bundle’s live path).
- **Sibling JS plan status:** See [../finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) before proxy edits.
- **Blockers:** **Edge cutover** to blue/green nginx for real users; optional **fm-beta** parallel containers recycled — not blockers for dev. Cloudflared: not verified (no passwordless sudo).

## VPS smoke env (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

## Minimum rules

See [design_docs/30_Releases/Runtime_Owner_Handoff_Template.md](../../../../design_docs/30_Releases/Runtime_Owner_Handoff_Template.md).
