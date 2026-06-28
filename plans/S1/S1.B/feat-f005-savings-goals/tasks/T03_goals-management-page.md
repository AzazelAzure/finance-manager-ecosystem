# T03 — Goals Management Page

## End State

A new authenticated route `/app/goals` renders a full goals management page: list of all goals with progress bars, a form to create new goals, and edit/delete controls on each card. Offline-aware: reads cached goals when offline, write actions (create/edit/delete) are blocked with a message.

## Acceptance Criteria

1. [V3] `/app/goals` route renders within `ProtectedShell` (behind `RequireAuth`)
2. [V3] Goals list shows each goal's name, progress bar (current/target), per-cycle required, and target date
3. [V3] "Add goal" form: name (required), target amount (required), currency (defaults to profile base_currency), target date (required), linked source (optional dropdown of user's savings-type sources)
4. [V3] Edit inline or modal: same fields as create; saves via PATCH
5. [V3] Delete with confirm: removes goal from list immediately (optimistic update)
6. [V1] When offline: list shows cached data; create/edit/delete buttons disabled with "Not available offline" tooltip
7. [V1] i18n keys in `en-US` and `tl-PH`
8. [V1] `npm run build` zero errors
9. [V1] Route registered in `App.tsx`

## Scope Lock

### Files to create
- `src/pages/goals/GoalsPage.tsx` — page component
- `src/api/goals.ts` — API client functions for goals CRUD

### Files to modify
- `src/App.tsx` — add `<Route path="goals" element={<GoalsPage />} />` inside `ProtectedShell`
- `src/i18n/en-US.json` — add `goals.*` keys
- `src/i18n/tl-PH.json` — add `goals.*` keys

### Files NOT to touch
- DashboardPage (T04 handles the widget)
- Any API view or model

## Slices

### T03.SL1 — API client
Create `src/api/goals.ts`:
```typescript
export type SavingsGoal = {
  id: number;
  name: string;
  target_amount: string;
  currency: string;
  target_date: string;       // "YYYY-MM-DD"
  current_amount: string;
  source: string | null;     // source name or null
  per_cycle_required: string;
};

export function listGoals(opts?): Promise<SavingsGoal[]>
export function createGoal(data: Omit<SavingsGoal, 'id' | 'per_cycle_required'>): Promise<SavingsGoal>
export function updateGoal(id: number, data: Partial<Omit<SavingsGoal, 'id' | 'per_cycle_required'>>): Promise<SavingsGoal>
export function deleteGoal(id: number): Promise<void>
```
`listGoals` accepts `readOptsFromQuery` opts for offline compatibility (passes through to axios config).

### T03.SL2 — GoalsPage component
- `useQuery` for `listGoals` — pass `readOptsFromQuery` so offline cache is readable
- `useMutation` for create, update, delete — each invalidates `['goals']` query on success
- Goal card: name header, progress bar (`current_amount / target_amount`), "₱X per [pay cycle]" subtitle, target date chip
- Progress bar color: green if ≥80%, yellow if ≥40%, red if <40% of target
- "Add Goal" button → inline form or modal (your choice — inline form is simpler)
- Per-card: "Edit" (expand/modal) + "Delete" (confirm prompt via state toggle, not browser `confirm()`)
- Offline guard: wrap mutation triggers with `if (!navigator.onLine) { show toast; return }`

### T03.SL3 — Route registration
In `src/App.tsx`, inside the `ProtectedShell` route group:
```tsx
import { GoalsPage } from "./pages/goals/GoalsPage";
// ...
<Route path="goals" element={<GoalsPage />} />
```

### T03.SL4 — i18n keys
Add under `goals` in `en-US.json`:
```
goals.heading: "Savings Goals"
goals.addGoal: "Add Goal"
goals.name: "Goal name"
goals.targetAmount: "Target amount"
goals.currency: "Currency"
goals.targetDate: "Target date"
goals.currentAmount: "Saved so far"
goals.linkedSource: "Linked account (optional)"
goals.perCycle: "per pay cycle"
goals.progressLabel: "{current} of {target}"
goals.targetDateLabel: "By {date}"
goals.edit: "Edit"
goals.delete: "Delete"
goals.deleteConfirm: "Delete this goal?"
goals.save: "Save"
goals.cancel: "Cancel"
goals.offlineDisabled: "Not available offline"
goals.empty: "No goals yet. Add one to get started."
goals.met: "Goal met!"
```
Mirror in `tl-PH.json`.

### T03.SL5 — Browser verification
Open `/app/goals` in dev server. Confirm:
- Empty state shows correct message
- Create a goal → appears in list with progress bar
- Edit name/amount → updates without page reload
- Delete → removed from list
- Simulate offline (DevTools → Network → Offline) → list still shows; add/edit/delete blocked

## Notes

- `per_cycle_required` comes from the API — do not recalculate on the frontend; display what the API returns
- Pay cycle label ("per week", "per month", etc.) — read from `profile.pay_cycle_frequency`; map to display string via i18n key `profile.payFrequency.{weekly|biweekly|semimonthly|monthly}`; if those keys don't exist yet, add them
- Do not add a nav link to Goals yet — the dashboard widget (T04) will link there; nav link can come with F-006 dashboard widgets plan
