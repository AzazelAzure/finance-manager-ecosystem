# Archived: one-off Python scripts (former repo root)

These files lived at the **parent repo root** (`finance_manager/`) as ad-hoc experiments (Reflex dashboard models/state, httpx API smokes, pydantic checks). They are **not** part of CI, `scripts/fm_*.sh`, or maintained workflows.

**Do not run blindly:** several contain **hardcoded absolute paths** or **assumptions** (local hostnames, old URL shapes, `finance_manager_api.settings` from the wrong cwd) that no longer match production or current API routes.

**Why archived (2026-05-04):** `finance_manager_reflex` is **archived**; flagship work is `finance_manager_web`. Legitimate API tests belong under `finance_manager_api/finance/tests/`; web tests under `finance_manager_web/`.

| File | Original purpose (approx.) |
| --- | --- |
| `fix_models.py` | Overwrite Reflex `agentdash/models.py` with a fixed Pydantic model block. |
| `fix_state.py` | Toggle Reflex agentdash models between `BaseModel` and `rx.Base`. |
| `test_api.py` | Async httpx smoke vs `api.financemanager.local:8443`. |
| `test_db_script.py` | Django `get_transactions` from parent cwd (fragile imports). |
| `test_dump.py` | `TransactionRecord.model_dump` sanity. |
| `test_httpx.py` | Login + txs + `build_spend_series` against localhost:8000. |
| `test_mappers.py` | `map_to_view_model` with inline JSON payloads. |
| `test_pydantic.py` | Pydantic `Decimal` coercions on a tiny model. |
| `test_reflex_state.py` | Instantiate Reflex `rx.State` subclass (historically flaky). |

If something here is worth reviving, **re-home** it as a proper test or a documented script under `finance_manager_api/`, `finance_manager_web/`, or `scripts/` with argparse, env-based URLs, and no absolute paths.
