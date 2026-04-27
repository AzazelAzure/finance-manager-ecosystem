# PLAN_Reflex_Remember_Me_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Remember_Me`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (Authentication)

## 1) Objective
Implement a "Remember Me" feature on the login screen that allows users to stay logged in across browser sessions using a persistent cookie for the JWT refresh token.

## 2) Scope
- Updating the login form UI.
- Modifying the login/logout state logic.
- Implementing an auto-login check on app load.

## 3) Execution Breakdown

### Task T1: Login UI Update
- **Goal:** Add the "Remember Me" checkbox.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/auth/view.py`.
- **Implementation notes:** 
    - Add an `rx.checkbox("Remember Me")` below the password field.
    - Bind it to `AuthState.remember_me`.

### Task T2: Persistent Session Logic
- **Goal:** Set a long-term cookie if "Remember Me" is checked.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/auth/state.py`.
- **Implementation notes:** 
    - In the `login` handler: If `remember_me` is `True`, set the JWT cookies with `max_age=604800` (7 days, matching our new API refresh lifetime).
    - If `False`, set them as session cookies.

### Task T3: Auto-Login on Load
- **Goal:** Log the user in automatically if a valid cookie exists.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/state.py` (or the root State).
- **Implementation notes:** 
    - In `State.on_load`: Check if the `finance-auth` (access) or `finance-refresh-token` (refresh) cookies exist.
    - If they do, attempt to fetch the user profile from the API to verify the token.
    - If the API returns 200, set `is_authenticated = True` and redirect to the dashboard.

## 4) Verification
- Log in with "Remember Me" checked.
- Close the browser tab and reopen it.
- Verify you are automatically redirected to the dashboard without being asked for credentials.
