# PLAN_Reflex_Sidebar_and_Nav_Polish_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Sidebar_and_Nav_Polish`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (Shell & Navigation)

## 1) Objective
Implement a high-fidelity sidebar navigation with an "expanding flag" hover effect and ensure page-specific help tutorials work correctly across all views.

## 2) Scope
- **Sidebar**: Hover transition with purple background and white text.
- **Help System**: Unifying the sidebar "Guide" button with page-specific tutorials.

## 3) Execution Breakdown

### Task T1: Sidebar Hover "Flag" Effect
- **Goal:** Create a tactile, premium sidebar transition.
- **Implementation:** 
    - In `shell.py`, update the sidebar menu item component.
    - On `_hover`: 
        - Transition the entire item container background to `COLOR_TOKENS["brand"]` (purple).
        - Transition the icon and text colors to white.
        - Ensure the container "slides out" (width/padding transition) to reveal the full text.

### Task T2: Unified Guide Logic
- **Goal:** Sidebar guide button triggers the current page's tutorial.
- **Implementation:** 
    - Remove any page-local "Guide" buttons (e.g., on the transactions page).
    - In `shell.py`, wire the sidebar "Guide" button to the `TutorialState.start_tutorial` action, passing the current page's route as the tutorial name.

## 4) Verification
- Hover over sidebar: Verify smooth transition to purple background with white text.
- Click Guide in sidebar: Verify it triggers the specific "How-to" for the page you are currently on.
