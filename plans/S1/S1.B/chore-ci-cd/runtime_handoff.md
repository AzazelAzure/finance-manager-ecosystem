# Runtime Handoff — PLAN_CROSS_CI_CD

Hard limit: 200 lines. Keep current.

## Status snapshot (2026-06-28)

Plan: `completed`. Workflow files for all four tasks authored, pushed, PR'd,
merged, and deployed to the VPS. **API CI and Web CI are confirmed GREEN on
`main`.** Dependabot opened the first API/Web dependency PR batches.

Closeout criteria status:

- **T03.SL2 complete:** the first dispatch `28306433192` failed with
  web `403`. Root cause: `thehivemanager.com` / `api.thehivemanager.com` are
  behind **Cloudflare**, which blocks GitHub-runner datacenter IPs at the edge
  before the request reaches the VPS. Fix (PR #73,
  branch `cur/s1b/fix/health-check-cloudflare-bypass`) pins each host to the VPS
  origin IP via `curl --resolve` + `-k` (origin uses an internal cert), giving a
  true origin-up signal. Verified GREEN on the branch: dispatch `28306551715`
  returned web `200` and `/api/health/` `200`. PR #73 merged 2026-06-28, then
  main dispatch `28306647911` returned web `200` and `/api/health/` `200`.
- **T04.SL3 waived by HitM:** API/Web branch protection API returns
  `403` ("Upgrade to GitHub Pro or make this repository public to enable this
  feature") for private repos. HitM explicitly declined GitHub Pro and public
  repo visibility on 2026-06-28; waiver accepted for the closed-loop beta.

## PRs opened (executor: Cursor; merge: HitM)

| Task | Repo | Branch | PR |
|---|---|---|---|
| T01 + T04.SL1 | finance-manager-api | `cur/s1b/chore/api-ci` | https://github.com/AzazelAzure/finance-manager-api/pull/43 |
| T02 + T04.SL2 | finance-manager-web | `cur/s1b/chore/web-ci` | https://github.com/AzazelAzure/finance-manager-web/pull/71 |
| T03 | finance-manager-ecosystem (parent) | `cur/s1b/chore/health-check` | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/71 |

## What shipped

- **API CI** (`.github/workflows/api-ci.yml`): `uv sync --frozen` (Python 3.12) →
  `pytest` → `makemigrations --check --dry-run`. `redis:7` service container +
  `REDIS_URL`. SQLite fallback (no Postgres service). Dependabot: `uv` + actions.
- **Web CI** (`.github/workflows/web-ci.yml`): `npm ci` → `tsc -b` → `vitest run`
  on Node 22. Dependabot: `npm` + actions.
- **Health check** (parent `.github/workflows/health-check.yml`): cron `*/10` +
  `workflow_dispatch`; checks web and API origin health directly with
  `curl --resolve` to bypass Cloudflare runner blocks.

## Deviations from task templates (all intentional, documented in PRs)

1. API uses `uv`, not `pip install -r requirements.txt`.
2. API needs **Redis** (ObservabilityMiddleware + DRF throttling) — added a
   service container. Postgres NOT needed (SQLite fallback).
3. `makemigrations --check --dry-run` replaces template's `migrate --check`
   (which always fails on a fresh CI DB).
4. Web uses `tsc -b` (solution-style `tsconfig.json`; `--noEmit` checks nothing).
5. API Dependabot ecosystem is `uv` (tracks `uv.lock`), not `pip`.

## CI-only failures fixed (API PR #43) — surfaced by the first runs

Local runs alone were misleading (the dev machine already had cached data). The
real CI runs exposed two environment gaps + stale tests. API CI is now green.
- **Redis** (24 failures): `ObservabilityMiddleware` + DRF throttling use the
  Redis-backed cache → added a `redis:7` service container + `REDIS_URL`.
- **Exchange-rate data** (222 failures): `finance/data/` is gitignored, so
  `exchange_rates.zip` is absent on a fresh checkout → currency converter loads
  zero currencies → `IndexError: Cannot choose from an empty sequence` in test
  setup. Added a pre-test `manage.py update_conversion_file` step (downloads the
  ECB dataset) with a `test -f` guard.
- **3 stale tests** aligned to shipped behavior:
  - `test_permission_defaults.py` (x2): now send `tos_version`/`tos_accepted_at`
    (required since ToS clickwrap PR #42).
  - `test_support_adversarial.py::test_parameter_injection_spoofing_uid`: now
    asserts `emailed=True` for BUG tickets (view sets it after operator dispatch,
    F-012/F-014; `emailed` is read-only on the serializer so anti-spoof is intact).

- **Test suite flakiness** (HitM-approved fix-now): the transaction test base
  builds data with unseeded random currencies/sources/amounts, so a couple of
  currency-sensitive assertions flaked. Added `conftest.py` seeding
  `random`/`factory.random`/`Faker` per test (`FM_TEST_SEED` override) + made the
  calendar month-boundary and safe-to-spend snapshot tests currency/source-stable.
  Verified green across **5 seeds** (285 passed/0 failed each).

Result: API CI `test` job = **success** on both push and pull_request runs
(deterministic, no longer flaky). Web CI `ci` job = **success**.

Minor follow-up: `actions/checkout@v4` + `astral-sh/setup-uv@v6` emit a Node 20
deprecation warning (auto-run on Node 24); non-blocking, bump when convenient.

## Remaining steps

None for this plan. T04.SL3 is waived for private repos without GitHub Pro.

## Historical notes

- **Evidence** — optional but useful: capture Actions-tab screenshots for API
  run `28305288437`, Web run `28305298483` or `28305751301`, failed Health
  Check run `28306433192`, and fixed main Health Check run `28306647911`.
- **PR template** (§7 V0) — checked API/Web on `main`; no repo-local PR template
  files found, so no template edit is required unless a parent/global template is
  later introduced.

## Runtime owner (released 2026-06-28)

- VPS ownership **released** in `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
- VPS left **live** on active **blue** (no teardown). Next agent needing
  `fm_server_beta.sh` lifecycle must claim ownership in the signup sheet first.

## Notes

- Web repo had in-progress uncommitted work on `cur/s1b/integration/ui-fixes-verify`;
  the web CI branch was built in a throwaway `git worktree` off `origin/main` so that
  work was never touched.
- Parent CHANGELOG + this handoff/plan-status update live on local parent `main`
  (governance docs are not pushed through the health-check PR).
