# L1 Localization v0

- Status: active (started 2026-04-27); Gate A pending.
- Goal: lock minimum PH + US localization contract.
- Scope:
  - critical-path strings and locale formatting behaviors.
- DoD:
  - critical-path review complete for PH and US.
- Depends on: `tasks/L0_scope_freeze.md`

## L1 Execution Checklist (Concrete)

- [x] Confirm critical-path localization coverage reference for auth/profile/dashboard/transactions.
- [x] Confirm PH and US currency/date formatting rules are explicitly documented and consistent with shared localization strategy.
- [x] Confirm copy and formatting contracts are stable enough for Android contract-first handoff (no feature implementation in this slice).
- [x] Produce/update L1 delegation evidence links in `01_delegation_packets.md`.
- [x] Prepare Gate A evidence packet stub in `03_readiness_gates.md` without marking Gate A passed.
- [x] Confirm current frontend translation infrastructure status (translation-key system absent in critical views).
- [x] Define execution choice for Tagalog-readability: (A) full critical-path translations now, or (B) translator onboarding lane with reviewed glossary.
- [x] Define interim language-selection approach for beta (simple selector + mapped copy catalog) or log research spike if deferred.
- [x] Keep business logic and contracts in English while localizing user-facing copy only.

## L1 Evidence Links (Cycle 2)

- Critical-path surface reference (auth/profile/dashboard/transactions):
  - `finance_manager_reflex/README.md`
- PH + US localization requirement reference:
  - `design_docs/03_Localization_Strategy.md`
- Android hard gate / contract-planning-only constraint:
  - `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md`
- Hosted beta `[Now]` priority alignment:
  - `design_docs/20_Roadmap/Beta_Execution_Board.md`
- Current frontend localization readiness signals:
  - `finance_manager_reflex/finance_manager_reflex/features/auth/view.py`
  - `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
  - `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`
  - `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`
  - `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view_components.py`
- L1 decision memo and execution slices:
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/04_L1_translation_decision_memo.md`
- L1 translation key inventory for onboarding:
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/05_L1_translation_key_inventory.md`

## Validation Stub

- Gate A evidence bundle is complete for v0.
- Gate decision source:
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/07_L1_gateA_evidence_pack.md`

## Cycle 3+ Progress (Execution)

- L1-T1 completed for v0 with i18n scaffold + selector wiring on critical surfaces.
- L1-T2 completed for v0 with selector/fallback behavior documented and validated.
- L1-T3 completed for v0 with glossary + review protocol.
- L1-T4 completed with evidence pack artifact.
- Deterministic compile validation passed for updated Reflex files (`python -m py_compile`).
