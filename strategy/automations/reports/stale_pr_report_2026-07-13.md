# Stale PR Report — 2026-07-13

**Captured (UTC):** 2026-07-13T01:00:39Z  
**Stale threshold:** last activity ≥7 days ago (`updatedAt` before 2026-07-06T01:00:39Z)  
**Repos scanned:** 8 (parent ecosystem + 7 sub-repos per `scripts/repos.txt` + `finance-manager-design-docs`)

---

## Summary

| Metric | Count |
|---|---|
| Open PRs (all repos) | 11 |
| **Stale PRs (7+ days, no updates)** | **0** |
| Repos with stale PRs | 0 |
| Near-stale (6d+ idle, crosses threshold within 24h) | 6 (API) |

**Headline:** No PRs have crossed the 7-day idle threshold yet. The entire open queue is an unmerged Dependabot batch (6 API + 5 Web) opened 2026-07-06. API PRs become stale after ~07:25 UTC today; Web PRs after ~23:45 UTC tonight.

---

## Stale PRs by repo

### finance-manager-ecosystem

*None.*

### finance-manager-api

*None (6 open Dependabot PRs idle ~6d 17h — stale threshold hits ~2026-07-13T07:25Z).*

### finance-manager-web

*None (5 open Dependabot PRs idle ~6d 1h — stale threshold hits ~2026-07-13T23:45Z).*

### finance-manager-design-docs

*None.*

### finance-manager-cli

*None.*

### finance-manager-andriod

*None.*

### finance-manager-rust-tools

*None.*

### finance-manager-rust-middleware

*None.*

---

## Active open PRs (not stale — queue awareness)

**Theme: Dependabot dependency batch.** All opened in a single burst 2026-07-06; zero human reviews; CI green on all. Parent `#114` (Dependabot three-tier review chain) merged 2026-07-07 — these are candidates for `dependabot-batch-triage` / WS3 review.

### finance-manager-api (6 PRs — idle ~6d 17h)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---|---|---|---|
| [#87](https://github.com/AzazelAzure/finance-manager-api/pull/87) | bump astral-sh/setup-uv 8.2.0 → 8.3.0 | 6d 17h | 2026-07-06T07:25:07Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. CI workflow pin only (`.github/workflows/api-ci.yml`). |
| [#88](https://github.com/AzazelAzure/finance-manager-api/pull/88) | bump psycopg 3.2.4 → 3.3.4 | 6d 17h | 2026-07-06T07:25:27Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. DB driver minor bump (`pyproject.toml` + `uv.lock`). |
| [#89](https://github.com/AzazelAzure/finance-manager-api/pull/89) | bump idna 3.15 → 3.18 | 6d 17h | 2026-07-06T07:25:36Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. Transitive dep patch. |
| [#90](https://github.com/AzazelAzure/finance-manager-api/pull/90) | bump django-allauth 65.16.1 → 65.18.0 | 6d 17h | 2026-07-06T07:25:46Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. Auth library minor — review auth flows if batch-merging. |
| [#91](https://github.com/AzazelAzure/finance-manager-api/pull/91) | bump pycountry 22.3.5 → 26.2.16 | 6d 17h | 2026-07-06T07:25:51Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. **Major version jump** (22→26) — highest-risk item in API batch; verify locale/country lookups before merge. |
| [#92](https://github.com/AzazelAzure/finance-manager-api/pull/92) | bump setuptools 82.0.1 → 83.0.0 | 6d 17h | 2026-07-06T07:25:58Z | ahead 1 / behind 0 | **MERGEABLE**, `CLEAN`. `test` SUCCESS. Dev-only dep (`pyproject.toml`). |

### finance-manager-web (5 PRs — idle ~6d 1h)

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---|---|---|---|
| [#118](https://github.com/AzazelAzure/finance-manager-web/pull/118) | bump vite-plugin-pwa 1.2.0 → 1.3.0 | 6d 1h | 2026-07-06T23:45:17Z | ahead 1 / **behind 1** | **MERGEABLE**, `CLEAN`. `ci` SUCCESS. **Diverged** — `main` gained [#117](https://github.com/AzazelAzure/finance-manager-web/pull/117) (PR template) 2026-07-07; rebase before merge to avoid lockfile drift. |
| [#119](https://github.com/AzazelAzure/finance-manager-web/pull/119) | bump motion 12.42.0 → 12.42.2 | 6d 1h | 2026-07-06T23:45:24Z | ahead 1 / **behind 1** | Same as #118 — diverged, rebase needed. |
| [#120](https://github.com/AzazelAzure/finance-manager-web/pull/120) | bump tailwind-merge 3.5.0 → 3.6.0 | 6d 1h | 2026-07-06T23:45:30Z | ahead 1 / **behind 1** | Same as #118 — diverged, rebase needed. |
| [#121](https://github.com/AzazelAzure/finance-manager-web/pull/121) | bump typescript-eslint 8.59.1 → 8.63.0 | 6d 1h | 2026-07-06T23:45:42Z | ahead 1 / **behind 1** | Same as #118 — diverged, rebase needed. Largest diff (+66/−66 lockfile lines). |
| [#122](https://github.com/AzazelAzure/finance-manager-web/pull/122) | bump vite 8.1.0 → 8.1.3 | 6d 1h | 2026-07-06T23:45:51Z | ahead 1 / **behind 1** | Same as #118 — diverged, rebase needed. Build-tool patch. |

**Web batch note:** All five share `package.json` + `package-lock.json` only. Rebasing any one will likely conflict with siblings if merged out of order — batch-rebase or merge sequentially with lockfile sync per `dependabot-batch-triage`.

---

## Recently cleared (context)

Heavy parent-repo merge wave 2026-07-06 → 2026-07-07 cleared the prior queue:

- **Parent:** security audit T01/T05 (#96–#97), OPS-REVAMP T01–T08 (#117–#125), CODEX-REVIEW T1–T7 (#109–#122), Dependabot review chain (#114).
- **Web:** smoke PRs #113–#116 merged 2026-07-06; PR template #117 merged 2026-07-07.
- **API:** no feature PRs open since F-006/F-009/security batch closed 2026-07-02.

Prior weekly scan (2026-07-06) also reported zero stale PRs; the Dependabot batch landed later that day.

---

## Method

```bash
gh pr list --repo AzazelAzure/<repo> --state open --json number,title,createdAt,updatedAt,...
gh api repos/AzazelAzure/<repo>/compare/main...<branch>
```

Stale = `updatedAt` < cutoff (7 days before capture). Merge/conflict checks via GitHub API `compare` + PR `mergeable` / `mergeStateStatus`.
