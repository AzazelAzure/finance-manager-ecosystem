# PLAN_Reflex_Interactive_Tutorials_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Interactive_Tutorials_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: `finance_manager_reflex/ui/`, `finance_manager_reflex/features/`

## 1) Objective
Implement a "human" and intuitive tutorial system that guides users through the various subsystems of the application. This moves away from static documentation to a "living" step-through overlay.

## 2) Scope
### In scope
- Creating a global `TutorialState` to manage step progression and visibility.
- Implementing a `tutorial_overlay` component using the "Living Design" glassmorphism style.
- Creating "Step-through" sequences for:
    - Dashboard (KPIs & Charts)
    - Transactions (Filtering & Adding)
    - Data Hub (Sources & Categories)
- Persisting "Tutorial Completed" flags (using secure session context).

### Out of scope
- Video tutorials.
- Modifying the underlying feature logic.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py` (specifically `tutorial_popover`)
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #2 (Readability):** Tutorial copy must be concise and human-centric.
- **Rule #5 (Tools):** Create a reusable `TutorialStep` primitive that can be easily dropped into any feature page.
- **Design Fidelity:** The tutorial overlay should feel like it's floating *above* the interface, using deep shadows and blurs.

## 5) Execution Breakdown

### Task T1: Tutorial Manager (State)
- **Goal:** Implement the logic to track which tutorial is active and which step the user is on.
- **Files to edit:** New `finance_manager_reflex/core/tutorial_state.py` (or similar).
- **Implementation notes:** Support `next_step`, `previous_step`, and `dismiss`.

### Task T2: Living Tutorial Primitive
- **Goal:** Refactor `tutorial_popover` into a more robust `TutorialStep` component that supports "Next" buttons and step indicators.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`.
- **Design Fidelity:** Use `glass_box` and brand glows to highlight the UI element being explained.

### Task T3: Subsystem Mapping
- **Goal:** Integrate tutorial steps into the Dashboard and Transactions pages.
- **Files to edit:** `agentdash/`, `transactions/`.

## 6) Verification Plan
- **Flow Check:** Verify that a user can successfully complete a tutorial sequence.
- **Persistence Check:** Ensure the tutorial doesn't reappear once dismissed/completed.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md`.
- [ ] Archive plan upon completion.
