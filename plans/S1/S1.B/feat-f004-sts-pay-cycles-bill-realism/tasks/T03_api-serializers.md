# T03 — API Serializers & Profile/Expense Contract

## End State

Profile GET/PATCH and expense CRUD expose F-004 fields. Validation rejects invalid pay-cycle combos and partial amounts over bill total.

## Acceptance Criteria

1. [V1] `AppProfileGetSerializer` returns pay-cycle fields; PATCH accepts them with validation
2. [V1] Expense serializers include `bill_class`, partial-pay fields; create/update round-trip tests pass
3. [V1] `pytest` expense + profile serializer tests green

## Scope Lock

### Files to modify (API)
- `finance/api_tools/serializers/profile_serializers.py`
- `finance/api_tools/serializers/exp_serializers.py`
- `finance/services/user_services.py` (profile update allowlist)
- `finance/validators/` as needed
- Tests under `finance/tests/`

### Files NOT to touch
- STS calculation logic (`T04`)
- Web

## Depends on

- T01, T02

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t03-api-serializers` (API repo)
