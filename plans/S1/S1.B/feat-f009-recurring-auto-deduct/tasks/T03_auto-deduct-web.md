# T03 — Auto-Deduct Web UI

## End State

Users can toggle `auto_deduct` on a bill (with `source` required in the UI), see a plain-language
explanation, preview the "next auto action," and recognize auto-posted transactions in history.
All strings are i18n; mutations follow the PWA offline guard.

## Acceptance Criteria

1. [V1] Bill create/edit form has an `auto_deduct` toggle. Enabling it requires selecting a `source` (the existing PaymentSource selector) — the form blocks submit otherwise, mirroring the API rule.
2. [V1] A short explanation string clarifies what auto-deduct does (posts from the source on the due date; can be turned off per bill, history is preserved).
3. [V1] "Next auto action" preview where helpful: shows the next due date + source + amount that will be drawn (uses cadence-driven next due date).
4. [V1] Auto-posted transactions are visually distinguishable in transaction history (badge/label) so users can tell automated from manual entries.
5. [V1] i18n keys under `bills.autoDeduct.*`; no hardcoded copy; added to every shipped locale.
6. [V1] Offline: enabling/disabling auto-deduct follows the established offline guard (toast + no-op when `!navigator.onLine`).

## Scope Lock

### Files to modify
- `finance_manager_web/src/` — the UpcomingExpense bill form component
- transaction history list component (auto-posted indicator)
- the upcoming-expense TS type (`auto_deduct: boolean`)
- i18n locale files (`bills.autoDeduct.*`)

### Files NOT to touch
- API/model/scheduler (T01–T02)

## Slices

### T03.SL1 — Toggle + source-required validation
Add the toggle; gate it on `source`; wire into the submit payload. Reuse the existing source
selector and form styling.

### T03.SL2 — Explanation + next-action preview
Render the explanation and the "next auto action" preview (next due date + source + amount).

### T03.SL3 — History indicator + i18n
Badge auto-posted transactions; add all i18n keys.

## Notes

- Build additively on the bill form — pre-fill the bill's current `auto_deduct` on edit.
- The "next auto action" date must match the API's cadence-driven next due date (bill recurrence engine, 2026-06-29) — don't compute it independently on the client.
- PWA offline conventions: follow the same `readOptsFromQuery` / offline-guard patterns the bills feature already uses.
