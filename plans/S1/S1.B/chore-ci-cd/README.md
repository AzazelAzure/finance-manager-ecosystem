---
plan_id: PLAN_CROSS_CI_CD_2026-06-27
status: draft
priority: P1
created: 2026-06-27
updated: 2026-06-27
owner: pproctor
phase: S1.B
plan_root: plans/S1/S1.B/chore-ci-cd/
strategic_link: strategy/strategic-roadmap-reframe-53be/validation_gates.md
depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_CROSS_LEGAL_PAGES_2026-06-27
  - PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27
conflicts_with: []
standalone: true
standalone_notes: >
  Pure infrastructure. No API or web feature code. Safe to run in parallel
  with any open feature plan since it only adds .github/ workflow files and
  repo settings. No migration, no model change, no policy change.
legal_impact:
  tos: false
  privacy_policy: false
  cookie_policy: false
  notes: none
---

# PLAN_CROSS_CI_CD — Minimum Viable CI/CD Pipeline

## §1 Problem

Zero GitHub Actions workflows exist across all repos. Tests exist (30+ API test files, vitest configured in web) but never run automatically. The PR template asks "are CI checks green?" — a question that has no answer. Any PR can merge regardless of test status. Regressions are caught manually, if at all.

This is the highest-weighted gap from the 2026-06-27 operational audit (CI/CD: 1/10, 12% weight).

## §2 Scope

Four tasks across two repos (API + Web) plus the parent repo for the health check cron:

| Task | Repo | What ships |
|---|---|---|
| T01 | `finance-manager-api` | `.github/workflows/api-ci.yml` — pytest + migration check on push/PR |
| T02 | `finance-manager-web` | `.github/workflows/web-ci.yml` — tsc + vitest on push/PR |
| T03 | `finance-manager` (parent) | `.github/workflows/health-check.yml` — cron uptime check every 10 min |
| T04 | Both repos | `.github/dependabot.yml` (pip + npm + actions); branch protection on `main` (GitHub UI) |

**Out of scope:**
- E2E or Playwright tests (future CI/CD phase)
- Deploy-on-merge automation (future; requires VPS webhook setup)
- Coverage thresholds (add after baseline established)
- Linting enforcement (add after CI green baseline; don't block first merge)

## §3 Context for Executor

Before implementing, verify:
- Does `finance_manager_api/` have a `pytest.ini`, `setup.cfg`, or `pyproject.toml` with `[pytest]` config? Check what test database is configured (SQLite acceptable for CI; Postgres requires a service container).
- Does a `settings_test.py` or `TEST` block in `settings.py` exist that overrides the DB?
- In `finance_manager_web/`, confirm `vitest` is in `devDependencies` and `package.json` has a `test` script (`"test": "vitest run"`).
- Identify the API health endpoint path (e.g., `/api/health/`, `/health/`, or `/api/`) for the T03 health check curl.
- Check if there's a Django management command `check` or any existing smoke script to reuse in CI.

## §4 Talking Points (from admin session 2026-06-27)

- **Why self-hosted health check vs external service:** GitHub Actions runs on GitHub's infrastructure, external from the VPS. If the VPS goes down entirely, the cron still fires and fails → GitHub emails the repo owner. Free, no new service required.
- **GitHub Actions schedule caveat:** Scheduled workflows can be delayed by a few minutes. Also disabled if repo has no push activity for 60 days (not a concern for active repos). Acceptable for beta stage uptime monitoring.
- **Dependabot folded in:** Small config file alongside CI — same PR, same executor pass. Opens auto-PRs for dependency updates but does not merge anything automatically.
- **Branch protection last:** Enable branch protection AFTER the first CI run succeeds, so `main` isn't accidentally locked before the workflow is verified.
- **Linting:** Do not enforce lint failures as CI blockers in this pass. First goal is "tests run automatically." Lint can be added to the workflow as a warning step, non-blocking.
- **Audit PR template correction:** Once CI is live and branch protection is on, the PR template's "Required Checks" section becomes truthful. No template edit needed — it was already written correctly, just ahead of reality.

## §5 Tasks

| Task | Title | V-Tier |
|---|---|---|
| T01 | API CI Workflow | V1 |
| T02 | Web CI Workflow | V1 |
| T03 | Health Check Cron | V1 |
| T04 | Dependabot + Branch Protection | V0 (config) + manual (GitHub UI) |

## §6 Execution Order

1. T01 and T02 can be parallel (different repos).
2. T03 can be parallel with T01/T02 (different repo).
3. T04 (branch protection) must come AFTER T01 and T02 workflows have at least one successful run on `main`. Otherwise branch protection will immediately block all PRs.

## §7 Completion Criteria

- [ ] [V1] API CI workflow: `git push` to any branch triggers workflow; `pytest` runs and result is visible in GitHub Actions tab
- [ ] [V1] Web CI workflow: `git push` to any branch triggers workflow; `vitest run` + `tsc --noEmit` runs and result is visible
- [ ] [V1] Health check: workflow is visible in parent repo Actions tab; manual trigger (`workflow_dispatch`) runs and returns pass on a healthy VPS
- [ ] [V0] `main` branch protection active on both API and Web repos; merge requires passing CI
- [ ] [V0] Dependabot config present in both repos; first batch of dependency PRs opened (or confirmed no updates pending)
- [ ] [V0] PR template "Required Checks" section now reflects real check names from GitHub Actions (update `PULL_REQUEST_TEMPLATE.md` if names differ)
