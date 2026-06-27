# T03 — Health Check Cron (Uptime Monitoring)

## Context

Self-hosted alternative to external uptime monitors (Uptime Robot, etc.). Runs on GitHub's infrastructure (external from the VPS), so it detects VPS-down scenarios independently. When the workflow fails, GitHub automatically emails the repo owner.

**Decision from admin session 2026-06-27:** Fold into CI/CD plan rather than a standalone monitoring item. No external service needed.

## End State

`.github/workflows/health-check.yml` in the parent `finance-manager` repo. Runs every 10 minutes via cron. Checks both the web app and the API health endpoint. On failure, exits non-zero → GitHub sends failure email to repo owner.

## Pre-flight (Cursor: read before writing)

1. Identify the API health endpoint. Check `finance_manager_api/finance_api/urls.py` (or `finance/urls.py`) for a route like `/health/`, `/api/health/`, `/api/status/`. If none exists, use `/api/` (should return 200 if the API is up) or `/admin/` (redirects to login, returns 302 — adjust the expected code).
2. Confirm the domain and port used for the live VPS. From current docs: `:8443`. Confirm the hostname.
3. The workflow needs `workflow_dispatch` (manual trigger) for testing before relying on the cron.

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T03.SL1 | Workflow file | V1 |
| T03.SL2 | Manual trigger verify | V1 |

## T03.SL1 — Workflow File

Create `.github/workflows/health-check.yml` in the **parent repo** (`finance-manager`, not a submodule):

```yaml
name: Health Check

on:
  schedule:
    - cron: '*/10 * * * *'   # every 10 minutes
  workflow_dispatch:           # allow manual trigger for testing

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Check web app
        run: |
          code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 https://YOURDOMAIN:8443)
          echo "Web response: $code"
          [ "$code" = "200" ] || [ "$code" = "301" ] || [ "$code" = "302" ] || {
            echo "FAIL: unexpected response $code"
            exit 1
          }

      - name: Check API health endpoint
        run: |
          code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 https://YOURDOMAIN:8443/api/health/)
          echo "API response: $code"
          [ "$code" = "200" ] || {
            echo "FAIL: API health returned $code"
            exit 1
          }
```

**Replace `YOURDOMAIN` with the actual VPS hostname.**

**On accepted codes:** The web root may redirect (301/302) to `/login` or `/app` — that's healthy. The API health endpoint should be a clean 200. Adjust if the actual endpoints differ.

**Note on GitHub Actions schedule reliability:** Cron schedules can be delayed by several minutes under GitHub load. This is acceptable for beta uptime monitoring — the point is detection within ~15 minutes, not sub-minute alerting.

**Note on the 60-day inactivity rule:** GitHub disables scheduled workflows in repos with no push activity for 60 days. This repo (parent) is actively committed to; this is not a concern in practice.

**Acceptance criteria:**
- [V1] Workflow file parses without YAML errors
- [V1] Manual trigger (`workflow_dispatch`) completes successfully against live VPS

## T03.SL2 — Manual Trigger Verify

1. Push the workflow file to parent repo `main`
2. Navigate to GitHub → `finance-manager` → Actions → `Health Check` → Run workflow
3. Confirm both check steps return expected codes on a healthy VPS
4. Confirm failure behavior: if VPS is reachable, temporarily change the expected code to `999` to force a failure, verify the workflow fails, then revert

**Acceptance criteria:**
- [V1] Manual trigger runs and passes against live VPS
- Evidence: `evidence/T03.SL2_health_check_pass.png`
