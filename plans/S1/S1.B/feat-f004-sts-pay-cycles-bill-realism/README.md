---
plan_id: PLAN_CROSS_STS_BILL_REALISM_F004_2026-05-05
status: draft
priority: P1
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/S1/S1.B/feat-f004-sts-pay-cycles-bill-realism/
intended_branch: cursor/s1b/feat/f004-sts-pay-cycles-bill-realism
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - Snapshot / STS KPI smoke after contract change
  notes: Large surface — use **expansion annex** below; split into task branches (migrations, serializers, STS engine, web wizards). Expect companion mini-features (see §2b) to ship as sub-tasks inside this plan.

standalone: true
standalone_notes: ""
---

# F-004 — Configurable STS periods, bill juggling, volatile vs rigid bills

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-004). **Backlog index:** [`../../PRODUCT_FEATURE_BACKLOG_INDEX.md`](../../PRODUCT_FEATURE_BACKLOG_INDEX.md).

## 0) Strategic Inheritance

- **Wedge respected:** yes — core “safe to spend before payday” requires pay-cycle truth and partial-pay realism.
- **Locked decisions touched:** snapshot `safe_to_spend` semantics; upcoming expense model; possibly profile timezone rules.
- **Cost cap impact:** extra fields and jobs must stay within single-DB + existing VPS posture; no new paid infra without gate.
- **Validation gates affected:** S1.B exit “worth paying for” when this is chosen as differentiator; coordinates with **F-003** projections.

## 1) Objective

Let STS and projections use **user-defined pay windows** (not only calendar month), model **partial bill payments** and **remainder timing**, and classify bills as **volatile** (utilities that swing) vs **rigid** (rent, fixed installments) so the engine and UX treat uncertainty and obligations differently.

## 2) Scope

### In scope

- **API:** schema + serializers for partial payment state (amount paid this cycle, remainder, next due for remainder), bill **type** or flags (`volatile` | `rigid` + optional confidence/volatility metadata), pay-cycle anchors on user profile (or dedicated model), STS recomputation inputs.
- **Web:** editors for upcoming expense / bill setup (partial pay intent, volatility class), STS and upcoming views reflecting multi-period juggling.
- **Engine:** STS calculation reads new fields; deterministic tests for multi-cycle scenarios.
- **Coordination:** consume outputs in **F-003** when projection layer needs pay-cycle + partial bill truth.

### Out of scope

- Full cashflow bank sync; legal promissory note tracking; multi-currency optimization beyond existing rules.

## 2b) Expansion annex — companion / minor work (same plan, own tasks)

This feature **will grow**. The following are **explicit follow-ons** to schedule as `tasks/Txx_*.md` rather than orphan one-offs:

| Companion | Purpose |
| --------- | ------- |
| **Notifications / reminders** | Remainder due soon for partial-pay bills; optional push/in-app later. |
| **Quick pay handoff** | [`../quick-pay-bill-design/DESIGN_DECISION.md`](../quick-pay-bill-design/DESIGN_DECISION.md) should post transactions compatible with partial-pay ledger once F-004 fields exist. |
| **Projection feed (F-003)** | Expose stable read models for “obligations by pay period” for burn-rate / shortfall UI. |
| **Volatile bill estimates** | Optional suggested amount band from history for utilities; rigid bills stay single-amount unless user edits. |
| **Audit / history** | Who changed partial amounts, when (trust + support). |
| **Migration + backfill** | Existing users: default rigid vs volatile heuristic + one-time review UX (optional). |

Add rows here as new companion needs appear; keep **one plan_id** until HitM splits scope.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-004.
- Current snapshot + upcoming expense handlers in API; dashboard KPI copy in web.

## 4) Phase Plan or Task List

Suggested waves: (A) data model + migrations, (B) API + tests, (C) STS engine integration, (D) web forms + mobile layout, (E) F-003 read contract, (F) polish + feature flag.

## 5) Execution Order

Author tasks under `tasks/` with explicit dependency edges (engine after schema).

## 6) Verification Gates

- Property tests or table-driven tests for STS across synthetic pay cycles with partials.
- Web e2e for “pay 60% electric” + remainder next period.
- Regression: existing users with no new fields behave as today (defaults).

## 7) Documentation Sync Required

- API + web changelogs; design_docs STS section when behavior is user-visible.

## 8) Strategic Phase Impact

Major W3 / wedge deliverable; registry completion unblocks marketing truth claims.

## 9) Completion Criteria

- Volatile vs rigid + partial pay **persisted**, **API-complete**, **web editable**, **STS consumes**; companion tasks either shipped or explicitly deferred with tickets referenced.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| STS regression for legacy users | migration defaults wrong | Feature flag off; hotfix defaults | api |
