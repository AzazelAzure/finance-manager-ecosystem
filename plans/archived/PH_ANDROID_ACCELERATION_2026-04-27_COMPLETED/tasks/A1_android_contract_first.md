# A1 Android Contract-First Start

- Goal: begin Android production path with contract-first core.
- Status: complete (A1-v0 artifact lane, 2026-04-27).
- Scope:
  - app skeleton, auth/session, baseline data fetch, outbox schema scaffold.
- DoD:
  - login + snapshot + deterministic contract checks pass.
- Depends on: `tasks/L1_localization_v0.md`

## A1 Evidence (v0)

- `finance_manager_android/docs/A1_contract_first_packet.md`
- `finance_manager_android/fixtures/auth_login_request.json`
- `finance_manager_android/fixtures/auth_login_response.json`
- `finance_manager_android/fixtures/profile_snapshot_response.json`
- `finance_manager_android/tools/validate_contract_fixtures.py`

## Verification Result

- `python tools/validate_contract_fixtures.py` -> `contract_fixtures_ok`
