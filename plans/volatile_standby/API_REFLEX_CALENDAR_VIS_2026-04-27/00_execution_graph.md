# Execution Graph

`CAL_API_1 -> CAL_CLI_1 -> CAL_REFLEX_1 -> PROF_API_1 -> PROF_REFLEX_1 -> VIS_API_2 -> VIS_REFLEX_2 -> PERF_3 -> RUST_4`

- Enforce API -> CLI -> Reflex order for all user-facing feature rollout tasks.
- Run performance baseline before selecting Rust offload candidates.
- Profile settings editability (spend accounts, week start, base currency) is a mandatory lane before visualization polish closes.
