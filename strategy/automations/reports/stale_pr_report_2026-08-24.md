# Stale PR Report — 2026-08-24

**Captured:** 2026-08-24T01:00 UTC (cron automation)  
**Threshold:** Open PRs ≥7 days old with no updates in ≥7 days  
**Repos scanned:** finance-manager-ecosystem, finance-manager-andriod, finance-manager-api, finance-manager-cli, finance-manager-design-docs, finance-manager-rust-middleware, finance-manager-rust-tools, finance-manager-web

**Summary:** 4 stale PRs across 3 repos. 5 repos have no open PRs. 12 younger open PRs (Dependabot, created 2026-08-17) are below the 7-day threshold.

---

## Themes

### 1. Dual-PWA balance collision (merge pair)

API #101 and Web #127 share branch `cur/s1b/fix/hfm-pwa-balance-collision-2026-08-13`. Both are mergeable, CI green, but idle 10 days with no review decision.

### 2. Superseded / conflicting CI infra

Ecosystem #136 (Health Check edge probe) conflicts with `main` and overlaps territory already landed via merged #137 (`fix(ci): probe public HFM health endpoints`).

### 3. Stale seed fix overtaken by main

API #99 (`ux_demo` `source_id` seed) conflicts with `main`; main advanced via merged #100 (auto-deduct accepted|replace + migration 0022 neutralization).

---

## finance-manager-ecosystem

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#136](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/136) fix(ci): Health Check probes Cloudflare edge | 10d | 10d | **CONFLICTING** (`mergeable_state: dirty`); 4 commits behind `main`. `pr-body` check **FAIL** — missing Plan ID and Anomaly disposition (run 31658017343). Label `codex-review:pending`. Likely **superseded** by merged #137 on same health-probe theme. |

**Open but not stale:** none other.

---

## finance-manager-api

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#101](https://github.com/AzazelAzure/finance-manager-api/pull/101) Fix dual-PWA source-balance last-write-wins | 10d | 10d | **MERGEABLE** (`mergeable_state: clean`); 0 behind `main`; API CI green (2026-08-13). No review decision. Pair with Web #127. |
| [#99](https://github.com/AzazelAzure/finance-manager-api/pull/99) fix(seed): ux_demo create_ux_testuser source_id compatibility | 11d | 11d | **CONFLICTING** (`mergeable_state: dirty`); 2 behind `main` (includes merged #100). CI was green at open; needs rebase/conflict resolution or **close** if seed path changed on `main`. |

**Open but not stale (6 Dependabot PRs, #102–#107):** created 2026-08-17 (~6d 18h at capture) — below threshold.

---

## finance-manager-web

| PR | Age | Last update | Issues |
|---|---|---|---|
| [#127](https://github.com/AzazelAzure/finance-manager-web/pull/127) fix(pwa): Recalculate balances and overlay ledger invariant | 10d | 10d | **MERGEABLE** (`mergeable_state: clean`); 0 behind `main`; Web CI green (2026-08-13). No review decision. Pair with API #101. |

**Open but not stale (5 Dependabot PRs, #128–#132):** created 2026-08-17 (~6d 1h at capture) — below threshold.

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
2. **Close or rebase:** Ecosystem #136 — confirm #137 covers intent; close if redundant.
3. **Close or rebase:** API #99 — rebase onto `main` only if `create_ux_testuser` seed path still needs `source_id` fix post-#100; otherwise close.
