# Runtime handoff — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Orchestration root:** `plans/cursor/s1b/pwa-implementation-branch/` (not `plans/cursor/pwa-implementation-branch/`).

## Priority (HitM — locked for execution)

| When | Scope |
| ---- | ----- |
| **Now (must-fix)** | **Offline functionality:** every user-visible read path (lists, KPIs, charts, flows, aggregates) must **materialize from IndexedDB caches plus outbox overlays** so the app stays **coherent and numerically consistent offline** within the seed window. No “looks online-only” surfaces. |
| **Later (explicit defer)** | **Sync banner / status bar:** copy, visibility rules, stuck **error** phase polish, extra i18n, lie-fi cosmetic messaging — **do not spend sprint bandwidth here until the offline lane is done.** Critical correctness (#48-style loops) already addressed; remaining items are UX polish only. |

**Single-owner rule:** Only one agent controls container start/stop/rebuild at a time. Record owner changes here. Prefer project scripts per `.cursor/rules/container-testing-orchestration.mdc`.

## Lifecycle scripts (default)

```bash
# From workspace root
scripts/fm_docker.sh status
scripts/fm_services.sh status
# Before/after testing batches as needed:
scripts/fm_docker.sh restart   # or start / stop / rebuild — per local policy
scripts/fm_services.sh restart
```

## Verification surface

- **Authoritative PWA exit:** manual **D4-exec** on **deployed HTTPS :8443** (active blue/green stack), **Chrome desktop + Chrome Android** only for certified exit (D0 Option B).
- **Staging / cutover hostnames:** follow `deploy/BLUEGREEN_SWITCHOVER.md` — production origin for installed PWA vs `jsdevtesting` / inactive color validation.

## Current snapshot (2026-05-03 — offline parity sweep landed in workspace)

| Field | Value |
| ----- | ----- |
| **Runtime owner** | _(unassigned — set on first test batch)_ |
| **Mode** | VPS containerized blue/green (`~/finance_manager`, Podman) |
| **Last lifecycle command** | **2026-05-03:** `fm_server_beta.sh rebuild-color green` (active); `smoke --color active` **PASS** after web **#48** (PWA online continuous drain loop fix) merged to `main` and pulled on VPS `~/finance_manager/finance_manager_web`. |
| **Last :8443 / D4 checkpoint** | **REOPENED for verification** after web **PR #52** (PWA offline **PR-3** — form parity: Data Hub invalidations, profile Dexie merge, lookup-rename → tx overlay, `getTransaction` PWA local-first, dashboard refresh offline). Full **D4-exec** still **OPEN** until HitM runs Chrome desktop + Android on `:8443` post-merge + VPS pull/rebuild. |
| **Active / inactive** | **Live:** confirm on VPS (`fm_server_beta.sh active` / proxy). **Intent:** keep active color on good `main` builds; rebuild inactive color when convenient so both sides match. |
| **Sync UX vs MVP** | **Banner/track deferred:** #48 fixed the **online drain loop**; all **sync status bar / banner** follow-ups are **explicitly later** (see **Priority** table). |
| **Next execution priority** | **Must-fix now — offline:** same as **Priority → Now**: cached reads + overlays everywhere so **stored changes** drive **numbers, graphs, and lists** offline. |

### Breakpoint checklist (agent)

| BP | Status | Notes |
| --- | --- | --- |
| BP_OUTBOX | **In progress (code)** | Profile PATCH allowlisted API + web; overlays for lookups/upcoming/profile; pending tx edit. |
| BP_OFFLINE_READ | **Code complete (web PR #52)** — merge + VPS `git pull` / `rebuild-color <active>` + smoke; then human **D4-exec** to flip to **PASS**. Covers Data Hub invalidation breadth, QuickActions queued category create, dashboard forced snapshot offline, `appprofile:root` Dexie after profile PATCH enqueue, cross-entity rename on merged tx rows, `getTransaction` under `preferPwaLocalFirstReads()`. |
| BP_D3_AUTH | **Verify** | Logout modal shows queue depth; `AUTH_CHANGED` aborts drain (existing `drain.ts`). |
| BP_BG_PWA | **Pending** | CPPRD: merge web+API PRs, rebuild inactive color, flip per `deploy/BLUEGREEN_SWITCHOVER.md`. |
| BP_D4_EXEC | **Pending (window reopened)** | Run after **PR #52** lands on active color; record under `evidence/` after Chrome desktop + Android on :8443. |

## Smoke log

| Date | Task / BP | Color | Result | Notes |
| ---- | --------- | ----- | ------ | ----- |
| 2026-05-03 | BP_D4_EXEC §2 / T14 | blue (active) | PASS | VPS `fm_server_beta.sh smoke --color active`; see evidence file. |
| 2026-05-03 | Post PR #44/#45 deploy | green (inactive) | PASS | Script smoke only; human PWA passes **not** closed. |
| 2026-05-03 | Continuation triage | — | — | HitM: green active + PWA regressions; see **Open issues (continuation)**. |
| 2026-05-03 | Web PR #48 online sync loop | green (active) | PASS | `git pull` web `main` @ `3d58e30`; `rebuild-color green`; `smoke --color active`. |
| 2026-05-03 | Web **PR #52** PWA offline PR-3 (form parity) | _(post-merge)_ | **PENDING** | Branch `feature/pwa-offline-e2e-pr3` → `https://github.com/AzazelAzure/finance-manager-web/pull/52`; after merge: VPS `~/finance_manager/finance_manager_web` pull + `fm_server_beta.sh rebuild-color <active>` + `smoke --color active` + spot D4 repro (Data Hub / Quick add / profile PATCH / rename / `getTransaction`). |

## Open issues — continuation (2026-05-03)

Operational / product (HitM):

1. **Blue/green:** Keep **active** color on merged `main` builds; **rebuild inactive** when convenient so blue/green stay in sync (see `deploy/BLUEGREEN_SWITCHOVER.md`). Prior “broken build on green” crisis is **superseded** by #48 + deploy; still avoid long-lived drift between colors.
2. **Sync banner / status — defer only (no sprint work until offline lane closes):** Copy, reconnect prompts, **stuck “error”** phase until next reachability transition, hide/show rules, i18n gaps. **#48** already fixed the **continuous online drain** bug; anything left here is **polish**, not blocking offline correctness.
3. **Reachability / lie-fi enqueue (offline-adjacent — fix with offline lane if reproduced):** Second offline spell sometimes did not enqueue until a failing request flipped `lastReachable`; may share root with read paths not using offline state — **not** sync-bar copy work.
4. **Dashboard vs offline tx (often diagnosis, not storage):** Data **does** persist in **IndexedDB**; `fetchAppSnapshot` + `applyTransactionOutboxToSnapshot` path exists. Gaps are often **filter window**, **stale RQ view**, or **read path not using overlay** — rolls into **Next execution priority** (cache coherence across all surfaces).
5. **Parity / graphs (active work, not defer):** Full offline parity (except password / account delete) remains the bar — **numbers, graphs, aggregates, and every ledger-adjacent read** must go through **cached + overlay** logic so offline matches what the user already stored.

### Deferred — sync banner / status only (do not implement until HitM clears offline lane)

- **`markApiReachable(false)` on `window.offline`** in `OfflineRoot` and `SyncStatusBar` (reachability UX; can help lie-fi messaging — still **sync/track bucket**, not offline graph correctness).
- **`SyncStatusBar`:** hide when **browser offline** + idle + empty outbox + no reconnect prompt; **clear `error` → `idle`** when `fm-api-reachable` reports `ok`; split copy for **offline + queue** vs **reachable-but-API-down + no queue**; i18n keys `sync.status.queuedWillSync`, `sync.status.offlineNoQueue`; clear stale `syncDetail` when phase returns to `idle`.

## Previously resolved batch (2026-05-03) — keep for history

- **Issue A — CORS:** `X-Client-Build`, `Idempotency-Key` on `CORS_ALLOW_HEADERS` (API).
- **Issue B — SW shell:** `clientsClaim: true` in Workbox (`vite.config.ts`).
- **Issue C — RQ offline pause + first-write loss:** `networkMode: "always"`; retroactive queue in Axios error path + `canRetroactivelyQueue()`.

## Rollback

- SW-related production incident: disable SW registration via feature flag (per research README §10) after HitM approval; hotfix branch per `git-repo-workflow`.
