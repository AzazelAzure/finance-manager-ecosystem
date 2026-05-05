---
plan_id: PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21
status: draft
priority: P2
created: 2026-05-21
updated: 2026-05-21
owner: pproctor

plan_root: plans/S1/S1.B/feat-f007-walkthrough-polish/
intended_branch: cursor/s1b/feat/f007-walkthrough-polish
target_repos:
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
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/ (inactive stack via fm_server_beta smoke)
    - Tour flows on jsdevtesting :8443
  notes: Extends F-007 Joyride/help-mode work; uses sprint_verify.sh for V2 evidence per orchestration huddle.

standalone: true
standalone_notes: "Protocol test: first plan authored explicitly for V0–V3 + sprint_verify evidence discipline."
---

# F-007 walkthrough polish — help flow, forms, calendar

**Parent context:** [`../feat-f007-guided-walkthroughs/README.md`](../feat-f007-guided-walkthroughs/README.md) (F-007 core). **Handoff baseline:** [`../feat-f007-guided-walkthroughs/runtime_handoff.md`](../feat-f007-guided-walkthroughs/runtime_handoff.md).

## 1) Objective

Close gaps HitM reported after the first F-007 pass:

1. **Help / widget flow:** After focusing a widget in help mode, users still must press an extra control to open the step-by-step guide — reduce or remove that friction where consistent with a11y.
2. **Form guides:** Add real **step-by-step** Joyride (or agreed pattern) inside transaction / quick-add / bill modals, not only spotlight + manual start.
3. **Transaction calendar:** Add a dedicated **step-by-step** tour for the calendar surface (month grid / navigation), currently missing.

## 2) Scope

- **In scope:** `TourProvider.tsx`, transaction pages, calendar component(s), QuickActions / Upcoming modals as needed; no API contract change unless completion persistence requires it (unlikely).
- **Out of scope:** New tour library; Settings global redesign; PWA offline tour state.

## 3) Automation protocol (this plan is the test)

Per [`governance/plan_template.md`](../../../governance/plan_template.md) §1a and [`governance/cursor_pa_slack_visibility.md`](../../../governance/cursor_pa_slack_visibility.md):

| Tier | Executor may self-run | Evidence |
|------|------------------------|----------|
| V0 | Yes | Plan / doc / code audit notes in slice file or `evidence/` |
| V1 | Yes | `npm run build` log path under `evidence/` |
| V2 | Reviewer or scripted | `scripts/sprint_verify.sh` log under `evidence/` (attach path in `runtime_handoff.md`) |
| V3 | HitM or browser-capable agent with screenshot | `evidence/T##.SL#_*.png` (or webp) + row in `runtime_handoff.md` |

**Executor must not** mark V2/V3 PASS without the matching artifact.

## 4) Tasks (execute in order)

| Task | File | Summary |
|------|------|---------|
| **T00** | [tasks/T00_protocol_and_acceptance.md](./tasks/T00_protocol_and_acceptance.md) | V0 acceptance + dry-run `sprint_verify.sh`; evidence naming |
| **T01** | [tasks/T01_help_mode_single_action_flow.md](./tasks/T01_help_mode_single_action_flow.md) | Help-mode → guide without extra dismissible step |
| **T02** | [tasks/T02_form_modal_step_by_step.md](./tasks/T02_form_modal_step_by_step.md) | Step-by-step tours inside modals |
| **T03** | [tasks/T03_transaction_calendar_tour.md](./tasks/T03_transaction_calendar_tour.md) | Calendar surface Joyride |

## 5) Execution order

T00 → T01 → T02 → T03 (verify-first between slices inside each task file).

## 6) Documentation

- [`finance_manager_web/CHANGELOG.md`](../../../finance_manager_web/CHANGELOG.md) when user-visible tour behavior ships.
- Update both `runtime_handoff.md` (this plan) and optionally the parent F-007 `runtime_handoff.md` pointer when slices close.

## 7) Completion

- All slices in T00–T03 PASS or WAIVE with HitM note.
- At least one full **V2** `sprint_verify_*.log` attached for a release batch and **V3** evidence for T01–T03 user-visible slices.
