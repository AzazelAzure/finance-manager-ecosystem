# Plan Registry — Portfolio Status

Single source of truth for plan status. Update on every status transition.

**Last updated:** 2026-06-30 (Reconciled plan registry: moved Bill Recurrence Engine and Design Docs Restructure to Completed, moved Local Security Audit Suite to In Progress; updated design_docs stale references)

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
| `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29` | P1 | S1.B | `cur/s1b/chore/local-security-audit-suite` | pproctor | - | - | - | 2026-06-30 | Local security audit suite; T01, T02, T04 merged; T03 (weekly cron + prompt) pending |

## Ready for Execution

| plan_id | priority | phase | branch | depends_on | blocks | parallel_safe_with | conflicts_with | notes |
|---|---|---|---|---|---|---|---|---|
| `PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009_2026-05-05` | P2 | S1.B | `cur/s1b/feat/f009-recurring-auto-deduct` | bill-recurrence (✅ shipped) | - | - | - | **F-009** opt-in `auto_deduct` on `UpcomingExpense.source`; Celery-beat due-date eval (profile TZ) + idempotent post; T01–T04 authored; `plans/S1/S1.B/feat-f009-recurring-auto-deduct/README.md` |
| `PLAN_CROSS_DASHBOARD_WIDGETS_F006_2026-05-05` | P2 | S1.B | `cur/s1b/feat/f006-dashboard-widgets-custom` | - | - | - | - | **F-006** customizable dashboard: `DashboardLayout` persistence + catalog of existing widgets + DnD reorder/resize + optional device variants; T01–T04 authored; `plans/S1/S1.B/feat-f006-dashboard-widgets-custom/README.md` |

## Draft / Planning

| plan_id | phase | author | created | notes |
|---|---|---|---|---|
| `PLAN_CROSS_INVITE_REFERRAL_LINK_2026-06-30` | S1.B | Claude Code | 2026-06-30 | Invite token generation + public invite landing route; organic beta growth (no referral rewards). `plans/S1/S1.B/feat-invite-referral-link/README.md`. Stub — HitM markup required before `ready`. |
| `PLAN_CROSS_SMART_TAG_ESTIMATION_F002_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-002** tag apportioning + **`finance_manager_rust_tools`**: `plans/S1/S1.B/feat-f002-smart-tag-estimation/README.md`. |
| `PLAN_CROSS_PREDICTIVE_BUDGET_F003_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-003** budgets + projections + rust_tools: `plans/S1/S1.B/feat-f003-predictive-budgeting/README.md`. |
| `PLAN_CROSS_FAMILY_LEDGER_F008_2026-05-05` | S1.B | pproctor | 2026-05-05 | **F-008** household ledger: `plans/S1/S1.B/feat-f008-family-ledger/README.md`. |

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
| `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` | S1.B | 2026-06-29 | Standalone bill recurrence engine — first-class cadence field; API PRs #63, #64, #65 + Web PR #91 merged; deployed to inactive BLUE | https://github.com/AzazelAzure/finance-manager-api/pull/63 https://github.com/AzazelAzure/finance-manager-api/pull/64 https://github.com/AzazelAzure/finance-manager-api/pull/65 https://github.com/AzazelAzure/finance-manager-web/pull/91 |
| `PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29` | S1.B | 2026-06-29 | D6 execution (design docs restructure): archived historical Reflex/alpha docs, retired duplicate roadmap/versioning docs, updated sync protocol and dashboard pointers; docs-only sweep; parent PR #80 merged | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/80 |
| `PLAN_CROSS_PRODUCTION_UX_FIX_2026-06-28` | S1.B | 2026-06-28 | Production UX batch: nav brand link, login redirect, form labels, legal scrub, bill catch-up, onboarding re-enable; promoted active blue | https://github.com/AzazelAzure/finance-manager-api/pull/51 https://github.com/AzazelAzure/finance-manager-web/pull/80 |
| `PLAN_CROSS_EXPORT_SHARING_F010_2026-05-05` | S1.B | 2026-06-28 | CSV export, full JSON backup, Data Hub export UI, share token API + share UI; migration `0015`; promoted active green | (see F-010 runtime_handoff; API/Web on `main`) |
| `PLAN_CROSS_STS_BILL_REALISM_F004_2026-05-05` | S1.B | 2026-06-28 | STS pay cycles, bill realism (volatile/rigid, partial payments), pay-period dashboard/upcoming views; migrations `0012`–`0013`; promoted active green | https://github.com/AzazelAzure/finance-manager-api/pull/52 https://github.com/AzazelAzure/finance-manager-api/pull/53 https://github.com/AzazelAzure/finance-manager-api/pull/54 https://github.com/AzazelAzure/finance-manager-api/pull/55 https://github.com/AzazelAzure/finance-manager-web/pull/81 https://github.com/AzazelAzure/finance-manager-web/pull/83 |
| `PLAN_CROSS_SAVINGS_GOALS_F005_2026-05-05` | S1.B | 2026-06-28 | Savings goals shipped: API `SavingsGoal` migration `0016`, CRUD + per-cycle recalculation, PWA-aware goals management page, and dashboard goals widget; promoted active blue after inactive-blue rebuild, smoke, and 15-min monitoring | https://github.com/AzazelAzure/finance-manager-api/pull/61 https://github.com/AzazelAzure/finance-manager-api/pull/62 https://github.com/AzazelAzure/finance-manager-web/pull/88 https://github.com/AzazelAzure/finance-manager-web/pull/89 |
| `PLAN_CROSS_BALANCE_HISTORY_F001_2026-05-05` | S1.B | 2026-06-28 | Day-end balance history shipped: API `BalanceSnapshot` migration `0014`, nightly capture + backfill, read endpoint, dashboard PWA-compatible balance trend chart; promoted active blue after full backfill and smoke | https://github.com/AzazelAzure/finance-manager-api/pull/56 https://github.com/AzazelAzure/finance-manager-web/pull/84 |
| `PLAN_CROSS_LEGAL_PAGES_2026-06-27` | S1.B | 2026-06-27 | Public `/privacy`, `/terms`, `/cookies` routes; footer links; dark-mode readability fix | https://github.com/AzazelAzure/finance_manager_web/pull/66 https://github.com/AzazelAzure/finance_manager_web/pull/70 |
| `PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27` | S1.B | 2026-06-27 | ToS clickwrap on signup; server-side acceptance on registration; migration `0011_tos_acceptance_fields` | https://github.com/AzazelAzure/finance_manager_web/pull/67 https://github.com/AzazelAzure/finance_manager_api/pull/42 |
| `PLAN_CROSS_EMAIL_COMMS_2026-06-27` | S1.B | 2026-06-27 | User support confirmation emails + 5-min cooldown (`send_user_support_confirmation`); live inbox E2E smoke still open | https://github.com/AzazelAzure/finance_manager_api/pull/41 |
| `PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27` | S1.B | 2026-06-27 | `create_ux_testuser` management command for PH-peso UX test data | https://github.com/AzazelAzure/finance_manager_api/pull/40 |
| `PLAN_CROSS_CI_CD_2026-06-27` | S1.B | 2026-06-28 | Minimum viable CI/CD completed: API CI green on `main` (`28305288437`), Web CI green on `main` (`28305298483`, `28305751301`), Dependabot opened API/Web PRs, parent health check fixed for Cloudflare by origin-direct PR #73 and green on `main` (`28306647911`); branch protection waived by HitM because private repos require GitHub Pro/public visibility | https://github.com/AzazelAzure/finance-manager-api/pull/43 https://github.com/AzazelAzure/finance-manager-web/pull/71 https://github.com/AzazelAzure/finance-manager-ecosystem/pull/71 https://github.com/AzazelAzure/finance-manager-ecosystem/pull/73 |
| `PLAN_CROSS_USAGE_MONITORING_NOTIFY_2026-06-26` | S1.B | 2026-06-28 | F-014 notify dispatcher + usage rollups closed after active-green VPS deploy: Redis, shared `celery-worker`/`celery-beat`, and public API/web health verified; HitM accepted closed-loop beta closeout without extra rotation/screenshots | https://github.com/AzazelAzure/finance_manager_api/pull/39 |
| `PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26` | S1.B | 2026-06-28 | F-014 observability layer (FROM routing, Redis request counters, analytics rollups, security alerts) closed after active-green VPS deploy with Celery worker/beat running; privacy-policy disclosure remains separate | https://github.com/AzazelAzure/finance_manager_api/pull/39 |
| `PLAN_CROSS_UI_UX_DESIGN_SYSTEM_2026-06-26` | S1.B | 2026-06-26 | Design-system tokens + responsive nav shell (T01–T06); promoted to active blue | https://github.com/AzazelAzure/finance_manager_web/pull/65 |
| `PLAN_CROSS_GUIDED_TOURS_F007_2026-05-05` | S1.B | 2026-06-27 | F-007 guided walkthroughs shipped; post–react-joyride v3 repair merged | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/52 https://github.com/AzazelAzure/finance_manager_web/pull/54 https://github.com/AzazelAzure/finance_manager_api/pull/31 https://github.com/AzazelAzure/finance_manager_web/pull/68 |
| `PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21` | S1.B | 2026-06-26 | Help-mode flow, form/calendar polish; sprint_verify evidence | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/55 https://github.com/AzazelAzure/finance-manager-ecosystem/pull/56 https://github.com/AzazelAzure/finance_manager_web/pull/63 |
| `PLAN_CROSS_WEDGE_MARKETING_F011_2026-05-05` | S1.B | 2026-06-28 | Living landing plan: T01 UX+SEO (PR #59); T03+T04 landing reflect-shipped + honest forward roadmap (balance history, pay cycles, savings goals, export/sharing now live; recurring/widgets/predictive/family roadmap) merged PR #90 and promoted to production active green | https://github.com/AzazelAzure/finance_manager_web/pull/59 https://github.com/AzazelAzure/finance-manager-web/pull/90 |
| `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` | S1.B | 2026-05-03 | PWA research D0–D4 locked; implementation complete and live | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/43 https://github.com/AzazelAzure/finance-manager-ecosystem/pull/49 |
| `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03` | S1.B | 2026-06-28 | PWA fully implemented and functional — offline support live on VPS. New features require PWA integration as part of definition of done per AGENTS.md §1. | plans/S1/S1.B/pwa-implementation-branch/ |
| `PLAN_CROSS_USER_ACTIVITY_LOGS_2026-05-21` | S1.B | 2026-06-16 | F-013 server-side user-keyed logs & incident window extractor; live closeout accepted 2026-06-28 after active-green VPS deploy verified API health and support/Celery prerequisites | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/61 |
| `PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26` | S1.B | 2026-06-27 | Axes lockout, Argon2, password complexity, proxy IP config, auth tests | https://github.com/AzazelAzure/finance_manager_api/pull/35 https://github.com/AzazelAzure/finance_manager_api/pull/36 |
| `PLAN_CROSS_SUPPORT_INTAKE_2026-05-21` | S1.B | 2026-06-26 | F-012 support intake verified + remediated (redaction, digest window, compose beat fix); live closeout accepted 2026-06-28 after active-green VPS deploy with shared Celery worker/beat running | API PR #37 branch lineage |
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
