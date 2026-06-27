# T01 — Celery/Redis Verify + Django Email Backend

## End State
Redis is confirmed reachable from the API container. Celery worker and beat are defined and start cleanly. Django email backend is configured to route through Proton Bridge SMTP. A test email arrives in the Proton inbox.

## Acceptance Criteria
1. [V1] `redis-cli ping` from inside the API container returns PONG
2. [V1] Celery worker starts with `celery -A finance_manager worker --loglevel=info` (or compose service equivalent) without connection errors
3. [V1] `python manage.py sendtestemail {ADMIN_EMAIL}` succeeds and email is received in Proton inbox
4. [V1] `python manage.py check --deploy` passes with no errors

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Redis + Celery verify | V1 | Confirm Redis reachable; confirm Celery worker + beat services defined in docker-compose.yml; start services; no errors in logs |
| T01.SL2 | Email backend config | V1 | Add Proton Bridge SMTP settings to Django settings (from env vars only); `sendtestemail` round-trip passes |

## Scope Lock

### Redis verification
```bash
# Inside API container
redis-cli -u $REDIS_URL ping
# Expected: PONG
```
If `REDIS_URL` is not set, stop and ask HitM for the correct env var name.

### Celery services (docker-compose check)
Confirm `docker-compose.yml` contains both:
- `celery_worker` service: `command: celery -A {app_name} worker --loglevel=info`
- `celery_beat` service: `command: celery -A {app_name} beat --loglevel=info --scheduler django_celery_beat.schedulers:DatabaseScheduler`

If either is missing, add it. Use the same base image and env as the `api` service. Do not create a separate Dockerfile — use the existing API image with a different command.

### Django email backend (settings.py — env vars only)
```python
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = env("EMAIL_HOST", default="127.0.0.1")        # Proton Bridge SMTP host
EMAIL_PORT = env.int("EMAIL_PORT", default=1025)            # Proton Bridge default port
EMAIL_USE_TLS = env.bool("EMAIL_USE_TLS", default=True)
EMAIL_HOST_USER = env("EMAIL_HOST_USER")                    # Proton Bridge account
EMAIL_HOST_PASSWORD = env("EMAIL_HOST_PASSWORD")            # Proton Bridge SMTP password
DEFAULT_FROM_EMAIL = env("DEFAULT_FROM_EMAIL", default="Finance Manager <noreply@thehivemanager.com>")
```

**Never hardcode credentials. Never commit `.secrets/` files.**

### Test command
```bash
python manage.py sendtestemail {ADMIN_EMAIL}
```
Confirm email arrives in Proton inbox with correct from address before marking T01.SL2 PASS.

## Evidence
- `evidence/T01.SL1_redis_ping.txt` — output of `redis-cli ping`
- `evidence/T01.SL1_celery_start.txt` — Celery worker startup log (first 20 lines, no errors)
- `evidence/T01.SL2_sendtestemail.txt` — Django command output
- `evidence/T01.SL2_inbox_screenshot.png` — [V1] Proton inbox showing received test email

## Anti-Patterns
- Do NOT store SMTP credentials in settings.py directly — env vars only
- Do NOT use `django.core.mail.backends.console.EmailBackend` — must be real SMTP for this task
- Do NOT skip T01.SL1 before T01.SL2 — email backend is meaningless if Celery can't process tasks
