# T15 — Onboarding flow (4 steps)

**Phase:** P6 — Profile + onboarding  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-profile-onboarding`

## Reference

Reflex `features/onboarding/` (`view.py`, `state.py`, `api.py`).

## Objective

4-step first-run flow: base currency → sources → categories → review +
optional first transaction → finish to dashboard. Sequential guards prevent
skipping ahead.

## Implementation checklist

### Routes
- [ ] `/app/onboarding` — Step 1 base currency
- [ ] `/app/onboarding/sources` — Step 2 add at least one source
- [ ] `/app/onboarding/categories` — Step 3 add at least one category
- [ ] `/app/onboarding/review` — Step 4 review + optional first transaction
      → Finish

### Guards (`src/state/onboarding.ts`)
- [ ] Local Zustand store: `profile_preferences_saved`, `source_added`,
      `category_added`.
- [ ] On entering step N, redirect back to the earliest unfinished step.
- [ ] On Finish: clear store; navigate to `/app/dashboard`.

### Signup integration
- [ ] On signup success (T04), set `force_onboarding_next_login` flag in
      session state; first redirect after login goes to `/app/onboarding`
      instead of `/app/dashboard`. Clears once acted on.

### Each step UI
- [ ] Progress bar at top (1/4, 2/4, etc.).
- [ ] One central card with the form for that step + Continue button.
- [ ] "Skip onboarding" link at bottom (sets all guards true and goes to
      dashboard).

### API calls
- [ ] Step 1: PATCH `/finance/appprofile/` with `{ base_currency }`.
- [ ] Step 2: POST `/finance/sources/` with `{ name, acc_type, starting
      balance }`.
- [ ] Step 3: POST `/finance/categories/` with `{ name }`.
- [ ] Step 4: optional POST `/finance/transactions/` for first tx.

## Definition of done

- [ ] New account created via T04 signup is routed into onboarding and
      completes all 4 steps.
- [ ] Trying to jump to step 3 in URL bar without completing 1+2 redirects
      back to the correct step.
- [ ] Skip button works.

## Verification

Manual: create a throwaway account and walk the full flow.
