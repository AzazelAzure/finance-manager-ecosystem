# Stale PR Report

**Captured:** 2026-08-10T01:02:28Z (automation cron `0 1 * * 1`)  
**Criterion:** open PRs with **no updates for 7+ days**  
**Repos scanned:** `finance-manager-ecosystem`, `finance-manager-api`, `finance-manager-web`, `finance-manager-cli`, `finance-manager-andriod`, `finance-manager-design-docs`, `finance-manager-rust-middleware`, `finance-manager-rust-tools`

## Summary

| Repo | Open PRs | Stale (7d+) | Theme |
|---|---:|---:|---|
| finance-manager-web | 6 | 6 | Dependabot — npm + GitHub Actions |
| finance-manager-api | 7 | 7 | Dependabot — Python deps + CI actions |
| finance-manager-ecosystem | 2 | 1 | Prior automation deliverables (drafts) |
| finance-manager-cli | 0 | 0 | — |
| finance-manager-andriod | 0 | 0 | — |
| finance-manager-design-docs | 0 | 0 | — |
| finance-manager-rust-middleware | 0 | 0 | — |
| finance-manager-rust-tools | 0 | 0 | — |

**Total stale:** 14 — 13 unattended Dependabot bumps (CI green, mergeable) plus 1 draft ecosystem automation PR with failing governance checks.

**Delta from prior scan (2026-08-03):** API #94 and #95 crossed the 7-day threshold. Ecosystem #127 gained 1 more behind commit (`94e933f` / #131). Web stale set unchanged. No new open PRs in cli/android/design-docs/rust repos.

---

## finance-manager-web

### Theme: Dependabot npm + Actions batch (Jul 6 + Jul 20)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---:|---|---|---|
| [#122](https://github.com/AzazelAzure/finance-manager-web/pull/122) | chore(deps-dev): bump vite from 8.1.0 to 8.1.3 | 34d | 34d ago | ahead 1, **behind 3** | Behind `4e03b05` (#117 PR template), `fc1bc65` (#124 transactions), `516c023` (#125 PWA sync); `MERGEABLE`/`CLEAN`. Main still `vite@^8.1.0`. |
| [#121](https://github.com/AzazelAzure/finance-manager-web/pull/121) | chore(deps-dev): bump typescript-eslint from 8.59.1 to 8.63.0 | 34d | 34d ago | ahead 1, **behind 3** | Same behind commits as #122. Main `typescript-eslint@^8.58.2`. |
| [#120](https://github.com/AzazelAzure/finance-manager-web/pull/120) | chore(deps): bump tailwind-merge from 3.5.0 to 3.6.0 | 34d | 34d ago | ahead 1, **behind 3** | Same behind commits as #122. Main `tailwind-merge@^3.5.0`. |
| [#119](https://github.com/AzazelAzure/finance-manager-web/pull/119) | chore(deps): bump motion from 12.42.0 to 12.42.2 | 34d | 34d ago | ahead 1, **behind 3** | Same behind commits as #122. Main `motion@^12.42.0`. |
| [#118](https://github.com/AzazelAzure/finance-manager-web/pull/118) | chore(deps-dev): bump vite-plugin-pwa from 1.2.0 to 1.3.0 | 34d | 34d ago | ahead 1, **behind 3** | Same behind commits as #122. Main `vite-plugin-pwa@^1.2.0`. |
| [#123](https://github.com/AzazelAzure/finance-manager-web/pull/123) | chore(deps): bump actions/setup-node from 6 to 7 | 20d | 20d ago | ahead 1, **behind 2** | Behind `fc1bc65` (#124), `516c023` (#125); `MERGEABLE`/`CLEAN`, CI green. Main still `actions/setup-node@v6`. |

---

## finance-manager-api

### Theme: Dependabot Python deps batch (Jul 6)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---:|---|---|---|
| [#92](https://github.com/AzazelAzure/finance-manager-api/pull/92) | chore(deps-dev): bump setuptools from 82.0.1 to 83.0.0 | 35d | 35d ago | ahead 1, **behind 1** | Behind `b7e6c86` (#96 profile snapshot source filter); `MERGEABLE`/`CLEAN`. Main `setuptools==82.0.1`. |
| [#91](https://github.com/AzazelAzure/finance-manager-api/pull/91) | chore(deps): bump pycountry from 22.3.5 to 26.2.16 | 35d | 35d ago | ahead 1, **behind 1** | Same behind commit. **Review risk:** major-version jump (22 → 26); smoke locale/country lookups before merge. |
| [#90](https://github.com/AzazelAzure/finance-manager-api/pull/90) | chore(deps): bump django-allauth from 65.16.1 to 65.18.0 | 35d | 35d ago | ahead 1, **behind 1** | Same behind commit. Main `django-allauth>=65.16.1`. |
| [#89](https://github.com/AzazelAzure/finance-manager-api/pull/89) | chore(deps): bump idna from 3.15 to 3.18 | 35d | 35d ago | ahead 1, **behind 1** | Same behind commit. Main `idna==3.15`. |
| [#88](https://github.com/AzazelAzure/finance-manager-api/pull/88) | chore(deps): bump psycopg from 3.2.4 to 3.3.4 | 35d | 35d ago | ahead 1, **behind 1** | Same behind commit. Main `psycopg==3.2.4`. |

### Theme: Dependabot CI actions batch (Jul 27)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---:|---|---|---|
| [#95](https://github.com/AzazelAzure/finance-manager-api/pull/95) | chore(deps): bump actions/checkout from 7.0.0 to 7.0.1 | 14d | 14d ago | ahead 1, **behind 1** | Behind `b7e6c86`; `MERGEABLE`/`CLEAN`, CI green. Diff refreshes checkout SHA pin (still annotated `v4.3.0`). |
| [#94](https://github.com/AzazelAzure/finance-manager-api/pull/94) | chore(deps): bump astral-sh/setup-uv from 8.2.0 to 9.0.0 | 14d | 14d ago | ahead 1, **behind 1** | Same behind commit. **Major** uv action bump (8 → 9); CI green on last run. Main still `setup-uv@… # v8.2.0`. |

---

## finance-manager-ecosystem

### Theme: Prior automation deliverables (drafts)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---:|---|---|---|
| [#127](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/127) | chore(automation): weekly stale PR report (2026-07-27) | 14d | 14d ago | ahead 1, **behind 5** | **Draft.** CI failures: `pr-body`, `branch-prefix`. Behind orchestrator/proxy commits (#128, #129, #131) and vhost fixes (`fcbc0cf`, `0470204`). Superseded — close without merge. |

### Not yet stale (watch — crosses 7d today if untouched)

| PR | Title | Age | Last update | Notes |
|---|---|---:|---|---|
| [#130](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/130) | chore(automation): weekly stale PR report (2026-08-03) | 7d | 7d ago | **Draft.** CI failures: `pr-body`, `branch-prefix`. Behind 1 (`94e933f` / #131). Superseded by this report. |

---

## Repos with no open PRs

`finance-manager-cli`, `finance-manager-andriod`, `finance-manager-design-docs`, `finance-manager-rust-middleware`, `finance-manager-rust-tools`

---

## Recommended actions

1. **Close ecosystem #127 and #130** — draft automation deliverables superseded by this report.
2. **Batch triage Dependabot** — route API batch (#88–#92, #94–#95) and Web batch (#118–#123) through WS3; all mergeable with green CI.
3. **Rebase before merge** — Web #118–#122 need `main` merged in (3 commits behind); Web #123 needs 2 commits; API batch needs 1 commit (`b7e6c86`).
4. **API #91 (pycountry)** — targeted smoke on country/locale paths before merging 22 → 26 jump.
5. **API #94 (setup-uv 9.0.0)** — review major action bump before merge.

---

*Generated by Cursor automation [Stale PR Check](https://cursor.com/automations/725b82d2-70f4-11f1-8cbf-12b154d6cb29). Canonical copy: `strategy/automations/reports/stale_pr_report.md` only.*
