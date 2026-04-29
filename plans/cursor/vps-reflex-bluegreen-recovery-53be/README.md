---
plan_id: PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29
execution_model: delegated_agents
orchestration_branch: cursor/vps-reflex-bluegreen-recovery-53be
sibling_plan: plans/cursor/finance-manager-web-beta-rollout-53be
deployment:
  required: true
  target_services:
    - reflex
    - proxy
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - "GET https://{PUBLIC_HOST}/ (Reflex root)"
    - "GET https://{API_HOST}/api/health/"
    - "WebSocket /_event stability on reflex-api host"
  notes: >-
    Coordinate with JS plan for CORS and extra server_name blocks.
    CPPR+D per plans/_governance/deployment_protocol.md; execution plane for SSH/deploy.
---

# VPS Reflex stack and blue-green recovery

## Execution status (rolling)

| Phase | State | Notes (as of 2026-04-29) |
|-------|--------|---------------------------|
| **A — Inventory** | **Done** | [`tasks/T01_inventory_results.md`](./tasks/T01_inventory_results.md), [`runtime_handoff.md`](./runtime_handoff.md). VPS = single-stack live + pseudo-BG proxy files on disk. |
| **B — Reflex stable** | **Open** | Public path smoke (login, dashboard, F5, websocket) not re-run this session. |
| **C — BG tooling** | **Parallel path done** | `FM_BG_PARALLEL=1` + [`docker-compose.bluegreen.parallel.yml`](../../../docker-compose.bluegreen.parallel.yml): **deploy** + **smoke inactive** on VPS without stopping legacy. See [`tasks/T03_parallel_impl_notes.md`](./tasks/T03_parallel_impl_notes.md). `switch` still for a later edge cutover. |
| **D — CPPR + deploy** | **Open** | Re-bundle to ship parallel compose + `fm_server_beta` updates; then CPPR. |
| **E — Parallel deploy + JS** | **In progress** | **A/B** (parallel + env-file) **implemented** in repo. **C** optional `web-*` + **D** Reflex sunset: follow [design doc](../../../design_docs/40_System_Design/14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md) + [web plan](../finance-manager-web-beta-rollout-53be/README.md). |

**Handoff for next agent:** read **[PASSDOWN.md](./PASSDOWN.md)** first, then the design doc above.

**Execution:** This work is assigned to a **dedicated Reflex/runtime agent**. Phases below are for that agent end-to-end; the orchestrator does not run them inline in chat.

## Agent startup

1. Paste **[AGENT_LAUNCH_PROMPT.md](./AGENT_LAUNCH_PROMPT.md)** into the agent (VPS is already set to `dev@159.198.75.194`; branch is `cursor/vps-reflex-bluegreen-recovery-53be`).
2. Follow **[CROSS_AGENT_COORDINATION.md](./CROSS_AGENT_COORDINATION.md)** before any container or VPS deploy.

## Context

- **Parallel deploy + future JS UI:** single source of truth for *how* we run inactive color beside active traffic and how **`finance_manager_web`** joins the same blue/green cycle when Reflex is sunset — [`14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md`](../../../design_docs/40_System_Design/14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md).
- VPS has often run **single-stack** [`docker-compose.yml`](../../../docker-compose.yml) + [`proxy/nginx.conf`](../../../proxy/nginx.conf) + [`scripts/fm_docker.sh`](../../../scripts/fm_docker.sh). Blue-green files exist: [`docker-compose.bluegreen.yml`](../../../docker-compose.bluegreen.yml), [`proxy/nginx.bluegreen.conf`](../../../proxy/nginx.bluegreen.conf), [`scripts/fm_server_beta.sh`](../../../scripts/fm_server_beta.sh).
- Baseline narrative: [`../server-beta-install-bluegreen-53be/known_good_beta_state_apr28.md`](../server-beta-install-bluegreen-53be/known_good_beta_state_apr28.md).
- Live cutover was previously deferred — do not `switch` without **pre_cutover** gate per [`deployment_protocol.md`](../../_governance/deployment_protocol.md).

## Phase A — Inventory

- **Goal:** Single source of truth: what is running on VPS, how tunnel maps to nginx, which compose project.
- **Exit:** Written artifact under `tasks/` or [`runtime_handoff.md`](./runtime_handoff.md); Breakpoint A in [`validation_gates.md`](./validation_gates.md) → pass.

## Phase B — Reflex stability on chosen stack

- **Goal:** Reliable Reflex through public hostname; script-first restarts; chart/dashboard behavior acceptable (see existing mapper fallbacks in Reflex repo).
- **Exit:** Breakpoint B in `validation_gates.md` → pass; Reflex submodule changelog if code changed.

## Phase C — Blue-green alignment

- **Goal:** `fm_server_beta.sh check`; deploy **inactive** color; smoke inactive; document `FM_PUBLIC_APP_HOST` / `FM_PUBLIC_API_HOST` for thehivemanager-style hosts.
- **Exit:** Breakpoint C minimum in `validation_gates.md`; optional cutover only with governance gates.

## CPPR+D through manual verification

| Step | Action |
|------|--------|
| C | Commit on `cursor/vps-reflex-bluegreen-recovery-53be` (submodule + parent as needed) |
| P | Push |
| PR | Open; workspace PR rules + Slack `#pull-requests` |
| M | Merge after checks |
| D | Execution plane: bundle (if required), push to VPS **inactive** color, `fm_server_beta.sh deploy`, `smoke`, then `pre_deploy` / `pre_cutover` Slack gates before any cutover |

After deploy: **human** manual verification (login, dashboard, F5, websocket) — record result in `runtime_handoff.md` or task notes.

## Task packets (create or expand as work proceeds)

| Task | Purpose |
|------|---------|
| [tasks/T01_inventory_single_vs_bluegreen.md](./tasks/T01_inventory_single_vs_bluegreen.md) | VPS discovery |
| [tasks/T02_align_fm_server_beta_env.md](./tasks/T02_align_fm_server_beta_env.md) | Smoke host env overrides |
| [tasks/T03_inactive_deploy_smoke.md](./tasks/T03_inactive_deploy_smoke.md) | Inactive color only |
| [tasks/T04_optional_cutover.md](./tasks/T04_optional_cutover.md) | Gated cutover / rollback |
