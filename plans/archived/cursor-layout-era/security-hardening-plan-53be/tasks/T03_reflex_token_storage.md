# T03 Reflex Token Storage Boundary

## Objective
Reduce beta token-theft risk and align Reflex with the future API/Rust security boundary by deciding and implementing the intended token storage model.

## Scope Boundary
- Repo: `finance_manager_reflex/`
- Related API contract may require a handoff to `finance_manager_api/` if moving refresh-token issuance to HttpOnly cookies.
- Do not implement zero-knowledge encryption in this task.

## Current Evidence
- `finance_manager_reflex/finance_manager_reflex/core/auth_state.py` stores `access_token` and `refresh_token` in `rx.Cookie`.
- Current API client sends `Authorization: Bearer <access_token>`.
- Design docs mention JWTs can be delivered via `HttpOnly` and `Secure` cookies, but current Reflex uses readable app cookies.

## Decision Required
Choose one beta-compatible token model before implementation:
1. **Bearer model:** refresh token is not stored in JS-readable cookie; access token is short-lived and held in memory/session state where possible.
2. **Cookie model:** API sets `HttpOnly`, `Secure`, `SameSite` refresh/session cookies and frontend no longer reads refresh token directly.

Document which model is beta scope and which is deferred to Rust/ZK.

## Acceptance Criteria
- Refresh token is no longer exposed in a long-lived JS-readable cookie, or an explicit risk acceptance is documented for beta only.
- Cookie names and API auth docs match the implemented behavior.
- Login, refresh, logout, and deleted-user refresh behavior are verified.
- `finance_manager_reflex/CHANGELOG.md` is updated for behavior changes.

## Verification
If using browser/runtime:

```text
Inspect Set-Cookie and document.cookie after login.
Confirm refresh token cannot be read from JavaScript if cookie model is chosen.
Confirm logout clears relevant auth state.
```

Automated or manual checks should cover:
- Successful login.
- Access-token refresh path.
- 401 handling when refresh is invalid/deleted.

## Required Handoff
- Selected token model and rationale.
- API changes required, if any.
- Verification evidence.
- Residual beta risk.
