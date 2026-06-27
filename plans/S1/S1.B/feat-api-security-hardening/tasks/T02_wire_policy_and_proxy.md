# T02 — Wire Password Policy and Axes Proxy Config

## ⚠️ Cloudflare Caveat (verified 2026-06-26)

`thehivemanager.com:8443` is confirmed behind Cloudflare (cf-ray present in responses, Singapore PoP). This changes the proxy topology and axes configuration:

**Actual topology:** `client → Cloudflare → nginx (proxy_1) → Django`

**The risk:** if axes is configured with `AXES_PROXY_COUNT = 1` only, it reads from `X-Forwarded-For` and may still resolve to Cloudflare's egress IP — locking out Cloudflare's IP would block **all traffic simultaneously**.

**Correct configuration for Cloudflare + nginx:**
```python
# Prefer CF-Connecting-IP (real client IP set by Cloudflare, not spoofable at the edge)
AXES_META_PRECEDENCE_ORDER = ('HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR')
AXES_PROXY_COUNT = 1  # nginx hop only; CF-Connecting-IP is already the real IP
```

`HTTP_CF_CONNECTING_IP` is Cloudflare's canonical real-IP header. It is set by Cloudflare and cannot be spoofed by a client when Cloudflare is in the path. Reading it directly bypasses the `X-Forwarded-For` chain entirely.

**Executor must verify:** check if the installed `django-axes` version supports `AXES_META_PRECEDENCE_ORDER` (available in axes ≥5.x). If using an older version, check the equivalent setting name in the installed version's docs.

---

## End State
`validate_password()` is called on all password-setting flows (change, reset, registration). `django-axes` is configured to read `CF-Connecting-IP` for real client IP lockout — so Cloudflare's egress IP is never locked out.

## Acceptance Criteria
1. [V1] `POST /finance/auth/change-password/` with password `abc` returns `400` with a password-policy error message
2. [V1] `POST /finance/auth/change-password/` with a valid complex 12-char password succeeds (200/204)
3. [V0] `settings.py` contains `AXES_META_PRECEDENCE_ORDER` with `HTTP_CF_CONNECTING_IP` as first entry; comment explains Cloudflare topology

## Scope Lock

### Files to modify
- `finance_api/settings.py` — add `AXES_META_PRECEDENCE_ORDER` + `AXES_PROXY_COUNT = 1` (Cloudflare-aware; see caveat above); verify `AXES_FAILURE_LIMIT = 5` and `AXES_COOLOFF_TIME` are set
- Password-setting endpoints — add `validate_password(password, user)` call; import from `django.contrib.auth.password_validation`
  - Identify exact endpoint files by grepping for `change_password`, `set_password`, `PasswordResetConfirmView`, `RegisterView` or similar in `finance/` app

### Files NOT to touch
- `finance/validators/password_complexity.py` (already staged from T01)
- Auth login endpoint (axes handles login lockout automatically via middleware; do not add manual checks)
- Migrations (T03 scope)

## Technical Decisions (pre-locked)
- Use `validate_password(value, user=user_instance)` at the serializer or view level — not in the model `save()` — so error messages surface cleanly in the API response body
- `AXES_META_PRECEDENCE_ORDER = ('HTTP_CF_CONNECTING_IP', ...)` takes priority over `AXES_PROXY_COUNT` for IP resolution when Cloudflare is in path — this is the correct approach (verified 2026-06-26)
- `AXES_PROXY_COUNT = 1` remains set for the nginx hop, but `CF-Connecting-IP` is read first so the count is effectively bypassed for Cloudflare traffic
- Do not set `AXES_LOCKOUT_CALLABLE` — default 403/429 response is acceptable

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | Wire validate_password to endpoints | V1 | Grep for password-setting views/serializers; add `validate_password()` call; build + `python manage.py check` pass |
| T02.SL2 | Axes proxy config (Cloudflare-aware) | V0 | Add `AXES_META_PRECEDENCE_ORDER` with `HTTP_CF_CONNECTING_IP` first; `AXES_PROXY_COUNT = 1`; verify axes version supports the setting |

## Evidence
- `evidence/T02.SL1_change_password_400.txt` — curl output showing 400 on weak password
- `evidence/T02.SL1_change_password_200.txt` — curl output showing success on valid password
- `evidence/T02.SL2_settings_diff.txt` — diff of settings.py axes proxy section

## Anti-Patterns (do NOT do these)
- Do NOT call `validate_password` inside `User.set_password()` override — that path is called internally by Django and will break admin user creation
- Do NOT remove `AXES_ENABLED = True` if it exists — it should remain enabled
- Do NOT set `AXES_PROXY_COUNT` to a value other than 1 without asking HitM (misconfiguration locks out legitimate users)
