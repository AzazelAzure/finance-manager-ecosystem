# Daily Engineering Digest — June 29, 2026

**Date range covered:** 2026-06-28 to 2026-06-29

---

## Key Changes

### F-001 Balance History
* **Category:** Backend & Frontend Feature
* **Backend:** Shipped `BalanceSnapshot` model and migration `0014_balance_snapshot_f001` in [API PR #56](https://github.com/AzazelAzure/finance-manager-api/pull/56). Added a nightly capture and backfill management command (`backfill_balance_snapshots`) which was executed on the VPS, backfilling 4,143 historical snapshot rows.
* **Frontend:** Added a PWA-compatible dashboard balance trend chart in [Web PR #84](https://github.com/AzazelAzure/finance-manager-web/pull/84) to visualize historical net worth and balance trends.

### F-004 Pay-Period STS & Bill Realism
* **Category:** Backend & Frontend Feature
* **Backend:** Added pay-cycle STS (Safe-to-Spend) window fields to `AppProfile` via migration `0012` ([API PR #52](https://github.com/AzazelAzure/finance-manager-api/pull/52)) and bill realism fields (volatile/rigid, partial payments) to `UpcomingExpense` via migration `0013` ([API PR #53](https://github.com/AzazelAzure/finance-manager-api/pull/53)). Implemented the STS pay-window calculation engine and serializers in [API PR #54](https://github.com/AzazelAzure/finance-manager-api/pull/54) and [API PR #55](https://github.com/AzazelAzure/finance-manager-api/pull/55). Shipped a fix for upcoming bill-link mark-paid and interval-based overdue catch-up in [API PR #51](https://github.com/AzazelAzure/finance-manager-api/pull/51).
* **Frontend:** Shipped bill editor realism fields in [Web PR #81](https://github.com/AzazelAzure/finance-manager-web/pull/81) and STS pay-period views in [Web PR #82](https://github.com/AzazelAzure/finance-manager-web/pull/82) and [Web PR #83](https://github.com/AzazelAzure/finance-manager-web/pull/83).

### F-005 Savings Goals
* **Category:** Backend & Frontend Feature
* **Backend:** Shipped `SavingsGoal` model, migration `0016_savings_goal`, CRUD API endpoints, and per-cycle math in [API PR #61](https://github.com/AzazelAzure/finance-manager-api/pull/61) and [API PR #62](https://github.com/AzazelAzure/finance-manager-api/pull/62).
* **Frontend:** Added the savings goals management page in [Web PR #88](https://github.com/AzazelAzure/finance-manager-web/pull/88) and the dashboard goals widget in [Web PR #89](https://github.com/AzazelAzure/finance-manager-web/pull/89).

### F-010 Export & Sharing (Data Hub)
* **Category:** Backend & Frontend Feature
* **Backend:** Shipped CSV export and full JSON backup endpoints in [API PR #57](https://github.com/AzazelAzure/finance-manager-api/pull/57) and [API PR #58](https://github.com/AzazelAzure/finance-manager-api/pull/58). Added the share token API and migration `0015_export_share_token_f010` in [API PR #59](https://github.com/AzazelAzure/finance-manager-api/pull/59) and [API PR #60](https://github.com/AzazelAzure/finance-manager-api/pull/60).
* **Frontend:** Shipped the Data Hub export section and sharing UI in [Web PR #85](https://github.com/AzazelAzure/finance-manager-web/pull/85), [Web PR #86](https://github.com/AzazelAzure/finance-manager-web/pull/86), and [Web PR #87](https://github.com/AzazelAzure/finance-manager-web/pull/87).

### F-011 Wedge Landing Page Update
* **Category:** Frontend Feature
* **Frontend:** Updated the landing page to reflect the newly shipped features (balance history, pay cycles, savings goals, export/sharing) and outlined the honest forward roadmap (recurring automation, dashboard widgets, predictive budgeting, and family ledger) in [Web PR #90](https://github.com/AzazelAzure/finance-manager-web/pull/90).

### Production UX Polish Batch
* **Category:** Bug Fixes
* **Implementation:** Shipped navigation brand link fixes (clicking brand logo returns to landing page), redirect logic for authenticated users navigating to `/login` (renders "Return to Dashboard" instead of login form), form label i18n audits, and reactivated the onboarding wizard scoped to base currency and first payment source (API PR #51, Web PR #80). Removed internal codes (F-007, etc.) from Terms of Service and Privacy Policy markdown files.

### DevOps & Automations
* **Category:** Infrastructure & Operations
* **CI/CD:** Completed `PLAN_CROSS_CI_CD_2026-06-27` with green CI runs for API and Web. Resolved test-determinism issues in API CI (pinned actions, fixed currency-fragile tests, and added Redis service) in parent commits `25b13f5`, `566ca0c`, and `7246ba7`.
* **Administrative Sweeps:** Completed the Q2 quarterly self-review (parent commit `17c3648`). Reconciled the plan registry, closing out 9 plans (parent commit `d41085b`).
* **Automation Scripts:** Added background scripts for daily doc sweeps, anomaly queue sweeps, monthly ops pulses, quarterly audit prompts, and backup/cron utilities (parent commits `0506141`, `37044b1`, `c733d78`, `fb0978e`).

---

## Open PRs

| PR # | Title | Branch | Status | Plan | Age |
|---|---|---|---|---|---|
| API #50 | chore(deps): bump redis from 5.0.6 to 5.0.7 | `dependabot/uv/redis-5.0.7` | Open | — | 1d |
| API #49 | chore(deps): bump asgiref from 3.8.1 to 3.8.2 | `dependabot/uv/asgiref-3.8.2` | Open | — | 1d |
| API #48 | chore(deps-dev): bump rpds-py from 0.18.1 to 0.18.2 | `dependabot/uv/rpds-py-0.18.2` | Open | — | 1d |
| API #47 | chore(deps): bump djangorestframework from 3.15.1 to 3.15.2 | `dependabot/uv/djangorestframework-3.15.2` | Open | — | 1d |
| API #46 | chore(deps): bump python-dotenv from 1.0.1 to 1.0.2 | `dependabot/uv/python-dotenv-1.0.2` | Open | — | 1d |
| API #45 | chore(deps): bump actions/cache from 4.0.2 to 4.0.3 | `dependabot/github_actions/actions/cache-4.0.3` | Open | — | 1d |
| API #44 | chore(deps): bump astral-sh/setup-uv from 3 to 4 | `dependabot/github_actions/astral-sh/setup-uv-4` | Open | — | 1d |
| Web #78 | chore(deps): bump zod from 3.23.8 to 3.23.9 | `dependabot/npm_and_yarn/zod-3.23.9` | Open | — | 1d |
| Web #77 | chore(deps-dev): bump eslint from 8.57.0 to 9.6.0 | `dependabot/npm_and_yarn/eslint-9.6.0` | Open | — | 1d |
| Web #76 | chore(deps): bump axios from 1.7.2 to 1.7.3 | `dependabot/npm_and_yarn/axios-1.7.3` | Open | — | 1d |
| Web #75 | chore(deps): bump @hookform/resolvers from 3.6.0 to 3.7.0 | `dependabot/npm_and_yarn/hookform/resolvers-3.7.0` | Open | — | 1d |
| Web #74 | chore(deps-dev): bump vite from 5.3.1 to 5.3.2 | `dependabot/npm_and_yarn/vite-5.3.2` | Open | — | 1d |
| Web #73 | chore(deps): bump actions/setup-node from 4.0.2 to 4.0.3 | `dependabot/github_actions/actions/setup-node-4.0.3` | Open | — | 1d |
| Web #72 | chore(deps): bump actions/checkout from 4.1.6 to 4.1.7 | `dependabot/github_actions/actions/checkout-4.1.7` | Open | — | 1d |

---

## PRs Merged / Closed Today

| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| Parent #73 | fix(ci): health check hits origin direct | Merged | Fixed VPS uptime checks for Cloudflare by hitting origin direct on :8443 |
| Parent #72 | fix(deploy): redact secrets in compose config | Merged | Redacts secrets from compose output on VPS |
| Parent #71 | chore(ci): VPS health-check cron | Merged | Sets up health check cron on VPS |
| Parent #70 | plan(s1b): legal pages, clickwrap, email comms, ui/ux seed | Merged | Added four S1.B execution plans |
| Parent #69 | docs(parent): celery-observability plan + F-014 audit corrections | Merged | Registered F-014 observability plans |
| API #62 | feat(api): F-005 T02 savings goal CRUD API + per-cycle math | Merged | Shipped savings goals CRUD and math |
| API #61 | feat(api): F-005 T01 SavingsGoal model + migration | Merged | Added SavingsGoal model and migration `0016` |
| API #60 | feat(api): land F-010 export and sharing | Merged | Shipped F-010 export and sharing backend |
| API #59 | feat(api): F-010 T04 share token API | Merged | Added share token endpoints |
| API #58 | feat(api): F-010 T02 full JSON backup | Merged | Added full JSON backup export |
| API #57 | feat(api): F-010 T01 transaction CSV export | Merged | Added CSV export endpoint |
| API #56 | feat(api): F-001 balance history (feature branch) | Merged | Added balance history model and migration `0014` |
| API #55 | feat(api): F-004 T04 STS pay-window engine | Merged | Shipped STS pay-window engine |
| API #54 | feat(api): F-004 T03 API serializers | Merged | Added STS API serializers |
| API #53 | feat(api): F-004 T02 bill realism schema | Merged | Added bill realism fields and migration `0013` |
| API #52 | feat(api): add pay-cycle STS window fields (F-004 T01) | Merged | Added pay-cycle fields and migration `0012` |
| API #51 | fix(api): upcoming bill-link mark-paid + overdue recovery | Merged | Fixed bill-link and catch-up |
| Web #90 | feat(web): F-011 T03+T04 landing reflect-shipped + forward roadmap | Merged | Shipped landing page update and forward roadmap |
| Web #89 | feat(web): F-005 T04 dashboard goals widget | Merged | Added dashboard goals widget |
| Web #88 | feat(web): F-005 T03 goals management page | Merged | Added goals management page |
| Web #87 | feat(web): land F-010 export and sharing UI | Merged | Shipped Data Hub export and sharing UI |
| Web #86 | feat(web): F-010 T05 Data hub share UI | Merged | Added share UI to Data Hub |
| Web #85 | feat(web): F-010 T03 Data hub export section | Merged | Added export UI to Data Hub |
| Web #84 | feat(web): F-001 T04 dashboard balance history chart | Merged | Added balance history chart |
| Web #83 | feat(web): recover F-004 T06 web upcoming views | Merged | Recovered STS upcoming views |
| Web #82 | feat(web): F-004 T06 STS pay-period views | Merged | Added STS pay-period views |
| Web #81 | feat(web): F-004 T05 bill editor realism fields | Merged | Added bill realism fields to editor |
| Web #80 | feat(web): production UX batch — nav, i18n labels, etc. | Merged | Shipped production UX improvements |
| Web #60 | fix(offline): correct app profile offline cache sync | Closed | Closed without merge (regex fix already in main, vitest coverage split out) |

---

## VPS State

| Item | State |
|---|---|
| Active color | Green |
| Inactive color | Blue |
| API submodule on VPS | `defd844` (active green) / `42bfd0e` (inactive blue) |
| Web submodule on VPS | `8c117ee` (active green) / `8c493b6` (inactive blue) |
| Pending VPS actions | **High Priority:** The active green stack has the latest Web (`8c117ee`) but is running an older API (`defd844`), meaning it lacks the backend for F-005 (Savings Goals) while the frontend displays it. To resolve this mismatch, the inactive blue stack must be rebuilt with the latest `main` HEADs (API `42bfd0e`, Web `8c117ee`), thoroughly smoked (verifying F-005 and F-011), and then switched to active. |

---

## In-Progress Plans

*None (all previously active plans have been completed and closed out).*

---

## Legal / Compliance Flags

* **Legal Content Polish (N4/N5):** Completed. Removed internal feature codes (e.g., "F-007") from the Terms of Service and Privacy Policy markdown documents to ensure the public legal copy is user-facing clean.
* **Savings Goals Data Collection:** Shipped the `SavingsGoal` model (fields: name, target amount, target date, current amount) in API PR #61, which collects user-defined financial goals.
* **Data Hub Export & Sharing:** Shipped the export and sharing feature (API PR #57–#60, Web PR #85–#87), allowing users to export financial data to CSV/JSON and generate public share links.

---

## Watchlist & Regressions

1. **High - Active Stack Mismatch:** The active green stack has the latest Web (`8c117ee`) but is running an older API (`defd844`), meaning it lacks the backend for F-005 (Savings Goals) while the frontend displays it. This will cause `/app/goals` requests to fail on production.
2. **High - VPS Celery Deployment:** Celery worker and beat containers are not yet running on the VPS environment (the production Podman stack only runs `redis`, `db`, and active `green` web/api). Tasks like the weekly feature digest and F-014 operator alerts will not execute until Celery worker/beat containers are successfully deployed and SMTP credentials (`EMAIL_*` env variables) are set up in the VPS environment.
3. **Medium - Bill Recurrence Engine Revamp:** As logged in anomaly log `2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md`, the current bill-recurrence engine needs a revamp to support non-monthly cycles more robustly.
4. **Low - Stale Containers:** Legacy `finance-manager-db` / `finance-manager-proxy` containers show `Exited (2 weeks ago)` on VPS. These are harmless but should be pruned during the next maintenance pass.

---

## Parked Items

*None.*

---

## Next priorities

1. **Unify Active Stack via VPS Rebuild:** Rebuild the inactive blue stack on VPS with the latest parent `main` HEADs (API `42bfd0e`, Web `8c117ee`), run migrations, smoke test, and switch active color to blue to resolve the API/Web mismatch.
2. **SMTP and Celery Verification on VPS:** Set up SMTP credentials on VPS and verify Celery worker/beat container execution to unblock support email confirmations and F-014 operator alerts.
3. **Wedge Consistency Audit:** Execute the remaining rows (4–12) of the wedge consistency audit under `plans/S1/S1.B/wedge-consistency-audit/`.
4. **Android Pull-Forward:** Begin planning and scaffold setup for pulling the Android app forward to `android:Alpha` per the S1.B exit checklist.
