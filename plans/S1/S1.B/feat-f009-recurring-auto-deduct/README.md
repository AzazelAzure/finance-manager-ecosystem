---
plan_id: PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/S1/S1.B/feat-f009-recurring-auto-deduct/
intended_branch: cursor/s1b/feat/f009-recurring-auto-deduct
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - Upcoming expense PATCH with auto_deduct smoke
  notes: **Product funnel:** upcoming expense already supports tying a **source** (payment source) — today underutilized in UX. This plan exposes **user opt-in `auto_deduct`**: on due date (per profile TZ), optionally create or propose a transaction drawing that source, or enqueue outbox work consistent with PWA D2/D3. User can disable per bill.

standalone: true
standalone_notes: ""
---

# F-009 — Recurring expense automation & auto-deduct

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-009).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — less admin on recurring survival bills.
- **Locked decisions touched:** PWA outbox + idempotency if auto-post runs server-side or client-led replay — **must** reuse standard transaction-create contract (D2).
- **Cost cap impact:** scheduled jobs bounded; no unbounded fan-out.
- **Validation gates affected:** aligns with Topic 6 “recurring automation” candidate; complements **B-003** rollover quality.

## 1) Objective

Use the **existing source field** on upcoming/recurring expenses as the funnel for **auto_deduct** (opt-in): on due date, system assists posting or staging the payment from the linked source, unless the user disables automation for that bill.

## 2) Scope

### In scope

- API: `auto_deduct` (or equivalent) flag + validation with `source` required when true; idempotent replay keys for generated transactions.
- Web: toggle + explanation; preview “next auto action” where helpful.
- Scheduler or event path: due-date evaluation — exact mechanism (cron vs user-triggered batch) in tasks; align with offline queue if client-led.

### Out of scope

- Autopay without user opt-in; pulling bank balances from institutions.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-009.
- Current upcoming expense serializer + `source` field usage audit in API.

## 4) Phase Plan or Task List

T01 field + API → T02 scheduler/outbox strategy → T03 web → T04 edge cases (timezone, skipped holidays).

## 5) Execution Order

API contract before scheduler to avoid double-spend.

## 6) Verification Gates

- No double transaction on retry; toggling off stops future runs without deleting history.
- Tests for “due today” vs “due tomorrow” boundaries in profile TZ.

## 7) Documentation Sync Required

- Changelogs; PWA research cross-link if outbox involved.

## 8) Strategic Phase Impact

Registry; ties to **F-004** partial-pay story when both adjust “paid” state machine.

## 9) Completion Criteria

- Opt-in auto_deduct shippable path with source required; documented failure modes.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Duplicate tx on flaky network | idempotency gap | Kill job; manual reconcile playbook | api |
