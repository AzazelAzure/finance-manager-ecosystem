# T04 — Signup page

**Phase:** P2 — Public surface  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-public-surface`

## Reference

Reflex `signup_page` in `features/auth/view.py` and `signup_and_continue` in
`profile/state.py`.

## Objective

Add `/signup` (public) that creates a user via `POST /finance/user/`, then
auto-logs in via `POST /api/token/`, and finally **routes to onboarding**
(wired fully in T15). Until T15 lands, route to `/app/dashboard`.

## Implementation checklist

- [ ] `src/pages/SignupPage.tsx` rendered at `/signup` inside `<PublicShell>`.
- [ ] Form (RHF + zod): `username`, `user_email`, `password`,
      `password_confirm`. Validation: email format, password ≥ 8 chars, match.
- [ ] On submit:
  1. `POST /finance/user/` with `{ username, user_email, password }`
  2. on 201/200: `POST /api/token/` with `{ username, password }`
  3. `setSession(...)`; navigate to `/app/dashboard` (T15 will redirect to
     `/app/onboarding` if `force_onboarding_next_login` flag)
- [ ] On 4xx from signup: surface server message inline (e.g. duplicate
  username/email).
- [ ] Visual: same overlay pattern as login (overlay over splash backdrop).
- [ ] Link "Already have an account? Sign in" → `/login`.

## Definition of done

- [ ] New account flow works end-to-end against the prod API on
  `https://jsdevtesting…`.
- [ ] Error from server is shown inline with the relevant field (when
  detectable) or as a form-level callout.
- [ ] Mobile form is single-column with comfortable tap targets (≥ 44 px).

## Verification

Manual: create a throwaway test user (delete via `/app/settings/profile` after
T14, or via DELETE `/finance/user/`).
