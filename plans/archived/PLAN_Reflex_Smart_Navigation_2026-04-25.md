# PLAN_Reflex_Smart_Navigation_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Smart_Navigation_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex` (App/Shell)

## 1) Objective
Modernize the application shell and navigation to feel "living" and intuitive. This involves transitioning from basic links to a smart sidebar that reacts to user focus and scroll position.

## 2) Scope
### In scope
- Updating `shell.py` navigation items with "active" states and hover animations.
- Implementing a "Smart Header" that changes character (blur/opacity) on scroll.
- Adding a "Contextual Sidebar" that highlights the current route using the new "Living Primitives."

### Out of scope
- Changing individual page content.
- Authentication logic.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/app/shell.py`
- `plans/PLAN_Reflex_Living_Primitives_2026-04-25.md` (Dependency)
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- Must wait for `Living Primitives` to be implemented.
- Maintain Rule #4 (Separation of concerns - navigation logic stays in `shell.py`).
- No hardcoded colors; use `COLOR_TOKENS`.

## 5) Execution Breakdown

### Task T1: Active State Highlighting
- **Goal:** Update navigation links to have a distinct "active" look using brand colors and subtle glows.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/shell.py`
- **Design Fidelity:** Helps the user feel oriented and "humanizes" the navigation.
- **Implementation notes:** Use the new `glow` shadow and brand color for the active route.

### Task T2: Hover Interactions for Sidebar
- **Goal:** Add subtle motion to sidebar icons and text on hover.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/shell.py`
- **Design Fidelity:** Makes the menu feel responsive and "alive."
- **Implementation notes:** Add `_hover={"transform": "translateX(4px)"}` or similar micro-motion.

### Task T3: Adaptive Header
- **Goal:** Implement a header that transitions from transparent to blurred/glass when scrolling.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/shell.py`
- **Design Fidelity:** Modern "SaaS" feel that prioritizes content visibility.
- **Implementation notes:** Use Reflex's scroll tracking if available, or a sticky glass primitive.

## 6) Verification Plan
- **Integration Check:** Verify that clicking different menu items updates the "active" state correctly.
- **Motion Check:** Ensure sidebar hover animations are smooth and not distracting.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md`.
- [ ] Document the new `Smart Shell` pattern.
