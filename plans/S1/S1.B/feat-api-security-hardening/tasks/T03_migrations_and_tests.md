# T03 — Migrations and Test Suite

## End State
All axes migrations are applied and committed. A test suite covers the three security behaviors introduced by this plan: login lockout, password complexity rejection, and Argon2 hashing.

## Acceptance Criteria
1. [V1] `python manage.py showmigrations axes` shows all migrations applied
2. [V1] `pytest` passes with tests covering lockout (5 bad logins → 429), complexity rejection (weak password → 400), and Argon2 verification (stored hash starts with `$argon2`)
3. [V1] `python manage.py migrate --check` exits 0 (no unapplied migrations after committing)

## Scope Lock

### Actions
- Run `python manage.py migrate axes`
- Verify axes migration files are generated under `finance_manager_api/` (or wherever migrations live) and commit them
- Write tests in the appropriate test file (likely `finance/tests/test_auth_security.py` or similar):
  - **Lockout test:** make 5 consecutive bad login POSTs with wrong password for a valid user; assert 6th returns 403 or 429
  - **Complexity test:** authenticated POST to change-password endpoint with weak password; assert 400 with error body
  - **Argon2 test:** create user, verify `user.password` field starts with `$argon2`

### Files to create
- `finance/tests/test_auth_security.py` (if not exists) — new test file

### Files NOT to touch
- Any endpoint logic (T02 scope)
- `settings.py` (T02 already complete at this point)

## Technical Decisions (pre-locked)
- Use Django's `APIClient` or `TestClient` for HTTP-level tests to exercise middleware (axes lockout must go through the middleware stack)
- Reset axes access attempts between test cases using `axes.models.AccessAttempt.objects.all().delete()` in setUp/tearDown to avoid test pollution
- Do not test HSTS/nosniff headers here — those are infrastructure-level and verified at deployment

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T03.SL1 | Axes migration | V1 | `python manage.py migrate axes`; commit migration state; `showmigrations axes` confirms applied |
| T03.SL2 | Security test suite | V1 | Write and run 3 tests (lockout, complexity, Argon2); `pytest` green |

## Evidence
- `evidence/T03.SL1_showmigrations.txt` — output of `python manage.py showmigrations axes`
- `evidence/T03.SL2_pytest_output.txt` — full pytest output showing 3 new tests passing

## Clarifying Questions (ask HitM before proceeding if unclear)
1. Are tests run with `pytest` or `python manage.py test`? (Confirm test runner to use correct invocation)
2. Is there an existing test file for auth flows that new tests should extend, or create a new file?
