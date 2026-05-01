# RUST_4 Candidate Offload Map

## Inputs

- PERF evidence from `tasks/PERF_3_baseline_and_hotspots.md`
- Seeded benchmark confirmation at 10k and 20k transaction fixtures
- Implemented API packets:
  - `/finance/transactions/calendar/`
  - `/finance/transactions/visualization/`

## Ranked Candidates

1. **Visualization aggregate reducer kernel** (`get_transaction_visualization`)
   - ROI: High
   - Complexity: Medium
   - Why: repeated numeric aggregation/grouping work over large transaction sets.

2. **Calendar rollup reducer** (`get_transaction_calendar`)
   - ROI: Medium-High
   - Complexity: Medium
   - Why: deterministic day/week/month bucketing, stable pure-compute semantics.

3. **Cross-currency normalization helper batch path**
   - ROI: Medium
   - Complexity: High
   - Why: potential gain if profile-currency conversions become dominant under larger fixtures.

## Suggested Offload Sequence

1. Prototype Rust reducer for visualization flow/category/monthly buckets with parity tests against Python output.
2. Add Rust calendar bucketing adapter with fallback feature flag to Python implementation.
3. Keep Django ORM query boundaries in Python; offload only in-memory numeric reduction paths first.

## Acceptance Criteria Before Production Offload

- 10k+ fixture benchmark shows meaningful latency reduction versus Python baseline.
- Contract parity tests pass for both calendar and visualization payloads.
- Feature-flag rollback path verified in API runtime.
- Keep ORM boundary in Python and offload only pure reducer kernels first.
