# Plan Registry — Portfolio Status

Single source of truth for plan status. Update on every status transition.

**Last updated:** 2026-05-01 (design-docs sync; legacy `plans/feat|fix|volatile*` moved under `plans/archived/`)

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

Active strategic phase: **S1**, Stage **S1.B** (per `plans/cursor/strategic-roadmap-reframe-53be/README.md` §3).

## In Progress

| plan_id | priority | phase | branch | owner | depends_on | blocks | parallel_safe_with | updated | notes |
|---|---|---|---|---|---|---|---|---|---|
| _(empty — pre-governance plans closed; S1.B sub-plans pending creation)_ | | | | | | | | | |

## Ready for Execution

| plan_id | priority | phase | branch | depends_on | blocks | parallel_safe_with | conflicts_with | notes |
|---|---|---|---|---|---|---|---|---|
| _(empty — S1.B Sprint Brief plans created during Topic 11 close-out will land here as authored)_ | | | | | | | | |

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

Pre-governance plans closed at huddle as part of Topic 11 reconciliation. They executed under prior conventions; their contributions are folded into the S1.A → S1.B transition state.

| plan_id | phase | completed_date | strategic_impact | pr_url(s) |
|---|---|---|---|---|
| `PLAN_API_REFLEX_BETA_READINESS_2026-04-28` | S1.A | 2026-04-30 (close) | API hardening shipped; Reflex archived; web is flagship | (multiple — see API repo PRs #16-18) |
| `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28` | S1.A | 2026-04-30 (close) | Blue-green runtime deployed; CPPR+D pipeline live | (parent repo PRs) |
| `PLAN_VPS_BETA_ROLLOUT_OPS_2026-04-28` | S1.A | 2026-04-30 (close) | VPS go-live successful; bug-report intake operational | (parent repo PRs) |
| `PLAN_SECURITY_HARDENING_MIDDLEWARE_ALIGNMENT_2026-04-28` | S1.A | 2026-04-30 (close) | HSTS, log redaction, env hygiene shipped; ZK middleware deferred to S5 | (multiple) |
| `PLAN_FEAT_DASHBOARD_I18N_CALENDAR_2026-04-28` | S1.A | 2026-04-30 (close) | Reflex i18n + calendar (now archived with Reflex) | (multiple) |
| `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29` | S1.A | 2026-04-30 (close) | Reflex blue-green recovery completed; subsequently archived per Topic 2 | (parent repo PRs) |
| `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29` | S1.A | 2026-04-30 (close) | JS web rollout shipped; web is now flagship; BP1-BP7 complete | (web repo PRs #2-11+) |

## Abandoned

| plan_id | phase | abandoned_date | abandoned_reason |
|---|---|---|---|
| _(empty)_ | | | |

## Archived (Index Only — files at `plans/archived/`)

Older plans from prior cycles. Not retroactively migrated to this registry. Future archives appear here.

| plan_id | archived_date | phase | notes |
|---|---|---|---|
| `LAYOUT_LEGACY_FEAT_FIX_VOLATILE_2026-05-01` | 2026-05-01 | S1.B | Workspace hygiene: former top-level `plans/feat/`, `plans/fix/`, `plans/volatile/`, `plans/volatile_standby/` moved under `plans/archived/`; cross-links updated. New work must not resurrect removed top-level paths. |

## Hierarchical plan structure (Topic 11 lock)

New plans use the hierarchical pattern per `_governance/branching_guidelines.md`:

```
plans/cursor/<phase-stage>/                          ← Stage umbrella
  ├── README.md                                       Stage summary + sub-plan index
  ├── <sub-plan-name>/                                Sub-plan
  │   ├── README.md                                   Plan metadata + body
  │   ├── tasks/
  │   │   └── T<NN>_<slug>.md
  │   └── validation_gates.md
  └── feat/<feature-name>/                            Feature-track sub-plan (optional)
      ├── README.md
      └── tasks/
```

Branch names follow the hierarchy:

```
cursor/s1b/<sub-plan-name>                            (sub-plan branch)
cursor/s1b/feat/<feature-name>                        (feature branch)
cursor/s1b/feat/<feature-name>/t<NN>-<slug>           (task branch)
```

Pre-existing plans NOT retroactively moved. Stay at `plans/cursor/<branch>/` per their original paths.

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

See `_governance/branching_guidelines.md` §5 for color-cycle concurrency rules (one feature at a time).
