# T01 API Auth Defaults

## Objective
Make authenticated API access explicit by default so beta endpoints do not depend on accidental `AnonymousUser` failures or per-view omissions.

## Scope Boundary
- Repo: `finance_manager_api/`
- Branch: `cursor/api-auth-defaults-53be`
- Primary files:
  - `finance_api/settings.py`
  - `finance_api/urls.py`
  - public/auth/schema/health views as needed
  - targeted tests under `finance/tests/`
  - `CHANGELOG.md`

## Current Evidence
- `REST_FRAMEWORK` sets JWT authentication but not `DEFAULT_PERMISSION_CLASSES`.
- Many `APIView` classes do not define local `permission_classes`.
- Risk: omitted permissions default to DRF `AllowAny`.

## Requested Change
- Set DRF default permission to `IsAuthenticated`.
- Explicitly mark only truly public endpoints as `AllowAny`.
- Preserve token obtain/refresh/verify and health/docs behavior intentionally; do not rely on implicit defaults.

## Acceptance Criteria
- Anonymous requests to finance data endpoints return `401 Unauthorized`.
- Public endpoints remain reachable as intentionally documented.
- Existing authenticated API tests pass.
- New or updated auth-negative tests cover representative endpoint groups.

## Verification Commands
Run from `finance_manager_api/`:

```bash
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q finance/tests/user_tests
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q finance/tests/category_tests finance/tests/source_tests finance/tests/transaction_tests
SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' uv run pytest -q
```

## Risks / Rollback
- Risk: making schema/docs private may disrupt local development. Decide explicitly and document whichever route remains public.
- Rollback: revert permission defaults if a critical beta route is accidentally blocked, then add explicit view permissions before reapplying.

## Required Handoff
Use shared handoff format and include:
- Public routes explicitly allowed.
- Anonymous-access test evidence.
- Full or partial pytest results.
- Branch/PR status and Slack/GitHub gate state.
