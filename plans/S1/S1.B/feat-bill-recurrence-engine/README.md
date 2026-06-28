---
plan_id: PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29
status: ready
priority: P1
created: 2026-06-29
updated: 2026-06-29
owner: pproctor

plan_root: plans/S1/S1.B/feat-bill-recurrence-engine/
intended_branch: cur/s1b/feat/bill-recurrence-engine
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks:
  - PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009_2026-05-05
parallel_safe_with: []
conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: required

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - UpcomingExpense create with cadence=weekly, confirm advance lands +7 days
    - UpcomingExpense PATCH cadence, confirm due-date roll respects new cadence
  notes: Migration adds a non-null-with-default cadence field plus a one-time backfill of existing rows. Backfill must run inside the migration, not as a separate management command.

standalone: true
standalone_notes: "First-class cadence field on UpcomingExpense. Replaces the start/due-delta inference heuristic in bill_recurrence.py. Must ship and deploy before F-009 recurring auto-deduct executes."
---

# Bill Recurrence Engine — First-Class Cadence

**Context:** Bill due-date rolling currently *infers* cadence from the day delta between
`start_date` and `due_date` (`finance/logic/bill_recurrence.py`), falling back to one
calendar month when that delta is absent or non-positive. This is the T02 stopgap flagged in
`strategy/anomalies/2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md`. The
inference is fragile: weekly, biweekly, semi-monthly, and pay-cycle-aligned bills can roll to
the wrong date, and there is no way for a user to state a bill's cadence explicitly. F-009
(recurring auto-deduct) will trigger real money movement off these dates, so the cadence must
be correct and first-class **before** F-009 executes.

## 0) Strategic Inheritance

- **Wedge respected:** yes — accurate bill cadence is core to the "honest, realistic upcoming bills" wedge already shipped in F-004.
- **Locked decisions touched:** none. Reuses the existing `PayCycleFrequency` vocabulary (weekly/biweekly/semimonthly/monthly) for consistency with STS pay cycles.
- **Cost cap impact:** zero infra cost; one migration.
- **Validation gates affected:** adds cadence smoke targets to the deploy bundle.

## 1) Objective

Add a first-class `cadence` field to `UpcomingExpense`, drive `bill_recurrence.py` from that
field instead of inferring from date deltas, expose cadence through the API and the bill
create/edit UI, and backfill existing rows by inferring their cadence once at migration time.
After this ships, no recurrence math depends on `start_date`/`due_date` deltas.

## 2) Current State (what this replaces)

| Location | Today | After |
|---|---|---|
| `finance/models.py` `UpcomingExpense` | no cadence field; cadence implied by dates | explicit `cadence` CharField + optional `custom_interval_days` |
| `finance/logic/bill_recurrence.py` | `bill_interval_timedelta()` infers from `due_date - start_date`, else `relativedelta(months=1)` | cadence → interval lookup table; `custom` reads `custom_interval_days` |
| `finance/logic/updaters.py` `_handle_upcoming` | calls `advance_bill_due_date(bill, periods=1)` (unchanged signature) | same call, now cadence-driven |
| API serializer / endpoints | cadence not exposed | cadence + custom_interval_days read/write, validated |
| Web bill create/edit form | no cadence selector | cadence dropdown; custom-days input when `custom` |
| Web upcoming/dashboard views | no cadence label | shows human-readable cadence per bill |

## 3) Scope

### In scope
- `cadence` enum field (`weekly`, `biweekly`, `semimonthly`, `monthly`, `quarterly`, `annual`, `custom`) on `UpcomingExpense`, default `monthly`.
- `custom_interval_days` nullable integer for the `custom` cadence.
- Data migration that backfills existing rows by inferring cadence from current `start_date`/`due_date` deltas (the existing heuristic, run once).
- Recurrence engine rework to be cadence-driven; `semimonthly` handled explicitly (twice-monthly, not "15 days").
- API exposure + validation (custom requires positive `custom_interval_days`).
- Frontend cadence selector + display label + i18n keys.

### Out of scope
- **Rust tools / WASM port** of the recurrence math — HitM flagged this as a likely future direction as calculations get more complex (D2). Explicitly deferred; do not introduce a Rust crate in this plan.
- F-009 auto-deduct behavior (this plan only makes cadence correct and first-class; F-009 consumes it).
- Changing STS pay-cycle logic on `AppProfile` — untouched.

## 4) Task List

| Task | Slug | Scope | Owner |
|---|---|---|---|
| T01 | cadence-model-migration | `cadence` + `custom_interval_days` fields; data-backfill migration | Cursor |
| T02 | recurrence-engine-rework | Rewrite `bill_recurrence.py` to be cadence-driven; tests | Cursor |
| T03 | cadence-api | Serializer + endpoint read/write + validation; `updaters.py` wiring | Cursor |
| T04 | cadence-ui | Bill form cadence selector + upcoming/dashboard cadence labels + i18n | Cursor |

**Execution order:** T01 → T02 → T03 → T04. T01 (schema + backfill) must land before the engine can be cadence-driven.

## 5) Verification Gates

- [V1] Migration applies cleanly and backfills existing rows with an inferred cadence (no row left null).
- [V1] A `weekly` bill advances exactly +7 days; `biweekly` +14; `semimonthly` to the next 1st/15th-style half-month; `monthly` +1 calendar month; `custom` by `custom_interval_days`.
- [V1] `periods_behind` catch-up respects cadence and the `MAX_CATCH_UP_PERIODS` cap.
- [V1] API rejects `cadence=custom` without a positive `custom_interval_days`.
- [V2] Existing bills on VPS roll correctly after deploy (smoke on inactive color before promote).
- [V3] HitM confirms an existing weekly/biweekly test bill rolls to the right date post-deploy.

## 6) Completion Criteria

- Cadence is first-class on `UpcomingExpense`; no recurrence path infers from date deltas.
- Backfill complete; legacy bills carry a concrete cadence.
- API + UI expose cadence.
- Anomaly `2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md` moved to `resolved` at close.
- F-009 unblocked.

## 7) Risks

| Risk | Trigger | Response |
|---|---|---|
| Backfill mis-infers a bill's cadence | Sparse/odd existing date deltas | Backfill defaults to `monthly` when delta is absent or ambiguous; log inferred cadence per row in the migration for HitM audit |
| Semimonthly modeled as fixed days | Treating semimonthly as `timedelta(days=15)` | Implement semimonthly as explicit half-month anchors (e.g. 1st/15th), not a 15-day step |
| Frontend/API cadence vocab drift | Different string sets API vs Web | Single source of truth: mirror the API `cadence` choices into a shared TS union; document the mapping in T04 |
| Scope creep into Rust/WASM | Engineer starts a crate | Out of scope per §3; recurrence stays pure-Python this plan |
