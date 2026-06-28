---
task_id: T03
status: pending
owner: pproctor
phase: S1.B
intended_branch: cur/s1b/feat/f001-balance-history/t03-balance-history-api
last_verification: null
---

# T03 — Balance history read API

## End state

Authenticated users can query day-end balance series per account with date-range presets (7d / 30d / 90d / all). Amounts are returned in the user's base currency using existing `Calculator._calc_totals` conversion.

## Acceptance criteria

1. [V1] `GET /finance/balance-history/` accepts `source` (optional), `range` (`7d`|`30d`|`90d`|`all`), or explicit `start_date`/`end_date`
2. [V1] Response shape: `{ "series": [{ "date": "YYYY-MM-DD", "source": "...", "amount": "123.45", "currency": "PHP" }], "base_currency": "PHP" }`
3. [V1] Auth required; queryset scoped to requesting user's `uid`
4. [V1] OpenAPI schema updated via drf-spectacular
5. [V1] Contract tests in `finance/tests/balance_tests/test_balance_history_api.py`

## Slice decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T03.SL1 | Serializer + service | V1 | Query helper + base-currency conversion |
| T03.SL2 | View + routing | V1 | `finance/views/balance_views.py`; route in `finance_api/urls.py` |
| T03.SL3 | API tests | V1 | Empty, partial, and dense series cases |

## Scope lock

### In scope

- `finance_manager_api/` only
- Read endpoint, serializer, tests

### Out of scope

- Web chart (T04)
- Embedding in existing snapshot payload (separate endpoint keeps contract stable)

## Evidence

- `evidence/T03.SL3_pytest.txt` — pytest output

## Anti-patterns

- Do NOT mutate snapshot rows from the read endpoint
- Do NOT add write endpoints
