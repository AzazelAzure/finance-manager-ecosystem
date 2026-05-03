# T01 API Production Settings Hardening

## Objective
Make `finance_manager_api` safe to configure for a small server beta by fixing production-setting parsing and reducing `manage.py check --deploy` warnings to intentional, documented choices.

## Scope Boundary
- Repo: `finance_manager_api/`
- Branch: create a feature branch in the API repo before edits.
- Keep changes limited to settings/config, tests, changelog, and docs directly required by this task.

## Current Evidence
- Cloud command:
  - `SECRET_KEY='dev-check-secret-with-enough-length-1234567890abcdef' DEBUG=False ALLOWED_HOSTS='localhost,127.0.0.1' uv run python manage.py check --deploy`
- Observed issue:
  - Django still reports `security.W018` because `DEBUG = os.getenv("DEBUG", default=False)` stores raw strings; non-empty `"False"` is truthy.
- Additional deploy warnings observed:
  - `SECURE_HSTS_SECONDS` unset.
  - `SECURE_SSL_REDIRECT` unset.
  - `SESSION_COOKIE_SECURE` unset.
  - `CSRF_COOKIE_SECURE` unset.

## Implementation Notes
- Add a small environment boolean parser or reuse an existing helper if present.
- Apply it to `DEBUG` and any new deploy-hardening flags.
- Prefer explicit environment-driven settings for:
  - `SECURE_SSL_REDIRECT`
  - `SESSION_COOKIE_SECURE`
  - `CSRF_COOKIE_SECURE`
  - `SECURE_HSTS_SECONDS`
  - any public-beta host/origin settings if already modeled locally.
- Preserve developer defaults that keep local development usable.
- Do not hard-code production secrets or public beta hostnames.

## Acceptance Criteria
- `DEBUG=False` is false in Django settings.
- Deployment security warnings are either eliminated under beta env values or documented as intentionally proxy-owned.
- API changelog updated if behavior/config surface changes.
- No unrelated endpoint/schema behavior changes.

## Verification Commands
Run from `finance_manager_api/`:

```bash
SECRET_KEY='replace-with-long-local-test-secret-1234567890abcdef' \
DEBUG=False \
ALLOWED_HOSTS='localhost,127.0.0.1' \
SECURE_SSL_REDIRECT=True \
SESSION_COOKIE_SECURE=True \
CSRF_COOKIE_SECURE=True \
SECURE_HSTS_SECONDS=3600 \
uv run python manage.py check --deploy
```

Also run targeted settings tests if added, then the API test subset affected by config.

## Expected Handoff
Use `shared-subagent-handoff` format and include:
- Exact settings changed.
- Deploy-check output.
- Residual warnings, if any, with rationale.
- Branch/PR status.
