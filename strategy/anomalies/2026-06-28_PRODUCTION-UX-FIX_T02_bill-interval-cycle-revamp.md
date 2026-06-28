---
logged: 2026-06-28
agent: cursor
plan_context: PLAN_CROSS_PRODUCTION_UX_FIX_2026-06-28 / T02
status: dispatched
dispatched_to: PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29
dispatched_on: 2026-06-29
severity_guess: medium
---

> **2026-06-29 dispatch:** Standalone plan authored — `plans/S1/S1.B/feat-bill-recurrence-engine/`
> (PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29, status: ready). It replaces the start/due-delta
> inference with a first-class `cadence` field on `UpcomingExpense`. Move this anomaly to
> `resolved` when that plan closes. Blocks F-009.

## What was found

Overdue recurring bill catch-up and transaction-linked bill settlement currently assume **calendar-month** advancement in `Updater._handle_upcoming` (`relativedelta(months=1)`). HitM directed **bill-interval** advancement for T02 (days between `start_date` and `due_date`, with monthly fallback when unset).

The interval-based advance is a stopgap: the product still models bills as effectively **monthly** in most UI flows, and true multi-cycle support (weekly, biweekly, pay-cycle-aligned, F-004 STS realism) needs a dedicated recurrence engine — not another patch on `due_date` arithmetic.

## Where

`finance_manager_api/finance/logic/updaters.py:267-268` — `bill.due_date = bill.due_date + relativedelta(months=1)`

`finance_manager_api/finance/models.py` — `UpcomingExpense` (`start_date`, `due_date`, `is_recurring`; no explicit interval/cadence field)

Related future work: `plans/S1/S1.B/feat-f004-sts-pay-cycles-bill-realism/README.md`

## What agent was doing

Implementing T02 (bill link mark-paid + overdue recovery) after HitM chose interval-based advance (option B).

## Why outside scope

T02 scope is targeted mark-paid + advance/catch-up fixes. A full bill-cycle model (cadence field, pay-cycle alignment, volatile vs rigid bills) is F-004 / recurrence-engine territory and would expand this batch into a multi-plan API redesign.

## Possible owner

Cursor — follow-up plan under F-004 STS pay cycles / bill realism, or a new `feat-bill-recurrence-engine` slice after F-004 research locks

## Notes

HitM comment (2026-06-28): interval advance is acceptable for now; **revamp later** so differing bill cycles are first-class in API + web, not inferred from `start_date`/`due_date` deltas.
