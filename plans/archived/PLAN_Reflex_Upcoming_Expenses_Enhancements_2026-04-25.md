# Gemini Plan Template V2 (Collaboration & Living Design)

## 0) Metadata

- Plan ID: `PLAN_Reflex_Upcoming_Expenses_Enhancements_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: reflex

## 1) Objective

Refine Upcoming Expenses UI by improving filter usability, updating creation defaults, and introducing inline popup edits and "Mark as Paid" actions.

## 2) Scope

### In scope

- Changing filter text fields to drop-downs and calendar selections.
- Setting "Paid" flag to default False on creation.
- Implementing an edit popup menu.
- Adding a "Mark as Paid" quick action button in the list view.

### Out of scope

- Core structural changes to the expenses table backend.

## 3) Inputs / Source Docs

- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails

- **Design Fidelity:** Popup menus must feel responsive, "Living", and maintain context without heavy page reloads.

## 5) Execution Breakdown

### Task T1: Filter & Search Improvements

- **Goal:** Change the month filter to an empty calendar selection that auto-populates format. Convert recurring and paid flags to dropdown menus. Fix default month overriding.
- **Files to edit:** Upcoming Expenses UI components, state.

### Task T2: Create & Edit Flow Polish

- **Goal:** Default "Paid" flag to `false` for new entries. Change the edit flow from populating the create fields to launching a dedicated popup menu.
- **Files to edit:** Upcoming Expenses UI.

### Task T3: Quick Actions

- **Goal:** Add a "Mark as paid" button to the list items that fires a PATCH request directly.
- **Files to edit:** Upcoming Expenses UI, state methods.

## 6) Subagent Request Protocol

- Subagent type: `generalPurpose`
- Purpose: Polish Upcoming Expenses UI.
- Mode: `write`
- Completion criteria: Filters function natively; mark as paid successfully updates status.
