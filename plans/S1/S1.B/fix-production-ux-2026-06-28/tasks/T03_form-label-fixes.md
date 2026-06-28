# T03 — Form Label Fixes

## End State

Every form field label, placeholder, and helper text in the app renders a human-readable string in both en-US and tl-PH. No raw i18n key strings (snake_case, dot-notation, or otherwise) are visible to users.

## Acceptance Criteria

1. [V1] `grep -rn "t('[a-z_]*\.[a-z_]*')" src/` — every key found has a corresponding entry in `en-US.json` (or equivalent)
2. [V1] No i18n keys missing from `tl-PH` translation file for any key used in form components
3. [V3] All major forms reviewed in browser (en-US locale) — no raw key strings visible as labels or placeholders
4. [V3] Spot-check tl-PH locale on at least 2 forms — labels are human-readable Tagalog, not key strings
5. [V1] `npm run build` passes with zero errors

## Scope Lock

### Forms to audit (at minimum)
- Quick Add Expense / Transaction forms
- Upcoming Expense form
- Profile / Account Settings form
- Payment Sources form
- Registration / Signup form
- Support / Bug Report form

### Files to modify
- `src/i18n/en-US.json` (or equivalent) — add missing keys
- `src/i18n/tl-PH.json` (or equivalent) — add missing keys
- Any form component where label text is hardcoded raw string (not i18n) — wrap in `t()`

### Files NOT to touch
- Logic, validation, or API contract of any form
- Any non-form UI text (headers, nav, tooltips — separate concern)

## Slices

### T03.SL1 — Audit
- Grep all form components for: label props, placeholder props, `t('...')` calls
- Cross-reference against `en-US` translation file
- Output: list of missing keys with the form component that uses them
- Evidence: paste the missing-key list as a comment in this task file before proceeding to SL2

**Audit result (2026-06-28):** Missing `tr()` keys in `i18n.ts` (fell through to raw key strings):
- `upcoming.editor.label.name`, `.amount`, `.currency`, `.dueDate` — used in `UpcomingExpensesPage.tsx`
- Many form labels were hardcoded English strings (not i18n) across QuickActions, TransactionsPage, UpcomingExpensesPage, DataHubPage, SettingsProfilePage, OnboardingPage, LoginPage, SignupPage

### T03.SL2 — Fix: add missing i18n entries
- Add all missing keys to `en-US` and `tl-PH`
- For `tl-PH` entries, use natural Tagalog equivalents — if unsure, use English with a `// TODO tl-PH` inline comment (do not use machine-translated guesses)
- Evidence: [V1] build passes; grep from SL1 returns no missing keys

### T03.SL3 — Browser verification
- Open each form listed in Scope Lock in browser (en-US)
- Screenshot any form that previously showed raw keys (before/after pair)
- Evidence: [V3] screenshots in `evidence/T03.SL3_form-labels/`

## Notes

- Check if there is a `i18n-ally` or similar tooling already configured in the project that can surface missing keys automatically — use it if available
- Some labels may be hardcoded strings (not i18n at all) — if found, wrap in `t()` with a new key rather than leaving them raw
