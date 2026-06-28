---
plan_id: PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03
status: draft
priority: P2
created: 2026-06-03
updated: 2026-06-03
owner: pproctor

plan_root: plans/S1/S1.B/feat-f007-walkthrough-sandbox/
intended_branch: agy/s1b/feat/f007-walkthrough-sandbox
target_repos:
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: [feat-f007-walkthrough-polish]

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - Tour flows on inactive stack :8443
---
# F-007 Walkthrough Sandbox

## 1) Objective
Redesign the F-007 Guided Walkthroughs to provide a Sandbox Overlay for the global onboarding tour (mocking actual app state with seeded data), and transition the Help Mode into a non-obtrusive hover tooltip.

## 2) Scope
- **In scope:** `TourProvider.tsx`, `HelpModeWrapper`, new `OnboardingSandbox.tsx`, new `GlobalOnboardingTour.tsx`.
- **Out of scope:** Modifying backend APIs, new CSS frameworks.

## 3) Tasks
| Task | File | Summary |
|------|------|---------|
| **T01** | `tasks/T01_help_mode.md` | Redesign Help Mode to use hover tooltips instead of Joyride. |
| **T02** | `tasks/T02_sandbox_tour.md` | Implement Sandbox Overlay and Global Joyride Tour. |
