# T01 — SavingsGoal Model + Migration

## End State

A new `SavingsGoal` model exists in `finance/models.py` with a clean migration. The model stores a named goal with a target amount, target date, current amount (manually updated), optional link to a savings `PaymentSource`, and a currency field defaulting to the profile's base currency.

## Acceptance Criteria

1. [V1] `python manage.py makemigrations finance` produces exactly one new migration with no merge conflicts against existing migrations
2. [V1] `python manage.py migrate` applies cleanly on a fresh DB
3. [V1] `python manage.py check` — zero errors
4. [V1] `python manage.py test` — no regressions in existing test suite
5. [V1] `SavingsGoal.objects.create(...)` works in Django shell with all required fields

## Scope Lock

### Files to modify
- `finance/models.py` — add `SavingsGoal` class

### Files to create
- `finance/migrations/XXXX_savings_goal.py` — auto-generated via `makemigrations`

### Files NOT to touch
- Any existing model
- Any view, serializer, URL, or test file

## Slices

### T01.SL1 — Model definition
Add to `finance/models.py` after `UpcomingExpense`:

```python
class SavingsGoal(models.Model):
    uid = models.ForeignKey(AppProfile, on_delete=models.CASCADE, related_name="savings_goals")
    name = models.CharField(max_length=255)
    target_amount = models.DecimalField(max_digits=15, decimal_places=2)
    currency = models.CharField(max_length=10, default="USD")
    target_date = models.DateField()
    current_amount = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    source = models.ForeignKey(
        PaymentSource, null=True, blank=True,
        on_delete=models.SET_NULL, related_name="savings_goals"
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["target_date"]

    def __str__(self):
        return f"{self.name} ({self.uid_id})"
```

### T01.SL2 — Migration
Run `python manage.py makemigrations finance --name savings_goal`. Confirm the generated file creates the `finance_savingsgoal` table with all columns. Run `python manage.py migrate` to verify.

### T01.SL3 — Smoke check
```python
python manage.py shell -c "
from finance.models import SavingsGoal, AppProfile
p = AppProfile.objects.first()
if p:
    g = SavingsGoal.objects.create(uid=p, name='Test', target_amount='1000.00', currency='USD', target_date='2027-01-01')
    print('created:', g)
    g.delete()
"
```

## Notes

- `current_amount` is manually set by the user for beta — no auto-sum from transactions yet (that belongs to F-009's auto-deduct territory)
- `source` FK is nullable — not every goal needs to be tied to a specific savings account; it's a soft hint for the UI to surface the linked account balance alongside goal progress
- `currency` defaults to `"USD"` at the model level; the API layer should override with the profile's `base_currency` when creating via the API
- `ordering = ["target_date"]` so the soonest deadlines surface first in list views by default
