# T04 — Edge Cases (timezone, skips, toggle-off, partial-pay)

## End State

Auto-deduct behaves correctly at the boundaries: timezone-correct "due today," safe toggle-off
(stops future runs, preserves history), no double-post under retry/concurrency, and coherent
interaction with the F-004 partial-pay paid-state machine.

## Acceptance Criteria

1. [V1] **Timezone:** a bill due on date D fires on D **in the profile's timezone** — a "due tomorrow" bill in the user's TZ does not fire today even if it's already tomorrow in server/UTC time. Tests cover a profile in a TZ ahead of and behind server time.
2. [V1] **Toggle-off:** setting `auto_deduct=False` stops all future auto-posts for that bill and **does not delete or reverse** any previously auto-posted transactions.
3. [V1] **Retry/idempotency:** re-running the task (crash recovery, beat overlap) for the same occurrence is a no-op via the T01 dedup key; a concurrency test asserts a single transaction.
4. [V1] **Partial-pay interaction (F-004):** if a bill uses `planned_partial_amount` / volatile bill_class, auto-deduct posts the correct amount and the paid-state transition matches the manual-payment path — no divergent state machine.
5. [V1] **Failure modes documented:** a short "auto-deduct failure & manual reconcile" note (insufficient-source handling, what the user sees, how to recover) added to the plan's runtime handoff or a `docs` block.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/tasks/auto_deduct.py` — boundary handling
- `finance_manager_api/finance/tests/test_auto_deduct.py` — boundary/concurrency tests
- plan `runtime_handoff.md` — failure-mode/reconcile note

### Files NOT to touch
- Web (T03), unrelated task paths

## Slices

### T04.SL1 — Timezone boundary
Resolve "due today" against profile TZ; tests for ahead/behind-server profiles around midnight.

### T04.SL2 — Toggle-off + history preservation
Verify disabling halts future posts and leaves history intact.

### T04.SL3 — Concurrency + partial-pay + failure docs
Concurrency/idempotency test; partial-pay amount + paid-state parity with manual; write the
reconcile playbook note.

## Notes

- Holidays/skipped business days: v1 posts on the calendar due date (no holiday calendar). If a holiday-skip rule is wanted later, it's a follow-up — note it, don't build it here.
- Insufficient source balance: define the v1 behavior explicitly (e.g. still record intent + flag for user, OR skip + notify) — confirm with HitM if underspecified rather than guessing (AGENTS.md §1).
- The paid-state machine is shared with F-004; changing it risks regressions there — add tests on both manual and auto paths.
