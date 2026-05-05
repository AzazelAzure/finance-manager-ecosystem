# Huddle reconciliation delta — 2026-05-05

**Canonical checklist:** [`ACTIONS.md`](./ACTIONS.md) (this file summarizes verified state vs the repo; [`implementation_plan.md`](./implementation_plan.md) exit table is aligned to match).

## Verified done (repo + ACTIONS)

| # | Deliverable | Evidence |
|---|-------------|----------|
| 1 | `strategy/huddles/` tree + post-beta migration | Present |
| 2 | `governance/plan_template.md` V-tiers §1a | Present |
| 4 | `governance/runtime_handoff_template.md` | Present |
| 6 | F-001–F-013 slice V-tier retrofit | Marked done in ACTIONS |
| 8 | Governance glossary / README updates per huddle | Marked done |

## Partial

| # | Item | Remaining work |
|---|------|----------------|
| 3 | Deployment script audit | VPS orphan/duplicate containers (legacy Reflex prefixes per `DEPLOYMENT_AUDIT.md`); SHA check in `smoke_cmd` pending `/api/version/` contract |

## Partial (continued)

| # | Item | Notes |
|---|------|-------|
| 7 | F-007 manual verification vs handoff | V3 findings + slice log in `runtime_handoff.md`; V2 log contract + `sprint_verify.sh` added 2026-05-05 — HitM V3 re-run after rework slices still pending |

## Open

| # | Item | Notes |
|---|------|-------|
| 9 | Slack accounts `cursor-agent`, `antigravity-agent` | HitM when ready |
| 10 | Cursor subagent concurrency limits | HitM when ready |

## New automation (this pass)

- [`scripts/sprint_verify.sh`](../../../scripts/sprint_verify.sh) — inactive-color deploy + smoke + evidence (Phase 2b).
- [`scripts/jsdevtesting_stack_check.sh`](../../../scripts/jsdevtesting_stack_check.sh) — optional curl guardrails for staging hostnames.
- [`governance/cursor_pa_slack_visibility.md`](../../../governance/cursor_pa_slack_visibility.md) — Cursor PA + outbox vs IDE MCP.

## Superseded / clarified

- **Slack orchestration:** Primary visibility is **Cursor PA** (local, out of repo) via **JSONL outbox** (e.g. `slack_outbox.jsonl` — confirm basename in Cursor PA). In-repo `cursor_headless_slack_agent.py` is optional reference only.
- **Antigravity Slack runner:** Legacy for orchestration; do not use for new sprints (see `governance/agent_workspace_isolation.md` and script header).
