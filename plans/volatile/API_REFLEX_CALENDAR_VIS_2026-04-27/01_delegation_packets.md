# Delegation Packets

Use with `/orchestration-manager`. Enforce API -> CLI -> Reflex order for feature tasks.

## Shared Packet Fields

- Task ID and objective
- Scope boundary
- Definition of done
- Verification checklist
- Constraints/contracts
- Expected handoff format (`shared-subagent-handoff`)

## CAL_API_1 - Calendar contract freeze
- Objective: define/finalize API payload for daily/weekly/monthly calendar aggregates and day drill rows.
- Scope: `finance_manager_api` endpoints/services/serializers/tests.
- DoD: response schema stable and documented; test fixtures cover month boundaries.
- Verification: API tests + schema/contract checks pass.

## CAL_CLI_1 - Contract verification via CLI
- Objective: confirm calendar payload usability via CLI path.
- Scope: `finance_manager_cli` contract commands/tests.
- DoD: CLI can fetch and validate calendar payloads for representative ranges.
- Verification: CLI smoke commands and parser assertions pass.

## CAL_REFLEX_1 - Calendar MVP
- Objective: ship transaction calendar page with day click drill panel.
- Scope: `finance_manager_reflex` transactions calendar route/state/components.
- DoD: calendar renders API aggregates; day click shows detailed transactions for selected date.
- Verification: state/UI smoke and filter interactions pass.

## VIS_API_2 - Visualization aggregate packets
- Objective: expand API packets for transaction and upcoming-expense deep-dive visualizations.
- Scope: API aggregate query utilities + endpoint payloads.
- DoD: trend/category/source/expense packets return in digestible chart-ready structure.
- Verification: API tests for correctness and performance-sensitive query shapes.

## VIS_REFLEX_2 - Visualization subpages
- Objective: implement transactions/expenses analysis subpages backed by VIS_API_2 packets.
- Scope: Reflex subpages, chart state, controls, and drill interactions.
- DoD: charts and controls are functional, readable, and consistent with dashboard filter semantics.
- Verification: UI smoke and no-regression checks against existing transactions flows.

## PERF_3 - Baseline and hotspot evidence
- Objective: profile API/reflex behavior with high-volume transaction fixtures (10k+ user rows).
- Scope: API query latency + Reflex rendering/state update paths.
- DoD: evidence table with top bottlenecks and threshold recommendations.
- Verification: reproducible benchmark/profile artifacts attached.

## RUST_4 - Candidate offload map
- Objective: identify first Rust-worthy calculations/transformations with measurable ROI.
- Scope: analysis + roadmap/doc updates only (no production Rust integration yet).
- DoD: ranked list of offload candidates, expected gains, and integration complexity.
- Verification: candidate list maps directly to PERF_3 evidence and approved thresholds.
