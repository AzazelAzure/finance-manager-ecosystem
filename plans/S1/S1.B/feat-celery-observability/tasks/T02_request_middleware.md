# T02 — PII-Safe Request Logging Middleware

## End State
A Django middleware increments Redis counters on every request. Near-zero overhead — atomic INCR only, no DB writes, no file I/O in the hot path. All keys are PII-free: normalized endpoint, IP hash, classified UA. F-013 Loguru files are untouched.

## Acceptance Criteria
1. [V1] `redis-cli keys "fm_metrics:*"` shows populated keys after a few requests to the API
2. [V1] `redis-cli keys "fm_security:*"` shows a key after a request to a non-existent endpoint
3. [V1] No raw IP address or user-agent string appears in any Redis key — grep `redis-cli keys "*"` output
4. [V1] `python manage.py check --deploy` passes; `npm run build` unaffected (web not touched)

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | Middleware + metric counters | V1 | Install middleware; Redis INCR for traffic metrics; IP hash; UA classification; endpoint normalization |
| T02.SL2 | Security counters | V1 | INCR security keys on auth failure + invalid endpoint; verify with test requests |

## Scope Lock

### Module location
Create `finance_manager/middleware/observability.py` (or match existing middleware convention in the repo).

### Middleware implementation
```python
import hashlib
import re
from django.conf import settings
from django.core.cache import cache  # Uses Redis backend
import logging

logger = logging.getLogger(__name__)

def normalize_endpoint(path: str) -> str:
    path = re.sub(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}', '{uuid}', path)
    path = re.sub(r'/\d+(?=/|$)', '/{id}', path)
    return path.rstrip('/') + '/'

def hash_ip(ip: str) -> str:
    salt = getattr(settings, 'LOG_IP_HASH_SALT', 'changeme')
    return hashlib.sha256(f"{salt}{ip}".encode()).hexdigest()[:16]  # 16 hex chars — enough for correlation

def classify_ua(ua: str) -> str:
    ua_lower = (ua or '').lower()
    if any(x in ua_lower for x in ['googlebot', 'bingbot', 'twitterbot', 'facebookexternalhit', 'applebot']):
        return 'crawler'
    if any(x in ua_lower for x in ['curl', 'python-requests', 'go-http', 'semrush', 'ahrefs', 'scrapy', 'wget']):
        return 'bot'
    if any(x in ua_lower for x in ['mozilla', 'chrome', 'safari', 'firefox', 'edge']):
        return 'user'
    return 'unknown'

class ObservabilityMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        try:
            self._record(request, response)
        except Exception as exc:
            # Never let observability break a response
            logger.error("ObservabilityMiddleware error: %s", exc)

        return response

    def _record(self, request, response):
        from datetime import datetime, timezone
        date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
        hour_str = datetime.now(timezone.utc).strftime('%Y-%m-%d-%H')

        endpoint = normalize_endpoint(request.path)
        method = request.method or 'UNKNOWN'
        status = response.status_code
        response_class = f"{status // 100}xx"
        ua_class = classify_ua(request.META.get('HTTP_USER_AGENT', ''))
        # Cloudflare confirmed in traffic path (verified 2026-06-26, cf-ray present).
        # CF-Connecting-IP is the real client IP; REMOTE_ADDR would be Cloudflare's IP.
        raw_ip = request.META.get('HTTP_CF_CONNECTING_IP') or request.META.get('REMOTE_ADDR', '')
        ip_hash = hash_ip(raw_ip)

        # Traffic metric counter (48h TTL — Celery rolls up before expiry)
        metric_key = f"fm_metrics:{date_str}:{endpoint}:{method}:{response_class}:{ua_class}"
        cache.client.get_client().incr(metric_key)
        cache.client.get_client().expire(metric_key, 172800)  # 48h

        # Security counters
        is_auth_failure = status in (401, 403)
        is_invalid_endpoint = status == 404 and not self._is_known_endpoint(request)

        if is_auth_failure:
            sec_key = f"fm_security:{hour_str}:{ip_hash}:auth_failure"
            cache.client.get_client().incr(sec_key)
            cache.client.get_client().expire(sec_key, 7200)  # 2h

        if is_invalid_endpoint:
            sec_key = f"fm_security:{hour_str}:{ip_hash}:invalid_endpoint"
            cache.client.get_client().incr(sec_key)
            cache.client.get_client().expire(sec_key, 7200)

    def _is_known_endpoint(self, request) -> bool:
        from django.urls import resolve, Resolver404
        try:
            resolve(request.path)
            return True
        except Resolver404:
            return False
```

### Settings additions
```python
# settings.py
MIDDLEWARE = [
    # ... existing middleware ...
    'finance_manager.middleware.observability.ObservabilityMiddleware',  # append last
]

LOG_IP_HASH_SALT = env('LOG_IP_HASH_SALT')  # Required env var — generate with: python -c "import secrets; print(secrets.token_hex(32))"
```

Add `LOG_IP_HASH_SALT` to `.secrets/` env file. Generate a random value — **never commit it**.

### Important: Redis client access
`cache.client.get_client().incr()` is the `django-redis` pattern for direct Redis commands. If the project uses a different Redis cache backend, adjust accordingly. Check existing cache usage in settings before writing this.

### Do NOT use
- `cache.incr()` — Django's cache INCR does not support key TTL in one call
- Any `logging.info()` call that includes `request.body`, query params, or `request.user.email`
- Any write to disk in `_record()` — Redis only

## Evidence
- `evidence/T02.SL1_redis_keys.txt` — output of `redis-cli keys "fm_metrics:*"` after test requests
- `evidence/T02.SL2_security_keys.txt` — output of `redis-cli keys "fm_security:*"` after 404 + 401 requests
