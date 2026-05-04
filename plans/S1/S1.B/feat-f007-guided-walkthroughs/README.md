---

plan_id: PLAN_CROSS_GUIDED_TOURS_F007_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-04
owner: pproctor

plan_root: plans/S1/S1.B/feat-f007-guided-walkthroughs/
intended_branch: cursor/s1b/feat/f007-guided-walkthroughs
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
    - Tour completion API smoke if persisted server-side
  notes: Per-page tours; library choice per F-007 (react-joyride, intro.js, etc.).

## standalone: true

standalone_notes: ""

# F-007 — Guided page walkthroughs

**Feature idea:** `[../../FEATURE_IDEAS.md](../../FEATURE_IDEAS.md)` (F-007).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): work is ordered as **tasks** `T##` and **slices** `T##.SL#` (**`SL`** = slice, not Phase **S**). Each slice has a **verify-first** gate before the next slice or task proceeds.

## Rebuild stance (2026-05-04)

Shipped work on `cursor/s1b/feat/f007-guided-walkthroughs` is **provisional**. Assume it **must be rebuilt or removed** until that slice’s verification is **PASS**. Do not expand scope (new pages, new tour types) until the **T00** matrix and **T00.SL3** UX decisions are closed.

## 0) Strategic Inheritance

- **Wedge respected:** yes — education reduces support load for thin-margin persona.
- **Locked decisions touched:** none at open.
- **Cost cap impact:** tour content static weight minimal.
- **Validation gates affected:** W3 onboarding quality.

## 1) Objective

Replace single popup with **per-page** and **per-widget** guided tours; persist completion state per user.

## 2) Scope

### In scope

- Tour framework integration; step definitions for dashboard, transactions, upcoming, settings; API for completion flags if not local-only.

### Out of scope

- Full LMS; video hosting (links only v1).

## 3) Source Evidence

- `[../../FEATURE_IDEAS.md](../../FEATURE_IDEAS.md)` §F-007.
- **Web branch (local):** `cursor/s1b/feat/f007-guided-walkthroughs` — recent commits include Joyride/TourProvider, dashboard auto-tour, transactions/upcoming/quick-action tours, form step-through.
- **API:** `AppProfile.completed_tours` (`JSONField`), profile GET/PATCH serializers and `user_services` merge behavior; migration `finance/migrations/0007_appprofile_completed_tours.py`.
- **Handoff:** [`runtime_handoff.md`](./runtime_handoff.md) (inactive URL, known UX issues — refresh PR link when a real PR exists).

### 3a) Inventory — what exists on the branch (audit starting point)

| Location | Behavior (high level) |
| --- | --- |
| `TourProvider.tsx` | Global `Joyride`; `startTour` / `markTourCompleted` / `isTourCompleted`; help mode + `HelpModeWrapper` (click-to-spotlight); profile `completed_tours` |
| `DashboardPage.tsx` | Auto `dashboard_linear_tour` after data load; `HelpModeWrapper` on KPIs, filters, quick actions, charts |
| `TransactionsPage.tsx` | Auto `transactions_linear_tour` on load; wrappers; single/transfer form tours + manual “Start guide” |
| `QuickActions.tsx` | `startTour` for quick modals (transfer + per active type) |
| `UpcomingExpensesPage.tsx` | `bill_form_tour` |
| Settings / other routes | **No** tour wiring found in repo scan — treat as **out** until T07 |

## 4) Phase Plan — tasks and slices (verify-first)

Execute **in order**. Each **slice** must reach **PASS** (or explicit HitM **WAIVE** with reason) before starting the next slice.

| Task | Slice | Scope (single surface) | Verify (minimum) |
| --- | --- | --- | --- |
| **T00** | [tasks/T00_baseline_rebuild_audit.md](./tasks/T00_baseline_rebuild_audit.md) | Audit + decisions | SL1–SL3 checklists in that file |
| **T01** | T01.SL1 | **API only:** `completed_tours` field migration applied; GET returns list; PATCH append idempotent | API tests or scripted PATCH twice → stable list |
| **T01** | T01.SL2 | **API contract:** document merge rule (replace vs union) in serializer/service; align web payload | Contract note in README or serializer docstring + one web integration test if present |
| **T02** | T02.SL1 | **`TourProvider` only:** Joyride runs; skip/finish clears state; no page auto-starts | Manual: mount provider story or minimal route; no dashboard import side effects |
| **T02** | T02.SL2 | **Persistence wire:** `markTourCompleted` updates profile; refetch shows tour id | Network tab + refresh |
| **T02** | T02.SL3 | **Help mode vs Joyride:** behavior matches **T00.SL3** decision (remove redundant paths if required) | UX signoff |
| **T03** | T03.SL1 | **Dashboard:** DOM targets for `dashboard_linear_tour` exist when tour runs | No missing-target console errors; tour completes or skips cleanly |
| **T03** | T03.SL2 | **Dashboard:** auto-start policy (on / flagged / off) implemented per decision | PASS against decision doc |
| **T03** | T03.SL3 | **Dashboard:** `HelpModeWrapper` a11y (focus, modal z-index vs Joyride `zIndex: 10000`) | Keyboard + screen reader smoke as bar allows |
| **T04** | T04.SL1 | **Transactions:** linear tour targets + completion id stable | Same verify bar as T03.SL1 |
| **T04** | T04.SL2 | **Transactions:** single + transfer form tours; `force` repeatability | Two passes; profile id list sane |
| **T05** | T05.SL1 | **QuickActions:** one modal type at a time (e.g. expense only first) | PASS then next modal type |
| **T05** | T05.SL2 | **QuickActions:** remaining modal types | Full matrix PASS |
| **T06** | T06.SL1 | **Upcoming:** `bill_form_tour` only | Targets exist in open editor |
| **T07** | T07.SL1 | **Settings** (if still in scope) or **global:** entry point for “Help” / tours (shell, nav) | Single agreed entry; no duplicate toggles per T00.SL3 |

**Parallel rule:** Do not run T04 until T03.SL1 is PASS or waived (same pattern downstream) unless HitM accepts explicit cross-page risk.

## 5) Execution Order

1. [`tasks/T00_baseline_rebuild_audit.md`](./tasks/T00_baseline_rebuild_audit.md) (all slices)
2. **T01** — T01.SL1 → T01.SL2
3. **T02** — T02.SL1 → T02.SL2 → T02.SL3 (T02 may **strip** dashboard/transactions auto-starts until re-enabled per slice)
4. **T03** → **T04** → **T05** → **T06** → **T07** (each slice order as in §4 table)

## 6) Verification Gates

- **Per slice:** Record PASS/FAIL/WAIVE in `runtime_handoff.md` or a dated row in this README during execution.
- **Product:** a11y (skip, focus); no infinite re-run of the same linear tour after `completed_tours` contains that id unless `force: true` is intentional and documented.
- **Stack:** Post-deploy smoke on inactive `:8443` for any slice that touches web bundle.

## 7) Documentation Sync Required

- `finance_manager_web/CHANGELOG.md` and `finance_manager_api/CHANGELOG.md` when behavior changes per slice.
- Refresh [`runtime_handoff.md`](./runtime_handoff.md) after each verification batch (URL, color, PR link, matrix).

## 8) Strategic Phase Impact

- Registry + `validation_gates.md` W3 onboarding when the plan closes clean.

## 9) Completion Criteria

- **T00** complete (matrix + decisions).
- **T01–T02** all slices PASS (core contract + provider).
- **≥3** of T03–T06 areas PASS at slice level (dashboard, transactions, quick actions, upcoming) per original “≥3 pages” intent — or scope revised explicitly in §2 Out of scope.
- No open **FAIL** rows on inactive staging without a documented follow-up plan.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| --- | --- | --- | --- |
| Joyride / modal focus fight | z-index or double overlay | Lower auto-tours; reduce z-index; feature-flag tours | web |
| `completed_tours` growth / bad ids | Unbounded list or duplicate ids | API cap + normalization; migration cleanup if needed | api |
| Tours block PWA shell | overlay / SW | Disable tours via flag in `TourProvider` | web |
| PR not opened / wrong link | Stale handoff | Open real PR; link in chat per workspace rules | HitM / agent |
