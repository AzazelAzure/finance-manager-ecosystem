# Plan Registry — Portfolio Status

Single source of truth for plan status. Update on every status transition.

**Last updated:** 2026-06-16 (transitioned PLAN_CROSS_SUPPORT_INTAKE_2026-05-21 to in_progress)

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
| `PLAN_STRATEGIC_ROADMAP_REFRAME_2026-04-28` | `active` | (root) | `strategy/strategic-roadmap-reframe-53be/` |

Active strategic phase: **S1**, Stage **S1.B** (per `strategy/strategic-roadmap-reframe-53be/README.md` §3).

## In Progress

| plan_id | priority | phase | branch | owner | depends_on | blocks | parallel_safe_with | updated | notes |
|---|---|---|---|---|---|---|---|---|---|
| _(empty)_ | | | | | | | | | |

## Ready for Execution

| plan_id | priority | phase | branch | depends_on | blocks | parallel_safe_with | conflicts_with | notes |
|---|---|---|---|---|---|---|---|---|
| `PLAN_CROSS_USER_ACTIVITY_LOGS_2026-05-21` | P2 | S1.B | `agy/s1b/feat/infra-user-activity-logs` | - | - | `PLAN_CROSS_SUPPORT_INTAKE_2026-05-21` | - | **F-013** per-user Loguru diagnostic files: `plans/S1/S1.B/feat-infra-user-activity-logs/README.md`. |

## Draft / Planning

| plan_id | phase | author | created | notes |
|---|---|---|---|---|
| `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` | S1.B | pproctor | 2026-05-01 | PWA install + offline/resync research; **decisions + rationale:** `plans/S1/S1.B/pwa-install-offline-sync-research/README.md` §1.1–§1.7, §6; **sprint handoff:** `plans/S1/S1.B/README.md` → anchor `#pwa-sprint-activation-index`; **gates:** `strategy/strategic-roadmap-reframe-53be/validation_gates.md` (S1.B PWA bullet). |
| `PLAN_CROSS_BALANCE_HISTORY_F001_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-001** day-end balance history + charts: `plans/S1/S1.B/feat-f001-balance-history/README.md`; branch `agy/s1b/feat/f001-balance-history`. |
| `PLAN_CROSS_SMART_TAG_ESTIMATION_F002_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-002** tag apportioning + **`finance_manager_rust_tools`**: `plans/S1/S1.B/feat-f002-smart-tag-estimation/README.md`. |
| `PLAN_CROSS_PREDICTIVE_BUDGET_F003_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-003** budgets + projections + rust_tools: `plans/S1/S1.B/feat-f003-predictive-budgeting/README.md`. |
| `PLAN_CROSS_STS_BILL_REALISM_F004_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-004** STS pay cycles, partial pay, volatile vs rigid bills + expansion annex: `plans/S1/S1.B/feat-f004-sts-pay-cycles-bill-realism/README.md`; **P1**. |
| `PLAN_CROSS_SAVINGS_GOALS_F005_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-005** savings goals: `plans/S1/S1.B/feat-f005-savings-goals/README.md`. |
| `PLAN_CROSS_DASHBOARD_WIDGETS_F006_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-006** customizable dashboard: `plans/S1/S1.B/feat-f006-dashboard-widgets-custom/README.md`. |
| `PLAN_CROSS_GUIDED_TOURS_F007_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-007** guided walkthroughs: `plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md`. |
| `PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21` | S1.B | pproctor | 2026-05-21 | **F-007 polish** — help-mode flow, form step-by-step, calendar tour; V0–V3 + `sprint_verify.sh`: `plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`; branch `agy/s1b/feat/f007-walkthrough-polish`. |
| `PLAN_CROSS_FAMILY_LEDGER_F008_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-008** household ledger: `plans/S1/S1.B/feat-f008-family-ledger/README.md`. |
| `PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-009** recurring automation + **source → auto_deduct**: `plans/S1/S1.B/feat-f009-recurring-auto-deduct/README.md`. |
| `PLAN_CROSS_EXPORT_SHARING_F010_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-010** export/share + PWA trust; **P1**: `plans/S1/S1.B/feat-f010-export-sharing/README.md`. |
| `PLAN_CROSS_WEDGE_MARKETING_F011_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-011** living landing/hero (H-W3-1): `plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md`. |

## Paused

| plan_id | phase | paused_date | paused_reason | resume_trigger |
|---|---|---|---|---|
| `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03` | S1.B | 2026-05-21 | **Hub:** `plans/S1/S1.B/pwa-implementation-branch/README.md` · **Host branch:** `agy/s1b/pwa-implementation-branch` · Human verification **paused** — online tx network error + offline shell still repro; `runtime_handoff.md` **Open issues (paused)** | HitM re-test after web/API fixes + deploy; clear handoff issues |

## Blocked

| plan_id | phase | blocked_since | blocker | resolution_owner |
|---|---|---|---|---|
| _(empty)_ | | | | |

## Recently Completed (last 30 days)

Pre-governance plans closed at huddle as part of Topic 11 reconciliation. They executed under prior conventions; their contributions are folded into the S1.A → S1.B transition state.

| plan_id | phase | completed_date | strategic_impact | pr_url(s) |
|---|---|---|---|---|
| `PLAN_CROSS_SUPPORT_INTAKE_2026-05-21` | S1.B | 2026-06-16 | F-012 Support ticket intake: gated API, weekly digest task, and frontend Support page | [API PR #33](https://github.com/AzazelAzure/finance-manager-api/pull/33), [Web PR #61](https://github.com/AzazelAzure/finance-manager-web/pull/61) |
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

New plans use the hierarchical pattern per `branching_guidelines.md`:

```
plans/<Phase>/<Stage>/                               ← Stage umbrella (e.g. plans/S1/S1.B/)
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
agy/s1b/<sub-plan-name>                            (sub-plan branch)
agy/s1b/feat/<feature-name>                        (feature branch)
agy/s1b/feat/<feature-name>/t<NN>-<slug>           (task branch)
```

**Slices:** Within a task, execution steps are documented as **`T##.SL#`** (see `plan_template.md` §1a). Slice IDs are **plan artifacts**, not extra branch segments by default.

Pre-existing plans NOT retroactively moved. Each plan’s `plan_root` in its README metadata is authoritative (some legacy rows may still show historical `plans/cursor/...` paths until migrated).

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

See `execution_protocols.md` §8 for canonical conflict signatures.

See `branching_guidelines.md` §5 for color-cycle concurrency rules (one feature at a time).
