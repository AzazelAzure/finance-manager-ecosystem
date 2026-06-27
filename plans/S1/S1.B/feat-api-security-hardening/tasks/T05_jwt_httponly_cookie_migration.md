# T05 — JWT Token Storage Migration (localStorage → HttpOnly Cookie + Memory)

## Context
Audit 2026-06-27 confirmed both `fm_access_token` and `fm_refresh_token` are stored in `localStorage` (`state/auth.ts:1-2, 13-17, 62-67`). This is a security vulnerability (XSS can read both tokens) and blocks legal policy publication (privacy policy §3.12 and cookie policy §1.4 cannot claim 2026 gold-standard JWT handling until fixed).

## End State
- **Access token:** held in React memory only (lost on page reload → recovered via silent refresh)
- **Refresh token:** set as `HttpOnly; Secure; SameSite=Strict` cookie by the API on login/refresh; never returned in response body
- `localStorage` contains no auth tokens after this change
- Silent refresh flow works: page reload → no access token in memory → call refresh endpoint → cookie sent automatically → new access token returned

## Acceptance Criteria
1. [V1] After login, `localStorage` contains no `fm_access_token` or `fm_refresh_token` keys
2. [V1] After login, browser devtools shows a cookie named `fm_refresh` (or similar) with `HttpOnly` flag set
3. [V1] After page reload, authenticated routes re-authenticate silently (via refresh cookie) without prompting login
4. [V1] After logout, the refresh cookie is cleared (API sets `Set-Cookie: fm_refresh=; Max-Age=0`)
5. [V0] Offline session detection (`hasOfflineSession()`) still works — must be based on presence of refresh cookie (check via an API ping, not by reading the cookie value from JS)
6. [V1] Dexie offline DB continues to function — local outbox drains correctly after silent refresh

## Scope Lock

### API changes (`finance_manager_api`)
- `finance/auth/views.py` (or wherever the login/refresh endpoints live): change `refresh` token from response body to `Set-Cookie` header with flags `HttpOnly; Secure; SameSite=Strict; Path=/api/auth/refresh/`
- `finance/auth/views.py` logout endpoint: clear the refresh cookie with `Max-Age=0`
- CORS config: ensure `CORS_ALLOW_CREDENTIALS = True` is set so the cookie is included in cross-origin requests from the PWA domain (if applicable)
- Do NOT change the access token — it stays in the response body; the client stores it in memory

### Web changes (`finance_manager_web`)
- `src/state/auth.ts` — remove `localStorage.setItem/getItem` for both tokens; store access token in a module-level variable (or React context/store); refresh token is never touched client-side (cookie only)
- `src/api/auth.ts` — update the login/refresh API call to include `credentials: 'include'` so the browser sends the cookie
- Add silent refresh mechanism: on 401 response from any API call, attempt one silent refresh (call the refresh endpoint with credentials); on success, retry the original request with the new access token
- `hasOfflineSession()` — rewrite to detect offline session by checking if an access token is in memory; on page reload with no token, trigger a background silent refresh attempt before rendering protected routes

### Files NOT to touch
- `offline/db.ts` (T06 scope)
- Any Django model or migration files
- axes configuration (T02 complete)

## Technical Decisions (pre-locked)
- Cookie path scoped to `/api/auth/refresh/` — limits cookie exposure to the refresh endpoint only
- `SameSite=Strict` for refresh cookie (app is same-site PWA; if cross-site ever needed, revisit)
- Access token expiry should be short (15 min max) since it's in memory — silent refresh handles renewal
- No `jti` denylist required for MVP, but the `OperatorAlertState` model (F-014) can be extended later
- Do NOT store the access token in `sessionStorage` — it persists across tab navigations and is readable by JS

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T05.SL1 | API: set refresh as HttpOnly cookie | V1 | Login + refresh endpoints set cookie; logout clears it; CORS credentials enabled |
| T05.SL2 | Web: remove localStorage auth storage | V1 | `auth.ts` module-variable access token; credentials:include on refresh calls |
| T05.SL3 | Web: silent refresh on 401 | V1 | Interceptor retries once on 401 via refresh cookie; updates in-memory token |
| T05.SL4 | Web: offline session detection rewrite | V1 | `hasOfflineSession()` triggers background silent refresh on load; protected routes wait for result |

## Evidence
- `evidence/T05.SL1_cookie_header.txt` — curl output showing `Set-Cookie: fm_refresh=...; HttpOnly; Secure; SameSite=Strict`
- `evidence/T05.SL2_localstorage_empty.txt` — browser devtools screenshot or JSON export showing no auth keys in localStorage post-login
- `evidence/T05.SL3_401_retry.txt` — network trace showing 401 → silent refresh → retry → 200

## Security Note
This migration eliminates XSS-based token theft for the refresh token (the higher-value, longer-lived credential). The access token remains in memory and is lost on page close/reload — by design. This is the correct security posture for a PWA.
