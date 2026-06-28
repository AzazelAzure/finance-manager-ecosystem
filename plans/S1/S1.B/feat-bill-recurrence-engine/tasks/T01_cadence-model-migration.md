# T01 — Cadence Model Field + Backfill Migration

## End State

`UpcomingExpense` has an explicit `cadence` field and an optional `custom_interval_days`
field. A data migration backfills every existing row with a concrete cadence inferred once
from its current `start_date`/`due_date` delta. No row is left without a cadence.

## Acceptance Criteria

1. [V1] `UpcomingExpense.cadence` is a CharField with choices `weekly | biweekly | semimonthly | monthly | quarterly | annual | custom`, default `monthly`, not null.
2. [V1] `UpcomingExpense.custom_interval_days` is a nullable positive integer, used only when `cadence == custom`.
3. [V1] Migration applies cleanly on a copy of production data with no manual steps.
4. [V1] Data migration backfills existing rows: infer cadence from `due_date - start_date` using the existing heuristic; default to `monthly` when the delta is absent or ambiguous.
5. [V1] Migration logs (via `loguru` or migration `print`) the inferred cadence per row count by bucket, so HitM can audit the backfill.
6. [V1] A `CheckConstraint` enforces: `cadence != custom` OR `custom_interval_days` is a positive integer.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/models.py` — add fields + choices enum + constraint
- `finance_manager_api/finance/migrations/00XX_bill_cadence.py` — new migration (schema + data backfill in one)

### Files NOT to touch
- `bill_recurrence.py` (T02)
- Any serializer or view (T03)

## Slices

### T01.SL1 — Cadence enum + fields

Add to `UpcomingExpense` (mirror the existing `AppProfile.PayCycleFrequency` vocabulary, extended):

```python
class Cadence(models.TextChoices):
    WEEKLY = "weekly", "Weekly"
    BIWEEKLY = "biweekly", "Biweekly"
    SEMIMONTHLY = "semimonthly", "Semi-monthly"
    MONTHLY = "monthly", "Monthly"
    QUARTERLY = "quarterly", "Quarterly"
    ANNUAL = "annual", "Annual"
    CUSTOM = "custom", "Custom interval"

cadence = models.CharField(
    max_length=12, choices=Cadence.choices, default=Cadence.MONTHLY
)
custom_interval_days = models.PositiveIntegerField(null=True, blank=True)
```

Add to `Meta.constraints`:
```python
models.CheckConstraint(
    condition=~models.Q(cadence="custom") | models.Q(custom_interval_days__gt=0),
    name="upcoming_custom_requires_interval_days",
)
```

### T01.SL2 — Data backfill in the migration

In the same migration, add a `migrations.RunPython(forwards, reverse)` step. `forwards`
iterates existing rows and sets `cadence` using the inference logic currently in
`bill_recurrence.bill_interval_timedelta` — but resolved to a named cadence:

- delta ≈ 7 → `weekly`; ≈14 → `biweekly`; 15–16 or twice-monthly pattern → `semimonthly`;
  ≈28–31 → `monthly`; ≈90 → `quarterly`; ≈365 → `annual`
- no usable delta → `monthly` (the legacy fallback)

Use tolerance bands (e.g. ±2 days) so real-world dates classify cleanly. `reverse` is a
no-op (field removal handled by schema reverse). Count rows per bucket and emit a summary
line so the backfill is auditable.

### T01.SL3 — Migration safety

- Confirm the migration number does not collide (last applied is `0016_savings_goal`; check current head before naming).
- The field is non-null with a default, so the schema step is safe on a populated table; the backfill then replaces the default with the inferred value.
- Run `python manage.py makemigrations --check` to confirm no further migration drift after.

## Notes

- Keep `start_date`/`due_date` on the model — they are still used for display and as the backfill source. They simply stop being the *source of truth* for cadence.
- Semimonthly is intentionally a named cadence here; the engine (T02) decides how it advances. Do not encode it as a fixed day count in the model.
