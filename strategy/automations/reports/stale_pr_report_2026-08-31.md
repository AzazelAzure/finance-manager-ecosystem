# Stale PR Report — 2026-08-31

**Captured:** 2026-08-31T01:02 UTC (cron automation)  
**Threshold:** Open PRs ≥7 days old with no updates in ≥7 days  
**Repos scanned:** finance-manager-ecosystem, finance-manager-andriod, finance-manager-api, finance-manager-cli, finance-manager-design-docs, finance-manager-rust-middleware, finance-manager-rust-tools, finance-manager-web

**Summary:** 15 stale PRs across 3 repos (5 repos have no open PRs). Since the 2026-08-24 report, the Dependabot batch (#102–#107 API, #128–#132 Web) crossed the 7-day threshold; feature PRs #99/#101/#127/#136 remain idle with no new commits or reviews.

---

## Themes

### 1. Dual-PWA balance collision (merge pair — still blocked on review)

API [#101](https://github.com/AzazelAzure/finance-manager-api/pull/101) and Web [#127](https://github.com/AzazelAzure/finance-manager-web/pull/127) share branch `cur/s1b/fix/hfm-pwa-balance-collision-2026-08-13`. Both are **MERGEABLE** (`mergeStateStatus: CLEAN`), 0 commits behind `main`, CI green since 2026-08-13. No review decision in 17 days. API adds migration `0024_paymentsource_opening_amount`, row locking, and `concurrency-postgres` CI job.

### 2. Dependabot backlog (11 PRs, now stale)

Six API and five Web dependency bumps opened 2026-08-17; all **MERGEABLE**, CI green, untouched for 13 days. Highest-risk item: Web [#131](https://github.com/AzazelAzure/finance-manager-web/pull/131) (vitest 3.2.6 → 4.1.10 major). API [#106](https://github.com/AzazelAzure/finance-manager-api/pull/106) (cryptography 49 → 50) is a major semver jump. Remaining bumps are patch/minor.

### 3. Superseded / conflicting CI infra

Ecosystem [#136](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/136) (Health Check Cloudflare edge probe) is **CONFLICTING** (`mergeStateStatus: DIRTY`). `pr-body` check **FAIL** (run [31658017343](https://github.com/AzazelAzure/finance-manager-ecosystem/actions/runs/31658017343)); label `codex-review:pending`. Likely **superseded** by merged [#137](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/137) (`fix(ci): probe public HFM health endpoints`, merged 2026-08-15). `main` Health Check workflow is succeeding on schedule (latest: 2026-08-30T23:50 UTC).

### 4. Stale seed fix overtaken by main

API [#99](https://github.com/AzazelAzure/finance-manager-api/pull/99) (`ux_demo` `source_id` seed) is **CONFLICTING** (`mergeStateStatus: DIRTY`). CI was green at open (2026-08-12); `main` advanced via merged [#100](https://github.com/AzazelAzure/finance-manager-api/pull/100) (auto-deduct accepted|replace + migration 0022 neutralization, merged 2026-08-12). Needs rebase/conflict resolution or **close** if seed path no longer relevant.

---

## finance-manager-ecosystem

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#136](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/136) fix(ci): Health Check probes Cloudflare edge | 17d | 17d | **CONFLICTING**; `pr-body` **FAIL**; `codex-review:pending`. Superseded by merged #137. |
| [#138](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/138) chore(strategy): stale PR report 2026-08-24 | 7d | 7d | **Draft** (automation artifact). Superseded by this report; safe to close. |

---

## finance-manager-api

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#101](https://github.com/AzazelAzure/finance-manager-api/pull/101) Fix dual-PWA source-balance last-write-wins | 17d | 17d | **MERGEABLE**; 0 behind `main`; CI green. Pair with Web #127. |
| [#99](https://github.com/AzazelAzure/finance-manager-api/pull/99) fix(seed): ux_demo create_ux_testuser source_id compatibility | 18d | 18d | **CONFLICTING**; CI green at open. Overtaken by merged #100. |
| [#107](https://github.com/AzazelAzure/finance-manager-api/pull/107) chore(deps-dev): bump packaging 26.0 → 26.3 | 13d | 13d | **MERGEABLE**; CI green. |
| [#106](https://github.com/AzazelAzure/finance-manager-api/pull/106) chore(deps): bump cryptography 49.0.0 → 50.0.0 | 13d | 13d | **MERGEABLE**; CI green. Major semver — review changelog. |
| [#105](https://github.com/AzazelAzure/finance-manager-api/pull/105) chore(deps): bump asgiref 3.11.1 → 3.12.1 | 13d | 13d | **MERGEABLE**; CI green. |
| [#104](https://github.com/AzazelAzure/finance-manager-api/pull/104) chore(deps): bump drf-spectacular 0.29.0 → 0.30.0 | 13d | 13d | **MERGEABLE**; CI green. |
| [#103](https://github.com/AzazelAzure/finance-manager-api/pull/103) chore(deps): bump redis 8.0.1 → 8.1.0 | 13d | 13d | **MERGEABLE**; CI green. |
| [#102](https://github.com/AzazelAzure/finance-manager-api/pull/102) chore(deps): bump astral-sh/setup-uv 8.2.0 → 10.0.1 | 13d | 13d | **MERGEABLE**; CI green. CI action major bump. |

---

## finance-manager-web

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#127](https://github.com/AzazelAzure/finance-manager-web/pull/127) fix(pwa): Recalculate balances and overlay ledger invariant | 17d | 17d | **MERGEABLE**; 0 behind `main`; CI green. Pair with API #101. |
| [#132](https://github.com/AzazelAzure/finance-manager-web/pull/132) chore(deps): bump @hookform/resolvers 5.4.0 → 5.8.0 | 13d | 13d | **MERGEABLE**; CI green. |
| [#131](https://github.com/AzazelAzure/finance-manager-web/pull/131) chore(deps-dev): bump vitest 3.2.6 → 4.1.10 | 13d | 13d | **MERGEABLE**; CI green. **Major** vitest bump — test separately. |
| [#130](https://github.com/AzazelAzure/finance-manager-web/pull/130) chore(deps): bump dexie 4.4.2 → 4.4.5 | 13d | 13d | **MERGEABLE**; CI green. PWA offline store. |
| [#129](https://github.com/AzazelAzure/finance-manager-web/pull/129) chore(deps): bump react-is 19.2.7 → 19.2.8 | 13d | 13d | **MERGEABLE**; CI green. |
| [#128](https://github.com/AzazelAzure/finance-manager-web/pull/128) chore(deps-dev): bump @vitejs/plugin-react 6.0.3 → 6.0.5 | 13d | 13d | **MERGEABLE**; CI green. |

---

## No open PRs

- finance-manager-andriod
- finance-manager-cli
- finance-manager-design-docs
- finance-manager-rust-middleware
- finance-manager-rust-tools

---

## Recommended actions (signal only)

1. **Merge pair:** Review and merge API #101 + Web #127 together (inactive-color deploy per branching guidelines).
2. **Dependabot batch:** Triage via `dependabot-batch-triage` skill; merge low-risk patches first; hold #131 (vitest 4.x) and #106 (cryptography 50) for explicit review.
3. **Close or rebase:** Ecosystem #136 — confirm #137 covers intent; close if redundant.
4. **Close or rebase:** API #99 — rebase only if `create_ux_testuser` seed path still needs `source_id` fix post-#100; otherwise close.
5. **Close:** Ecosystem #138 (draft prior report) — superseded by this file.
