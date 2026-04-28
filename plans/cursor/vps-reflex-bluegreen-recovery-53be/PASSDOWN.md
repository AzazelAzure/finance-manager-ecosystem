# Passdown — VPS Reflex blue-green recovery

**Plan:** `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29`  
**Plan root:** `plans/cursor/vps-reflex-bluegreen-recovery-53be/`  
**Last updated:** 2026-04-29 (host/workspace agent session)

Use this file as the primary handoff for a **cloud agent** or a later **execution-plane** session. Re-read [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md) and [`../../_governance/deployment_protocol.md`](../../_governance/deployment_protocol.md) before any VPS lifecycle work.

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

---

## Where we left off

- **Live user traffic** is still the **original single-stack**: `docker-compose.yml` / project `finance_manager`, containers `finance-manager-{db,api,reflex,proxy}`. Nothing was **`deploy`**, **`switch`**, or **`smoke --color inactive`** for the **fm-beta** blue-green project in this session.
- **`fm_server_beta.sh status`** shows logical colors (active **blue**, inactive **green**) and only lists the legacy `finance-manager-*` containers in its filtered view — **inactive color services are not running yet**.
- **Breakpoint B** (public login / dashboard / F5 / websocket stability) was **not** re-validated in this pass.
- **Breakpoint C** is **partially** satisfied: **`check` passes**; **`deploy` + `smoke --color inactive` are not done** (see `validation_gates.md`).
- **Runtime Signup Sheet** was not re-claimed for this session; coordinate before any `fm_docker.sh` / `fm_server_beta.sh deploy` on VPS.
- **Slack gates** (`pre_deploy`, `pre_cutover`) were **not** posted; required per deployment protocol before VPS writes that promote risk (deploy to inactive is still a VPS write — follow org practice on `pre_deploy`).

---

## What is next (ordered)

1. **Claim runtime owner** on [`design_docs/30_Releases/Runtime_Signup_Sheet.md`](../../../design_docs/30_Releases/Runtime_Signup_Sheet.md); confirm no conflict with [sibling JS plan](../finance-manager-web-beta-rollout-53be/README.md).
2. **`pre_deploy` gate** (if your org requires it for this host): post per [`deployment_protocol.md`](../../_governance/deployment_protocol.md) §3 before `deploy`.
3. **T03 — Inactive color only** ([`tasks/T03_inactive_deploy_smoke.md`](./tasks/T03_inactive_deploy_smoke.md)):
   - SSH: `dev@159.198.75.194`
   - `cd /home/dev/finance_manager`
   - Export smoke hosts (see below).
   - `./scripts/fm_server_beta.sh status` → confirm inactive color (**green** as of last check).
   - `./scripts/fm_server_beta.sh deploy green` (or dry-run first if recovering from failure).
   - `./scripts/fm_server_beta.sh smoke --color inactive`
   - **Do not** `switch` / `promote` inside T03.
4. Record commands, timestamps, and smoke outcome in `runtime_handoff.md` or `tasks/T03_notes.md` (create if needed).
5. **Breakpoint B** if not yet satisfied: human or scripted checks on public URL (login, dashboard, F5, websocket).
6. **T04 / cutover** only after **T03** success + human **`pre_cutover`** approval ([`tasks/T04_optional_cutover.md`](./tasks/T04_optional_cutover.md)).

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

## Cloud agent vs execution plane

- Workspace rules + [`deployment_protocol.md`](../../_governance/deployment_protocol.md): **cloud / planning agents** should treat **SSH and deploy** as **execution-plane** work unless your session is explicitly waived in as execution plane.
- This passdown assumes a **host-trusted agent** or human runs SSH, `push_runtime_bundle.sh`, `fm_server_beta.sh deploy/smoke`.
- **Cloud agent** can still: update plans, open/refresh PRs, reconcile validation gates text, draft Slack gate messages, and sequence tasks for the execution plane.

---

## Git / PR follow-up

- Parent repo commit **`a2e495a`** (`create_runtime_bundle.sh`): push and include in a PR if not already on remote; plan README names branch `cursor/vps-reflex-bluegreen-recovery-53be` for *this* plan’s feature work — reconcile branch naming with whatever branch actually carries the bundle change when opening PRs.
- Plan markdown edits under `plans/cursor/vps-reflex-bluegreen-recovery-53be/` may be uncommitted until you commit them on an appropriate branch.

---

## First files to read on pickup

1. This file (**PASSDOWN.md**)
2. [`runtime_handoff.md`](./runtime_handoff.md)
3. [`validation_gates.md`](./validation_gates.md)
4. [`README.md`](./README.md) (Execution status section)
5. [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md)
