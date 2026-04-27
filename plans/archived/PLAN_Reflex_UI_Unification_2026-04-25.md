# PLAN_Reflex_UI_Unification_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_UI_Unification_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex/features/`

## 1) Objective
Synchronize the "Living Design" aesthetics across all functional pages of the application. This ensures that the Data Hub, Transactions, Profile, and Upcoming Expenses pages all feel like part of the same "living" and "human" ecosystem initiated on the splash page.

## 2) Scope
### In scope
- Auditing and refactoring `data_hub`, `transactions`, `profile`, and `upcoming_expenses` features.
- Applying `surface_card`, `glass_box`, and `living_button` primitives to all page components.
- Standardizing typography, spacing, and transition easing.
- Implementing consistent hover and active states for all interactive data elements.

### Out of scope
- Changing business logic or API data structures.
- Implementing the tutorial system (separate plan).

## 3) Inputs / Source Docs
- `plans/PLAN_Reflex_Living_Primitives_2026-04-25.md` (Dependency)
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #3 (Lean Files):** If a feature page grows too large during refactoring, split it into smaller component files.
- **Rule #10 (Fix it Forever):** Use the established design tokens rather than ad-hoc CSS or styling.
- **Design Fidelity:** Every page must pass the "Motion & Depth" check—no flat backgrounds or static buttons.

## 5) Execution Breakdown

### Task T1: Data Hub Modernization
- **Goal:** Update the Data Hub to use the new card and glass primitives.
- **Files to edit:** `finance_manager_reflex/features/data_hub/`
- **Design Fidelity:** Ensure category and source management cards "lift" and "glow" on hover.

### Task T2: Transaction View Refinement
- **Goal:** Apply living design to the transactions table and filters.
- **Files to edit:** `finance_manager_reflex/features/transactions/`
- **Design Fidelity:** Use `glass_box` for the filter bar and ensure table rows have subtle hover highlights.

### Task T3: Profile & Settings Update
- **Goal:** Modernize the user profile and account settings pages.
- **Files to edit:** `finance_manager_reflex/features/profile/`
- **Design Fidelity:** Use tactile buttons for account switches and settings saves.

### Task T4: Upcoming Expenses Polish
- **Goal:** Refactor the bill management view.
- **Files to edit:** `finance_manager_reflex/features/upcoming_expenses/`

## 6) Verification Plan
- **Visual Audit:** Walk through every page to verify design consistency.
- **Motion Check:** Ensure all buttons and cards respond with established easing.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md`.
- [ ] Archive plan upon completion (Rule #12).
