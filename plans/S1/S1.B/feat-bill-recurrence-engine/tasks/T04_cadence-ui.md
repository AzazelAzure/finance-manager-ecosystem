# T04 — Cadence UI (form selector + display labels)

## End State

The bill create/edit form has a cadence selector. When `custom` is chosen, a "every N days"
number input appears and is required. Upcoming-expense lists and the dashboard show a
human-readable cadence label per recurring bill. All strings are i18n keys. Offline behavior
matches the rest of the PWA (mutations guarded when offline).

## Acceptance Criteria

1. [V1] Bill create/edit form includes a cadence dropdown with the 7 cadence options, defaulting to Monthly.
2. [V1] Selecting "Custom interval" reveals a required positive-integer "every N days" input; other cadences hide it.
3. [V1] Form submit sends `cadence` (and `custom_interval_days` only when custom) to the API.
4. [V1] Upcoming-expense list rows and the dashboard upcoming widget display the cadence label for recurring bills.
5. [V1] All new visible strings use i18n keys under `bills.cadence.*`; no hardcoded copy.
6. [V1] Offline: cadence-changing mutations follow the existing offline guard pattern (toast + no-op when `!navigator.onLine`), consistent with other bill mutations.

## Scope Lock

### Files to modify
- `finance_manager_web/src/` — the bill create/edit form component (locate the existing UpcomingExpense form)
- the upcoming-expense list component and the dashboard upcoming widget
- the TS type for an upcoming expense (add `cadence` + `custom_interval_days`)
- i18n locale files (add `bills.cadence.*` keys)

### Files NOT to touch
- API serializers / models (T01–T03)

## Slices

### T04.SL1 — Shared cadence vocabulary

Add a single source of truth so API and Web strings cannot drift:

```ts
export const BILL_CADENCES = [
  "weekly", "biweekly", "semimonthly", "monthly", "quarterly", "annual", "custom",
] as const;
export type BillCadence = (typeof BILL_CADENCES)[number];
```

Extend the upcoming-expense type with `cadence: BillCadence` and
`custom_interval_days: number | null`.

### T04.SL2 — Form selector

Add the cadence `<select>` to the bill form. On `custom`, conditionally render the
"every N days" number input (min 1) and mark it required in the form's validation. Wire both
into the existing submit payload. Reuse existing form field styling — do not introduce a new
input pattern.

### T04.SL3 — Display labels

In the upcoming list and dashboard widget, render the cadence label
(`t('bills.cadence.' + cadence)`) next to recurring bills. For `custom`, show
`t('bills.cadence.customEvery', { days })`.

### T04.SL4 — i18n keys

Add under `bills.cadence.*`: `weekly`, `biweekly`, `semimonthly`, `monthly`, `quarterly`,
`annual`, `custom`, `customEvery` (with `{days}` interpolation), plus a form label
`bills.cadence.fieldLabel` and the custom-days input label. Add to every locale file the
project currently ships (match the set used by existing bill strings).

## Notes

- The cadence string set MUST equal the API's `Cadence.choices` values exactly (T01). If they diverge, the dropdown will send values the API rejects.
- Keep the form change additive — an existing bill with no cadence selected by the user still defaults to monthly server-side, so the form should pre-fill the bill's current `cadence` on edit.
- PWA: this is a new field on an existing offline-capable resource; follow the established `readOptsFromQuery` / offline-guard conventions already used by the bills feature.
