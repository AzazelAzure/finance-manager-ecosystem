# T01 — Pay-Cycle Profile Schema

## End State

`AppProfile` stores user-defined STS window settings. Legacy users default to `calendar_month` so existing STS behavior is unchanged until they opt into pay-cycle mode.

## Acceptance Criteria

1. [V1] `AppProfile` has `sts_window_mode`, `pay_cycle_frequency`, and `pay_cycle_anchor_date` with safe defaults
2. [V1] Migration `0012` applies cleanly; existing rows get `sts_window_mode=calendar_month`
3. [V1] Model/unit tests assert defaults and choice validation

## Scope Lock

### Files to modify (API)
- `finance/models.py` — `AppProfile` fields + choices
- `finance/migrations/0012_appprofile_pay_cycle_fields.py` — additive migration
- `finance/tests/` — new or extended profile model tests

### Files NOT to touch
- Serializers, views, STS engine (`T03`/`T04`)
- Web repo

## Slices

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Model fields | V1 | Add fields with defaults; migration |
| T01.SL2 | Tests | V1 | Defaults preserve calendar month; anchor nullable |

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t01-pay-cycle-profile` (API repo, from `main`)

## References

- `design_docs/20_Roadmap/Volatile_Bills_and_Partial_Payment_Rulebook.md`
- `plans/S1/S1.B/FEATURE_IDEAS.md` §F-004 (configurable STS period)
