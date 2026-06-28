# T02 — Bill Realism Schema (Volatile / Rigid + Partial Pay)

## End State

`UpcomingExpense` persists bill classification and partial-payment intent. Defaults (`rigid`, no partial) preserve legacy full-bill semantics.

## Acceptance Criteria

1. [V1] Fields: `bill_class` (`volatile`|`rigid`), `planned_partial_amount`, `cycle_residual_amount`, `remainder_due_date`
2. [V1] Migration applies with defaults; existing bills are `rigid` with null partial fields
3. [V1] Model tests cover defaults and partial-amount constraints (`planned_partial_amount <= amount` when set)

## Scope Lock

### Files to modify (API)
- `finance/models.py` — `UpcomingExpense` fields
- `finance/migrations/0013_upcomingexpense_bill_realism_fields.py`
- `finance/tests/` — expense model tests

### Files NOT to touch
- Serializers, STS engine, web

## Depends on

- T01 (independent migration numbering — land T01 first)

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t02-bill-realism-schema` (API repo)
