# Delegation Packets for /orchestration-manager

Use one packet per delegated task. Do not open next dependency task until prior gate passes.

## Packet Template

- Task ID and objective
- Scope boundary (repo/path/system)
- Definition of done
- Required verification checklist
- Constraints/contracts/runtime owner notes
- Expected handoff format: `shared-subagent-handoff`

## Packets

### L0 - Scope freeze
- Objective: lock acceleration lane and breakpoints for PH + Android.
- Scope: `design_docs/20_Roadmap/`, `design_docs/03_Localization_Strategy.md`, this volatile folder.
- DoD: scope, gates, and lane order approved and recorded.
- Verification: file updates exist; no contradictory gate wording.

### L1 - Localization v0 (PH + US)
- Objective: ship minimum localization contract for critical flows.
- Scope: Reflex critical-path copy/formatting and docs.
- DoD: auth/profile/dashboard/transactions critical path is PH+US localization-ready.
- Verification: walkthrough checklist pass for PH + US profiles.
- Current status: complete for v0; Gate A passed.
- L1-ready packet updates for next dependency (`A1`):
  - Scope boundary: docs/planning artifacts only in this slice; no Android/Reflex feature implementation.
  - Required checklist:
    - translation key inventory for critical path
    - PH/US formatting contract confirmation
    - cross-doc consistency check against localization + Android gate docs
    - Gate A objective evidence links recorded
    - Tagalog-readability path decision recorded (full translation pass vs translator-onboarding lane)
    - Interim language-selection plan recorded (implementation slice or research spike outcome)
  - Constraints:
    - runtime intentionally down; avoid runtime-dependent validations
    - preserve roadmap and architecture gate wording
    - localize UI copy only; keep logic/contracts in English
  - Expected handoff format: `shared-subagent-handoff`
  - Evidence links:
    - critical-path surface: `finance_manager_reflex/README.md`
    - localization policy: `design_docs/03_Localization_Strategy.md`
    - Android gate dependency: `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md`
    - hosted-beta priority alignment: `design_docs/20_Roadmap/Beta_Execution_Board.md`
    - critical frontend surfaces requiring translation treatment:
      - `finance_manager_reflex/finance_manager_reflex/features/auth/view.py`
      - `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
      - `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`
      - `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`
      - `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view_components.py`

### A1 - Android contract-first
- Objective: start production lane with auth/session + contract-bound data flows.
- Scope: Android app skeleton and API contract fixtures.
- DoD: boot/login/snapshot path stable; outbox schema scaffolded.
- Verification: deterministic contract smoke and startup checks.
- Current status: complete for v0 artifact lane (Gate B = pass).
- Evidence:
  - `finance_manager_android/docs/A1_contract_first_packet.md`
  - `finance_manager_android/tools/validate_contract_fixtures.py`

### P1 - Play Store preflight
- Objective: prep release operations in parallel.
- Scope: release docs/checklists/tracks.
- DoD: internal/closed track strategy + signing/policy checklist complete.
- Verification: dry-run checklist can be executed end-to-end.
- Current status: complete for v0 artifact lane.
- Evidence:
  - `finance_manager_android/docs/P1_play_store_preflight_checklist.md`

### A2 - Offline sync core
- Objective: durable offline create/update replay with restart resilience.
- Scope: Android sync/outbox/replay workers and conflict baseline.
- DoD: offline->reconnect replay succeeds; restart recovery succeeds.
- Verification: network toggle tests + crash/restart replay tests.
- Current status: complete (A2-S1 baseline scaffold).
- Ownership packet:
  - `finance_manager_android/docs/A2_runtime_ownership_bootstrap.md`
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/08_A2_ownership_unblock_packet.md`
- Verification:
  - `python tools/validate_a2_scaffold.py` -> `a2_scaffold_ok`

### P2 - Closed beta gate
- Objective: approve PH+US early closed beta.
- Scope: release readiness + risk ledger + rollout thresholds.
- DoD: go/no-go decision recorded with explicit fallback.
- Verification: Gate C checklist complete with evidence links.
- Current status: complete (`go` decision logged).
