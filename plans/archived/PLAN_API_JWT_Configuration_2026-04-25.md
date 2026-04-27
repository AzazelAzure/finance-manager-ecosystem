# PLAN_API_JWT_Configuration_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_JWT_Configuration`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_api` (Settings)

## 1) Objective
Extend JWT token lifetimes to improve user experience and prevent premature session expiration. Ensure tokens last up to 1 week and are correctly blacklisted upon logout.

## 2) Scope
- Modifying `SIMPLE_JWT` settings in `finance_api/settings.py`.

## 3) Execution Breakdown

### Task T1: Update Token Lifetimes
- **Goal:** Set Access token to 1 day and Refresh token to 7 days.
- **Files to edit:** `finance_manager_api/finance_api/settings.py`.
- **Implementation notes:** 
    - Change `ACCESS_TOKEN_LIFETIME` to `timedelta(days=1)`.
    - Change `REFRESH_TOKEN_LIFETIME` to `timedelta(days=7)`.
    - Ensure `ROTATE_REFRESH_TOKENS` and `BLACKLIST_AFTER_ROTATION` remain `True`.

## 4) Verification
- Login and check the `exp` claim in the returned JWT (via jwt.io or similar). Verify it matches the new durations.
