# PLAN_Reflex_Widget_Implementation_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Widget_Implementation`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (Dashboard)

## 1) Objective
Finalize the implementation of the modular widget system. Restore the dashboard cards (KPIs, Charts) as widgets and implement the customization modal to allow users to toggle them on/off.

## 2) Scope
- **Widgets**: KPI Summary, Flow Chart, Category Chart, Source Balances.
- **Customization**: Implementing the checkboxes in the "Customize Dashboard" modal.

## 3) Execution Breakdown

### Task T1: Widget Component Restoration
- **Goal:** Move cards into the new widget architecture.
- **Implementation:** 
    - Take the previously working cards from `agentdash/view_components.py` and wrap them in the `DashboardWidget` primitive.
    - Ensure they only render if their ID is present in `State.active_widgets`.

### Task T2: Customization Modal Logic
- **Goal:** Enable the "Customize" UI.
- **Implementation:** 
    - Update the modal in `agentdash/view.py`.
    - Replace the placeholder text with a list of `rx.checkbox` items, one for each available widget.
    - Bind the checkboxes to the `State.active_widgets` list.

## 4) Verification
- Open Dashboard: Verify cards reappear.
- Click Customize: Verify you can toggle widgets on and off and the dashboard updates immediately.
