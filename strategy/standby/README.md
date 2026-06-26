# Standby Readiness — Consolidated Summary

**Updated:** 2026-06-26 (post-execution)  
**Scope:** Pre-VPS inactive-color test gate.  
**Detail reports:** [`open_prs_assessment.md`](./open_prs_assessment.md) · [`uncommitted_work_status.md`](./uncommitted_work_status.md) · [`../active_vs_research_comparison.md`](../active_vs_research_comparison.md)

---

## Current `origin/main` (reconciled)

| Field | Value |
|-------|-------|
| Parent HEAD | `1716b4b` — #64 merged; parent pins standby submodules |
| Target API pin | `789b266` (F-013 + security hardening + migration merge) |
| Target Web pin | `4ad032a` (F-012 lineage + build/CSP/header cleanup) |
| Submodule PRs | API #35 and Web #62 merged |

VPS **green** remains active. VPS **blue** has been rebuilt and smoked with the target SHAs.

---

## PR actions completed

| PR | Action | Result |
|----|--------|--------|
| **#58** | CLOSE | ✅ Closed — stale conflicting API submodule sync |
| **#60** | CLOSE | ✅ Closed — F-012 superseded by `main` |
| **#61** | MERGE | ✅ Merged → parent `86f7063` |
| **#57, #59** | CLOSE | Already closed (daily-status relics) |
| **#62** | MERGE | ✅ Governance overhaul merged into `main` |
| **#64** | MERGE | ✅ Parent pointer bump merged → `1716b4b` |

---

## Local code — completed

| Workstream | Branch | PR | Status |
|------------|--------|-----|--------|
| API security hardening | `cur/s1b/feat/api-security-hardening` | [API #35](https://github.com/AzazelAzure/finance-manager-api/pull/35) | Committed `a97116b`; `manage.py check` passes |
| Web build + CSP + header cleanup | `cur/s1b/fix/build-csp-tour-cleanup` | [Web #62](https://github.com/AzazelAzure/finance-manager-web/pull/62) | Committed `fb9f4c9`; `npm run build` passes |

F-007 sandbox overlay (T01/T02) **deferred** — not started; no dead-button regression on `fb9f4c9`.

---

## VPS sync gate: **BLUE READY** (cutover requires HitM)

Completed:

1. Parent submodule-pointer PR #64 merged.
2. Inactive blue rebuilt with API `789b266` and Web `4ad032a`.
3. Finance migrations through `0009_merge_20260626` and axes migrations verified/applied.
4. Smoke passed for both blue and green.

Green remains active. Do not switch to blue until HitM approves cutover.

---

## Target deploy SHAs (after submodule PRs merge)

| Repo | SHA | Notes |
|------|-----|-------|
| Parent | `1716b4b` | Pins API/Web standby SHAs |
| API | `789b266` | Security PR adds axes + Argon2; includes merge migration |
| Web | `4ad032a` | CSP + header cleanup; build passes |

---

## VPS cutover command (HitM only)

```bash
ssh dev@159.198.75.194

cd ~/finance_manager
scripts/fm_server_beta.sh status
scripts/fm_server_beta.sh smoke --color blue
scripts/fm_server_beta.sh switch --to blue
scripts/fm_server_beta.sh smoke --color blue
# Do NOT switch without explicit approval
```

**Pre-deploy on inactive API container:** `python manage.py migrate` (including `axes` once security PR lands).

---

*Executor: Cursor standby queue run 2026-06-26.*
