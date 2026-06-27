# T04 — Security Alert Task (Probe Detection)

## End State
A Celery beat task runs every 15 minutes, reads `fm_security:*` Redis keys, and fires `notify_operator` when probe thresholds are crossed. Dedup prevents alert flooding. This is the only place where security Redis counters drive operator action — the analytics files (T03) are for reporting, not alerting.

## Acceptance Criteria
1. [V1] Seeding Redis with >10 auth_failure keys for one ip_hash in one hour window triggers `notify_operator.delay()` with `event_type=SECURITY_PROBE_DETECTED`
2. [V1] Second threshold check within 2h for the same ip_hash + event_type does NOT fire a second alert (dedup via cache key)
3. [V1] 5xx rate check: if >5% of last-hour requests are 5xx, alert fires
4. [V1] `python manage.py check --deploy` passes after task is registered

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T04.SL1 | Probe threshold checks + dedup | V1 | Per-ip_hash auth failure + invalid endpoint thresholds; 5xx rate check; dedup; notify_operator |

## Scope Lock

### Thresholds (configurable via settings)
```python
SECURITY_ALERT_THRESHOLDS = {
    'auth_failure': env.int('SEC_THRESHOLD_AUTH_FAILURE', default=10),       # per ip_hash per hour
    'invalid_endpoint': env.int('SEC_THRESHOLD_INVALID_ENDPOINT', default=20), # per ip_hash per hour
    '5xx_rate_pct': env.int('SEC_THRESHOLD_5XX_RATE_PCT', default=5),         # % of total requests in hour
}
SECURITY_ALERT_DEDUP_TTL = 7200  # 2 hours
```

### Task (`finance_manager/tasks/security_alerts.py`)
```python
from celery import shared_task
from django.core.cache import cache
from .notify import notify_operator, Severity
import logging

logger = logging.getLogger(__name__)

@shared_task
def check_security_thresholds():
    from django.conf import settings
    from datetime import datetime, timezone

    redis = cache.client.get_client()
    thresholds = getattr(settings, 'SECURITY_ALERT_THRESHOLDS', {
        'auth_failure': 10,
        'invalid_endpoint': 20,
        '5xx_rate_pct': 5,
    })
    dedup_ttl = getattr(settings, 'SECURITY_ALERT_DEDUP_TTL', 7200)
    hour_str = datetime.now(timezone.utc).strftime('%Y-%m-%d-%H')

    # --- Per-ip_hash threshold checks ---
    for event_type, threshold in [
        ('auth_failure', thresholds['auth_failure']),
        ('invalid_endpoint', thresholds['invalid_endpoint']),
    ]:
        pattern = f"fm_security:{hour_str}:*:{event_type}"
        keys = redis.keys(pattern)
        for key in keys:
            count = int(redis.get(key) or 0)
            if count >= threshold:
                key_str = key.decode() if isinstance(key, bytes) else key
                ip_hash = key_str.split(':')[2]
                dedup_key = f"sec_alert_sent:{event_type}:{ip_hash}"
                if not cache.get(dedup_key):
                    notify_operator.delay(
                        event_type="SECURITY_PROBE_DETECTED",
                        severity=Severity.HIGH,
                        user_ref="system",
                        file_paths=[],
                        notes=f"{event_type} threshold crossed: {count} events from ip_hash={ip_hash} in current hour",
                    )
                    cache.set(dedup_key, True, timeout=dedup_ttl)
                    logger.warning("Security alert fired: %s ip_hash=%s count=%d", event_type, ip_hash, count)

    # --- 5xx rate check (aggregate, not per ip_hash) ---
    _check_5xx_rate(redis, hour_str, thresholds['5xx_rate_pct'], dedup_ttl)


def _check_5xx_rate(redis, hour_str, threshold_pct: int, dedup_ttl: int):
    from datetime import datetime, timezone
    date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
    all_keys = redis.keys(f"fm_metrics:{date_str}:*")

    total = 0
    errors = 0
    for key in all_keys:
        key_str = key.decode() if isinstance(key, bytes) else key
        parts = key_str.split(':')
        if len(parts) < 5:
            continue
        response_class = parts[4]
        count = int(redis.get(key) or 0)
        total += count
        if response_class == '5xx':
            errors += count

    if total > 0:
        rate_pct = (errors / total) * 100
        if rate_pct >= threshold_pct:
            dedup_key = f"sec_alert_sent:5xx_rate:{date_str}"
            if not cache.get(dedup_key):
                notify_operator.delay(
                    event_type="SECURITY_PROBE_DETECTED",
                    severity=Severity.HIGH,
                    user_ref="system",
                    file_paths=[],
                    notes=f"5xx error rate {rate_pct:.1f}% exceeds threshold {threshold_pct}% ({errors}/{total} requests today)",
                )
                cache.set(dedup_key, True, timeout=3600)
```

### Beat schedule addition
```python
"check-security-thresholds": {
    "task": "finance_manager.tasks.security_alerts.check_security_thresholds",
    "schedule": crontab(minute='*/15'),  # every 15 minutes
},
```

### Unit test
Mock `notify_operator.delay` and `cache.get`/`cache.set`. Assert:
- Redis with 11 auth_failure entries for one ip_hash → alert fires once
- Second call within dedup window → alert does NOT fire again
- 5xx rate at 6% (threshold 5%) → alert fires
- 5xx rate at 4% → no alert

## Evidence
- `evidence/T04.SL1_unit_test_output.txt` — pytest output
- `evidence/T04.SL1_notify_log.txt` — worker log showing SECURITY_PROBE_DETECTED task fired during manual seed test

## Anti-Patterns
- Do NOT log the ip_hash value in alert Notes in a way that enables reverse lookup — it's already a one-way hash, using it in notes for correlation is fine, but don't include the original IP (you don't have it anyway)
- Do NOT alert on every 15-min check — dedup is mandatory
- Do NOT check F-013 Loguru files here — security signal comes from Redis counters only
