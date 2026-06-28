---
research_id: RESEARCH_CLOUDFLARE_INTEGRATION_2026-06-26
status: draft
created: 2026-06-26
author: pproctor
phase: S1.B
---

# Cloudflare Integration — Feasibility Research

> **Not a feature plan.** Kill-fast research note. Answer the feasibility questions before committing any implementation work.

## Context

The VPS is at `159.198.75.194`, serving `thehivemanager.com` on port `:8443` via Nginx reverse proxy. Celery observability plan (`PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26`) adds server-side traffic analytics. The question is whether Cloudflare in the traffic path would supersede, complement, or complicate that work — and whether Cloudflare agent tooling (Workers, AI Gateway) is useful for the current multi-agent workflow.

## Kill-Fast Result (verified 2026-06-26)

```
curl -I https://thehivemanager.com:8443/api/health/
→ server: cloudflare
→ cf-ray: a11b2a437ab9f910-SIN   (Singapore PoP)
→ cf-cache-status: DYNAMIC
→ alt-svc: h3=":8443"           (Cloudflare advertising HTTP/3 on this port)
```

**Cloudflare IS in the traffic path on :8443.** All questions below are now answered.

**Immediate action taken:** `PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26` T02 updated — middleware now reads `HTTP_CF_CONNECTING_IP` (real client IP) instead of `REMOTE_ADDR` (Cloudflare's IP). Fallback to `REMOTE_ADDR` for local dev.

**Cross-plan flag:** `PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26` sets `AXES_PROXY_COUNT = 1` for nginx. With Cloudflare also in the path, django-axes needs to be configured to read `CF-Connecting-IP` for accurate lockout targeting — otherwise axes locks out Cloudflare's IP and blocks all traffic. Executor must verify this when running the API security hardening plan.

---

## Feasibility Questions (answer these before committing)

### 1. Is Cloudflare currently in the traffic path?
- Does the DNS for `thehivemanager.com` point through Cloudflare's proxy (orange cloud)?
- If VPS serves on `:8443` (non-standard port), is Cloudflare proxying that port? Cloudflare's free/pro tiers only proxy specific ports — `:8443` **is** on the supported list, but verify.
- Run: `curl -I https://thehivemanager.com:8443/api/health/` and check response headers for `CF-RAY` header — presence confirms Cloudflare is proxying.

### 2. Traffic analytics supersession
If Cloudflare is proxying:
- Cloudflare Analytics provides bot/crawler classification, country breakdown, threat scores, response code distribution — at the edge, before traffic hits the VPS.
- This **partially supersedes** T02/T03 of the observability plan for traffic-composition analytics (bot vs user, crawler rates).
- It does NOT supersede per-endpoint API usage analytics or security threshold alerting (those need application-layer context Cloudflare doesn't have).
- **Decision:** if Cloudflare is in the path, scope T02 down to API-layer events only (endpoint usage, auth failures, probe detection) and rely on Cloudflare for traffic composition.

### 3. WAF / DDoS protection
- Cloudflare WAF (available at Pro tier, ~$20/mo) would catch common probe patterns before they hit Django.
- At current traffic scale (single-digit users), this is low priority — but if probe detection in T04 starts firing frequently, WAF becomes the right mitigation layer.
- Free tier Cloudflare includes basic DDoS protection; WAF is Pro+.

### 4. Cloudflare Workers / AI Gateway for agent workflow
- **AI Gateway:** Cloudflare offers a proxy layer for LLM API calls — logs requests/responses, adds caching, rate limiting. Relevant if Claude/Cursor API calls become a meaningful cost or need logging.
- **Workers:** edge compute that could handle lightweight request processing before hitting the VPS. Not currently needed.
- **For the current agent workflow (Claude Code CLI + cagent + Antigravity):** these tools make API calls from the local machine, not from the VPS — Cloudflare Workers wouldn't be in that path unless specifically routed through.
- **Verdict (preliminary):** Cloudflare AI Gateway is worth evaluating if LLM API costs become a concern at S1.C+ scale. Not needed now.

### 5. Real IP passthrough
If Cloudflare is proxying, the Django app sees Cloudflare's IP, not the real client IP. The observability middleware uses `REMOTE_ADDR` for IP hashing — this would hash Cloudflare's IP instead of the attacker's, breaking probe detection.
- **Fix:** configure Django to trust the `CF-Connecting-IP` header when Cloudflare is proxying.
- **Security concern:** `CF-Connecting-IP` must only be trusted if Cloudflare is confirmed in the path; otherwise it's a spoofable header.
- This must be resolved before the observability plan is deployed if Cloudflare is active.

## Kill-Fast Checklist

| Question | How to answer | Kill condition |
|---|---|---|
| Is CF in the path? | Check `CF-RAY` header in response | If no → CF integration is a non-issue for now |
| Does `:8443` work through CF proxy? | Check Cloudflare dashboard → Network → supported ports | If no → traffic goes direct; CF analytics not useful |
| Real IP passthrough working? | Check `CF-Connecting-IP` header in Django request | If missing → probe detection breaks; fix before observability deploy |
| Does CF Analytics cover bot/user split? | Review Cloudflare dashboard analytics tab | If yes → drop T02 UA classification, use CF data instead |

## Recommendation (preliminary)

**If Cloudflare is already in the path:** adjust the observability plan to trust `CF-Connecting-IP` for IP hashing, and lean on Cloudflare Analytics for traffic composition. Keep the Django middleware for API-layer events only.

**If Cloudflare is NOT in the path:** proceed with observability plan as written. Consider adding Cloudflare proxy at a natural infrastructure milestone (e.g., blue-green rebuild before S1.C) — it adds DDoS protection and bot classification for free.

**Cloudflare AI Gateway:** research for S1.C when LLM usage costs are measurable. Not now.

## Next Action

Run the kill-fast checklist above (takes ~10 minutes). Update this file with findings. If CF is in the path, open a note to adjust `PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26` T02 before that plan executes.
