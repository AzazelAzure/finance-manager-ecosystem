# T03 — Cadence API Exposure + Validation

## End State

The `UpcomingExpense` API reads and writes `cadence` and `custom_interval_days`. Creating or
updating a bill with `cadence=custom` requires a positive `custom_interval_days`; all other
cadences ignore/forbid it. `updaters.py` continues to roll bills correctly using the
cadence-driven engine from T02 (no logic change needed there — just confirm it works end to
end).

## Acceptance Criteria

1. [V1] The upcoming-expense serializer includes `cadence` (writable, defaults `monthly`) and `custom_interval_days` (writable, nullable).
2. [V1] Serializer validation: `cadence == custom` requires `custom_interval_days > 0`; any non-custom cadence with a non-null `custom_interval_days` is rejected (or silently nulled — pick one and document it).
3. [V1] GET responses include the cadence fields.
4. [V1] Existing create/update flows that omit `cadence` still succeed (defaults to `monthly`), preserving backward compatibility for any client not yet sending it.
5. [V1] An integration test creates a weekly bill via the API, settles it, and confirms the due date advanced +7 days through the real `updaters.py` path.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/serializers.py` (the `UpcomingExpense` serializer)
- `finance_manager_api/finance/views/...` only if explicit field allow-lists exist that must include the new fields

### Files NOT to touch
- `models.py` (T01), `bill_recurrence.py` (T02)
- Frontend (T04)

### Files to verify (no change expected)
- `finance/logic/updaters.py` — confirm `_handle_upcoming` rolls cadence-driven bills correctly; only touch if a bug surfaces

## Slices

### T03.SL1 — Serializer fields

Add `cadence` and `custom_interval_days` to the `UpcomingExpense` serializer `fields`. Ensure
any `read_only_fields` / explicit field lists include them. If the serializer uses
`fields = "__all__"`, confirm the new fields flow through and are writable.

### T03.SL2 — Validation

Add `validate()`:

```python
def validate(self, attrs):
    cadence = attrs.get("cadence", getattr(self.instance, "cadence", "monthly"))
    days = attrs.get("custom_interval_days", getattr(self.instance, "custom_interval_days", None))
    if cadence == "custom" and not (days and days > 0):
        raise serializers.ValidationError(
            {"custom_interval_days": "Required and must be > 0 when cadence is 'custom'."}
        )
    if cadence != "custom" and days:
        attrs["custom_interval_days"] = None  # documented: non-custom clears the field
    return attrs
```

### T03.SL3 — End-to-end confirmation

Add an integration/API test: create a `weekly` bill, mark it paid via the normal settlement
path, and assert `due_date` advanced exactly 7 days. This proves the model (T01) → engine
(T02) → settlement (`updaters.py`) chain works through the API, not just in unit isolation.

## Notes

- The DB `CheckConstraint` from T01 is the backstop; serializer validation gives a clean 400 instead of an IntegrityError.
- Do not add a separate cadence endpoint — cadence is a field on the existing upcoming-expense resource.
