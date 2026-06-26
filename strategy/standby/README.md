# Standby Readiness — Consolidated Summary

**Updated:** 2026-06-26 (post-execution)  
**Scope:** Pre-VPS inactive-color test gate.  
**Detail reports:** [`open_prs_assessment.md`](./open_prs_assessment.md) · [`uncommitted_work_status.md`](./uncommitted_work_status.md) · [`../active_vs_research_comparison.md`](../active_vs_research_comparison.md)

---

## Current `origin/main` (reconciled)

| Field | Value |
|-------|-------|
| Parent HEAD | `86f7063` — F-013 landed (#61 merged) + governance overhaul (#62 merged) |
| API pin | `7b6f564` (F-012 + F-013 diagnostic logs) |
| Web pin | `e66c2bb` (F-012 support intake + F-007 lineage) |
| Pending submodule PRs | API [#35](https://github.com/AzazelAzure/finance-manager-api/pull/35) (`a97116b`), Web [#62](https://github.com/AzazelAzure/finance-manager-web/pull/62) (`fb9f4c9`) |

VPS green stack remains on **stale SHAs** (web `3e2b370` @ `agy/s1b/feat/landing-page-ux-seo`, api `1833e74` @ `main`).

---

## PR actions completed

| PR | Action | Result |
|----|--------|--------|
| **#58** | CLOSE | ✅ Closed — stale conflicting API submodule sync |
| **#60** | CLOSE | ✅ Closed — F-012 superseded by `main` |
| **#61** | MERGE | ✅ Merged → parent `86f7063` |
| **#57, #59** | CLOSE | Already closed (daily-status relics) |
| **#62** | MERGE | ✅ Governance overhaul merged into `main` |

---

## Local code — completed

| Workstream | Branch | PR | Status |
|------------|--------|-----|--------|
| API security hardening | `cur/s1b/feat/api-security-hardening` | [API #35](https://github.com/AzazelAzure/finance-manager-api/pull/35) | Committed `a97116b`; `manage.py check` passes |
| Web build + CSP + header cleanup | `cur/s1b/fix/build-csp-tour-cleanup` | [Web #62](https://github.com/AzazelAzure/finance-manager-web/pull/62) | Committed `fb9f4c9`; `npm run build` passes |

F-007 sandbox overlay (T01/T02) **deferred** — not started; no dead-button regression on `fb9f4c9`.

---

## VPS sync gate: **NOT CLEAR** (remaining blockers)

Clear when:

1. Merge API #35 and Web #62 (or accept `7b6f564` / `e66c2bb` without security/CSP slices).
2. Open parent submodule-pointer PR bumping to post-merge SHAs.
3. Resolve API finance migration graph conflict (`0004` vs `0008` leaves) before `migrate` on VPS.
4. Run `python manage.py migrate axes` on inactive color after API security deploy.

Green stack smoke **passed** 2026-06-26 — do not rebuild green until HitM approves.

---

## Target deploy SHAs (after submodule PRs merge)

| Repo | SHA | Notes |
|------|-----|-------|
| Parent | `86f7063` + pointer bump PR | Compose/redis/celery from F-012 |
| API | `a97116b` (preferred) or `7b6f564` (F-013 only) | Security PR adds axes + Argon2 |
| Web | `fb9f4c9` (preferred) or `e66c2bb` (F-012 only) | CSP + header cleanup |

---

## VPS inactive-color next commands (HitM)

```bash
ssh dev@159.198.75.194

# API — checkout target SHA on inactive deploy path only
cd ~/finance_manager/finance_manager_api
git fetch origin
git checkout a97116b   # or 7b6f564 if security PR deferred

# Web — leave green on current branch until blue validated
cd ~/finance_manager/finance_manager_web
git fetch origin
git checkout fb9f4c9   # or e66c2bb if web PR deferred

# Rebuild INACTIVE color only (blue while green is active)
cd ~/finance_manager
scripts/fm_server_beta.sh status
scripts/fm_server_beta.sh rebuild-color --no-cache blue
scripts/fm_server_beta.sh smoke --color blue

# After smoke: HitM may scripts/fm_server_beta.sh switch --to blue
# Do NOT switch without explicit approval
```

**Pre-deploy on inactive API container:** `python manage.py migrate` (including `axes` once security PR lands).

---

*Executor: Cursor standby queue run 2026-06-26.*
