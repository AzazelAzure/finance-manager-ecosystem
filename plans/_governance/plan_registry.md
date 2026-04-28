# Plan Registry — Portfolio Status

Single source of truth for plan status. Update on every status transition.

**Last updated:** 2026-04-29

## Update protocol

```
On status change:
  1. Move row to the section matching new status
  2. Update the plan's metadata header `updated:` field
  3. Update this file's "Last updated" header above
```

## Strategic plan (always active)

| plan_id | status | phase | plan_root |
|---|---|---|---|
| `PLAN_STRATEGIC_ROADMAP_REFRAME_2026-04-28` | `active` | (root) | `plans/cursor/strategic-roadmap-reframe-53be/` |

Active strategic phase: **S1**.

## In Progress

These plans are actively executing against the running VPS under a separate (pre-governance) agent workstream. Do not pick up; do not modify their plan files; do not register conflicting work. Their actual dependencies and conflicts are managed outside this governance system pending close-out.

| plan_id | priority | phase | branch | owner | depends_on | blocks | parallel_safe_with | updated | notes |
|---|---|---|---|---|---|---|---|---|---|
| `PLAN_API_REFLEX_BETA_READINESS_2026-04-28` | P0 | S1 | `cursor/api-reflex-beta-readiness-plan-53be` | external_agent | — | `PLAN_VPS_BETA_ROLLOUT_OPS_2026-04-28` | `PLAN_FEAT_DASHBOARD_I18N_CALENDAR_2026-04-28` | 2026-04-29 | pre-governance; active on VPS |
| `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28` | P0 | S1 | `cursor/server-beta-install-bluegreen-53be` | external_agent | — | — | review needed | 2026-04-29 | pre-governance; active on VPS |
| `PLAN_VPS_BETA_ROLLOUT_OPS_2026-04-28` | P0 | S1 | `cursor/vps-beta-rollout-ops` | external_agent | `PLAN_API_REFLEX_BETA_READINESS_2026-04-28`, `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28` | — | — | 2026-04-29 | pre-governance; active on VPS |
| `PLAN_SECURITY_HARDENING_MIDDLEWARE_ALIGNMENT_2026-04-28` | P0 | S1 + S4/S5 prep | `cursor/security-hardening-plan-53be` | external_agent | — | — | `PLAN_FEAT_DASHBOARD_I18N_CALENDAR_2026-04-28` | 2026-04-29 | pre-governance; active on VPS |
| `PLAN_FEAT_DASHBOARD_I18N_CALENDAR_2026-04-28` | P1 | S1 (UX polish) | `feat/dashboard-transactions-i18n-calendar-month` | external_agent | — | — | most | 2026-04-29 | pre-governance; active on VPS |

> **Pre-governance plans** (those marked `pre-governance` above) were authored before this governance system existed. They are being executed under prior conventions by a separate agent workstream. Their close-out will retrofit governance metadata if needed; until close, do not invalidate their progress with concurrent work that would conflict.

## Ready for Execution

| plan_id | priority | phase | branch | depends_on | blocks | parallel_safe_with | conflicts_with | notes |
|---|---|---|---|---|---|---|---|---|
| `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29` | P0 | S1 | `cursor/vps-reflex-bluegreen-recovery-53be` | `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28` | — | `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29` | uncoordinated `proxy/` + root compose edits | delegated agent; see plan `AGENT_LAUNCH_PROMPT.md` |
| `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29` | P0 | S1 | `cursor/finance-manager-web-beta-rollout-53be` | — | — | `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29` | same | submodule + CORS/VPS jsdev host; `AGENT_LAUNCH_PROMPT.md` |

## Draft / Planning

| plan_id | phase | author | created | notes |
|---|---|---|---|---|
| _(empty)_ | | | | |

## Paused

| plan_id | phase | paused_date | paused_reason | resume_trigger |
|---|---|---|---|---|
| _(empty)_ | | | | |

## Blocked

| plan_id | phase | blocked_since | blocker | resolution_owner |
|---|---|---|---|---|
| _(empty)_ | | | | |

## Recently Completed (last 30 days)

| plan_id | phase | completed_date | strategic_impact | pr_url(s) |
|---|---|---|---|---|
| _(empty)_ | | | | |

## Abandoned

| plan_id | phase | abandoned_date | abandoned_reason |
|---|---|---|---|
| _(empty)_ | | | |

## Archived (Index Only — files at `plans/archived/`)

| plan_id | archived_date | phase | notes |
|---|---|---|---|
| _(future archives appear here)_ | | | |

## Conflict pre-check (read before authoring)

For each currently-active plan (In Progress + Ready):

```
1. List target_repos(active_plan) ∩ target_repos(my_plan)
2. If intersection non-empty:
   - Check shared infra (docker-compose.yml, proxy/, .secrets/, root scripts, settings.py)
   - Check shared Django apps
   - Check migration sequence
3. If any conflict signature matches: declare conflicts_with
4. Else: candidate for parallel_safe_with (confirm both plans agree)
```

See `_governance/execution_protocols.md` §8 for canonical conflict signatures.
