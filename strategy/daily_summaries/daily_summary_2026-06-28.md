# Daily Engineering Digest — June 28, 2026

**Date range covered:** 2026-06-27 to 2026-06-28

---

## Key Changes

### Legal Compliance & Clickwrap Consent (N2, N4, N5)
* **Public Legal Pages (N4/N5):** Added public routes for `/privacy`, `/terms`, and `/cookies` in the web application (Web PR #66). The pages render their respective policy documents from markdown files (`src/content/legal/`) using `react-markdown` and `remark-gfm`. Added a `LegalFooter` component to the landing page and updated the `CookieBanner` to link to `/cookies`.
* **Signup Clickwrap (N2):** Implemented affirmative consent on the account creation flow (Web PR #67, API PR #42). Added a required checkbox on the signup form that must be checked before submission. Added `tos_version` (CharField) and `tos_accepted_at` (DateTimeField) fields to `AppProfile` via migration [0011_tos_acceptance_fields.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/migrations/0011_tos_acceptance_fields.py). Updated the registration serializer and view to require, validate, and save these fields.
* **UI Polish & Dark Mode:** Fixed dark-mode readability issues for the new legal pages (Web PR #70) and added a public light/dark theme toggle to the authentication shell (Web PR #69).

### User Support Email Confirmation & Celery Observability
* **Confirmation Emails:** Implemented user-facing confirmation emails when a user submits a bug report or feature request (API PR #41). The emails are dispatched asynchronously via Celery to the user's server-stored email address. Added a 5-minute cooldown per user per ticket type to prevent duplicate emails.
* **Celery Task Registration:** Fixed a bug where Celery's `autodiscover_tasks` did not automatically register beat-scheduled tasks under `finance/tasks/` by creating [__init__.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tasks/__init__.py) to explicitly import the task modules (API PR #38).
* **Celery Observability:** Shipped the backend implementation for Celery observability (T01–T04) and F-014 notify fixes, including model definitions for usage snapshots and operator alerts (API PR #39).

### UI/UX Test Seeder
* **UX Test User Seeder:** Created a Django management command `create_ux_testuser` (API PR #40) that generates a deterministic test user (`ux_demo`) with 12 months of realistic Philippine Peso (PHP) transaction data, payment sources (Cash, GCash, BDO Checking), tags, and upcoming expenses. This provides a clean seeder for visual regression and UI/UX testing without using personal accounts.

### Governance Overhaul & DevOps Infrastructure
* **Three-Tool Model:** Merged the three-tool governance model (Parent PR #62) defining clear boundaries between Cursor Pro+ (sprint execution), Claude Code (governance ops), and Antigravity Pro (daily status/admin).
* **CI/CD & Disaster Recovery:** Added the `PLAN_CROSS_CI_CD_2026-06-27` plan (Parent PR #66) for minimum viable CI/CD. Added disaster recovery and incident response plans (Parent [disaster_recovery_plan.md](file:///home/pproctor/Documents/python/finance_manager/governance/disaster_recovery_plan.md)).
* **Blue-Green Deploy & Celery Setup:** Integrated Celery worker/beat services into the blue-green compose file and server script, enabling container pruning of orphan instances during color switches (Parent PR #67 & #68).

---

## Open PRs

| PR # | Title | Branch | Status | Plan | Age |
|---|---|---|---|---|---|
| #60 (web) | fix(offline): correct app profile offline cache sync | `agy/s1b/fix/pwa-profile-offline-sync` | Open | `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03` | 11d |

---

## PRs Merged / Closed Today

### Parent Repository
| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| #70 | plan(s1b): legal pages, clickwrap, email comms, ui/ux seed | Merged | Added four S1.B execution plans to the registry. |
| #69 | docs(parent): celery-observability plan + F-014 audit corrections | Merged | Registered F-014 observability plans. |
| #68 | fix(deploy): suppress/redact compose up secret output | Merged | Redacts secrets from compose output on VPS. |
| #67 | chore(deploy): wire Celery into blue/green rebuild + active orphan teardown | Merged | Integrates Celery into blue/green deployment scripts. |
| #66 | docs(parent): close F-012/F-013 verification and add F-014 plan | Merged | Closes out F-012/F-013 and adds F-014 plan. |
| #65 | docs(strategy): record inactive blue standby smoke pass | Merged | Records blue stack smoke test success. |
| #64 | chore(parent): sync standby API and web submodule pins | Merged | Syncs submodule pins for standby release. |
| #63 | docs(strategy): standby queue closeout — PRs merged, VPS gate status | Merged | Closes out standby queue. |
| #62 | docs(governance): admin overhaul — three-tool model and archive legacy orchestration | Merged | Establishes the three-tool agent model. |

### API Submodule (`finance_manager_api`)
| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| #42 | feat(api): require ToS acceptance on registration | Merged | Enforces ToS clickwrap consent on registration. |
| #41 | feat(api): user support submission confirmation emails | Merged | Sends support confirmation emails with 5min cooldown. |
| #40 | feat(api): create_ux_testuser management command | Merged | Seeder command for deterministic UI/UX test user. |
| #39 | feat(api): celery observability (T01–T04) + F-014 notify fixes | Merged | Celery observability and F-014 notify backend. |
| #38 | fix(api): register beat-scheduled celery tasks via tasks package init | Merged | Fixes Celery task autodiscovery. |

### Web Submodule (`finance_manager_web`)
| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| #70 | fix(web): legal pages readable in dark mode | Merged | Dark-mode readability fix for legal pages. |
| #69 | feat(web): public light/dark theme toggle | Merged | Adds light/dark toggle to login/signup. |
| #68 | fix(web): repair guided tours after react-joyride v3 upgrade | Merged | Fixes guided tours after library upgrade. |
| #67 | feat(web): signup clickwrap + login legal footnote | Merged | Signup clickwrap checkbox and login footnote. |
| #66 | feat(web): public legal pages and footer links | Merged | Adds `/privacy`, `/terms`, `/cookies` pages and footer. |

---

## VPS State

| Item | State |
|---|---|
| Active color | Green |
| Inactive color | Blue |
| API submodule on VPS | `789b266` (blue) / `1833e74` (green) |
| Web submodule on VPS | `4ad032a` (blue) / `3e2b370` (green) |
| Pending VPS actions | Rebuild inactive blue with latest parent commits (API `ac6aa49`, Web `add3fbe` or `67f9e79`), run migration `0011_tos_acceptance_fields`, smoke test, and perform cutover. |

---

## In-Progress Plans

| Plan | Status | What's moving | Blocker |
|---|---|---|---|
| `PLAN_CROSS_USAGE_MONITORING_NOTIFY_2026-06-26` | in_progress | Code merged (API PR #39); pending live Proton/Redis VPS smoke. | None |
| `PLAN_CROSS_CELERY_OBSERVABILITY_2026-06-26` | in_progress | Code merged (API PR #39); pending live Proton/Redis VPS smoke. | None |

---

## Legal / Compliance Flags

- **Clickwrap Consent (N2):** Shipped. Accounts now require affirmative acceptance of the Terms of Service and Privacy Policy before registration, logging the timestamp and ToS version in the database (`AppProfile.tos_accepted_at`, `AppProfile.tos_version`).
- **Public Legal Disclosures (N4/N5):** Shipped. Public routes for `/privacy`, `/terms`, and `/cookies` are now live on the web frontend and linked in a new footer.

---

## Watchlist & Regressions

1. **High - VPS Celery Deployment:** Celery worker and beat containers are not yet running on the VPS environment (the production Podman stack only runs `redis`, `db`, and active `green` web/api). Tasks like the weekly feature digest and F-014 operator alerts will not execute until Celery worker/beat containers are successfully deployed and SMTP credentials (`EMAIL_*` env variables) are set up in the VPS environment.
2. **High - VPS Rebuild & Migration:** With the merge of `PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27`, we have a new database migration (`0011_tos_acceptance_fields`). The inactive blue stack needs to be rebuilt with the new submodule pins, migrations applied, and thoroughly smoked before cutover.
3. **Medium - Web Build & Guided Tours Verification:** The Web submodule has been updated to `67f9e79` on the integration branch `cur/s1b/integration/ui-fixes-verify` which includes guided tour fixes and theme toggle. We need to verify that `npm run build` succeeds on this branch.

---

## Parked Items

| Item | Parked since | Resume trigger |
|---|---|---|
| `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03` | 2026-05-21 | HitM re-test after web/API fixes + deploy; clear handoff issues. |

---

## Next priorities

1. **VPS Rebuild and Migration:** Rebuild the inactive blue stack on VPS with the latest parent `main` HEAD (API `ac6aa49`, Web `add3fbe` or `67f9e79`), run migrations (`0011_tos_acceptance_fields.py`), and smoke test the clickwrap and legal pages.
2. **SMTP and Celery Verification on VPS:** Set up SMTP credentials on VPS and verify Celery worker/beat container execution to unblock support email confirmations and F-014 operator alerts.
3. **Quarterly Self-Review:** Execute the first quarterly self-review due by June 30, 2026 (in 2 days) per `kill_commit_gates.md` §6.
4. **CI/CD Pipeline Setup:** Begin execution of `PLAN_CROSS_CI_CD_2026-06-27` to establish GitHub Actions CI workflows for both API and Web.
