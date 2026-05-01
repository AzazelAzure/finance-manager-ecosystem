# A2 Offline Sync Core

- Goal: implement resilient offline replay path.
- Status: complete (A2-S1 baseline scaffold, 2026-04-27).
- Scope:
  - offline create/update queue, replay worker, restart durability.
- DoD:
  - offline->reconnect replay and restart recovery pass.
- Depends on: `tasks/A1_android_contract_first.md`

## Ownership/Unblock Evidence

- `finance_manager_android/docs/A2_runtime_ownership_bootstrap.md`
- `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/08_A2_ownership_unblock_packet.md`

## Next Slice (A2-S1)

- Create module layout for outbox/replay/contracts/state.
- Implement outbox schema model and replay worker skeleton.
- Run deterministic serialization and queue-order checks.

## A2-S1 Evidence

- `finance_manager_android/app/src/main/java/com/finance_manager/sync/state/SyncState.kt`
- `finance_manager_android/app/src/main/java/com/finance_manager/sync/outbox/OutboxRecord.kt`
- `finance_manager_android/app/src/main/java/com/finance_manager/sync/contracts/ContractDtos.kt`
- `finance_manager_android/app/src/main/java/com/finance_manager/sync/replay/ReplayWorker.kt`
- `finance_manager_android/tools/validate_a2_scaffold.py`

## Verification Result

- `python tools/validate_a2_scaffold.py` -> `a2_scaffold_ok`
