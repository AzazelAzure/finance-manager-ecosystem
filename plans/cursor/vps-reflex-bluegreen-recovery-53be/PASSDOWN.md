# Passdown — VPS Reflex blue-green recovery

**Plan:** `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29`  
**Plan root:** `plans/cursor/vps-reflex-bluegreen-recovery-53be/`  
**Last updated:** 2026-04-30 — parallel T03 done, Breakpoint B signed, main + bundle current

Use this file as the primary handoff for the **next executor** (host agent or human). Re-read [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md) and [`../../../governance/deployment_protocol.md`](../../../governance/deployment_protocol.md) before any VPS lifecycle work.

---

## What is done

| Item | Evidence / notes |
|------|------------------|
| **T01 — VPS inventory** | [`tasks/T01_inventory_results.md`](./tasks/T01_inventory_results.md): single-stack `finance_manager` project live; **pseudo** blue-green (`proxy/nginx.bluegreen.conf`, `proxy/active_color.conf` = blue); live `proxy/nginx.conf` still single-stack (`reflex:3000`). |
| **Breakpoint A** | Inventory + mapping documented; [`runtime_handoff.md`](./runtime_handoff.md) updated. |
| **Bundle includes blue-green compose** | [`scripts/server/create_runtime_bundle.sh`](../../../scripts/server/create_runtime_bundle.sh) stages `docker-compose.bluegreen.yml` and lists it in `RELEASE_MANIFEST.txt`. **Committed** on parent branch `cursor/finance-manager-web-beta-rollout-53be` as `a2e495a` (*Include docker-compose.bluegreen.yml in server runtime bundles*). |
| **VPS sync (bundle push)** | `push_runtime_bundle.sh --host 159.198.75.194 --user dev --remote-dir /home/dev/finance_manager` ran successfully; bundle `finance_manager_runtime_20260429_073503` extracted; remote `verify_release_manifest.sh` passed. |
| **T02 — Smoke host env** | Verified on VPS: `FM_PUBLIC_APP_HOST`, `FM_PUBLIC_API_HOST`, `FM_PUBLIC_BASE_URL` for **thehivemanager.com**; `fm_server_beta.sh check` passes. Export block copied into [`runtime_handoff.md`](./runtime_handoff.md). |
| **`fm_server_beta.sh check` on VPS** | Compose `config` OK; nginx blue/green `nginx -t` OK (via ephemeral container mounts). |
| **T03 (legacy compose conflict)** | Superseded by **parallel** path; historical: [`T03_exec_notes_2026-04-29.md`](./tasks/T03_exec_notes_2026-04-29.md). |
| **T03 (parallel)** | **Done** — [`tasks/T03_parallel_impl_notes.md`](./tasks/T03_parallel_impl_notes.md). |
| **Breakpoint B (2026-04-30)** | **Pass (caveat)** — [`tasks/B_breakpoint_signoff_2026-04-30.md`](./tasks/B_breakpoint_signoff_2026-04-30.md); charts/data population **deferred**. |

---

## Where we left off (2026-04-30)

- **Live traffic:** still **single-stack** `finance_manager` on the public host; **API healthy** for sibling work.
- **Parallel `fm-beta`:** optional; can run **`FM_BG_PARALLEL=1`** `deploy` / `smoke inactive` without taking legacy down.
- **Remaining for “real” blue/green in front of users:** **edge proxy** uses `nginx.bluegreen.conf` + [`T04`](./tasks/T04_optional_cutover.md) + **`pre_cutover`** (governance). Not started.
- **Parent branch:** work landed on **`main`** (ecosystem); latest plan commits on `main` as of session.

---

## What is next (blue/green focus)

1. **Optional:** periodic **`FM_BG_PARALLEL=1`** `check` and **`smoke --color inactive`** after material API/reflex image changes.
2. **When ready for traffic cutover:** `pre_cutover` gate → reconfigure **live** nginx to blue/green (or maintenance window) → `fm_server_beta` **`switch`** — see [design doc](../../design_docs/40_System_Design/14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md) and [`deployment_protocol.md`](../../../governance/deployment_protocol.md).
3. **JS / `web-*` colors:** coordinate with [web plan](../finance-manager-web-beta-rollout-53be/README.md) when the React app is ready; does not block Reflex.
4. **Deferred product work:** dashboard **chart** data population — not tracked as this plan’s exit criteria.

---

## VPS quick facts

| Key | Value |
|-----|--------|
| SSH | `dev@159.198.75.194` |
| Workspace | `/home/dev/finance_manager` |
| Compose (live) | `docker-compose.yml`, project `finance_manager` |
| Blue-green compose (on disk) | `docker-compose.bluegreen.yml` (default project `fm-beta` in `fm_server_beta.sh`) |
| Proxy TLS | `https://127.0.0.1:8443` from host to proxy |

### Smoke exports (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

---

## Execution plane

- Use a **host-trusted agent** or human for SSH, bundle push, and `fm_server_beta` lifecycle. Follow [`deployment_protocol.md`](../../../governance/deployment_protocol.md) for gates.

---

## Git / PR follow-up

- Bundle work is on **`cursor/finance-manager-web-beta-rollout-53be`** (includes `a2e495a`); current tip `cb66e48` was **pushed** to `origin` as of this session’s `git` check.
- Plan docs under `plans/cursor/vps-reflex-bluegreen-recovery-53be/` should be committed on an appropriate feature branch when ready.

---

## First files to read on pickup

1. This file (**PASSDOWN.md**)
2. [`runtime_handoff.md`](./runtime_handoff.md)
3. [`validation_gates.md`](./validation_gates.md)
4. [`README.md`](./README.md) (Execution status section)
5. [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md)
