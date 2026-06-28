# Daily Engineering Digest — June 27, 2026

## Date Range Covered
2026-06-26 to 2026-06-27

## Key Changes

### 1. API Celery Task Autodiscovery & Registration Fix
* **Celery Task Registration:** Fixed an autodiscovery bug where Celery's `autodiscover_tasks` did not pick up beat-scheduled tasks under `finance/tasks/` because it was structured as a namespace package lacking an init module. Created [__init__.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tasks/__init__.py) to explicitly import all task modules.
* **Regression Testing:** Added [test_celery_task_registration.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tests/test_celery_task_registration.py) to assert that all configured beat-scheduled tasks (`rollup_daily_usage` and `send_weekly_feature_requests_email`) are correctly registered on the worker.

### 2. Weekly Digest Security Hardening
* **HTML Escaping User Input:** Fixed a security vulnerability in the weekly feature request digest task in [support_digest.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tasks/support_digest.py). User-submitted bug ticket fields (such as `uid`, `nature`, and `comment`) are now properly HTML-escaped before interpolation into the operator email HTML table, preventing potential stored XSS and phishing exploits.
* **Security Tests:** Integrated HTML-escaping assertions into [test_support_tasks.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tests/test_support_tasks.py) using malicious script and image tags.

### 3. F-014 Usage Monitoring & Operator Notify Backend
* **F-014 Architecture:** Completed the backend implementation for F-014 (Usage Monitoring & Operator Notify) under [feat-f014-usage-monitoring-notify/README.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/feat-f014-usage-monitoring-notify/README.md). Shipped database migration [0010_usage_monitoring_f014.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/migrations/0010_usage_monitoring_f014.py) defining models `DailyUsageSnapshot`, `InviteChainEvent`, and `OperatorAlertState`.
* **Async Dispatcher:** Created an asynchronous Celery task in [notify.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tasks/notify.py) enforcing a PII-redacted `[FM-NOTIFY]` email format. Replaced the synchronous bug report email delivery path in the support ticket view with the new async task.

### 4. Web UI Design Token Layer & Navigation Shell (PLAN_CROSS_UI_UX_DESIGN_SYSTEM)
* **Design Primitives:** Established a central design system in [tokens.css](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/styles/tokens.css) utilizing OKLCH semantic colors, a 4px scale, dark-mode flash protection, and tabular numeric figures for cash values. Applied tokens to Card, Button, and a new [Input.tsx](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/components/ui/Input.tsx) component.
* **Layout Shell & Animations:** Replaced default visual layouts with a responsive [ProtectedShell.tsx](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/layout/ProtectedShell.tsx) and [shells.css](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/layout/shells.css) mapping out a mobile bottom navigation bar and slide-up drawer with a strict z-index contract. Integrated Framer Motion animations gated by reduced-motion accessibility preferences. Localized UI support added for English (`en-US`) and Tagalog (`tl-PH`).

### 5. Web SEO Optimizations
* **Public Route Meta:** Configured localized document metadata and headers on the public [LoginPage.tsx](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/pages/LoginPage.tsx) and [SignupPage.tsx](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/pages/SignupPage.tsx) pages using React Helmet, resolving the issue where login/signup pages inherited site-wide fallback metadata.

### 6. Blue-Green Docker Deployment Integration
* **Celery Support:** Wired Celery worker and beat containers into the Docker Compose setup. Modified [docker-compose.bluegreen.yml](file:///home/pproctor/Documents/python/finance_manager/docker-compose.bluegreen.yml) and [fm_server_beta.sh](file:///home/pproctor/Documents/python/finance_manager/scripts/fm_server_beta.sh) to build and cycle the Celery services during Blue-Green deployments.
* **Container Pruning:** Added a targeted `prune-orphans` command to the deployment script to safely clean up stale, inactive container instances without restarting the active color container, avoiding disruptive `podman-compose --remove-orphans` commands. Updated [.gitignore](file:///home/pproctor/Documents/python/finance_manager/.gitignore) to exclude local SMTP secret files (`smtp.secret`).

---

## Watchlist & Regressions

1. **VPS Celery Deployment (High):** Celery worker and beat containers are not yet running on the VPS environment (the production Podman stack only runs `redis`, `db`, and active `green` web/api). Tasks like the weekly feature digest and F-014 operator alerts will not execute until Celery worker/beat containers are successfully deployed and SMTP credentials (`EMAIL_*` env variables) are set up in the VPS environment.
2. **VPS Submodule Sync & PR Bumps (Medium):** The local parent workspace standby branch (`cur/s1b/chore/sync-standby-submodules`) updates submodule pointers to API `789b266` and Web `4ad032a`. The parent PR bump is pending. Once merged, it requires a full rebuild of the inactive VPS Blue stack, migration execution (`0010_usage_monitoring_f014` and `axes`), and smoke testing before promotion.
3. **Web Build Validation (Medium):** The previous web submodule commit (`9b2ecbe`) failed `npm run build` due to TypeScript errors. Ensure the updated standby target (`4ad032a`) successfully builds and validates without error on a clean workspace before deployment.
