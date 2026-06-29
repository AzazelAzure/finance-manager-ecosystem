# T01 — auto_deduct Field + API Contract

## End State

`UpcomingExpense` carries an opt-in `auto_deduct` flag. The API validates that a `source`
(PaymentSource FK, already on the model) is set whenever `auto_deduct` is true, and exposes the
field for read/write. The idempotency mechanism that prevents double-posting auto-generated
transactions is defined here (the scheduler in T02 consumes it).

## Acceptance Criteria

1. [V1] `UpcomingExpense.auto_deduct` BooleanField, default `False`, with migration.
2. [V1] Serializer validation: `auto_deduct=True` requires a non-null `source`; reject with a clean 400 otherwise. A DB `CheckConstraint` backs it (`~Q(auto_deduct=True) | Q(source__isnull=False)`).
3. [V1] Idempotency key defined for auto-generated transactions: a deterministic key `autodeduct:{expense_id}:{due_date_iso}` enforced unique so a retried run cannot double-post. Implement as a nullable unique field on the transaction model (or a small `AutoDeductLedger` dedup row — pick one, document it).
4. [V1] GET/POST/PATCH on the upcoming-expense resource round-trip `auto_deduct`; omitting it defaults `False` (backward compatible).
5. [V1] Unit tests: validation pass/fail; idempotency-key uniqueness rejects a duplicate.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/models.py` — `auto_deduct` field + constraint; idempotency field/model
- `finance_manager_api/finance/serializers.py` — field + `validate()`
- `finance_manager_api/finance/migrations/00XX_auto_deduct.py`

### Files NOT to touch
- The scheduler/task path (T02), web (T03)

## Slices

### T01.SL1 — Field + constraint
Add `auto_deduct` to `UpcomingExpense`; add the source-required CheckConstraint. The `source` FK
already exists (`models.py:244`) — do not re-add it.

### T01.SL2 — Idempotency primitive
Define the dedup mechanism. Preferred: a unique, nullable `auto_deduct_key` CharField on the
transaction model, set to `autodeduct:{expense_id}:{occurrence_due_date}` when a row is generated
by auto-deduct. The unique constraint is the double-spend guard. Document the exact key format in
a docstring — T02 and T04 depend on it.

### T01.SL3 — Serializer + validation + tests
Expose `auto_deduct`; add `validate()` enforcing source-when-true; tests for both the validation
and the idempotency-key uniqueness.

## Notes

- **API contract lands before the scheduler (plan §5)** to avoid double-spend: the dedup key must exist before any job can post.
- `source` is already the funnel (underused in UX today); this task makes `auto_deduct` first-class on top of it.
- No bank-pull / institution integration — auto-deduct posts/stages an internal transaction from the linked source only (plan §2 out-of-scope).
