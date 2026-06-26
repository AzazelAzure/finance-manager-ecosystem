# Standby Readiness — Consolidated Summary

**Generated:** 2026-06-26  
**Scope:** Pre-VPS-sync gate. Governance overhaul explicitly deferred.  
**Detail reports:** [`open_prs_assessment.md`](./open_prs_assessment.md) (canonical stale-PR report) · [`uncommitted_work_status.md`](./uncommitted_work_status.md) · [`../active_vs_research_comparison.md`](../active_vs_research_comparison.md)

---

## Current `main` (reconciled)

| Field | Value |
|-------|-------|
| Parent HEAD | `dc04179` — F-012 landed (submodule pins + compose) |
| API pin | `277228a` (F-012 support intake backend) |
| Web pin | `9b2ecbe` (F-012 support intake frontend) |
| Local parent | **1 commit behind** `origin/main` — run `git pull` before PR work |

VPS green stack remains on **stale SHAs** (web `3e2b370`, api `1833e74`) — weeks behind even post-F-012 `main`.

---

## Standby action queue (ordered)

| Step | Action | Source |
|------|--------|--------|
| 1 | Resolve stale PR queue: API #33/#34 and Web #60/#61 are 7+ day stale; report shows no direct merge conflicts but flags duplicate/order risks | [Stale PR report](./open_prs_assessment.md) |
| 2 | Decide API merge vehicle: #34 contains #33 plus F-013, so #33 is redundant if #34 proceeds | [Stale PR report](./open_prs_assessment.md) |
| 3 | Decide Web offline/support ordering: #60 and #61 both carry the `profileOutboxOverlay.ts` appprofile regex change | [Stale PR report](./open_prs_assessment.md) |
| 4 | **API security WIP** — wire `validate_password` on change endpoints, `migrate axes`, proxy IP config, feature branch, tests | [Uncommitted work](a230ee90-aa96-4caa-9520-626d2c145616) |
| 5 | **Web WIP** — fix dead guide button; resolve CSP dev/prod matrix; committed `main` web **fails build** (9 TS errors); WIP uncommitted changes fix build but F-007 T02 sandbox not started | [Uncommitted work](a230ee90-aa96-4caa-9520-626d2c145616) |
| 6 | **Optional:** commit strategy/standby docs (exclude `cache/`) | [Uncommitted work](a230ee90-aa96-4caa-9520-626d2c145616) |
| 7 | **VPS sync** — pull `main`, rebuild inactive color, smoke — **only after 1–5** | [Active vs research](27020d64-b5c6-472b-94aa-f4fa22ffb5d3) |

---

## Cross-cutting conclusions

**PRs:** Current stale set is API #33/#34 and Web #60/#61. GitHub and local merge-tree checks show no direct conflicts against current `origin/main`; the risk is duplicate/order handling.

**Local code:** Neither API security nor web tour/CSP is commit-ready. Web submodule on `main` is broken for build until TS fixes land (partially in uncommitted WIP).

**Live vs strategy:** Infra design matches research; gap is **deploy drift** + **S1.B exit blockers** (entity, payments, worth-paying-for features). D4-exec PASS describes `main`, not production green stack today.

**Governance:** Parked for HitM admin overhaul — do not batch governance untracked files until that pass.

---

## VPS sync gate: **NOT CLEAR**

Clear when: stale API/Web PR decisions are made, API security + web build blockers are resolved or explicitly reverted/deferred, and deploy target SHAs are confirmed.
