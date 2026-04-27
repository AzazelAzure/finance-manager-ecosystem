# PLAN_Reflex_Onboarding_Wizard_Refinement_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Onboarding_Wizard_Refinement_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex/features/onboarding/`

## 1) Objective
Refine the Onboarding Wizard to ensure the first-user experience is modern, living, and human. The onboarding process should feel like a welcoming "guided setup" rather than a data entry form.

## 2) Scope
### In scope
- Refactoring the Onboarding steps (Currency, Initial Sources, Initial Categories) into the "Living Design" style.
- Implementing a smooth step-progress indicator.
- Adding micro-animations to "confirm" successful setup of each item.
- Enhancing the "Welcome" and "Success" splash states.

### Out of scope
- Changing the actual API setup endpoints.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/features/onboarding/`
- `plans/PLAN_Reflex_Living_Primitives_2026-04-25.md`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** Ensure the wizard handles edge cases (like browser refreshes) gracefully.
- **Design Fidelity:** Use large, clear `hero_section` style headings and tactile primary buttons.

## 5) Execution Breakdown

### Task T1: Onboarding Visual Overhaul
- **Goal:** Apply `glass_box` and `surface_card` to the onboarding steps.
- **Files to edit:** `onboarding/` views.
- **Design Fidelity:** Ensure the transition between steps is smooth (e.g., slide or fade).

### Task T2: Progress Feedback
- **Goal:** Add a visual indicator of how far the user is in the onboarding process.
- **Files to edit:** `onboarding/` components.
- **Design Fidelity:** Use brand colors and a subtle pulse for the "active" step.

### Task T3: Success Celebration
- **Goal:** Enhance the final onboarding screen to feel rewarding.
- **Files to edit:** `onboarding/` final view.

## 6) Verification Plan
- **User Flow:** Run through the onboarding process as a new user.
- **UI Check:** Verify that it matches the dashboard aesthetics.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md`.
- [ ] Archive plan upon completion.
