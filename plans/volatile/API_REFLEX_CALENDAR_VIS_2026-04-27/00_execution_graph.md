# Execution Graph

## Goal

Deliver calendar and richer visual analytics with low regression risk, while collecting performance evidence for future Rust offload work.

## Graph

`CAL_API_1 -> CAL_CLI_1 -> CAL_REFLEX_1 -> VIS_API_2 -> VIS_REFLEX_2 -> PERF_3 -> RUST_4`

- API contract work always precedes CLI and Reflex work.
- Performance review follows first usable visualization slice.
- Rust offload mapping depends on observed hotspots, not speculation.
