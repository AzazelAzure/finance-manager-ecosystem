# Daily Engineering Digest — June 30, 2026

**Date range covered:** 2026-06-29 to 2026-06-30

---

## Key Changes

### Local Security Audit Suite
* **Category:** Infrastructure & Security
* **Implementation:** Completed T01, T02, and T04 of [PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29](file:///home/pproctor/Documents/python/finance_manager/governance/plan_registry.md#L28). Added a security audit tool verification script ([check_tools.sh](file:///home/pproctor/Documents/python/finance_manager/scripts/security/check_tools.sh)), an audit runner script ([security_audit.sh](file:///home/pproctor/Documents/python/finance_manager/scripts/security/security_audit.sh)), and anomaly queue integration ([lib_anomaly_write.sh](file:///home/pproctor/Documents/python/finance_manager/scripts/security/lib_anomaly_write.sh)).
* **Remediation:** Fixed `gitleaks` scanning for submodule `.git` directories and resolved a stacked-PR base branch merge issue via corrective [PR #77](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/77).

### Bill Recurrence Engine
* **Category:** Backend & Frontend Feature
* **Backend:** Shipped first-class `bill_cadence` fields to `UpcomingExpense` via migration `0017_upcomingexpense_bill_cadence` and implemented a cadence-driven recurrence engine in [API PR #63](https://github.com/AzazelAzure/finance-manager-api/pull/63), [API PR #64](https://github.com/AzazelAzure/finance-manager-api/pull/64), and [API PR #65](https://github.com/AzazelAzure/finance-manager-api/pull/65).
* **Frontend:** Added the bill cadence selector and labels to the upcoming expenses UI in [Web PR #91](https://github.com/AzazelAzure/finance-manager-web/pull/91).
* **Verification:** Successfully deployed to VPS inactive BLUE color, ran migrations, and verified functionality.

### Inactive Blue Polish & Promotion
* **Category:** Backend, Frontend & Operations
* **Privacy Hardening:** Disabled all public share-link endpoints and removed the sharing UI from the Data Hub in [API PR #66](https://github.com/AzazelAzure/finance-manager-api/pull/66) and [Web PR #92](https://github.com/AzazelAzure/finance-manager-web/pull/92) to address the F-010 share-link exposure risk.
* **UX Polish:** Expanded guide-mode and walkthrough coverage across all major views in [Web PR #95](https://github.com/AzazelAzure/finance-manager-web/pull/95). Restructured the Data Hub and Profile pages in [Web PR #94](https://github.com/AzazelAzure/finance-manager-web/pull/94). Added savings goals navigation, mobile home link, and dashboard widget polishing in [Web PR #93](https://github.com/AzazelAzure/finance-manager-web/pull/93).
* **Form Walkthrough Fix:** Disabled broken auto-start Joyride tours on modal forms (Quick Add, Transactions, and Upcoming editors) in [Web PR #96](https://github.com/AzazelAzure/finance-manager-web/pull/96) to prevent background rendering issues, retaining per-field guide mode.
* **Promotion:** Rebuilt inactive BLUE stack on VPS with the latest heads, ran migrations, performed smoke tests, and promoted BLUE to active.

### Design Docs Restructure
* **Category:** Documentation & Planning
* **Restructure:** Merged [PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29](file:///home/pproctor/Documents/python/finance_manager/governance/plan_registry.md#L64) via [Parent PR #80](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/80). Archived historical Reflex/alpha docs, retired duplicate roadmap/versioning docs, updated sync protocol, and updated dashboard pointers.
* **Plan Updates:** Authored task files for `PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009_2026-05-05` and `PLAN_CROSS_DASHBOARD_WIDGETS_F006_2026-05-05` and promoted them to Ready for Execution.

---

## Open PRs

| PR # | Title | Branch | Status | Plan | Age |
|---|---|---|---|---|---|
| API #71 | chore(deps): bump tzdata from 2024.1 to 2026.1 | `dependabot/uv/tzdata-2026.1` | Open | — | <1d |
| API #70 | chore(deps): bump cryptography from 42.0.7 to 42.0.8 | `dependabot/uv/cryptography-42.0.8` | Open | — | <1d |
| API #69 | chore(deps-dev): bump coverage from 7.5.3 to 7.5.4 | `dependabot/uv/coverage-7.5.4` | Open | — | <1d |
| API #68 | chore(deps-dev): bump setuptools from 70.1.0 to 70.1.1 | `dependabot/uv/setuptools-70.1.1` | Open | — | <1d |
| API #67 | chore(deps-dev): bump pytest from 8.2.1 to 8.2.2 | `dependabot/uv/pytest-8.2.2` | Open | — | <1d |

---

## PRs Merged / Closed Today

| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| Parent #82 | docs: inactive blue polish jsdevtesting checklist | Merged | Inactive blue checklist documentation. |
| Parent #81 | docs(audit): F-010 share-link exposure RCA + hardening stub | Merged | Share-link exposure RCA and hardening stub. |
| Parent #80 | chore(docs): bump design_docs submodule for vault restructure (D6) | Merged | Restructured design docs submodule. |
| Parent #79 | fix(deploy): nginx check uses live proxy or resolver stub | Merged | Fixes deploy script nginx verification. |
| Parent #78 | chore(scripts): live VPS state, refactor gather_doc_context | Merged | Added VPS state script. |
| Parent #77 | chore(security): land local audit suite T04 (anomaly queue integration) onto main | Merged | Lands security audit T04 anomaly integration on main. |
| Parent #75 | Local security audit T02: audit runner script | Merged | Security audit runner script. |
| Parent #74 | Local security audit T01: tool setup | Merged | Security audit tool setup. |
| API #66 | fix(export): disable public share-link endpoints (privacy shutdown) | Merged | Disabled all public share-link endpoints for privacy. |
| API #65 | Bill recurrence T03: cadence API exposure + validation | Merged | Exposed cadence validation. |
| API #64 | Bill recurrence T02: cadence-driven recurrence engine | Merged | Core cadence-driven recurrence logic. |
| API #63 | Add first-class cadence fields to UpcomingExpense (T01) | Merged | Added cadence fields to UpcomingExpense. |
| Web #96 | fix(tours): disable auto-start Joyride on modal forms | Merged | Disabled Joyride modal form walkthroughs due to background rendering issues. |
| Web #95 | Web: Guide mode + walkthrough expansion (Theme 4) | Merged | Expanded guide mode and walkthroughs. |
| Web #94 | feat(web): Data Hub + Profile restructure (Theme 3) | Merged | Restructured Data Hub and Profile. |
| Web #93 | feat(nav): goals nav, mobile home link, dashboard polish | Merged | Polished navigation and widgets. |
| Web #92 | fix(data-hub): remove share-link UI (privacy shutdown) | Merged | Removed share-link UI. |
| Web #91 | Add bill cadence selector and labels to upcoming UI (T04) | Merged | Cadence selector in UI. |

---

## VPS State

| Item | State |
|---|---|
| Active color | Blue |
| Inactive color | Green |
| API submodule on VPS | `a9f7972` |
| Web submodule on VPS | `ed8d2a2` (submodule branch points to `7832dbf`) |
| Pending VPS actions | None |

---

## In-Progress Plans

| Plan | Status | What's moving | Blocker |
|---|---|---|---|
| `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29` | in_progress | T01, T02, T04 merged; T03 (weekly cron + prompt) pending | none |

---

## Watchlist & Regressions

1. **High - `sprint_verify.sh` Skips Smoke Checks:** As logged in [2026-06-29_BILL-RECURRENCE_sprint-verify-skips-smoke.md](file:///home/pproctor/Documents/python/finance_manager/strategy/anomalies/2026-06-29_BILL-RECURRENCE_sprint-verify-skips-smoke.md), the `--smoke` flag in `scripts/sprint_verify.sh` is currently a no-op because the `DO_SMOKE` environment variable is prefix-assigned on the SSH command line and does not propagate to the remote heredoc'd `bash -s` environment. Smoke checks must be run manually via `fm_server_beta.sh` on the VPS until fixed.
2. **Medium - Local Support Tests Require Live Redis:** As logged in [2026-06-29_BILL-RECURRENCE_support-tests-require-live-redis.md](file:///home/pproctor/Documents/python/finance_manager/strategy/anomalies/2026-06-29_BILL-RECURRENCE_support-tests-require-live-redis.md), 24 support-ticket tests fail locally if Redis is not running because Celery's result backend raises a reconnection error during the request path. Local runs require starting Redis via Podman/Docker, and the test suite should be hardened to use eager Celery suite-wide.
3. **Medium - Modal Form Joyride Tours Broken:** As logged in [2026-06-29_INACTIVE-POLISH_modal-form-joyride-broken.md](file:///home/pproctor/Documents/python/finance_manager/strategy/anomalies/2026-06-29_INACTIVE-POLISH_modal-form-joyride-broken.md), auto-start Joyride tours inside modal forms render behind or outside the modal overlay, creating a broken UI. Modal form tours were disabled in Web PR #96 as a temporary fix; a permanent design pass is needed to either portal Joyride into the modal z-stack or rely solely on guide mode.
4. **Medium - VPS Celery Deployment:** Celery worker and beat containers are not yet running on the VPS environment (the production Podman stack only runs `redis`, `db`, and active `blue` web/api). Tasks like the weekly feature digest and F-014 operator alerts will not execute until Celery worker/beat containers are successfully deployed and SMTP credentials (`EMAIL_*` env variables) are set up in the VPS environment.

---

## Parked Items

| Item | Parked since | Resume trigger |
|---|---|---|
| _(none)_ | | |

---

## Next priorities

1. **Fix `sprint_verify.sh` Environment Passthrough:** Resolve the SSH heredoc environment variable propagation issue so `--smoke` works correctly during deployments.
2. **Harden Local Test Suite (Celery Eager):** Update `conftest.py` to enable `CELERY_TASK_ALWAYS_EAGER` suite-wide or retrofit support tests to use `patch_all_support_delays` to remove local Redis dependencies.
3. **SMTP and Celery Verification on VPS:** Set up SMTP credentials on VPS and verify Celery worker/beat container execution to unblock support email confirmations and F-014 operator alerts.
4. **Wedge Consistency Audit:** Execute the remaining rows (4–12) of the wedge consistency audit under `plans/S1/S1.B/wedge-consistency-audit/`.
5. **Android Pull-Forward:** Begin planning and scaffold setup for pulling the Android app forward to `android:Alpha` per the S1.B exit checklist.
