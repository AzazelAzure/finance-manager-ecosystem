---
plan_id: PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26
status: in_progress
priority: P1
created: 2026-06-26
updated: 2026-06-27
owner: pproctor

plan_root: plans/S1/S1.B/feat-celery-observability/
intended_branch: cur/s1b/feat/celery-observability
target_repos:
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on:
  - PLAN_CROSS_USAGE_MONITORING_NOTIFY_2026-06-26
blocks:
  - privacy policy plan (TBD — S1.B exit gate; §8 of this plan defines what must be disclosed)
parallel_safe_with:
  - PLAN_CROSS_UI_UX_DESIGN_SYSTEM_2026-06-26
  - PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26
conflicts_with: []

manual_gates:
  pre_execution: required
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, celery_worker, celery_beat]
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - Bug report submission → email FROM bugreport@thehivemanager.com
    - Feature request submission → email FROM featurerequest@thehivemanager.com
    - System notify → email FROM noreply@thehivemanager.com
    - Request to invalid endpoint → Redis security counter incremented; no PII in key
    - Celery aggregation task fires → JSON file written to /var/log/fm_api/analytics/
    - Probe threshold crossed → notify_operator email sent
  notes: >-
    Proton Bridge SMTP token must authorize FROM-header swap to bugreport@ and
    featurerequest@. Executor must verify T01 before proceeding — stop and ask
    HitM if Bridge rejects either address.
    Redis is the middleware write target (atomic INCR, no file locking). Celery
    reads Redis and rolls up to flat JSON files. F-013 Loguru files are NOT
    touched by this plan.
    Antigravity owns the weekly report generation (local side) — not in scope here.

standalone: true
standalone_notes: ""
---

## 0) Strategic Inheritance

- **Wedge respected:** yes — security visibility and traffic analytics protect the trust/privacy brand position; analytics data never leaves the VPS except via operator-controlled pulls
- **Locked decisions touched:** no third-party analytics; UUID-only for user references; F-013 Loguru files are strictly read-only for this plan (separate diagnostic system)
- **Cost cap impact:** zero new SaaS — Redis is already in the stack; analytics files live on existing VPS storage
- **Validation gates affected:** this plan is a prerequisite for the privacy policy S1.B exit gate — §8 defines what is collected and must be disclosed

## 1) Objective

Three deliverables:

1. **Email FROM routing:** `notify_operator` sends FROM the correct domain alias per event type (`bugreport@`, `featurerequest@`, `noreply@`). The existing Proton Bridge SMTP token is expected to cover all domain aliases.

2. **PII-safe observability layer:** Django middleware increments Redis counters per request (endpoint family, method, response class, user agent class, auth failure flag). Near-zero per-request overhead — no DB writes, no file writes in the hot path. Redis is already in the stack.

3. **Celery analytics aggregation:** Hourly Celery task reads Redis counters and rolls them up to flat JSON files at `/var/log/fm_api/analytics/` on the VPS. Separate security alert task checks probe thresholds and fires `notify_operator` when crossed. **Antigravity pulls these files weekly and generates the operator report — that reporting layer is outside this plan's scope.**

**What this plan does NOT do:**
- Weekly analytics digest email — replaced by Antigravity local report
- Touch F-013 Loguru per-user diagnostic files
- Write to DB on every request (Redis only in hot path)

**Pre-execution gate (required):**
- T01 Proton Bridge FROM verification must pass before any other task starts
- Redis reachable from API container (confirmed in F-014 T01 — verify still true)
- `/var/log/fm_api/analytics/` directory exists and is writable by the API container

## 2) Scope

### In scope
- FROM address routing per event type in `notify_operator` (T01)
- Django request logging middleware — Redis INCR counters only, no hot-path DB writes (T02)
- Celery hourly aggregation → `/var/log/fm_api/analytics/metrics_{date}.jsonl` (T03)
- Celery security alert task — probe threshold detection → `notify_operator` (T04)

### Out of scope
- Weekly analytics report generation — Antigravity responsibility (local side, reads VPS files)
- F-013 Loguru per-user diagnostic files — do not read, write, or reference
- Privacy policy / ToS / cookie consent documents — separate governance plan; §8 is the input spec
- Cloudflare integration — see `strategy/research/S1.B/cloudflare-integration/` (separate research)
- User-facing analytics or usage dashboards
- Raw IP storage of any kind

## 3) Email FROM Routing Contract

| Event type | FROM address |
|---|---|
| `BUG_REPORT` | `bugreport@thehivemanager.com` |
| `FEATURE_REQUEST` | `featurerequest@thehivemanager.com` |
| `DAU_THRESHOLD_CROSSED` | `noreply@thehivemanager.com` |
| `SECURITY_PROBE_DETECTED` | `noreply@thehivemanager.com` |
| `CELERY_TASK_FAILURE` | `noreply@thehivemanager.com` |
| All others / default | `noreply@thehivemanager.com` |

`support@thehivemanager.com` — reserved for future customer-facing outbound. **Do not use in this plan.**

## 4) Redis Counter Schema

Middleware increments these Redis keys atomically. No raw PII in any key.

```
# Traffic metrics — rolled up hourly by Celery
fm_metrics:{YYYY-MM-DD}:{endpoint_family}:{method}:{response_class}:{ua_class}
  e.g. fm_metrics:2026-06-26:/api/transactions/:POST:2xx:user

# Security events — checked every 15 min by Celery alert task
fm_security:{YYYY-MM-DD-HH}:{ip_hash}:{event_type}
  e.g. fm_security:2026-06-26-14:{sha256_hash}:auth_failure
  e.g. fm_security:2026-06-26-14:{sha256_hash}:invalid_endpoint
```

**IP hash:** `SHA256(settings.LOG_IP_HASH_SALT + raw_ip)` — salted, one-way, never recoverable. Salt stored as env var `LOG_IP_HASH_SALT`.

**Endpoint family normalization** (strip IDs from paths):
```python
import re
def normalize_endpoint(path: str) -> str:
    # Replace UUIDs, numeric IDs, and slugs with placeholders
    path = re.sub(r'[0-9a-f-]{32,}', '{uuid}', path)
    path = re.sub(r'/\d+/', '/{id}/', path)
    return path.rstrip('/') + '/'
```

**User agent classification** (classify at request time, never store raw string):
```python
def classify_ua(ua: str) -> str:
    ua_lower = ua.lower()
    if any(x in ua_lower for x in ['googlebot', 'bingbot', 'twitterbot', 'facebookexternalhit']):
        return 'crawler'
    if any(x in ua_lower for x in ['curl', 'python-requests', 'go-http', 'semrush', 'ahrefs', 'scrapy']):
        return 'bot'
    if any(x in ua_lower for x in ['mozilla', 'chrome', 'safari', 'firefox']):
        return 'user'
    return 'unknown'
```

## 5) Analytics File Output Schema

Celery writes these files. Antigravity reads them.

```
/var/log/fm_api/analytics/
  metrics_{YYYY-MM-DD}.jsonl    ← one line per endpoint/method/class/ua combination per hour
  daily_{YYYY-MM-DD}.json       ← daily aggregate summary
  weekly_{YYYY-WW}.json         ← weekly summary (written Monday 00:10 UTC)
```

**`metrics_{date}.jsonl` line format:**
```json
{"ts": "2026-06-26T14:00:00Z", "endpoint": "/api/transactions/", "method": "POST", "response_class": "2xx", "ua_class": "user", "count": 42}
```

**`daily_{date}.json` format:**
```json
{
  "date": "2026-06-26",
  "total_requests": 1240,
  "by_ua_class": {"user": 980, "bot": 210, "crawler": 40, "unknown": 10},
  "by_response_class": {"2xx": 1100, "4xx": 120, "5xx": 20},
  "top_endpoints": [{"endpoint": "/api/transactions/", "count": 450}, ...],
  "security_events": {"auth_failure": 12, "invalid_endpoint": 8, "probe_alerts_fired": 0},
  "dau": 7,
  "mau": 23
}
```

## 6) Security Alert Thresholds

Celery task checks every 15 minutes. Uses Django cache (Redis) for dedup — same pattern as F-014 DAU thresholds.

| Event | Threshold | Alert dedup |
|---|---|---|
| Auth failures from one ip_hash | >10 in 1 hour | 2h window |
| Invalid endpoint hits from one ip_hash | >20 in 1 hour | 2h window |
| 5xx rate across all traffic | >5% of requests in 1 hour | 1h window |
| Any ip_hash hitting >50 requests/minute | burst detect | 1h window |

Alert email event_type: `SECURITY_PROBE_DETECTED`, severity: `high`.

## 7) Phase Plan / Task List

| Task | File | Slices | Surface | Status |
|------|------|--------|---------|--------|
| **T01** | `tasks/T01_from_address_routing.md` | T01.SL1 | FROM header per event type; smoke test all three addresses | **code complete** — live Proton SMTP smoke blocked on HitM credentials |
| **T02** | `tasks/T02_request_middleware.md` | T02.SL1–SL2 | Redis INCR middleware; IP hash; endpoint normalization; UA classification | **code complete** — VPS `redis-cli` verification pending deploy |
| **T03** | `tasks/T03_analytics_aggregation.md` | T03.SL1–SL2 | Celery hourly rollup → metrics JSONL; daily + weekly summary JSON | **code complete** — `/var/log/fm_api/analytics/` volume + live beat smoke pending deploy |
| **T04** | `tasks/T04_security_alerts.md` | T04.SL1 | Probe threshold checks every 15 min → notify_operator | **code complete** — manual Redis seed smoke pending deploy |

### T01 live smoke (HitM gate — not done in code session)

Send three test emails via Proton Bridge and confirm inbox `From:` headers:

1. `BUG_REPORT` → `bugreport@thehivemanager.com`
2. `FEATURE_REQUEST` → `featurerequest@thehivemanager.com`
3. `DAU_THRESHOLD_CROSSED` (or any default event) → `noreply@thehivemanager.com`

Requires VPS `.secrets/server.env`: `EMAIL_HOST*`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD`, `OPERATOR_NOTIFY_EMAIL`. If Bridge rejects any FROM alias, stop and escalate to HitM per T01 acceptance criteria.

### Deploy prerequisites (HitM / VPS)

- Set `LOG_IP_HASH_SALT` in server env (generate: `python -c "import secrets; print(secrets.token_hex(32))"`)
- Ensure `/var/log/fm_api/analytics/` exists and is writable by API + celery_worker containers (volume mount if needed)
- Confirm `REDIS_URL` reachable from API container (F-014 baseline)

## 8) Execution Order

```
T01 (Proton Bridge FROM verification — gate on this before anything else)
  → T02 (middleware populates Redis — required before T03/T04 have data)
    → T03 (aggregation reads Redis → writes files)
    → T04 (security alert reads Redis → fires notify_operator if threshold)
```

T03 and T04 may proceed in parallel after T02 is merged.

## 9) Verification Gates

| Slice | Pass condition |
|-------|---------------|
| T01.SL1 | Three emails sent; Proton inbox headers confirm correct FROM address for each |
| T02.SL1 | Request to `/api/health/` increments a Redis `fm_metrics:*` key; `redis-cli keys "fm_metrics:*"` shows result; no raw IP or UA string in any key |
| T02.SL2 | Request to non-existent endpoint → `fm_security:*:invalid_endpoint` key incremented; 401 → `fm_security:*:auth_failure` key incremented |
| T03.SL1 | Celery hourly task fires; `metrics_{date}.jsonl` file exists at `/var/log/fm_api/analytics/`; re-run does not duplicate lines |
| T03.SL2 | `daily_{date}.json` written after midnight rollup; `weekly_{YYYY-WW}.json` written Monday 00:10 UTC |
| T04.SL1 | Seeding Redis with threshold-crossing security counter triggers `notify_operator.delay()` with `event_type=SECURITY_PROBE_DETECTED`; dedup prevents second alert within 2h |

## 10) Privacy Disclosure Spec (for governance plan author)

> **Input for the privacy policy plan — not authored here.**

| Data | Purpose | Retention | PII status |
|---|---|---|---|
| Hashed IP (salted SHA256) | Security event correlation | Redis: 48h rolling; files: 90 days | Low — one-way, salted, not recoverable |
| User UUID ref (authenticated requests) | Feature usage analytics | Files: 90 days rolling | None — pseudonymous UUID |
| User agent class (bot/crawler/user/unknown) | Traffic composition | Files: 90 days | None — classified, raw string never stored |
| Endpoint + method + response class | API usage + security | Files: 90 days | None |
| DAU/MAU (F-014) | Growth monitoring | Indefinite — aggregate counts | None |

**Cookie/session audit required:** confirm whether auth tokens are in cookies (→ cookie consent banner required) or localStorage only (→ simpler functional-cookie-only notice).

## 11) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
|---|---|---|---|
| Proton Bridge rejects FROM swap | T01 smoke test fails | Stop; HitM provides per-address SMTP credentials; implement multi-backend | Gate at T01 |
| Redis key explosion | Many unique endpoint/ip combinations fill Redis memory | Add `EXPIRE 172800` (48h) to all counter keys; monitor Redis memory | Cursor executor — set TTL on all keys |
| Middleware overhead | p99 latency increases >20ms | Make counter writes async (fire-and-forget Celery microtask); or drop to sampling (1-in-10 requests) | Cursor executor — measure before and after |
| Analytics dir not writable | Celery can't write files | Add volume mount in docker-compose; create dir with correct permissions | Cursor executor — check before T03 |
| PII in Redis key | Raw IP or username appears in key name | Audit all key-construction code paths; flush affected keys; fix hash function | Zero tolerance |
