# T02 — Celery Task + Wiring

## Context

`notify.py` already has an operator notification Celery task. This adds a user-facing confirmation task with a 5-minute cooldown per user per submission type. The cooldown uses the existing `SupportTicket.created_at` field — no model changes needed.

## End State

- `send_user_support_confirmation` Celery task in `notify.py`
- Task is queued after successful ticket creation; cooldown prevents duplicate confirmations within 5 minutes
- Operator notification is unchanged

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T02.SL1 | Celery confirmation task | V1 |
| T02.SL2 | Cooldown logic | V1 |
| T02.SL3 | Wire to support view/signal | V1, V2 |

## T02.SL1 — Celery Confirmation Task

Add to `finance/api_tools/notify.py` (or a new `finance/api_tools/support_notify.py` if the file is getting large):

```python
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.contrib.auth.models import User
from celery import shared_task

@shared_task(bind=True, max_retries=2, default_retry_delay=30)
def send_user_support_confirmation(self, user_id: int, ticket_type: str, nature: str) -> None:
    """
    Send a confirmation email to the user after a support ticket is created.
    ticket_type: "BUG" or "FEATURE"
    """
    try:
        user = User.objects.get(pk=user_id)
    except User.DoesNotExist:
        return  # User deleted between submission and task execution; drop silently

    if not user.email:
        return  # No email on file; skip

    template_prefix = "bug_report_received" if ticket_type == "BUG" else "feature_request_received"
    context = {"username": user.username, "nature": nature}

    subject = render_to_string(f"email/{template_prefix}_subject.txt", context).strip()
    body = render_to_string(f"email/{template_prefix}_body.txt", context)

    try:
        send_mail(
            subject=subject,
            message=body,
            from_email="support@thehivemanager.com",
            recipient_list=[user.email],
            fail_silently=False,
        )
    except Exception as exc:
        raise self.retry(exc=exc)
```

**Acceptance criteria:**
- [V1] Task imports without errors; `celery inspect registered` shows the task
- [V1] `User.DoesNotExist` and missing email cases handled silently

## T02.SL2 — Cooldown Logic

The cooldown check runs in the VIEW (not in the Celery task) — before queuing. This prevents duplicate tasks from being enqueued:

```python
from datetime import timedelta
from django.utils import timezone
from finance.models import SupportTicket

def _should_send_confirmation(user_uuid: str, ticket_type: str) -> bool:
    """Return True if no confirmation has been sent in the last 5 minutes."""
    cutoff = timezone.now() - timedelta(minutes=5)
    recent_count = SupportTicket.objects.filter(
        uid=user_uuid,
        report_type=ticket_type,
        created_at__gte=cutoff,
    ).count()
    # If this is the FIRST ticket in the window (count == 1 after creation), send.
    # If there are already others (count > 1), skip the confirmation email.
    return recent_count <= 1
```

**Important:** The cooldown check runs AFTER the ticket is saved. So `count == 1` means only the current ticket exists in the window — send confirmation. `count > 1` means the user already submitted recently — skip the duplicate confirmation.

**Acceptance criteria:**
- [V1] Helper function is unit-testable; add a test: create 2 tickets within 5min for same user/type → second check returns False

## T02.SL3 — Wire to Support View

Locate where `SupportTicket` is created (likely in `finance/api_tools/` views or `finance/views.py`). After the ticket is successfully saved:

```python
# After ticket.save():
if _should_send_confirmation(str(user.appprofile.user_id), ticket.report_type):
    send_user_support_confirmation.delay(
        user_id=request.user.id,
        ticket_type=ticket.report_type,
        nature=ticket.nature,
    )
# Operator notification (existing) — unchanged, fires every time:
# send_operator_notification.delay(...)
```

**Clarification required if:** the ticket creation is in a signal. In that case, the `request.user` is not available in the signal context. Pass `user_id` as a model field or use the `uid` on SupportTicket to look up the User. Ask HitM if unclear.

**Acceptance criteria:**
- [V1] Existing support tests still pass
- [V1] New test: submit bug report → `send_user_support_confirmation` task queued; submit again within 5min → task NOT queued; submit after 5min → task queued again
- [V2] VPS smoke: bug report submitted → Proton inbox (user test account) receives confirmation within ~60s
- [V2] VPS smoke: feature request submitted → Proton inbox receives correct feature request confirmation

## Evidence

- `evidence/T02.SL1_task_registered.txt` — `celery inspect registered` output showing the task
- `evidence/T02.SL3_test_pass.txt` — pytest output for cooldown tests
- `evidence/T02.SL3_proton_confirmation.png` — screenshot of confirmation email received in Proton
