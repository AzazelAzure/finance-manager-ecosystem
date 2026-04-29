# Runtime handoff — VPS Reflex blue-green recovery

_Update this file whenever the Reflex agent pauses, completes a breakpoint, or transfers ownership._

## Copy/paste handoff

- **Session / plan:** PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29
- **VPS SSH:** `dev@159.198.75.194` (shared with JS plan agent; coordinate lifecycle via Runtime Signup Sheet)
- **Stack in use:** `docker-compose.yml` **single-stack** still serving traffic (project `finance_manager`). **Pseudo BG:** `proxy/nginx.bluegreen.conf` + `proxy/active_color.conf` (blue); **live** `proxy/nginx.conf` single-stack. **`docker-compose.bluegreen.yml` present** after bundle sync; `fm_server_beta.sh check` passes (tooling ready; BG stack not deployed yet).
- **Active color (if BG):** `blue` in `active_color.conf` only; not wired through running nginx/compose BG project yet.
- **Last lifecycle command:** `push_runtime_bundle` (earlier) + T03 `fm_server_beta.sh deploy green` (failed) + **`podman-compose … down -v`** cleanup of partial `fm-beta` stack.
- **Last status:** **Single-stack** `finance-manager-*` all **Up**, api **healthy** after T03 cleanup. T03 `deploy` blocked by **port conflict** with legacy stack; see [`tasks/T03_exec_notes_2026-04-29.md`](./tasks/T03_exec_notes_2026-04-29.md). `fm_server_beta check` still expected to pass when re-run.
- **Sibling JS plan status:** See [../finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) before proxy edits.
- **Blockers:** **T03** requires **maintenance window or compose design** to avoid dual bind on 5432/8080/8443 while migrating single-stack → `fm-beta`. **Breakpoint C** deploy+smoke incomplete until that is resolved. Cloudflared: not verified (no passwordless sudo).

## VPS smoke env (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

## Minimum rules

See [design_docs/30_Releases/Runtime_Owner_Handoff_Template.md](../../../../design_docs/30_Releases/Runtime_Owner_Handoff_Template.md).
