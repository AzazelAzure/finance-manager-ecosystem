# T03 — F-012 Real-Time Bug Report Notification

## End State
When a `SupportTicket` is saved (bug report or feature request), `notify_operator.delay()` fires within the same request cycle. The email arrives in Proton inbox within 60 seconds. The F-012 submission flow is not broken if the notify task fails.

## Acceptance Criteria
1. [V1] POST to bug report endpoint → Celery worker log shows `notify_operator` task received within 10s of submission
2. [V1] Email arrives in Proton inbox within 60s with correct `event_type` (`BUG_REPORT` or `FEATURE_REQUEST`) and severity mapped from the ticket's severity field
3. [V1] `Relevant-Files` in email body includes the F-013 per-user log path for the submitting user's UUID
4. [V1] If `notify_operator` fails (SMTP down), the bug report is still persisted and the POST returns 201 — submission never fails due to notify

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T03.SL1 | Wire dispatcher to SupportTicket post-save | V1 | Django signal or post-save hook on SupportTicket model; severity mapping; F-013 log path construction; end-to-end smoke test |

## Scope Lock

### Signal location
Add to `finance_manager/signals.py` (or existing signals file — match repo convention):

```python
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import SupportTicket  # adjust import to actual model path
from .tasks.notify import notify_operator, Severity
import logging

logger = logging.getLogger(__name__)

SEVERITY_MAP = {
    "critical": Severity.CRITICAL,
    "high": Severity.HIGH,
    "medium": Severity.MEDIUM,
    "low": Severity.LOW,
    "feature_request": Severity.INFO,
}

@receiver(post_save, sender=SupportTicket)
def on_support_ticket_created(sender, instance, created, **kwargs):
    if not created:
        return  # only fire on new submissions, not updates

    ticket_type = "BUG_REPORT" if instance.report_type == "bug" else "FEATURE_REQUEST"
    severity = SEVERITY_MAP.get(getattr(instance, "severity", "medium"), Severity.MEDIUM)
    
    user_ref = str(instance.user.profile.user_id)  # UUID — adjust to actual field path
    
    # F-013 per-user log path (adjust base path to match actual VPS log location)
    log_path = f"/var/log/fm_api/users/{user_ref}.log"
    
    file_paths = [log_path]
    notes = f"Ticket ID: {instance.pk} | Type: {ticket_type}"
    
    try:
        notify_operator.delay(
            event_type=ticket_type,
            severity=severity,
            user_ref=user_ref,
            file_paths=file_paths,
            notes=notes,
        )
    except Exception as exc:
        # Log but never let notify failure propagate to the submission response
        logger.error("Failed to enqueue notify_operator for ticket %s: %s", instance.pk, exc)
```

### Critical: verify actual field paths
Before writing the signal, grep the F-012 `SupportTicket` model for:
- The actual field name for `report_type` (may be `ticket_type`, `category`, etc.)
- The actual field name for `severity` (may be `priority`)
- The path from `instance.user` to the UUID field (may be `instance.user.profile.user_id` or `instance.user_id`)

Check: `grep -n "class SupportTicket" finance_manager_api/` to find the model, then read it.

### F-013 log path
The base path `/var/log/fm_api/users/{uuid}.log` is an assumption. Verify against the F-013 implementation — grep for the Loguru sink configuration in the API codebase:
```bash
grep -r "loguru\|sink\|user_id" finance_manager_api/ --include="*.py" -l
```
Use the actual path. If per-user log files are stored elsewhere, update accordingly.

### Register signal in AppConfig
Ensure the signal is registered in the app's `AppConfig.ready()`. Do not add duplicate signal registration if a signals file already exists and is wired.

## Evidence
- `evidence/T03.SL1_celery_task_log.txt` — worker log showing BUG_REPORT notify task
- `evidence/T03.SL1_inbox_bug_report.png` — [V1] Proton inbox showing received bug report notification

## Anti-Patterns
- Do NOT call `notify_operator()` synchronously (without `.delay()`) — it will block the request
- Do NOT pass `instance.user.email` or `instance.user.username` to `notify_operator` — UUID only
- Do NOT let signal exceptions propagate — always catch and log; submission must always succeed
- Do NOT fire on ticket updates (`if not created: return`) — only new submissions
