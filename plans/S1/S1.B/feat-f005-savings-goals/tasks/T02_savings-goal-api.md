# T02 — Savings Goal CRUD API + Per-Cycle Recalculation

## End State

Five endpoints cover full goal CRUD. Each goal response includes a computed `per_cycle_required` field — the amount the user needs to save per pay cycle to hit the target by the deadline. The math handles past deadlines and already-met goals gracefully. All endpoints are scoped to the requesting user; cross-user access returns 404.

## Acceptance Criteria

1. [V1] `GET /finance/savings-goals/` returns all goals for the authenticated user; each includes `per_cycle_required`
2. [V1] `POST /finance/savings-goals/` creates a goal; `currency` defaults to `profile.base_currency` if not provided
3. [V1] `GET /finance/savings-goals/{id}/` returns single goal (own only — 404 if not owner)
4. [V1] `PATCH /finance/savings-goals/{id}/` partial update (name, target_amount, target_date, current_amount, source)
5. [V1] `DELETE /finance/savings-goals/{id}/` deletes (own only — 404 if not owner)
6. [V1] `per_cycle_required` math:
   - remaining = `max(target_amount - current_amount, 0)`
   - periods = number of full pay cycles between today and `target_date` (using profile's `pay_cycle_frequency`; see Notes)
   - if `periods <= 0` and `remaining > 0`: return `per_cycle_required = remaining` (one cycle overdue)
   - if `remaining == 0`: return `per_cycle_required = 0`
7. [V1] Security test: user A cannot read, update, or delete user B's goals
8. [V1] `python manage.py test` passes

## Scope Lock

### Files to create
- `finance/views/goal_views.py` — all 5 views

### Files to modify
- `finance_api/urls.py` — register goal endpoints
- `finance/tests/test_f005_goals.py` — create this file

### Files NOT to touch
- `finance/models.py` — model locked after T01
- Any existing view

## Slices

### T02.SL1 — Per-cycle calculation helper
Add to `goal_views.py` (module-level, not a view):

```python
from datetime import date
from decimal import Decimal

CYCLES_PER_YEAR = {
    "weekly": 52,
    "biweekly": 26,
    "semimonthly": 24,
    "monthly": 12,
}

def compute_per_cycle_required(goal, profile) -> Decimal:
    remaining = max(goal.target_amount - goal.current_amount, Decimal("0"))
    if remaining == 0:
        return Decimal("0")
    today = date.today()
    days_remaining = (goal.target_date - today).days
    if days_remaining <= 0:
        return remaining  # past due — full remaining in one cycle
    freq = profile.pay_cycle_frequency or "monthly"
    days_per_cycle = round(365 / CYCLES_PER_YEAR.get(freq, 12))
    periods = max(days_remaining // days_per_cycle, 1)
    return (remaining / periods).quantize(Decimal("0.01"))
```

### T02.SL2 — Views
`SavingsGoalListCreateView(APIView)` — `IsAuthenticated`:
- GET: filter `SavingsGoal.objects.filter(uid=profile)`, annotate each with `per_cycle_required` using helper
- POST: validate required fields (`name`, `target_amount`, `target_date`); default `currency` to `profile.base_currency`; save; return created goal with `per_cycle_required`

`SavingsGoalDetailView(APIView)` — `IsAuthenticated`:
- GET/PATCH/DELETE: resolve by `pk` and `uid=profile` (else 404)
- PATCH: allow partial update of `name`, `target_amount`, `target_date`, `current_amount`, `source`
- Always return `per_cycle_required` in GET and PATCH responses

### T02.SL3 — URL registration
```python
path("finance/savings-goals/", SavingsGoalListCreateView.as_view(), name="savings_goals"),
path("finance/savings-goals/<int:pk>/", SavingsGoalDetailView.as_view(), name="savings_goal_detail"),
```

### T02.SL4 — Tests
`finance/tests/test_f005_goals.py`:
- `test_goal_create_defaults_currency` — POST without currency → currency == profile.base_currency
- `test_goal_list_includes_per_cycle` — GET list → each item has `per_cycle_required` key, value is Decimal-serializable
- `test_per_cycle_math_monthly` — monthly pay cycle, target 1200, current 0, 12 months out → per_cycle = 100
- `test_per_cycle_past_due` — target_date in past, remaining > 0 → per_cycle == remaining
- `test_per_cycle_already_met` — current_amount >= target_amount → per_cycle == 0
- `test_cross_user_isolation` — user A cannot GET/PATCH/DELETE user B's goal
- `test_partial_update` — PATCH `current_amount` → per_cycle recalculates

## Notes

- `days_per_cycle` using `365 / cycles_per_year` is an approximation; it's correct enough for savings planning — don't over-engineer recurrence math here (F-009 will own precise pay-cycle scheduling)
- `semimonthly` maps to 24 cycles/year (1st and 15th pattern) — consistent with F-004's recurrence approach
- Return `per_cycle_required` as a string in the JSON response (same pattern as `target_amount` and `current_amount`) to preserve decimal precision
- `source` in PATCH accepts a source name string (consistent with how other endpoints reference `PaymentSource` by name, not pk) — look up `PaymentSource.objects.get(uid=profile, source=value)`
