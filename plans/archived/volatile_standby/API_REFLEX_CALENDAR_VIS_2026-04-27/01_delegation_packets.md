# Delegation Packets (Standby)

## CAL_API_1
- Objective: Freeze transaction calendar aggregate contracts (daily/weekly/monthly + day-drill rows).
- Scope: `finance_manager_api`
- DoD: schema and tests stable
- Verify: API contract tests pass

## CAL_CLI_1
- Objective: Verify CAL_API_1 contracts via CLI integration path.
- Scope: `finance_manager_cli`
- DoD: CLI fetch/parse validated
- Verify: CLI smoke checks pass

## CAL_REFLEX_1
- Objective: Implement calendar MVP with day-click drill panel.
- Scope: `finance_manager_reflex`
- DoD: render + day detail behavior stable
- Verify: state/UI smoke passes

## PROF_API_1
- Objective: Ensure profile endpoints fully support mutable settings for spend accounts, week-start day, and base currency.
- Scope: `finance_manager_api` profile/source contracts and validation paths.
- DoD: update operations are contract-stable and return persisted values reliably.
- Verify: API tests for create/update/delete spend accounts and profile setting updates pass.

## PROF_REFLEX_1
- Objective: Add editable profile controls for spend accounts, day-of-week, and base currency in Reflex profile/settings UX.
- Scope: `finance_manager_reflex` profile state, forms, and save flows.
- DoD: users can update these settings directly from profile view without CLI fallback.
- Verify: UI/state smoke confirms load-edit-save-refresh persistence across page reload.

## VIS_API_2
- Objective: Add chart-ready transaction/upcoming-expense aggregate packets.
- Scope: `finance_manager_api`
- DoD: stable visualization payloads
- Verify: aggregate correctness tests pass

## VIS_REFLEX_2
- Objective: Implement transactions/expenses deep-dive visualization pages.
- Scope: `finance_manager_reflex`
- DoD: charts + controls + drill behavior stable
- Verify: no regression in existing transactions flows

## PERF_3
- Objective: Benchmark/profile 10k+ transaction scenarios.
- Scope: API query + Reflex render/state paths
- DoD: reproducible hotspot evidence captured
- Verify: profiling artifacts attached

## RUST_4
- Objective: Rank first Rust offload candidates from PERF_3 evidence.
- Scope: planning/docs only
- DoD: candidate list with ROI and complexity scores
- Verify: evidence-linked recommendation approved
