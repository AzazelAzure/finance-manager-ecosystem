# T03 — Celery Analytics Aggregation → Flat Files

## End State
A Celery beat task runs hourly, reads `fm_metrics:*` Redis keys, and appends aggregated lines to `/var/log/fm_api/analytics/metrics_{date}.jsonl`. A daily rollup task writes `daily_{date}.json` (including DAU/MAU from F-014). A weekly summary `weekly_{YYYY-WW}.json` is written Monday 00:10 UTC. These files are the handoff surface for Antigravity's weekly operator report.

## Acceptance Criteria
1. [V1] After hourly task fires: `metrics_{date}.jsonl` exists and contains at least one line with correct JSON structure
2. [V1] Re-running the hourly task does not produce duplicate lines for the same hour window
3. [V1] `daily_{date}.json` is written at midnight rollup; contains `dau`, `mau` fields from F-014 `DailyUsageSnapshot`
4. [V1] `weekly_{YYYY-WW}.json` exists after Monday 00:10 UTC; aggregates 7 daily files
5. [V1] No PII in any output file — grep for `@` character and raw IP patterns

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T03.SL1 | Hourly metric rollup → JSONL | V1 | Read `fm_metrics:*` Redis keys; write to metrics JSONL; consume keys after write |
| T03.SL2 | Daily + weekly summary JSON | V1 | Midnight daily rollup (includes F-014 DAU/MAU); Monday weekly summary |

## Scope Lock

### Output directory
```bash
# Ensure directory exists with correct permissions (add to docker-compose or entrypoint)
mkdir -p /var/log/fm_api/analytics
```
Confirm this path is on a volume accessible to the `api` and `celery_worker` containers. If not, adjust path and update docker-compose volume mounts.

### Celery tasks (`finance_manager/tasks/analytics.py`)

```python
from celery import shared_task
from datetime import datetime, timezone, timedelta
import json
import os
import logging

logger = logging.getLogger(__name__)
ANALYTICS_DIR = os.getenv('ANALYTICS_LOG_DIR', '/var/log/fm_api/analytics')

@shared_task
def rollup_metrics_hourly():
    """Read fm_metrics:* Redis keys, append to daily JSONL, consume keys."""
    from django.core.cache import cache
    redis = cache.client.get_client()

    date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
    hour_str = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:00:00Z')
    pattern = f"fm_metrics:{date_str}:*"

    keys = redis.keys(pattern)
    if not keys:
        logger.info("rollup_metrics_hourly: no keys for %s", date_str)
        return

    output_path = os.path.join(ANALYTICS_DIR, f"metrics_{date_str}.jsonl")
    os.makedirs(ANALYTICS_DIR, exist_ok=True)

    lines_written = 0
    with open(output_path, 'a') as f:
        for key in keys:
            key_str = key.decode() if isinstance(key, bytes) else key
            parts = key_str.split(':')
            # key format: fm_metrics:{date}:{endpoint}:{method}:{response_class}:{ua_class}
            if len(parts) < 6:
                continue
            _, date, endpoint, method, response_class, ua_class = parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]
            count = int(redis.get(key) or 0)
            if count > 0:
                line = json.dumps({
                    "ts": hour_str,
                    "endpoint": endpoint,
                    "method": method,
                    "response_class": response_class,
                    "ua_class": ua_class,
                    "count": count,
                })
                f.write(line + '\n')
                lines_written += 1
            redis.delete(key)  # consume after writing

    logger.info("rollup_metrics_hourly: wrote %d lines to %s", lines_written, output_path)


@shared_task
def rollup_daily():
    """Aggregate yesterday's JSONL into a daily summary JSON with DAU/MAU from F-014."""
    from ..models.usage import DailyUsageSnapshot

    yesterday = (datetime.now(timezone.utc) - timedelta(days=1)).strftime('%Y-%m-%d')
    metrics_path = os.path.join(ANALYTICS_DIR, f"metrics_{yesterday}.jsonl")
    daily_path = os.path.join(ANALYTICS_DIR, f"daily_{yesterday}.json")

    if os.path.exists(daily_path):
        logger.info("rollup_daily: %s already exists, skipping", daily_path)
        return

    totals = {"total_requests": 0, "by_ua_class": {}, "by_response_class": {}, "top_endpoints": {}}

    if os.path.exists(metrics_path):
        with open(metrics_path) as f:
            for line in f:
                try:
                    row = json.loads(line)
                    totals["total_requests"] += row["count"]
                    totals["by_ua_class"][row["ua_class"]] = totals["by_ua_class"].get(row["ua_class"], 0) + row["count"]
                    totals["by_response_class"][row["response_class"]] = totals["by_response_class"].get(row["response_class"], 0) + row["count"]
                    totals["top_endpoints"][row["endpoint"]] = totals["top_endpoints"].get(row["endpoint"], 0) + row["count"]
                except (json.JSONDecodeError, KeyError):
                    continue

    # Top 10 endpoints by count
    top_endpoints = sorted(totals["top_endpoints"].items(), key=lambda x: x[1], reverse=True)[:10]

    # DAU/MAU from F-014
    try:
        snapshot = DailyUsageSnapshot.objects.get(date=yesterday)
        dau, mau = snapshot.dau_count, snapshot.mau_count
    except DailyUsageSnapshot.DoesNotExist:
        dau, mau = 0, 0

    summary = {
        "date": yesterday,
        "total_requests": totals["total_requests"],
        "by_ua_class": totals["by_ua_class"],
        "by_response_class": totals["by_response_class"],
        "top_endpoints": [{"endpoint": e, "count": c} for e, c in top_endpoints],
        "dau": dau,
        "mau": mau,
    }

    with open(daily_path, 'w') as f:
        json.dump(summary, f, indent=2)

    logger.info("rollup_daily: wrote %s", daily_path)


@shared_task
def rollup_weekly():
    """Aggregate the past 7 daily summaries into a weekly JSON. Runs Monday 00:10 UTC."""
    today = datetime.now(timezone.utc).date()
    week_str = today.strftime('%Y-W%W')
    weekly_path = os.path.join(ANALYTICS_DIR, f"weekly_{week_str}.json")

    if os.path.exists(weekly_path):
        logger.info("rollup_weekly: %s already exists, skipping", weekly_path)
        return

    days = [(today - timedelta(days=i)).strftime('%Y-%m-%d') for i in range(1, 8)]
    daily_summaries = []

    for day in days:
        path = os.path.join(ANALYTICS_DIR, f"daily_{day}.json")
        if os.path.exists(path):
            with open(path) as f:
                try:
                    daily_summaries.append(json.load(f))
                except json.JSONDecodeError:
                    pass

    if not daily_summaries:
        logger.warning("rollup_weekly: no daily files found for week %s", week_str)
        return

    total_requests = sum(d.get("total_requests", 0) for d in daily_summaries)
    avg_dau = sum(d.get("dau", 0) for d in daily_summaries) // len(daily_summaries)
    peak_dau = max(d.get("dau", 0) for d in daily_summaries)

    weekly = {
        "week": week_str,
        "days_covered": [d["date"] for d in daily_summaries],
        "total_requests": total_requests,
        "avg_dau": avg_dau,
        "peak_dau": peak_dau,
        "daily_summaries": daily_summaries,
    }

    with open(weekly_path, 'w') as f:
        json.dump(weekly, f, indent=2)

    logger.info("rollup_weekly: wrote %s", weekly_path)
```

### Celery beat schedule additions
```python
CELERY_BEAT_SCHEDULE = {
    **getattr(settings, 'CELERY_BEAT_SCHEDULE', {}),
    "rollup-metrics-hourly": {
        "task": "finance_manager.tasks.analytics.rollup_metrics_hourly",
        "schedule": crontab(minute=5),  # 5 minutes past every hour
    },
    "rollup-daily": {
        "task": "finance_manager.tasks.analytics.rollup_daily",
        "schedule": crontab(hour=0, minute=10),  # UTC 00:10 daily (after F-014 rollup at 00:05)
    },
    "rollup-weekly": {
        "task": "finance_manager.tasks.analytics.rollup_weekly",
        "schedule": crontab(day_of_week=1, hour=0, minute=10),  # Monday 00:10 UTC
    },
}
```

### Settings addition
```python
ANALYTICS_LOG_DIR = env('ANALYTICS_LOG_DIR', default='/var/log/fm_api/analytics')
```

## Evidence
- `evidence/T03.SL1_metrics_jsonl_sample.txt` — first 5 lines of a metrics JSONL file
- `evidence/T03.SL2_daily_json_sample.json` — full daily summary JSON
- `evidence/T03.SL2_weekly_json_sample.json` — weekly summary JSON

## Anti-Patterns
- Do NOT read F-013 Loguru files (`/var/log/fm_api/users/`) — those are diagnostic, not analytics
- Do NOT leave Redis keys unconsumed — `redis.delete(key)` after writing to JSONL
- Do NOT write DAU/MAU by re-querying User model here — read from F-014 `DailyUsageSnapshot` only
- Do NOT store ip_hash in output files — it's for security correlation only (T04), not analytics reports
