# Project Current Status

> **ADMIN USE ONLY.** Updated daily by Antigravity. Not a required read for executor agents (see `AGENTS.md` §6).

**Generated:** 2026-06-26 (post-standby execution; reconciled against `origin/main`, VPS SSH)  
**Sources:** Git history, submodule SHAs, VPS Podman state, open PR assessment, uncommitted-work audit, active-vs-research comparison, plan registry, strategic roadmap.  
**Scope:** Finance Manager Ecosystem (parent + all active sub-repos).  
**This file is a living summary. It is not the source of truth** — authoritative docs remain in `governance/`, `plans/`, and `strategy/strategic-roadmap-reframe-53be/`.  
**Standby detail:** [`strategy/standby/README.md`](./standby/README.md) · [`active_vs_research_comparison.md`](./active_vs_research_comparison.md)

---

## At a Glance

| Signal | State |
|---|---|
| **`origin/main` HEAD** | `86f7063` — F-013 + governance overhaul merged (API `7b6f564`, Web `e66c2bb`) |
| **Local parent checkout** | Behind `origin/main` — run `git pull origin main` before pointer-bump work |
| **VPS live stack** | Green active; smoke **PASS** 2026-06-26; **not synced to `main`** |
| **VPS web branch** | `agy/s1b/feat/landing-page-ux-seo` @ `3e2b370` (2026-06-13) |
| **VPS api branch** | `main` @ `1833e74` (2026-05-04) |
| **Submodule PRs ready** | API [#35](https://github.com/AzazelAzure/finance-manager-api/pull/35) security; Web [#62](https://github.com/AzazelAzure/finance-manager-web/pull/62) build/CSP |
| **Open parent PRs** | None blocking standby ( #58/#60 closed; #61/#62 merged ) |
| **VPS sync gate** | **NOT CLEAR** — merge submodule PRs + fix API migration graph + parent pointer bump |
| **Quarterly self-review** | **Due 2026-06-30** (4 days) |
| **Operator cadence** | Decompression mode — 6 hr/day, 30 hr/week (post-baby baseline) |
| **Governance overhaul** | **In progress** — admin overhaul on branch `cur/s1b/admin/governance-overhaul` (2026-06-26) |

---

## 1. Strategic Position

| Field | Value |
|---|---|
| **Active Phase** | S1 — Public Beta Launch + Position Lock-in (PH-only) |
| **Active Stage** | **S1.B — Distribution Readiness** (entered 2026-04-30) |
| **Flagship product** | `finance_manager_web` — React + Vite SPA (PWA) |
| **Active market** | PH-primary; US Honorary Founders only (passive) |
| **Estimated S1.B exit** | Late 2026 – early 2027 (original May–Jul window formally slipped per 2026-05-06 huddle projection) |
| **Next gate** | S1.B exit → S1.C entry (Founding Beta opening, ~Aug 2026 optimistic) |
| **Operator cadence** | Post-baby velocity reduction in effect (6 hr/day, 30 hr/week decompression mode since 2026-06-15) |

### Wedge (locked)

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

---

## 2. Critical Life-Event Context

- **Baby born ~2026-06-15.** Decompression mode velocity is now the baseline cadence (6 hr/day, 30 hr/week).
- **First quarterly self-review: Due 2026-06-30 (in 4 days).** Per `kill_commit_gates.md` §6 — three written questions must be answered and logged.
- **₱100/mo runtime cost cap** remains a hard ceiling; the Cursor cap is the forcing function.
- **Tooling CBA analysis** available at [`strategy/cursor_vs_claude_max_cba.md`](./cursor_vs_claude_max_cba.md) (2026-06-19) — primary bottleneck is human decisions + operator capacity, not model choice.

---

## 3. Git Activity — Last 30 Days

**9 commits on `origin/main`** since 2026-05-26. Tip: **`dc04179`** (2026-06-16). Local checkout is 1 commit behind.

| Date | Commit | Summary |
|---|---|---|
| 2026-06-16 | `dc04179` | feat(infra): F-012 submodule pins + compose + plan status (**current `origin/main`**) |
| 2026-06-16 | `90d2358` | docs: Mark D4-exec PWA validation as PASS per HitM sign-off |
| 2026-06-16 | `fff0ac1` | docs: Mark D4-exec PWA validation as pending HitM signoff |
| 2026-06-16 | `0cfc819` | chore: Update finance_manager_web submodule pointer |
| 2026-06-16 | `546c4a1` | Merge PR #56 — F-007 walkthrough polish |
| 2026-06-13 | `efda164` | docs(governance): enforce AI PR creation via gh cli |
| 2026-06-12 | `725bc36` | chore(web): update submodule (offline + HFM icon fixes) |
| 2026-06-03 | `688e4d2` | feat(pwa): fix offline bugs |
| 2026-06-03 | `2a0a846` | orchestrator-smoke-test: Execute slice T01.SL1 |

**Notable:** No commits since June 16 on `origin/main`. Five open PRs from June 15–16; standby review recommends closing three (#57, #58, #59, #60) and merging one (#61). ~50 local branches (many stale `cursor/s1b/*` and Antigravity worktrees under `.gemini/antigravity/`).

---

## 4. S1.A Retrospective — What Was Shipped (completed 2026-04-30)

S1.A is complete. Key outcomes from the JS pivot sprint and beta launch:

| Area | Outcome |
|---|---|
| **Frontend pivot** | Reflex→React+Vite in ~3 days; BP1–BP7 delivered; `web` is now flagship |
| **Reflex archived** | `finance_manager_reflex` retained as historical record; removed from production |
| **Blue-green infra** | Docker/Podman blue/green on VPS `:8443` via HTTPS proxy — operational |
| **Beta runtime** | Live at `thehivemanager.com:8443`; invite-only cohort (PH family + US Honorary Founders) |
| **API hardening** | HSTS, log redaction, env hygiene, CORS/CSRF hardened, JWT token handling |
| **Bug report pipeline** | `POST /finance/bug-report/` operational with email routing |

---

## 5. S1.B Sub-Plan Status (current as of 2026-06-26)

Per [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md) and [`governance/plan_registry.md`](../governance/plan_registry.md):

| Sub-plan | Status | Notes |
|---|---|---|
| `drift-cleanup/` | ✅ **completed** | W1 scope delivered 2026-05-01; HitM confirmed |
| `entity-formation-research/` | 🟡 draft | Counsel engagement pending; **gates PSP KYB and S1.B exit** |
| `payment-provider-research/` | 🟡 draft | PayMongo primary, Xendit contingency. Blended wallet MDR (~2.0%) |
| `ai-economics-deep-dive/` | ⏸ **shelved** | Paused until entity + payment research lands |
| `distribution-channel-research/` | 🟡 draft | Priority Matrix + SEO priority Matrix drafted |
| `wedge-consistency-audit/` | 🟡 draft | Audit report template + surface map drafted; execution pending |
| `pwa-install-offline-sync-research/` | ✅ **completed** | D0–D4 locked. **D4-exec** PWA validation **PASS** (HitM sign-off 2026-06-16) |
| `pwa-implementation-branch/` | ✅ **completed** | Merged 2026-06-16. Advanced offline read/write and outbox sync verified |
| `feat-f007-walkthrough-sandbox/` | 🟡 draft | Sandbox tour overlay + tooltip Help Mode redesign. **Untracked plan; local WIP edits in web** |

### Feature Plans (F-001 through F-013)

| F-id | Status | Notes |
|---|---|---|
| F-007 Guided Walkthroughs | ✅ **completed** | Merged 2026-06-16 (polish plan also merged via PR #56) |
| F-011 Wedge Landing Page | ✅ **completed** | Merged 2026-06-13 (landing page UX + SEO overhaul) |
| F-012 Support Intake | ✅ **on `main`** | Landed `dc04179` (API `277228a`, Web `9b2ecbe`); PR #60 **superseded — close** |
| F-013 User Activity Logs | 🟡 **open PR #61** | Not on `main`; merge #61 for Loguru per-user diagnostic logs + F-012 polish commits |
| F-001–F-006, F-008–F-010 | 🟡 draft | No active execution |
| **Sprint execution order huddle** | ⬜ Draft | 2026-05-22 `DECISIONS.md` not filled in |

---

## 6. Most Recent Feature Implementations (on `origin/main`)

### Web (`finance_manager_web` — pinned @ `9b2ecbe` on `origin/main`)

Prior mid-June work (F-007 @ `c855791` lineage, PWA Advanced, F-011) remains in history. **Current `main` pin** adds:

- **F-012 Support Intake (frontend):** In-app bug report + beta-gated feature request forms; client validation; authenticated submission flows.

**Build note:** Committed web @ `9b2ecbe` **fails `npm run build`** (9 TS errors per standby audit). Uncommitted local WIP partially fixes build but is not commit-ready.

### API (`finance_manager_api` — pinned @ `277228a` on `origin/main`)

Prior work (F-007 walkthrough persistence, PWA middleware, offline FX) in history. **Current `main` pin** adds:

- **F-012 Support Intake (backend):** Durable intake queue, auth, rate limiting, Celery digest alignment; compose/logging config updates in parent `dc04179`.

**Not on `main` yet:** F-013 per-user Loguru diagnostic log files (API `7b6f564` — only in PR #61).

---

## 7. Infrastructure State (VPS verified 2026-06-26)

### VPS Summary

| Field | Value |
|---|---|
| **Host** | `dev@159.198.75.194` (`server1.thehivemanager.com`) |
| **Runtime** | Podman (`/usr/bin/podman`); not Docker |
| **App root** | `~/finance_manager` (submodules only; parent repo not a git checkout) |
| **Active color** | **green** (`active_color.conf`: `default green`) |
| **Proxy** | `fm-beta_proxy_1` on host port `:8443` |

### Container Health (all Up ~12 days)

| Container | Status |
|---|---|
| `fm-beta_web-green_1` | Up 12 days (healthy) — **active** |
| `fm-beta_api-green_1` | Up 12 days (healthy) — **active** |
| `fm-beta_web-blue_1` | Up 12 days (healthy) — inactive |
| `fm-beta_api-blue_1` | Up 12 days (healthy) — inactive |
| `fm-beta_proxy_1` | Up 12 days |
| `fm-beta_db_1` | Up 13 days |
| `fm-beta_redis_1` | Up 13 days |

### SHA Drift — `origin/main` vs VPS (live)

| Submodule | `origin/main` pin | VPS checkout | Gap |
|---|---|---|---|
| **web** | `9b2ecbe` (F-012 frontend) | `3e2b370` on `agy/s1b/feat/landing-page-ux-seo` (2026-06-13) | **Missing F-007 merge, PWA fixes, F-011 final, F-012** |
| **api** | `277228a` (F-012 backend) | `1833e74` on `main` (2026-05-04) | **Missing F-007, PWA middleware, F-012, F-013 — ~6 weeks behind** |

**Live vs strategy:** D4-exec PWA PASS and Advanced-tier contracts describe code on `main`, **not** the green stack today. See [`active_vs_research_comparison.md`](./active_vs_research_comparison.md).

### Required Deployment Action (after standby gate clears)

**Do not sync VPS until:** PR cleanup (#58/#60 closed, #61 merged if F-013 wanted), local code blockers resolved or reverted, web build green.

```bash
# On VPS (dev@159.198.75.194) — after standby complete:
cd ~/finance_manager/finance_manager_web && git fetch && git checkout main && git pull
cd ~/finance_manager/finance_manager_api && git fetch && git pull
# From local or VPS:
./scripts/fm_server_beta.sh rebuild-color blue --no-cache   # rebuild inactive color
# smoke test on blue, then promote blue → active
```

---

## 8. Local Workspace — Uncommitted Changes

**Standby audit:** [`strategy/standby/uncommitted_work_status.md`](./standby/uncommitted_work_status.md). **Neither API nor web code is VPS-sync-ready.**

### Parent repo (`main` @ `90d2358`, 1 commit behind `origin/main`)

**Untracked (not committed):**

| Path | Description |
|---|---|
| `cache/projects.json` | Antigravity project cache — **cruft; keep untracked** |
| `governance/agent_context_delivery.md` | Agent context delivery protocol — defer to governance overhaul |
| `governance/archived/` | Archived cursor-rules, slack infra docs |
| `governance/examples/` | Sprint task spec worked example |
| `governance/security_protocols.md` | Security protocols doc |
| `governance/sprint_task_specification.md` | Sprint task specification |
| `plans/S1/S1.B/feat-f007-walkthrough-sandbox/` | F-007 sandbox tour plan (T01/T02) — needs linked feature work |
| `scripts/orchestrator.py` | Antigravity orchestrator script |
| `strategy/cursor_vs_claude_max_cba.md` | Cursor vs Claude Max CBA (2026-06-19) |
| `strategy/standby/` | Standby readiness pack (PR + uncommitted audits) |
| `strategy/active_vs_research_comparison.md` | Live vs strategy gap brief |
| `strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/` | Admin huddle session notes |

### API (`finance_manager_api`) — security hardening WIP — **PARTIAL, not deploy-ready**

| File | Change |
|---|---|
| `finance_api/settings.py` | `django-axes` (5 failures → 1hr lockout); Argon2 default hasher; min password 12; `ComplexPasswordValidator`; HSTS 1yr defaults; nosniff; `X_FRAME_OPTIONS = DENY` |
| `pyproject.toml` / `uv.lock` | `argon2-cffi`, `django-axes` |
| `finance/validators/password_complexity.py` | **Untracked** — complexity rules |

**Blockers before commit/deploy:** validator file untracked; **`migrate axes` required**; password policy not wired to change endpoints (`validate_password` missing); no proxy IP config for axes behind nginx; detached HEAD; no tests/CHANGELOG.

### Web (`finance_manager_web`) — sandbox tour WIP + CSP — **PARTIAL, not deploy-ready**

| File | Change |
|---|---|
| `index.html` | CSP meta tag |
| `DashboardPage.tsx` | Removed auto-tour `useEffect`; **dead "Start guide" button** (no onClick); duplicate refresh button groups |
| `QuickActions.tsx` | Removed force-restart arg from `startTour` calls |
| `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx` | Minor tour edits |

**Blockers before commit/deploy:** F-007 T02 sandbox not started; dead button UX; CSP blocks Lane A (`127.0.0.1:8000`); uncommitted WIP fixes TS build but is incomplete. Committed web @ `9b2ecbe` fails build without WIP.

---

## 9. Open Pull Requests (standby assessment)

Full detail: [`strategy/standby/open_prs_assessment.md`](./standby/open_prs_assessment.md).

| PR | Branch | Recommendation | Rationale |
|---|---|---|---|
| **#61** | `agy/s1b/feat/infra-user-activity-logs` | **MERGED** | F-013 → parent `86f7063` |
| **#60** | `agy/s1b/feat/infra-support-intake` | **CLOSED** | Superseded by F-012 on `main` |
| **#58** | `agy/s1b/chore/sync-api-submodule` | **CLOSED** | Stale conflicting API pin |
| **#62** | `cur/s1b/admin/governance-overhaul` | **MERGED** | Three-tool governance model |
| **#59** | daily status 2026-06-16 | **CLOSE** | Relic — superseded by this file; HitM decision to discard |
| **#57** | daily status 2026-06-15 | **CLOSE** | Relic — superseded; HitM decision to discard |

**Standby merge order (pre-VPS):** Close #57, #58, #59, #60 → merge #61 → resolve local code blockers → VPS sync.

VPS pull of `origin/main` alone delivers F-012 but **not** F-013 (F-013 requires #61).

---

## 10. Locked Decisions (Key Reference)

These are closed — re-opening requires a kill/commit gate review per `kill_commit_gates.md`:

| Decision | Lock date | Summary |
|---|---|---|
| `web` is flagship | 2026-04-30 | Reflex archived; React+Vite SPA |
| PH-first market | 2026-04-30 | US passive (Honorary Founders only) |
| Ads rejected | 2026-04-30 | Trust erosion; brand inconsistency with ZK position |
| User-data monetization rejected | 2026-04-30 | ZK is structural defense instead |
| Android mandatory pull-forward | 2026-04-30 | `android:Scaffold → android:Alpha` in S1.B |
| Mobile wallet as primary payment | 2026-04-30 | GCash/Maya; no credit-card-only path for PH |
| Pro list price | 2026-05-01 | **Pro ₱249/mo** · **Pro+ AI ₱349/mo** · PAYG floor ₱99 → 100 credits |
| Founding seats | 2026-05-01 | **≤100 seats** at **₱999–₱1,499** one-time |
| PSP primary (PM1–PM4) | 2026-05-05 | PayMongo primary, Xendit contingency, ~2.0% blended wallet MDR |
| PWA tier: Advanced | 2026-05-01 | Offline writes, outbox resync, force-upgrade on out-of-support clients |
| D0 browser matrix: Option B | 2026-05-01 | Chrome desktop + Chrome Android certified |
| Single production API | 2026-05-01 | No parallel API stacks; no Redis HTTP version routing |

---

## 11. S1.B Exit Checklist (Summary)

Per [`strategy/strategic-roadmap-reframe-53be/validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md):

- [x] Email uniqueness S0 fix shipped
- [x] `+Bill` hotfix retroactively committed to git
- [x] Reflex archival fully complete in registry
- [x] Bug fixes for KNOWN_ISSUES #1, #4, #7 shipped
- [x] **Flagship web PWA "install as app"** — **PASS (2026-06-16)**
- [ ] AI Economics Deep-Dive complete (Appendix A closure pending PSP/entity)
- [ ] **Entity formation decision made** (US LLC vs OPC / PH entity path)
- [ ] **Payment provider decision made** (PSP KYB pending entity formation)
- [ ] Distribution channel research complete
- [ ] Wedge consistency audit complete
- [ ] Founding member program backend ready
- [ ] "Worth paying for" feature work complete (Pro tier validation)
- [ ] ToS + Privacy + Refund policies drafted and live
- [ ] Android pulled forward to `android:Alpha` minimum

**S1.C entry remains blocked** until entity, payment, and billing policies are completed.

---

## 12. Open Blockers and Known Issues

| Issue | Severity | Status |
|---|---|---|
| **VPS sync gate** | 🔴 Critical | **NOT CLEAR** — PR cleanup + local code blockers must finish first |
| VPS deployment gap | 🔴 Critical | Green stack weeks behind `origin/main`; F-007, PWA, F-012, F-011 not live |
| Web build broken on `main` | 🔴 Critical | `9b2ecbe` fails `npm run build` (9 TS errors); blocks clean deploy |
| Local uncommitted security changes | 🔴 High | Axes/Argon2/HSTS partial — not wired, not migrated, not deployed |
| Local web tour/CSP WIP | 🟡 High | Partial; dead button; CSP Lane A gap; F-007 T02 not started |
| Entity formation (PH + US LLC) | **S1.B exit gate** | Research in draft; counsel engagement pending |
| PSP KYB | **Blocked on entity** | PayMongo/Xendit locked; KYB needs PH entity vehicle |
| Quarterly self-review | **Due 2026-06-30** | First kill/commit gates §6 execution due in 4 days |
| Sprint execution order not locked | **Planning gap** | 2026-05-22 huddle `DECISIONS.md` still draft |
| Android pull-forward | **Not started** | `android:Scaffold`; Alpha work not begun |
| Wedge consistency audit | **Not started** | Draft plan; execution pending |
| Governance drift | **Deferred** | Antigravity handoff vs committed Cursor/Slack docs — HitM admin overhaul pending |

---

## 13. Admin Huddle Summary

### Completed Sessions (2026-05-06 multi-day huddle)

| Session | Topics | Decisions |
|---|---|---|
| Session 1 — Legal & Entity | TP11, TP18 | 8 decisions locked (PH spouse-led entity, US LLC pipeline) |
| TP16 + Cluster C | TP16, TP3, TP9, TP20, TP21 | 14 decisions locked (velocity, hiring, feature projection) |
| Session 5 — Tooling & Agents | TP5, TP14, TP17, TP7, TP19, TP22 | 14 decisions locked (Antigravity for planning, Cursor for code) |

### Pending Sessions

| Session | Topics | Status |
|---|---|---|
| Session 4 — Infra & Security | TP1, TP4, TP26, TP15, TP8 | `pending` |
| Session 6 — Strategy Wrapup | TP10, TP23, TP28, TP6, TP12, TP13 | `pending` |

### Governance Drift Note

An untracked local doc [`admin_huddle_handoff.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/admin_huddle_handoff.md) (2026-06-03) claims Antigravity is now the primary orchestration engine with `agy/` branch prefix and manual IDE gates replacing Slack bridges. **Committed governance still references Cursor PA, Slack bridges, and `cursor/s1b/` branch conventions.** Reconciliation **deferred** — HitM will run a governance admin overhaul when adjusting production systems.

### Other Huddles

| Date | Huddle | Status |
|---|---|---|
| 2026-04-30 | Post-Beta Huddle | ✅ Complete — S1 stages locked, PH-first, Android pull-forward |
| 2026-05-22 | Feature Rollout Sprint Order | ⬜ Draft — `DECISIONS.md` not filled in |

---

## 14. Financial / Pricing State

| Item | Value |
|---|---|
| **Pro list price** | ₱249/mo (locked 2026-05-01) |
| **Pro+ AI list price** | ₱349/mo (locked 2026-05-01) |
| **PAYG floor** | ₱99 → 100 credits (locked 2026-05-01) |
| **Founding seats** | ≤100 at ₱999–₱1,499 one-time |
| **PSP blended MDR** | ~2.0% (PayMongo wallet) |
| **Break-even target** | ~$115–130/mo all-in overhead (~41 Pro subs) |
| **Personal success target** | ₱100k/mo take-home |
| **Runtime cost cap** | ₱100/mo hard ceiling |
| **Current tooling spend** | ~$60/mo Cursor Pro+ (see CBA doc for upgrade analysis) |

---

## 15. Sub-Repo Status Tags

| Sub-repo | Tag | `origin/main` pin | Notes |
|---|---|---|---|
| `finance_manager_api` | `api:Tight Beta` | `277228a` | F-012 on main; F-013 in PR #61 only; local security WIP uncommitted; VPS ~6 weeks behind |
| `finance_manager_web` | `web:Tight Beta` | `9b2ecbe` | F-012 on main; **build fails**; local sandbox/CSP WIP; VPS on stale feature branch |
| `finance_manager_cli` | `cli:Alpha` | `a9a3a7b` | CLI client; clean |
| `finance_manager_android` | `android:Scaffold` | `d33efd4` | Alpha work not yet begun |
| `finance_manager_rust_tools` | `rust_tools:Tight Beta` | `82d4994` | Numerics library; clean |
| `finance_manager_rust_middleware` | `middleware:Scaffold` | `8d7250d` | ZK middleware; deferred to S5 |
| `finance_manager_reflex` | `reflex:Archived` | `a5a1efe` | Historical record only |
| `design_docs` | — | `27130d8` | On branch `cursor/s1b/chore/sprint-queue-cursorpa-mention` (not main) |

---

## 16. Agent Tooling State

**Updated 2026-06-26.** Three-tool model now in effect; roles are distinct and non-overlapping.

| Tool | Plan | Role | Scope |
|---|---|---|---|
| **Cursor Pro+** | ~$60/mo | Primary IDE coding agent | Sprint execution, feature implementation, all code changes |
| **Claude Code (Claude Pro)** | Pro plan | Admin assistance | Acute, focused tasks only — status updates, PR admin, governance ops, research synthesis, planning artifacts. **Not for code implementation.** Usage-window constrained; keep sessions targeted. |
| **Antigravity Pro** | External subscription | Automation agents | Background/periodic tasks — test case generation, design doc updates, daily admin sweeps, other low-touch recurring work |
| **Slack bridges** | — | Deprecated | Scripts retained; governance refs stale |
| **Antigravity worktrees** | — | Stale | 4 worktrees under `.gemini/antigravity/`; cleanup pending |
| **Branch prefix** | — | `agy/s1b/*` | Current convention (recent PRs); committed governance still references `cursor/s1b/*` — drift unresolved |

---

## 17. Next Highest-Priority Actions

### Standby queue (before VPS sync)

1. **`git pull`** on local parent to reach `dc04179`.
2. **Close PRs #57, #58, #59, #60** (daily-status relics + stale/superseded infra PRs).
3. **Merge PR #61** if F-013 diagnostic logs are wanted on VPS.
4. **Resolve local code blockers:** API security (wire validators, `migrate axes`, proxy config, branch + tests) **or** revert; web TS build fix + dead button/CSP **or** revert sandbox WIP.
5. **Then VPS sync:** pull submodules on VPS, rebuild inactive color `blue`, smoke, promote.

### Parallel / non-blocking

6. **Execute quarterly self-review** — due 2026-06-30 (`kill_commit_gates.md` §6).
7. **Entity formation engagement** — unblock PSP KYB and S1.B exit.
8. **Governance admin overhaul** — HitM-led; defer batching governance untracked files until then.
9. **Lock feature rollout order** — `strategy/huddles/2026-05-22-feature-rollout-sprint-order/DECISIONS.md` (when capacity allows).

---

*Cross-references:*
- **Standby pack:** [`strategy/standby/README.md`](./standby/README.md)
- **Live vs research:** [`strategy/active_vs_research_comparison.md`](./active_vs_research_comparison.md)
- Strategic roadmap: [`strategy/strategic-roadmap-reframe-53be/README.md`](./strategic-roadmap-reframe-53be/README.md)
- Active stage hub: [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md)
- Plan registry: [`governance/plan_registry.md`](../governance/plan_registry.md)
- Validation gates: [`strategy/strategic-roadmap-reframe-53be/validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md)
- Kill/commit gates: [`strategy/strategic-roadmap-reframe-53be/kill_commit_gates.md`](./strategic-roadmap-reframe-53be/kill_commit_gates.md)
- Tooling CBA: [`strategy/cursor_vs_claude_max_cba.md`](./cursor_vs_claude_max_cba.md)
- Admin huddle sessions: [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/SESSION_INDEX.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/SESSION_INDEX.md)
