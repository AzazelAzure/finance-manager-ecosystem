# Readiness Gates

## Gate A (After CAL_API_1)

- Calendar API contract frozen.
- Month-boundary and day-drill test coverage passes.
- CLI handoff ready.

## Gate B (After CAL_CLI_1)

- CLI contract verification passes for sample ranges and filters.
- No contract ambiguity for Reflex implementation.

## Gate C (After CAL_REFLEX_1 + VIS_API_2 + VIS_REFLEX_2)

- Calendar and visualization UX stable under normal datasets.
- No major regressions in transactions CRUD/filter flows.

## Gate D (After PERF_3)

- Performance baseline and hotspots documented for 10k+ row scenarios.
- Threshold-based decision available for Rust offload prioritization.
