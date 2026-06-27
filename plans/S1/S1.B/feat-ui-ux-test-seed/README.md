---
plan_id: PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27
status: completed
priority: P2
created: 2026-06-27
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-ui-ux-test-seed/
intended_branch: cur/s1b/feat/ui-ux-test-seed
target_repos:
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_CROSS_LEGAL_PAGES_2026-06-27
  - PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27
  - PLAN_CROSS_EMAIL_COMMS_2026-06-27
conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: none

deployment:
  required: false
  target_services: []
  bundle_required: false
  rollback_plan_id: null
  smoke_targets: []
  notes: >-
    Management command only — not a deployed service. Runs on local dev env or
    directly on VPS via `python manage.py create_ux_testuser`. No VPS rebuild needed.

standalone: true
standalone_notes: ""

legal_impact:
  tos: false
  privacy_policy: false
  cookie_policy: false
  notes: none
---

## 0) Strategic Inheritance

- Wedge respected: yes — test infrastructure; no user-facing changes
- Locked decisions touched: none
- Cost cap impact: none — creates local/staging data only; no production impact
- Validation gates affected: none

## 1) Objective

Create a management command (`create_ux_testuser`) that produces a single, deterministic UI/UX test user with 12 months of realistic rolling PH-peso financial data. This replaces use of HitM's personal account for UI review and visual regression testing. The data is designed to make every meaningful UI state visible: multiple categories, payment sources, upcoming expenses, spending variance across months.

## 2) Scope

### In scope
- New management command: `finance/management/commands/create_ux_testuser.py`
- Creates or resets one user: default username `ux_demo`, password configurable via `--password` or env var `UX_DEMO_PASSWORD`; default email `ux_demo@internal.test`
- Seeds data relative to `date.today()` so data is always "current" (not fixed dates that age out)
- 12 months of rolling transaction history (~30 transactions/month, realistic variance)
- Philippine Peso (PHP) as primary currency
- Categories: Food/Groceries, Transport, Utilities, Rent/Housing, Health, Entertainment, Savings Transfer, Income
- Payment sources: Cash (CASH, PHP), GCash (EWALLET, PHP), BDO Checking (CHECKING, PHP)
- Tags: at least 3-4 realistic tags (e.g., "recurring", "essential", "discretionary", "work")
- Upcoming expenses: 3 upcoming bills (Rent, Electric, Internet) with realistic due dates
- `--reset` flag: if user exists, delete all domain data and reseed (user account preserved)
- `--username` and `--email` flags for non-default names
- Idempotent on first run (if user doesn't exist, creates; if exists and no `--reset`, prints warning and exits)

### Out of scope
- Multiple test users — one is sufficient for UI/UX review
- Savings goals model (if not yet implemented as a live model — skip and note in task)
- Financial snapshots / balance history seeding — add as a follow-up if F-001 is live
- Seeding data in non-PHP currencies — out of scope for MVP (PHP only)
- Running automatically on deploy — manual invocation only

## 3) Source Evidence

- `finance_manager_api/finance/management/commands/schema_setup.py` — existing seeder pattern (calls prod_setup + seeds fake userbase); use as reference for management command structure
- `finance_manager_api/finance/management/commands/_seed_fake_userbase.py` — existing bulk seeder; NOT what we need (bulk random users); reference only for model imports and `uid` handling
- `finance_manager_api/finance/factories.py` — factory classes for User, AppProfile, PaymentSource, Tag, Transaction, UpcomingExpense; use these factories as a reference for valid field values
- `finance_manager_api/stress_tests/seed_data.py` — another seeder reference; shows how to bypass signals during bulk create
- `finance_manager_api/finance/migrations/0008_supportticket.py` — confirms SupportTicket model exists; don't seed support tickets for the test user

## 4) Phase Plan — Task List

| Task | Title | Slices | V-tier |
|---|---|---|---|
| T01 | Management command | T01.SL1 Command scaffold + user creation; T01.SL2 Category/source/tag seed; T01.SL3 Transaction seed (12mo rolling); T01.SL4 Upcoming expenses seed | V1, V3 |

## 5) Execution Order

All slices within T01 are sequential (each builds on prior).

1. `tasks/T01_management_command.md` — T01.SL1 → T01.SL2 → T01.SL3 → T01.SL4

## 6) Verification Gates

- [V1] `python manage.py create_ux_testuser --help` shows expected arguments
- [V1] `python manage.py create_ux_testuser` creates user `ux_demo` with all expected domain data
- [V1] `python manage.py create_ux_testuser --reset` deletes and reseeds without error
- [V1] Running command twice without `--reset` prints warning and exits without duplicate data
- [V3] Browser: Log in as `ux_demo`; dashboard shows transaction history, categories, sources
- [V3] Browser: Upcoming expenses page shows seeded bills
- [V3] Browser: Transaction page shows 12 months of data with realistic PH-peso amounts

## 7) Documentation Sync Required

- `governance/plan_registry.md`: move to Completed
- Add a note in `AGENTS.md` or `governance/README.md` that `create_ux_testuser` exists and is the standard UI/UX test account

## 8) Strategic Phase Impact

When closing:
- [ ] Document command usage in `AGENTS.md` or `governance/README.md`
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- All V1/V3 gates in §6 met
- HitM confirms the seeded data looks realistic in the browser (pre_merge gate)
- PR merged
- §8 actions complete

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Accidentally runs on production | Command run without realizing env | Add a `--confirm-not-prod` flag OR check `DEBUG=True` before running; print prominent warning | Cursor |
| Field names differ from what factories reference | Model refactor broke field name | Run `python manage.py check` and inspect model before running; fix field references | Cursor |
| Transaction dates in future | Off-by-one in rolling date logic | Audit date generation: all dates must be `<= date.today()` | Cursor |
