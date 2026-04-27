# PLAN_Reflex_Dynamic_Dashboard_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Dynamic_Dashboard_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex` (Features/AgentDash)

## 1) Objective
Implement "Living" data visualizations and feedback on the main dashboard. This moves away from static numbers toward an interface that pulses with the data it represents.

## 2) Scope
### In scope
- Implementing **Skeleton Loaders** for dashboard metrics and tables.
- Adding "Pulse" animations for critical alerts or new data.
- Implementing smooth number transitions (count-up effects) for financial totals.
- Updating the layout to use the new "Lifting Glow" cards.

### Out of scope
- Changing the underlying data aggregation logic (API-First rule).
- Implementing new charts (focus on cards and tables first).

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/features/agentdash/`
- `plans/PLAN_Reflex_Living_Primitives_2026-04-25.md` (Dependency)
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- Maintain Rule #6 (DB hits) - ensure animations don't trigger redundant API calls.
- Adhere to Rule #11 - suggest any specific Reflex-compatible chart libraries that might fit the "Living" theme better than defaults.

## 5) Execution Breakdown

### Task T1: Skeleton Screens for Metrics
- **Goal:** Replace loading spinners with pulsing skeleton shapes that match the dashboard card layout.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/`
- **Design Fidelity:** Reduces perceived wait time and makes the app feel "Human" and ready.
- **Implementation notes:** Create a `skeleton_metric` primitive.

### Task T2: Living Totals (Count-up)
- **Goal:** Animate the transition of financial totals when they load or update.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/`
- **Design Fidelity:** Provides a sense of momentum and "life" to the data.
- **Implementation notes:** Use CSS `counter` or a custom Reflex state animation for the numbers.

### Task T3: Dashboard Layout Refactor
- **Goal:** Re-arrange the dashboard modules into the new `Lifting Glow` cards.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/`
- **Design Fidelity:** Complete the "Living Design" transformation for the main user landing page.

## 6) Verification Plan
- **UX Audit:** Simulate slow network conditions to verify skeleton loaders.
- **Visual Check:** Ensure number animations are smooth and stop at the correct value.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md`.
- [ ] Log feedback on Reflex performance during animations.
