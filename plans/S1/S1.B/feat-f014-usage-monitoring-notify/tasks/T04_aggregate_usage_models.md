# T04 — Aggregate Usage Models + Daily Rollup

## End State
Two new Django models: `DailyUsageSnapshot` (daily DAU/MAU/active account counts) and `InviteChainEvent` (UUID-to-UUID invite graph). A Celery beat task runs at UTC 00:05 daily, writes one `DailyUsageSnapshot` row per day (idempotent on re-run). No PII in any model field — UUID references only.

## Acceptance Criteria
1. [V1] Migrations apply cleanly on a clean DB with no conflicts against existing migrations
2. [V1] Django admin site shows both `DailyUsageSnapshot` and `InviteChainEvent` with correct fields
3. [V1] Daily rollup Celery beat task fires at UTC 00:05 (verify via beat log); writes exactly one `DailyUsageSnapshot` per calendar date (re-running the task does not create duplicate rows)
4. [V1] `python manage.py check --deploy` passes after migrations

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T04.SL1 | Models + migrations | V1 | `DailyUsageSnapshot` and `InviteChainEvent` models; migrations; admin registration |
| T04.SL2 | Daily rollup Celery beat task | V1 | `rollup_daily_usage` task; Celery beat schedule entry; idempotency via `update_or_create` |

## Scope Lock

### Models

```python
# finance_manager/models/usage.py (create new file or add to existing models)
import uuid
from django.db import models

class DailyUsageSnapshot(models.Model):
    """Operator-only. No PII. Aggregate counts only."""
    date = models.DateField(unique=True, db_index=True)
    dau_count = models.PositiveIntegerField(default=0)      # distinct active UUIDs today
    mau_count = models.PositiveIntegerField(default=0)      # distinct active UUIDs last 30 days
    active_accounts = models.PositiveIntegerField(default=0) # total accounts with any activity
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-date"]
        verbose_name = "Daily Usage Snapshot"
        verbose_name_plural = "Daily Usage Snapshots"

    def __str__(self):
        return f"{self.date}: DAU={self.dau_count} MAU={self.mau_count}"


class InviteChainEvent(models.Model):
    """Tracks invite graph edges. No PII — UUID references only."""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    inviter_uuid = models.UUIDField(db_index=True)     # AppProfile UUID of inviter
    invitee_uuid = models.UUIDField(db_index=True)     # AppProfile UUID of new user
    invite_code = models.CharField(max_length=64, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = [("inviter_uuid", "invitee_uuid")]
        verbose_name = "Invite Chain Event"
        verbose_name_plural = "Invite Chain Events"
```

**If an invite system does not yet exist in the codebase:** Create `InviteChainEvent` model but leave it empty for now. Do not implement invite logic in this plan — that belongs to the invite feature when built. The model just needs to exist so F-014's threshold logic can query it.

### Daily rollup task

```python
# finance_manager/tasks/usage_rollup.py
from celery import shared_task
from django.utils import timezone
from datetime import timedelta
import logging

logger = logging.getLogger(__name__)

@shared_task
def rollup_daily_usage():
    from django.contrib.auth import get_user_model
    from ..models.usage import DailyUsageSnapshot
    # Import the activity log model from F-013 — adjust to actual model path
    # e.g., from ..models.logs import UserActivityLog
    
    today = timezone.now().date()
    thirty_days_ago = today - timedelta(days=30)
    
    # Adjust these queries to match the actual activity-tracking model from F-013.
    # The F-013 implementation uses Loguru disk files, not a DB model —
    # if there is no queryable activity table, use last_login on the User model as a proxy.
    User = get_user_model()
    
    # DAU: users who logged in today (proxy if no activity model)
    dau_qs = User.objects.filter(last_login__date=today)
    dau_count = dau_qs.count()
    
    # MAU: users who logged in in last 30 days
    mau_count = User.objects.filter(last_login__date__gte=thirty_days_ago).count()
    
    # Active accounts: any account with last_login set
    active_accounts = User.objects.filter(last_login__isnull=False).count()
    
    snapshot, created = DailyUsageSnapshot.objects.update_or_create(
        date=today,
        defaults={
            "dau_count": dau_count,
            "mau_count": mau_count,
            "active_accounts": active_accounts,
        }
    )
    
    action = "created" if created else "updated"
    logger.info("Daily usage rollup %s for %s: DAU=%d MAU=%d", action, today, dau_count, mau_count)
    
    return {"date": str(today), "dau": dau_count, "mau": mau_count, "active": active_accounts}
```

### Celery beat schedule
Add to Django settings (using `django-celery-beat` or hardcoded `CELERY_BEAT_SCHEDULE`):

```python
from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    **getattr(settings, "CELERY_BEAT_SCHEDULE", {}),  # preserve existing entries
    "rollup-daily-usage": {
        "task": "finance_manager.tasks.usage_rollup.rollup_daily_usage",
        "schedule": crontab(hour=0, minute=5),  # UTC 00:05 daily
    },
}
```

### Admin registration
```python
from django.contrib import admin
from .models.usage import DailyUsageSnapshot, InviteChainEvent

@admin.register(DailyUsageSnapshot)
class DailyUsageSnapshotAdmin(admin.ModelAdmin):
    list_display = ["date", "dau_count", "mau_count", "active_accounts", "updated_at"]
    readonly_fields = ["created_at", "updated_at"]
    ordering = ["-date"]

@admin.register(InviteChainEvent)
class InviteChainEventAdmin(admin.ModelAdmin):
    list_display = ["inviter_uuid", "invitee_uuid", "invite_code", "created_at"]
    readonly_fields = ["id", "created_at"]
```

## Evidence
- `evidence/T04.SL1_migration_apply.txt` — output of `python manage.py migrate`
- `evidence/T04.SL1_admin_screenshot.png` — [V1] Django admin showing both models
- `evidence/T04.SL2_beat_log.txt` — Celery beat log showing `rollup-daily-usage` task fired
- `evidence/T04.SL2_snapshot_row.txt` — output of `DailyUsageSnapshot.objects.all()` showing one row

## Anti-Patterns
- Do NOT store username, email, full name, or IP in any field of these models — UUID and counts only
- Do NOT use `get_or_create` without `update_or_create` — rollup must overwrite stale values
- Do NOT create a new `ActivityLog` DB model if F-013 uses disk files — use `last_login` as the proxy (accurate enough for DAU/MAU at single-digit to early double-digit scale)
- Do NOT add user-facing views or API endpoints for usage data — this is ops-only
