# T04 — STS Pay-Window Engine

## End State

When `sts_window_mode=pay_cycle`, STS and `total_remaining_expenses` use bills due in the current pay window (anchor + frequency), not calendar month. Partial-pay bills contribute `planned_partial_amount` (or residual) to STS debt per rulebook.

## Acceptance Criteria

1. [V1] `pay_cycle.py` helper computes window `[start, end)` from profile anchor + frequency in profile TZ
2. [V1] `Updater` bill selection uses pay window when configured; calendar month when `calendar_month`
3. [V1] Table-driven tests: biweekly window, partial 60% electric, legacy user regression (calendar month unchanged)
4. [V1] `Calculator.calc_sts` debt uses effective obligation amount (partial when set)

## Scope Lock

### Files to modify (API)
- `finance/logic/pay_cycle.py` (new)
- `finance/logic/updaters.py`
- `finance/logic/fincalc.py` (effective bill amount helper if needed)
- `finance/tests/` — STS pay-cycle tests

### Files NOT to touch
- Web
- Volatile forecast endpoint (companion / deferred)

## Depends on

- T01, T02, T03

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t04-sts-pay-window-engine` (API repo)

## References

- `design_docs/20_Roadmap/Volatile_Bills_and_Partial_Payment_Rulebook.md` — partial payment rules
