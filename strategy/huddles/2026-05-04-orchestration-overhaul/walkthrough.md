# Walkthrough: Emergency Orchestration Overhaul Huddle

## What Happened

HitM identified fundamental systemic failures in the AI orchestration workflow after F-007 Guided Walkthroughs and PWA sprint experiences showed agents marking tasks complete without actual verification. This huddle diagnosed the three-stage failure cascade (coarse batches → slices without enforcement → this huddle) and established new governance infrastructure.

## Decisions Locked (10)

| ID | Decision | Impact |
|----|----------|--------|
| D1 | **Verification Tiers (V0–V3)** | Every slice checklist item must declare V-tier; agents cannot mark PASS without meeting tier |
| D2 | **Sprint Automation (phased)** | Fix deployment scripts first (2a), then build `sprint_verify.sh` (2b), then full automation (2c) |
| D3 | **Agent Identity Separation** | Three Slack accounts: HitM, `cursor-agent`, `antigravity-agent` |
| D4 | **Huddles as First-Class Artifacts** | `strategy/huddles/<date>-<topic>/` with scheduled + emergency + retro cadence |
| D5 | **Task Generation: Separation of Concerns** | Four roles: Orchestrator → Executor → Reviewer → HitM Gate; no self-certification |
| D6 | **Slice Branching: Deferred** | Get V-tiers working first; add per-slice branches for V2+ later |
| D7 | **Retrofit All Plans** | F-001–F-013 all get V-tier format; each feature = its own sprint |
| D8 | **Slack Channel Architecture** | Three new channels: `#sprint-queue`, `#review-queue`, `#hitm-gate` |
| D9 | **Huddle Location** | `strategy/huddles/` permanent; decisions propagate to governance at exit |
| D10 | **Antigravity Slack Runner** | Basic bridge created as huddle exit condition |

## Files Created

| File | Purpose |
|------|---------|
| [README.md](file:///home/pproctor/Documents/python/finance_manager/strategy/huddles/2026-05-04-orchestration-overhaul/README.md) | Huddle agenda + source links |
| [DECISIONS.md](file:///home/pproctor/Documents/python/finance_manager/strategy/huddles/2026-05-04-orchestration-overhaul/DECISIONS.md) | 10 append-only locked decisions |
| [ACTIONS.md](file:///home/pproctor/Documents/python/finance_manager/strategy/huddles/2026-05-04-orchestration-overhaul/ACTIONS.md) | 10 deliverables with status + file manifest |
| [DEPLOYMENT_AUDIT.md](file:///home/pproctor/Documents/python/finance_manager/strategy/huddles/2026-05-04-orchestration-overhaul/DEPLOYMENT_AUDIT.md) | 5 issues found on VPS deployment scripts |
| [runtime_handoff_template.md](file:///home/pproctor/Documents/python/finance_manager/governance/runtime_handoff_template.md) | Structured YAML template for sprint handoffs |
| [antigravity_slack_runner.py](file:///home/pproctor/Documents/python/finance_manager/scripts/antigravity_slack_runner.py) | Slack → `antigravity chat` bridge |
| [2026-04-30-post-beta/](file:///home/pproctor/Documents/python/finance_manager/strategy/huddles/2026-04-30-post-beta) | Migrated post-beta huddle from `plans/archived/` |

## Files Modified

| File | Change |
|------|--------|
| [plan_template.md](file:///home/pproctor/Documents/python/finance_manager/governance/plan_template.md) | Added V-tier section to §1a with enforcement rules + role separation |
| [glossary.md](file:///home/pproctor/Documents/python/finance_manager/governance/glossary.md) | Added §9 V-tiers, §10 Agent roles, §11 Huddles |
| [governance/README.md](file:///home/pproctor/Documents/python/finance_manager/governance/README.md) | Added runtime handoff template + huddle references |
| [fm_server_beta.sh](file:///home/pproctor/Documents/python/finance_manager/scripts/fm_server_beta.sh) | Added `--no-cache` flag to `rebuild-color` command |
| [F-007 README.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md) | Added V-Tier column to task/slice table |

## Remaining Items (HitM-dependent)

1. **F-007 manual verification overview** — HitM has notes on current state vs handoff; needs reconciliation
2. **Slack account creation** — HitM creates `cursor-agent` + `antigravity-agent` accounts and invites to channels
3. **Cursor subagent limits** — HitM confirms max concurrent subagents for pipeline concurrency planning
4. **VPS orphan cleanup** — Three stale container project prefixes need removal (coordinate timing)
5. **API version endpoint** — `/api/version/` returning git SHA for smoke verification

## Validation

- `antigravity_slack_runner.py` imports clean (no syntax errors)
- `fm_server_beta.sh` `--no-cache` flag tested via `--help` output (usage text updated)
- All governance files cross-reference correctly
- V-tier definitions consistent across `plan_template.md`, `glossary.md`, and `DECISIONS.md`
