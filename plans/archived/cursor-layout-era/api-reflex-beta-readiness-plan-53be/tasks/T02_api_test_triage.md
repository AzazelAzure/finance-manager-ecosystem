# T02 API Test Triage

## Objective
Make the `finance_manager_api` test suite trustworthy for beta readiness by identifying and fixing root causes behind the current broad failure set, without masking unrelated regressions.

## Scope Boundary
- Repo: `finance_manager_api/`
- Primary files likely involved:
  - `finance_api/urls.py`
  - `finance/urls.py`
  - affected view/router modules
  - affected tests under `finance/tests/`
  - `CHANGELOG.md` if behavior changes
- Do not modify Reflex or design docs in this task unless a handoff note is required.

## Known Evidence
- Cloud run: `SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q`
- Result: `94 failed, 65 passed, 4 skipped`.
- Dominant observed failures:
  - `NoReverseMatch` for names such as `categories`, `upcoming_expenses`, and `transaction_detail_update_delete`.
  - user authorization/delete status expectations returning `400`/`403` where tests expect `403`/`200`.

## Definition of Done
- Failure categories are grouped by root cause.
- URL naming regressions are fixed at the route layer or tests are updated only if the contract intentionally changed.
- Auth/status regressions are fixed or explicitly split into follow-up tasks with rationale.
- Targeted tests pass for each fixed failure cluster.
- Full API test suite is green, or remaining failures are listed with concrete next task packets.

## Required Verification
```bash
cd finance_manager_api
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q
```

When iterating, run narrower commands first, for example:

```bash
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q finance/tests/category_tests finance/tests/expense_tests
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q finance/tests/user_tests
```

## Risks / Rollback
- Broad test failure count may come from a small URL naming change; avoid sweeping behavioral rewrites until root cause is proven.
- If tests encode old endpoint contracts and current API intentionally changed, update design docs/contract matrix before changing consumers.
- Roll back individual route/view changes if they widen access or weaken ownership checks.

## Handoff Output
Use shared handoff format and include:
- Root-cause groups.
- Tests fixed and still failing.
- API branch/PR status.
- Any downstream Reflex or CLI contract impact.
