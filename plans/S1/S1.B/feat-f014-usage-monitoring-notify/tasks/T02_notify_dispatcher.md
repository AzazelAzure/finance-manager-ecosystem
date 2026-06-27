# T02 — Notify Operator Dispatcher (Celery Task)

## End State
A reusable `notify_operator` Celery task exists. Any Django code can call `notify_operator.delay(...)` to fire an async email notification. The email arrives in Proton inbox with the `[FM-NOTIFY]` subject prefix and a structured plain-text body matching the §3 contract in the plan README. No PII in any field.

## Acceptance Criteria
1. [V1] `notify_operator.delay(event_type="TEST", severity="info", user_ref="uuid-test-000", file_paths=[], notes="smoke test")` enqueues and Celery worker processes it within 30s
2. [V1] Email received in Proton inbox with subject `[FM-NOTIFY] TEST | SEV:info | {timestamp}`
3. [V1] Body contains `User-Ref: uuid-test-000` and no username, email address, or other PII
4. [V1] If SMTP fails (wrong credentials, bridge down), task logs error to Django logger and does NOT raise — calling code must not break

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | Celery task definition + format | V1 | `notify_operator` task in `finance_manager/tasks/notify.py`; formats email body per contract; unit test for body format (no live send) |
| T02.SL2 | Live send + error handling | V1 | Wire to Django email backend; live end-to-end smoke test; exception catch with logger.error (never re-raise) |

## Scope Lock

### Module location
Create `finance_manager/tasks/notify.py` (or the equivalent app-level tasks path — match existing Celery task convention in the repo).

### Task signature
```python
from celery import shared_task
from django.core import mail
from django.conf import settings
import logging
from datetime import datetime, timezone

logger = logging.getLogger(__name__)

@shared_task(bind=True, max_retries=2, default_retry_delay=60)
def notify_operator(self, event_type: str, severity: str, user_ref: str,
                    file_paths: list[str], notes: str = "") -> None:
    """
    Sends a structured [FM-NOTIFY] email to OPERATOR_EMAIL.
    Zero PII — user_ref must be a UUID string, never a username or email.
    """
    timestamp = datetime.now(timezone.utc).isoformat()
    subject = f"[FM-NOTIFY] {event_type} | SEV:{severity} | {timestamp}"
    
    file_list = "\n".join(f"  - {p}" for p in file_paths) if file_paths else "  (none)"
    body = (
        f"Event: {event_type}\n"
        f"Severity: {severity}\n"
        f"Timestamp: {timestamp}\n"
        f"User-Ref: {user_ref}\n"
        f"Relevant-Files:\n{file_list}\n"
        f"Notes: {notes}\n"
        f"---\n"
        f"Sent by finance_manager_api Celery notify worker.\n"
        f"No PII. User-Ref is pseudonymous UUID only.\n"
    )
    
    try:
        mail.send_mail(
            subject=subject,
            message=body,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[settings.OPERATOR_EMAIL],
            fail_silently=False,
        )
    except Exception as exc:
        logger.error("notify_operator failed: %s | event=%s severity=%s", exc, event_type, severity)
        # Do not re-raise — callers must not fail because notify failed
```

### Settings addition
```python
OPERATOR_EMAIL = env("OPERATOR_EMAIL")  # HitM's email address — env var only
```

### Severity constants (define in same module)
```python
class Severity:
    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    INFO = "info"
```

### Unit test (no live send)
Mock `mail.send_mail` and assert:
- Subject contains `[FM-NOTIFY]`
- Body contains `User-Ref: uuid-test-000`
- Body does NOT contain any `@` character (email address guard)
- Body does NOT contain the word "username"

## Evidence
- `evidence/T02.SL1_unit_test_output.txt` — pytest output for body format test
- `evidence/T02.SL2_celery_worker_log.txt` — worker log showing task received + processed
- `evidence/T02.SL2_inbox_notify.png` — [V1] Proton inbox screenshot showing [FM-NOTIFY] email

## Anti-Patterns
- Do NOT pass username, email address, full name, or IP address as `user_ref` — UUID only
- Do NOT use `fail_silently=True` — log the error so failures are visible in worker logs
- Do NOT raise exceptions from this task that would propagate to the caller — this is fire-and-forget
- Do NOT use `send_mail` synchronously in a Django view — always call `.delay()` from task site
