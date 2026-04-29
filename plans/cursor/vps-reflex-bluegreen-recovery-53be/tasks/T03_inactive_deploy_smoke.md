# T03 — Deploy and smoke **inactive** color only

**Status (2026-04-29):** **Unblocked (parallel path)** — use **`FM_BG_PARALLEL=1`** and [`docker-compose.bluegreen.parallel.yml`](../../../docker-compose.bluegreen.parallel.yml) (see repo root: `docker-compose.bluegreen.parallel.yml`) with shared network + `.secrets/server.env` for `SECRET_KEY`. **`deploy` + `smoke --color inactive`** verified on VPS without stopping legacy stack. See [`T03_parallel_impl_notes.md`](./T03_parallel_impl_notes.md). Historical failed attempt: [`T03_exec_notes_2026-04-29.md`](./T03_exec_notes_2026-04-29.md).

## Objective

Prove blue-green path without switching public traffic.

## Preconditions

- Runtime owner on [Runtime Signup Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md)
- T01 + T02 complete or explicitly waived in README notes

## Steps

1. Identify inactive color: `./scripts/fm_server_beta.sh status`
2. `./scripts/fm_server_beta.sh deploy <inactive_color>` (or dry-run first if recovering from failure)
3. `./scripts/fm_server_beta.sh smoke --color inactive` (or explicit color per script)
4. **Do not** `switch` / `promote` in this task.

## Handoff output

- Commands + timestamps
- Smoke pass/fail; if fail, logs snippet and `failure_category` for Slack handoff

## CPPR

Merged code → execution plane runs **D** per [deployment_protocol.md](../../_governance/deployment_protocol.md) with `pre_deploy` approval before VPS writes.
