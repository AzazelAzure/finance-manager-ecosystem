# T01 — Navigation: Return to Landing Page

## End State

1. Clicking the brand icon/logo in the top-left nav shell while authenticated navigates to `/` (the landing/splash page). The user session is preserved — they are not logged out.
2. Navigating to `/login` while already authenticated renders a "Return to Dashboard" prompt instead of the login form. No logout occurs.

## Acceptance Criteria

1. [V3] Authenticated user clicks brand icon → lands on `/` (landing page), session intact, no 401/redirect loop
2. [V3] Authenticated user navigates to `/login` → sees "Return to Dashboard" button/link, NOT the login form
3. [V3] Unauthenticated user navigates to `/login` → sees login form normally (regression check)
4. [V3] Unauthenticated user navigates to `/` → landing page renders normally (regression check)
5. [V1] `npm run build` passes with zero errors

## Scope Lock

### Files to modify
- Nav shell component (top bar — wherever the brand icon/logo is rendered) — change link target from `/dashboard` to `/`
- Login page component — add auth check: if authenticated, render return CTA instead of login form
- i18n `en-US` and `tl-PH` — add key `login.return_to_dashboard`

### Files NOT to touch
- Route guards that redirect unauthenticated users to `/login` — leave intact
- Any auth token / session logic
- Dashboard layout or any route beyond `/login` and the nav shell

## Slices

### T01.SL1 — Brand icon nav target
- Change the brand icon/logo anchor in the top-bar shell to `href="/"` (or `navigate('/')`)
- Confirm `/` renders the landing page when navigated to while authenticated (no redirect to `/dashboard`)
- Evidence: [V3] screenshot of landing page reached from dashboard via icon click

### T01.SL2 — Login page authenticated state
- Add auth guard to Login page: if `isAuthenticated` (check your auth context/store), render a centered card with the brand mark and a `login.return_to_dashboard` CTA button that calls `navigate('/dashboard')`
- Do not render the login form in this state
- Add i18n keys: `login.return_to_dashboard` → "Return to Dashboard" (en-US), "Bumalik sa Dashboard" (tl-PH)
- Evidence: [V3] screenshot of authenticated `/login` showing return CTA

## Notes

- Check DECISION_LOG.md before touching any auth flow
- The landing page at `/` must render correctly when the user is authenticated — confirm there are no redirect loops where `/` sends an authenticated user back to `/dashboard` automatically
