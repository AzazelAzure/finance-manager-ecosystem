# PLAN_Reflex_Auth_Redirect_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Auth_Redirect`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (Authentication Flow)

## 1) Objective
Ensure that unauthenticated users are automatically redirected to the splash/login page if they attempt to access protected routes like the dashboard.

## 2) Scope
- Implementing global or per-page auth checks in Reflex state.

## 3) Execution Breakdown

### Task T1: Auth Protection Logic
- **Goal:** Redirect unauthenticated users on page load.
- **Implementation:** 
    - In the base `State` (or a dedicated `AuthState`), add a check in `on_load` or a similar lifecycle event.
    - If `is_authenticated` is `False`, use `rx.redirect("/")` to send the user back to the splash page.
    - Ensure this check runs on the Dashboard, Transactions, and Data Hub pages.

## 4) Verification
- Log out of the application.
- Attempt to manually navigate to `/dashboard`.
- Verify you are immediately redirected back to the root `/` page.
