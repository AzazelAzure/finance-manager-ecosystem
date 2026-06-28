---
logged: 2026-06-28
agent: cursor
plan_context: PLAN_CROSS_STS_BILL_REALISM_F004_2026-05-05 / T01
status: unreviewed
severity_guess: medium
---

## What was found

F-004 T01 and F-001 T01 both authored `finance/migrations/0012_*` depending on `0011_tos_acceptance_fields`. Parallel agent work on `cur/s1b/feat/f001-balance-history-t01-balance-snapshot-model` uses `0012_balance_snapshot_f001`. Whichever merges second must renumber to `0013` and add a merge migration.

## Where

`finance_manager_api/finance/migrations/0012_appprofile_pay_cycle_fields.py`

`finance_manager_api/finance/migrations/0012_balance_snapshot_f001.py` (F-001 agent local branch)

## What agent was doing

Implementing F-004 T01 pay-cycle profile schema on API branch `cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t01-pay-cycle-profile`.

## Why outside scope

T01 cannot wait for F-001 merge without blocking F-004 execution order; renumber is a mechanical rebase after F-001 lands.

## Possible owner

Cursor — whichever F-004/F-001 PR merges second rebases migration number
