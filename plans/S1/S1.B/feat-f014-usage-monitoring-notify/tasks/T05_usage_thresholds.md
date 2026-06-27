# T05 — Usage Threshold Alerts

## End State
The daily rollup task checks DAU against configurable thresholds. When a threshold is crossed for the first time, `notify_operator` fires with `event_type=DAU_THRESHOLD_CROSSED`. The alert does not re-fire within a 24-hour window for the same threshold level.

## Acceptance Criteria
1. [V1] Seeding `DailyUsageSnapshot` with a DAU count that crosses a threshold triggers `notify_operator.delay()` call in the rollup task
2. [V1] Running the rollup again within 24h with the same DAU count does NOT send a second alert for the same threshold
3. [V1] Email arrives in Proton inbox with `event_type=DAU_THRESHOLD_CROSSED`, correct threshold value in Notes, no PII

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T05.SL1 | Threshold check in rollup + dedup guard | V1 | Add threshold check to `rollup_daily_usage`; `ThresholdAlert` model or Django cache key for dedup; end-to-end test |

## Scope Lock

### Threshold levels
Defined in settings, overridable per deployment:

```python
DAU_ALERT_THRESHOLDS = env.list("DAU_ALERT_THRESHOLDS", default=["10", "50", "100", "250", "500"])
DAU_ALERT_THRESHOLDS = [int(t) for t in DAU_ALERT_THRESHOLDS]
```

### Deduplication
Use Django's cache framework (already in stack if Redis is available — use Redis cache backend):

```python
from django.core.cache import cache

def check_and_alert_thresholds(dau_count: int) -> None:
    from django.conf import settings
    from .notify import notify_operator, Severity
    
    thresholds = getattr(settings, "DAU_ALERT_THRESHOLDS", [10, 50, 100, 250, 500])
    
    for threshold in thresholds:
        if dau_count >= threshold:
            cache_key = f"dau_threshold_alerted_{threshold}"
            if not cache.get(cache_key):
                notify_operator.delay(
                    event_type="DAU_THRESHOLD_CROSSED",
                    severity=Severity.INFO,
                    user_ref="system",  # no user ref for aggregate events
                    file_paths=[],
                    notes=f"DAU reached {dau_count} (threshold: {threshold})",
                )
                # Suppress re-alert for 23 hours
                cache.set(cache_key, True, timeout=60 * 60 * 23)
```

Add `check_and_alert_thresholds(dau_count)` call at the end of `rollup_daily_usage`, after the `update_or_create`.

### Cache backend note
If Django cache is currently `LocMemCache` (default), switch to Redis cache backend for persistence across worker restarts:

```python
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": env("REDIS_URL"),
    }
}
```

Only switch if not already using Redis cache. Do not change cache config if it's already set.

### Unit test
Mock `notify_operator.delay` and `cache.get`/`cache.set`. Assert:
- First call with DAU=10 → `notify_operator.delay` called once
- Second call with DAU=10 (same threshold) → `notify_operator.delay` NOT called (cache hit)
- Call with DAU=50 → `notify_operator.delay` called for threshold=50 only

## Evidence
- `evidence/T05.SL1_unit_test_output.txt` — pytest output for threshold test
- `evidence/T05.SL1_inbox_threshold_alert.png` — [V1] Proton inbox showing DAU_THRESHOLD_CROSSED email

## Anti-Patterns
- Do NOT alert on every rollup — once per threshold crossing, 23h dedup window
- Do NOT use `user_ref` for aggregate system events — pass `"system"` as the value
- Do NOT hardcode threshold values — pull from settings so they can be adjusted without a deploy
- Do NOT create a separate Celery beat task for threshold checking — run it inside `rollup_daily_usage` after the snapshot write
