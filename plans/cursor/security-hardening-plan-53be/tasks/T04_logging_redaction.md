# T04 Logging Redaction and PII Boundary

## Objective
Prevent beta logs from capturing raw financial payloads, usernames, or token-adjacent values while preserving enough context for support.

## Scope Boundary
- Primary repo: `finance_manager_api/`
- Secondary repo: `finance_manager_reflex/` only if parity changes are needed.
- Do not remove user-scoped observability entirely; prefer pseudonymous identifiers and trace IDs.

## Evidence
- API `finance/middleware/user_log_context.py` contextualizes logs with `username` and `uid`.
- API transaction validation path logs raw request `data`.
- Reflex has `redact_sensitive` helpers in `finance_manager_reflex/core/logging_config.py`; API should mirror this discipline.

## Requested Change
- Replace raw username logging with a pseudonymous identifier or make username logging debug-only behind an explicit flag.
- Remove raw payload logging from validation failures; log error keys, serializer errors, route/action, and trace ID instead.
- Add a small shared redaction helper if repeated patterns exist.
- Document beta log privacy expectations if behavior changes.

## Acceptance Criteria
- Invalid transaction payloads do not write raw submitted descriptions, amounts, tags, or token values to logs.
- Authenticated request logs retain enough pseudonymous context for support.
- Tests or targeted manual checks prove sensitive fields are redacted.

## Verification Commands
```bash
cd finance_manager_api
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q finance/tests/transaction_tests finance/tests/user_tests
```

If tests are not feasible, use a local invalid-payload smoke and inspect logs.

## Required Handoff
Use shared handoff format and include before/after logging examples with fake data only.
