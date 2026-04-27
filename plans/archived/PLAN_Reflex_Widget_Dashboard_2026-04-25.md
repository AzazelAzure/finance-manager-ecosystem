# PLAN_Reflex_Widget_Dashboard_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Widget_Dashboard_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: `finance_manager_reflex` (AgentDash Feature)

## 1) Objective
Architect a flexible, "Widget-Style" dashboard. The goal is to consolidate information from separate pages onto a single, customizable dashboard where users can add/remove widgets (e.g., Data Hub stats, quick transactions) while keeping the basic KPIs as the default view.

## 2) Scope
### In scope
- Creating a foundational `DashboardWidget` primitive.
- Refactoring existing dashboard cards (KPIs, Charts) into standardized widgets.
- Adding a simple state structure to manage which widgets are visible.
- Creating a "Dashboard Settings" or "Add Widget" modal.

### Out of scope
- Drag-and-drop reordering (save for a future enhancement if too complex).
- Full customization of chart colors per user.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/features/agentdash/`
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #1 (Efficiency):** Only render widgets that the user has enabled in their state to save DOM performance.
- **Design Fidelity:** Widgets must seamlessly integrate with the `glass_box` and `surface_card` design language.

## 5) Execution Breakdown

### Task T1: Widget Architecture & State
- **Goal:** Define the state structure for user-selected widgets.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/state.py`.
- **Implementation notes:** 
    - Create a list of available widgets (e.g., `["kpi_summary", "flow_chart", "category_chart", "recent_tx", "quick_add"]`).
    - Create a state variable `active_widgets` (defaulting to the basic set).

### Task T2: Widget Component Refactoring
- **Goal:** Wrap existing components in a standard widget interface.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`.
- **Implementation notes:** 
    - Convert charts and tables into modular functions that can be conditionally rendered based on `active_widgets`.

### Task T3: Widget Configuration Menu
- **Goal:** Allow the user to toggle widgets on/off.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/view.py`.
- **Implementation notes:** 
    - Add a "Customize Dashboard" button that opens a drawer or modal allowing the user to select checkboxes for active widgets.

## 6) Verification Plan
- Reflex Smoke Checks: Verify that toggling a widget in the configuration menu correctly shows/hides it on the dashboard without breaking the grid layout.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for Reflex.
- [ ] Move plan to `plans/archived/` upon completion.
