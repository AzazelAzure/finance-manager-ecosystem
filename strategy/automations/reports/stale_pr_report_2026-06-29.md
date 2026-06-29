# Stale PR Report — 2026-06-29

**Captured (GitHub API):** 2026-06-29T01:04:02Z  
**Stale threshold:** no PR activity (`updatedAt`) for **≥7 days** (cutoff: 2026-06-22T01:04:02Z)  
**Repos scanned:** 8 (`finance-manager-ecosystem`, `finance-manager-andriod`, `finance-manager-api`, `finance-manager-cli`, `finance-manager-design-docs`, `finance-manager-rust-middleware`, `finance-manager-rust-tools`, `finance-manager-web`)

---

## Executive summary

**No stale PRs.** All open pull requests were updated within the last ~1.1 days.

The prior standby queue (#57–#61) was closed or merged on **2026-06-27** per `strategy/current_status.md` — that cleanup explains the empty parent-repo queue today.

| Metric | Count |
|---|---|
| Total open PRs | 14 |
| Stale (≥7d idle) | **0** |
| Repos with open PRs | 2 (api, web) |
| Repos with zero open PRs | 6 |

---

## Stale PRs by repo

_None._

---

## Open PR inventory (not stale)

Grouped by theme for skimming. All listed PRs: **MERGEABLE / CLEAN**, CI green at capture time.

### Theme: Dependabot dependency bumps (API + Web)

Batch opened **2026-06-27** by `app/dependabot`. Idle ~1.1 days — not stale, but worth batching review/merge to avoid drift.

| Repo | PR | Title | Age | Last update | Tree issues |
|---|---|---|---|---|---|
| api | [#44](https://github.com/AzazelAzure/finance-manager-api/pull/44) | bump astral-sh/setup-uv 6.8.0 → 8.2.0 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| api | [#45](https://github.com/AzazelAzure/finance-manager-api/pull/45) | bump actions/checkout 4.3.1 → 7.0.0 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| api | [#46](https://github.com/AzazelAzure/finance-manager-api/pull/46) | bump python-dotenv 1.2.1 → 1.2.2 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| api | [#47](https://github.com/AzazelAzure/finance-manager-api/pull/47) | bump djangorestframework 3.16.1 → 3.17.1 | 1.1d | 2026-06-27 | None — CI SUCCESS; **minor DRF bump** — spot-check serializers/views if merging |
| api | [#48](https://github.com/AzazelAzure/finance-manager-api/pull/48) | bump rpds-py 0.30.0 → 2026.5.1 (dev) | 1.1d | 2026-06-27 | None — CI SUCCESS |
| api | [#49](https://github.com/AzazelAzure/finance-manager-api/pull/49) | bump asgiref 3.11.0 → 3.11.1 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| api | [#50](https://github.com/AzazelAzure/finance-manager-api/pull/50) | bump redis 8.0.0 → 8.0.1 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#72](https://github.com/AzazelAzure/finance-manager-web/pull/72) | bump actions/checkout 4 → 7 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#73](https://github.com/AzazelAzure/finance-manager-web/pull/73) | bump actions/setup-node 4 → 6 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#74](https://github.com/AzazelAzure/finance-manager-web/pull/74) | bump vite 8.0.10 → 8.1.0 (dev) | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#75](https://github.com/AzazelAzure/finance-manager-web/pull/75) | bump @hookform/resolvers 5.2.2 → 5.4.0 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#76](https://github.com/AzazelAzure/finance-manager-web/pull/76) | bump axios 1.15.2 → 1.18.1 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#77](https://github.com/AzazelAzure/finance-manager-web/pull/77) | bump eslint-plugin-react-refresh 0.5.2 → 0.5.3 | 1.1d | 2026-06-27 | None — CI SUCCESS |
| web | [#78](https://github.com/AzazelAzure/finance-manager-web/pull/78) | bump zod 4.3.6 → 4.4.3 | 1.1d | 2026-06-27 | None — CI SUCCESS |

### Theme: Feature / governance work

_No open feature or governance PRs at capture time._

Parent-repo security-audit chain (#74–#76) merged during this capture window (2026-06-29T01:03Z).

### Repos with zero open PRs

| Repo | Open PRs |
|---|---|
| finance-manager-ecosystem | 0 |
| finance-manager-andriod | 0 |
| finance-manager-cli | 0 |
| finance-manager-design-docs | 0 |
| finance-manager-rust-middleware | 0 |
| finance-manager-rust-tools | 0 |

---

## Recently resolved (context only — not stale)

These were the last known stale items; all closed before this report window:

| PR | Repo | Disposition | Date |
|---|---|---|---|
| #57, #58, #59, #60 | ecosystem | Closed (relic / superseded) | 2026-06-27 |
| #61 | ecosystem | Merged (F-013) | 2026-06-27 |

Evidence: `strategy/current_status.md` § standby queue; prior assessment archived at `strategy/archived/standby-2026-06-26/open_prs_assessment.md`.

---

## Recommended actions

1. **No stale-PR triage required** this week.
2. **Optional:** batch-merge Dependabot PRs (#44–#50 api, #72–#78 web) while CI is green; prioritize `setup-uv` / GitHub Actions major bumps and DRF 3.17.1 for a quick smoke pass.
3. **Next run:** re-query with same 7-day idle threshold; this file is the canonical location for stale-PR state.

---

*Source: `gh pr list --state open --json …` per repo; merge/CI fields from GitHub API at capture time.*
