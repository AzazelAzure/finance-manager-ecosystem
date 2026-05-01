# T02 — Auth refresh, 401 handling, session

**Phase:** P1 — Foundations (paired with **T01**; ships in same PR or
follow-up PR before BP1 gate)  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-foundations` (or `feat/web-auth-refresh` if split)  
**Repo scope:** `finance_manager_web/`

## Objective

Make the web session as robust as Reflex: store both tokens, transparently
refresh on 401, and recover from token expiry without dumping the user.

## Implementation checklist

### Token storage (`src/state/auth.ts`)
- [ ] `setSession({ access, refresh })` and `clearSession()`.
- [ ] Keys: `fm_access_token`, `fm_refresh_token`.
- [ ] `getAccessToken() / getRefreshToken()`.
- [ ] Optional `tokens` event emitter for cross-tab logout (use
      `window.addEventListener('storage', ...)`).

### Axios setup (`src/api/client.ts`)
- [ ] **Request interceptor** attaches `Authorization: Bearer <access>` (already
  present — keep).
- [ ] **Response interceptor**: on **401** with original `config._retry !==
      true`:
  1. set `_retry = true`
  2. queue concurrent 401 retries behind a single in-flight refresh promise
  3. call `POST /api/token/refresh/` with `refresh` token
  4. on success: store new access (rotated refresh too if returned), retry the
     original request
  5. on failure: `clearSession()` and `window.location.replace('/login')`
- [ ] Make sure the refresh call **does not** trigger the same interceptor
  (use a bare axios instance for the refresh call).

### Login flow
- [ ] `LoginPage.tsx` migrated to `<Form/>` + zod schema (`username`,
  `password`, both required).
- [ ] On submit: `POST /api/token/`, then `setSession(...)`, then
  `navigate('/app/dashboard')` (or `/app/onboarding` if `force_onboarding`
  hint comes back — wired in T15; until then always dashboard).
- [ ] Remove the prefilled default username/password.

### Logout
- [ ] Logout button (in `ProtectedShell`) calls `clearSession()` then
  `navigate('/')`.
- [ ] Clear React Query cache on logout (`queryClient.clear()`).

## Definition of done

- [ ] In dev: open `/app/dashboard`, manually invalidate `fm_access_token` in
  DevTools → trigger a refetch → request transparently refreshes and succeeds
  (verify in Network tab: one `/api/token/refresh/`, then the original request
  retried).
- [ ] If refresh also fails (delete `fm_refresh_token` too) the user is sent to
  `/login` and the session is cleared.
- [ ] Logout clears both tokens + React Query cache and lands on `/`.
- [ ] Two open tabs: logout in tab A logs out tab B on next interaction.

## Verification

Manual DevTools script:
```js
localStorage.removeItem('fm_access_token')
queryClient.invalidateQueries(['snapshot-current-month'])
```
Expect a successful refresh in Network panel, no flash of `/login`.

## Risks

- Refresh failures during concurrent requests can produce thundering-herd
  refresh attempts — implementing the queued single in-flight promise is
  required.
- SimpleJWT `BLACKLIST_AFTER_ROTATION=True`: refresh **rotates** the refresh
  token; we must store the new refresh value if returned, otherwise the next
  refresh will fail.
