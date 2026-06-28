# Uncommitted Work Status — Standby Review

**Generated:** 2026-06-26  
**Purpose:** Exact status of in-flight local changes before VPS sync. No commits performed.

---

## 1. API (`finance_manager_api`) — Security Hardening WIP

### What it does

| File | Change |
|------|--------|
| `finance_api/settings.py` | `django-axes` in INSTALLED_APPS + MIDDLEWARE; `AxesStandaloneBackend`; Argon2 first in `PASSWORD_HASHERS`; min password length 12; `ComplexPasswordValidator`; HSTS default 1yr + subdomains + preload; `SECURE_CONTENT_TYPE_NOSNIFF`; `X_FRAME_OPTIONS = DENY` |
| `pyproject.toml` / `uv.lock` | `argon2-cffi>=25.1.0`, `django-axes>=8.3.1` |
| `finance/validators/password_complexity.py` | **Untracked** — uppercase, lowercase, number, special-char rules |

### Completeness verdict: **~85% — not deploy-ready**

| Check | Status |
|-------|--------|
| Validator path `finance.validators.password_complexity.ComplexPasswordValidator` | ✅ Valid — `finance/validators/__init__.py` exists |
| `password_complexity.py` tracked in git | ❌ Untracked — must `git add` |
| django-axes migrations | ⚠️ **Required** — `python manage.py migrate axes` before deploy; lockout DB tables |
| Axes settings completeness | ⚠️ Partial — no `AXES_RESET_ON_SUCCESS`, lockout response template, or API-specific lockout behavior for JWT vs session |
| HSTS defaults in dev | ⚠️ Risk — defaults to 1yr HSTS even when env unset; may break local HTTP unless env overrides kept |
| Tests | ❌ None added |
| CHANGELOG | ❌ Not updated |

### Deploy-readiness risks

- **Axes without migrate** → startup errors or silent lockout failure.
- **HSTS 1yr default** on non-TLS dev stacks if env not set.
- **Password complexity** applies on next password change/set — existing users unaffected until reset.

### Recommended next step

1. `git add finance/validators/password_complexity.py`
2. Run `migrate axes` in container/local; verify lockout after 5 failures
3. Confirm HSTS defaults are env-gated for local `:8443` / Lane A
4. Add API CHANGELOG entry; CPPRD on feature branch (separate from F-012 rebase)
5. **Do not deploy with VPS sync** until migrated and smoke-tested on inactive color

---

## 2. Web (`finance_manager_web`) — Sandbox Tour WIP + CSP

### What it does

| File | Change |
|------|--------|
| `index.html` | CSP meta tag (self + api hosts + fonts + unsafe-inline/eval for Vite/Joyride) |
| `DashboardPage.tsx` | Removed auto-start `dashboard_linear_tour` useEffect; guide Button **stripped of onClick and icon** |
| `QuickActions.tsx` | Removed force-restart `true` from two `startTour(...)` calls |
| `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx` | Minor tour arg edits |

Aligns with untracked plan `plans/S1/S1.B/feat-f007-walkthrough-sandbox/` (T01 hover tooltips, T02 sandbox overlay) — **plan not implemented**, only partial removal of old tour behavior.

### Completeness verdict: **~30% — partial / broken UX**

| Check | Status |
|-------|--------|
| `useEffect` / `HelpCircle` unused imports | ✅ Removed with useEffect (HelpCircle was removed from imports) |
| `startTour` still used | ✅ Yes — welcome replay button |
| Dead guide Button (lines ~234–241) | ❌ **Empty button** — visible "Start guide" with no onClick; duplicate refresh row (two refresh button groups in header) |
| Sandbox overlay / hover Help Mode (T01/T02) | ❌ Not implemented |
| TypeScript / lint | ⚠️ Likely passes (no unused imports flagged) but **UX regression** |
| CSP vs runtime | ⚠️ Medium risk — `connect-src` lists prod/dev API hosts; may miss `localhost` Vite proxy or tunnel hostnames; Joyride needs `unsafe-inline` styles (style-src allows inline) |

### CSP risk assessment

- **Prod `:8443`:** Likely OK if API same-origin or listed hosts match proxy routing.
- **Local Vite (5173):** May block API if base URL not in `connect-src`.
- **`unsafe-eval`:** Required for Vite dev; acceptable for dev, review for prod hardening.

### Recommended next step

**Do not commit as-is.** Either:

- **A)** Revert web WIP and ship VPS sync from clean `main` only, **or**
- **B)** Finish sandbox plan (T01/T02), remove dead Button / duplicate header actions, test CSP on inactive color, then CPPRD

---

## 3. Parent Untracked Inventory

| Path | Classification | Notes |
|------|----------------|-------|
| `cache/projects.json` | **(c) cruft** | Antigravity cache; gitignore candidate |
| `governance/agent_context_delivery.md` | **(a) doc** | Ready to commit when governance overhaul lands |
| `governance/archived/*` | **(a) doc** | Archived cursor-rules / slack docs |
| `governance/examples/*` | **(a) doc** | Sprint spec example |
| `governance/security_protocols.md` | **(a) doc** | Pairs with API hardening WIP |
| `governance/sprint_task_specification.md` | **(a) doc** | Defer to governance overhaul |
| `plans/S1/S1.B/feat-f007-walkthrough-sandbox/*` | **(b) plan** | Needs linked web feature work |
| `scripts/orchestrator.py` | **(a) artifact** | Antigravity wrapper; commit with orchestration decision |
| `strategy/cursor_vs_claude_max_cba.md` | **(a) doc** | Ready to commit |
| `strategy/current_status.md` | **(a) doc** | Ready to commit |
| `strategy/active_vs_research_comparison.md` | **(a) doc** | Ready to commit |
| `strategy/standby/*` | **(a) doc** | This standby pack |
| `strategy/huddles/admin-meeting-huddle-prep-2026-05-06/*` | **(a) doc** | Session notes; large pack |

Governance reconciliation **explicitly deferred** by HitM.

---

## 4. Standby Readiness Summary

| Change set | Commit-ready? | Blocker |
|------------|---------------|---------|
| API security hardening | **No** | Untracked validator; axes migrate; HSTS dev gating; tests/CHANGELOG |
| Web sandbox/CSP WIP | **No** | Dead button, duplicate header, T01/T02 not built |
| Strategy/standby docs | **Yes** | Optional batch commit (no code deps) |
| F-012/F-013 (on PR branches) | **No** | Rebase onto `main` submodules first (#60 → #61) |
| Governance untracked pack | **Defer** | HitM admin overhaul |

### Suggested standby sequence (matches open PR assessment)

1. Close stale PR #58  
2. Rebase/merge F-012 (#60) then F-013 (#61)  
3. Finish or revert API security WIP; migrate axes; smoke  
4. Finish or revert web sandbox WIP  
5. Commit strategy/standby docs (optional)  
6. VPS sync + inactive-color rebuild  

---

*Verified via `git status`, `git diff`, file reads in api/web submodules.*
