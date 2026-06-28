# T05 — Onboarding Wizard Re-activation

## ⚠️ HitM Gate — Required Before Execution

Confirm approach before starting:

- **Option A:** Re-enable wizard as-is with prominent "Skip" button
- **Option B:** Complete tours to 100% first, then re-enable wizard
- **Option C (recommended):** Re-enable wizard scoped to currency + first payment source only; follow-up plan handles tour completion

Default to **Option C** if no response within 24h.

---

## End State (Option C assumed)

1. A new user completing registration sees the onboarding wizard on first login
2. The wizard covers exactly two steps: (1) set base currency, (2) add first payment source
3. A "Skip" button is present on every wizard step and exits gracefully to the dashboard
4. Completing the wizard saves currency and payment source, then lands in dashboard
5. A follow-up task list for tour form coverage gaps is documented (not implemented in this plan)

## Acceptance Criteria

1. [V3] New `ux_demo` user after `--reset`: first login → wizard appears immediately
2. [V3] Wizard step 1: set currency → saves to `AppProfile.base_currency`
3. [V3] Wizard step 2: add payment source → creates `PaymentSource` record
4. [V3] "Skip" on any step → exits to dashboard, no errors, no data corruption
5. [V3] Completing wizard → dashboard loads with currency and source applied
6. [V3] Existing user login → wizard does NOT appear (first-run flag respected)
7. [V1] `npm run build` passes with zero errors

## Scope Lock

### Files to modify
- Wizard component and/or wizard trigger logic — re-enable the trigger on first login
- Wizard step configuration — scope to currency + first payment source only; hide or remove other steps for now
- First-run flag mechanism (localStorage, AppProfile field, or similar) — ensure it works correctly

### Files NOT to touch
- Tour logic (Joyride) — separate concern, tracked in follow-up
- Any wizard steps beyond currency and payment source — remove from active flow without deleting (comment out or feature-flag)
- Registration / auth flow itself

## Slices

### T05.SL1 — Re-enable wizard trigger
- Find where the wizard is currently disabled (likely a flag in auth flow, router, or AppProfile)
- Re-enable the trigger: show wizard on first login (first-run flag not yet set)
- Confirm the wizard renders and does not crash
- Evidence: [V3] screenshot of wizard appearing for new ux_demo user

### T05.SL2 — Scope wizard to currency + first source
- Reduce active wizard steps to: (1) base currency selector, (2) add payment source form
- Any other steps: comment out with `// TODO: wizard-expansion` note, not deleted
- "Skip" button on each step: exits to `/dashboard`
- "Done" / "Finish" button on final step: saves and exits to `/dashboard`
- Evidence: [V3] walkthrough of full wizard (both steps) + skip on step 1 (should land in dashboard)

### T05.SL3 — Tour gap documentation (no code)
- Review current tour steps against all app forms
- List forms not yet covered by a tour step:
  - Quick Add Expense / Transaction forms
  - Upcoming Expense form
  - Payment Source form (if not covered)
  - Profile / Settings
  - Data Hub
- Output: a `tasks/T05_tour-gap-list.md` file in this plan with the list
- This becomes the input spec for the follow-up tour completion plan

Evidence: [V0] tour gap list file written

## Notes

- The first-run flag must be checked server-side or in a durable client store (not sessionStorage — it won't survive a page refresh). If the current implementation uses a fragile mechanism, fix it here.
- i18n needed for any new wizard UI strings: `wizard.step_currency`, `wizard.step_source`, `wizard.skip`, `wizard.finish` in en-US and tl-PH
