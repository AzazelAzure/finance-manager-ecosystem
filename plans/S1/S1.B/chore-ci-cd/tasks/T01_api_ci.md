# T01 — API CI Workflow

## End State

`.github/workflows/api-ci.yml` in `finance-manager-api` repo. Runs on every push and every PR targeting `main`. Executes `pytest` and checks for unapplied migrations. Failure blocks PR merge once branch protection is enabled (T04).

## Pre-flight (Cursor: read before writing)

1. Read `finance_manager_api/pytest.ini` or `pyproject.toml [tool.pytest.ini_options]` — what's the configured `testpaths`, `DJANGO_SETTINGS_MODULE`, and DB backend?
2. If `DJANGO_SETTINGS_MODULE` points to a settings file that uses Postgres, a `services: postgres:` container is required. If it uses SQLite for tests, skip the service container.
3. Check `finance_manager_api/requirements.txt` — confirm `pytest-django` is present. Note the Python version pinned.
4. Check if `manage.py migrate --check` exists (Django 3.1+) — use it for the migration check step.

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T01.SL1 | Workflow file | V1 |
| T01.SL2 | Migration check step | V1 |
| T01.SL3 | Verify first run | V1 |

## T01.SL1 — Workflow File

Create `.github/workflows/api-ci.yml`:

```yaml
name: API CI

on:
  push:
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    # Include this block ONLY if Postgres is required for tests.
    # Remove entirely if Django test settings use SQLite.
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test_db
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_password
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'   # match pinned version in requirements

      - name: Install dependencies
        run: pip install -r requirements.txt
        working-directory: finance_manager_api/

      - name: Run tests
        env:
          DJANGO_SETTINGS_MODULE: finance_api.settings
          SECRET_KEY: ci-test-secret-key-not-real
          DB_HOST: localhost          # remove if using SQLite
          DB_NAME: test_db            # remove if using SQLite
          DB_USER: test_user          # remove if using SQLite
          DB_PASSWORD: test_password  # remove if using SQLite
          DEBUG: 'True'
        run: pytest
        working-directory: finance_manager_api/
```

**Note on env vars:** Do not use repository secrets for CI test values — use hard-coded, obviously-fake values. Real secrets (SMTP, production DB) must never be in CI env.

**Acceptance criteria:**
- [V1] Workflow file parses (no YAML syntax errors — GitHub will show this immediately on push)
- [V1] `pytest` step completes (pass or fail is fine; the goal is "runs at all")

## T01.SL2 — Migration Check Step

Add this step AFTER the `Run tests` step:

```yaml
      - name: Check for missing migrations
        env:
          DJANGO_SETTINGS_MODULE: finance_api.settings
          SECRET_KEY: ci-test-secret-key-not-real
          DEBUG: 'True'
          # same DB env vars as above if needed
        run: python manage.py migrate --check
        working-directory: finance_manager_api/
```

`manage.py migrate --check` exits non-zero if there are unapplied migrations. This catches the common case where a model was changed but `makemigrations` was forgotten.

**Acceptance criteria:**
- [V1] Step runs and returns exit 0 on a clean migration state

## T01.SL3 — Verify First Run

After pushing the workflow file:
- Navigate to GitHub → `finance-manager-api` → Actions tab
- Confirm the `API CI` workflow appears and has run
- Capture a screenshot of a passing (or at minimum, running) workflow

**Acceptance criteria:**
- [V1] GitHub Actions tab shows `API CI` workflow with at least one completed run
- Evidence: `evidence/T01.SL3_api_ci_run.png`
