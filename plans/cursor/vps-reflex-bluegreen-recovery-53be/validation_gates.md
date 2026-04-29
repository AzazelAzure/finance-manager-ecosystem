# Validation gates — VPS Reflex blue-green recovery

Plan ID: `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29`  
Sibling plan: [finance-manager-web-beta-rollout-53be](../finance-manager-web-beta-rollout-53be/README.md)

## Status snapshot (2026-04-29)

| Gate | Result |
|------|--------|
| **A** | **Pass** — inventory and pseudo-BG vs single-stack documented under `tasks/` and `runtime_handoff.md`. |
| **B** | **Pass (caveat)** — 2026-04-30: public Dashboard loads; **websocket** reported up; scalar metric (e.g. transactions this month) populates. **Chart / flow widgets** empty — **deferred** data-population work, not a blue/green blocker. |
| **C** | **Minimum pass (parallel)** — `FM_BG_PARALLEL=1`: `check`, **`deploy` inactive**, **`smoke --color inactive`** on VPS without legacy shutdown (see [`tasks/T03_parallel_impl_notes.md`](./tasks/T03_parallel_impl_notes.md)). **No public cutover** (`switch` still N/A for parallel path until edge uses blue/green nginx). |
| **Final** | **Partial** — ecosystem **merged** + **bundle deploy** to VPS done; **human** Breakpoint B sign-off and optional **T04** / `pre_cutover` when edge cutover is scheduled. |

Next execution steps and cloud-vs-SSH split: **[PASSDOWN.md](./PASSDOWN.md)**.

## Breakpoint A — Runtime inventory

- **Pass when:** Document exists in `tasks/` or `runtime_handoff.md`: which compose file is live on VPS, container list, Cloudflare tunnel target port, active domains → upstream mapping; agreement on authoritative stack for the sprint.
- **Owner:** Reflex agent updates Runtime Signup Sheet when touching lifecycle.

## Breakpoint B — Reflex user-path stable

- **Pass when:** Public (or agreed test) URL: login, dashboard, F5 refresh, no sustained `reflex-api` websocket failures; restart procedure documented (script-first).

## Breakpoint C — Blue-green tooling aligned (minimum without public cutover)

- **Pass when:** `scripts/fm_server_beta.sh check` succeeds on VPS; `deploy` + `smoke --color inactive` succeed; **no** `switch` unless logged human pre_cutover approval per deployment_protocol.
- **Stretch:** Cutover + rollback drill with captured commands and outcomes.

## Final — CPPR to manual verification

- **Pass when:** Merged PRs exist for touched repos; deployment_protocol D-step evidence posted if deploy occurred; human sign-off recorded (Slack or plan notes); sibling coordination file updated if proxy/API changed.
