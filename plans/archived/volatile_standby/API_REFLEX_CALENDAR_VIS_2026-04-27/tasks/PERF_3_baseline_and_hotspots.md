# PERF_3 Baseline and Hotspots

## Scope

- API calendar/visualization aggregation path
- Reflex transactions/profile/deep-dive compile validation path

## Evidence Collected

- `uv run pytest finance/tests/transaction_tests/test_transaction_visualization.py finance/tests/transaction_tests/test_transaction_calendar.py --durations=5`
  - slowest call: visualization aggregate test at `0.21s`
  - calendar aggregate call: `0.16s`
  - calendar day-drill call: `0.14s`
- `uv run pytest finance/tests/transaction_tests/test_transaction_calendar.py finance/tests/transaction_tests/test_transaction_visualization.py finance/tests/profile_tests/test_profile_patch.py`
  - 9 tests passed
  - total runtime: `1.48s`
- `uv run python -m compileall finance_manager_reflex`
  - full Reflex package compiled successfully after CAL/VIS/PROF changes
- `uv run python manage.py benchmark_calendar_visualization --seed --users 1 --transactions-per-user 2000 --iterations 3 --window-days 30`
  - artifact: `finance_manager_api/stress_tests/results/calendar_visualization_benchmark.json`
  - sample result:
    - calendar avg/p95: `7.13ms / 4.82ms`
    - visualization avg/p95: `4.98ms / 4.91ms`
- `uv run python manage.py benchmark_calendar_visualization --seed --users 1 --transactions-per-user 10000 --iterations 10 --window-days 30`
  - artifact: `finance_manager_api/stress_tests/results/calendar_visualization_benchmark.json`
  - result:
    - calendar avg/p95: `26.81ms / 24.56ms`
    - visualization avg/p95: `26.62ms / 24.85ms`
- `uv run python manage.py benchmark_calendar_visualization --seed --users 1 --transactions-per-user 20000 --iterations 10 --window-days 30`
  - artifact: `finance_manager_api/stress_tests/results/calendar_visualization_benchmark.json`
  - result:
    - calendar avg/p95: `52.24ms / 74.60ms`
    - visualization avg/p95: `51.53ms / 74.42ms`

## Initial Hotspot Signals

1. API visualization aggregation performs multiple grouped scans (transaction flow, category totals, upcoming monthly rollups).
2. Calendar + visualization paths are both query-heavy and should remain primary profiling targets under 10k+ transaction fixtures.
3. Reflex deep-dive pages currently depend on server-side packet shape and appear CPU-light in this pass (no frontend runtime profiling artifact yet).

## Gate Status

- PERF_3 baseline evidence: captured (test-duration baseline)
- PERF_3 seeded command baseline: captured (`benchmark_calendar_visualization`)
- PERF_3 10k+ benchmark artifact: captured (`--transactions-per-user 10000 --iterations 10`)
- PERF_3 extended high-volume baseline: captured (`--transactions-per-user 20000 --iterations 10`)
