# Runtime handoff — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Orchestration root:** `plans/cursor/s1b/pwa-implementation-branch/` (not `plans/cursor/pwa-implementation-branch/`).

## Priority (HitM — locked for execution)

| When | Scope |
| ---- | ----- |
| **Now (must-fix)** | **Offline functionality:** every user-visible read path (lists, KPIs, charts, flows, aggregates) must **materialize from IndexedDB caches plus outbox overlays** so the app stays **coherent and numerically consistent offline** within the seed window. No “looks online-only” surfaces. |
| **Later (explicit defer)** | **Sync banner / status bar:** copy, visibility rules, stuck **error** phase polish, extra i18n, lie-fi cosmetic messaging — **do not spend sprint bandwidth here until the offline lane is done.** Critical correctness (#48-style loops) already addressed; remaining items are UX polish only. |

**Single-owner rule:** Only one agent controls container start/stop/rebuild at a time. Record owner changes here. Prefer project scripts per `.cursor/rules/container-testing-orchestration.mdc`.

### Merge / review policy (2026-05-03 — **locked for now**)

- **Bug-fix auto-merge is no longer in effect.** Do not assume PRs can be squash-merged immediately without human review or branch protection exceptions. Treat every web/API change as **normal PR workflow** (review, checks, manual merge when HitM is ready) until this note is explicitly revoked.

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

## Current snapshot (2026-05-03 — post PR #52 / #53 deploy on **active green**)

| Field | Value |
| ----- | ----- |
| **Runtime owner** | _(unassigned — set on first test batch)_ |
| **Mode** | VPS containerized blue/green (`~/finance_manager`, Podman) |
| **Last lifecycle command** | **2026-05-03:** `git pull` web `main` @ `4c949a0` (PR **#52** + build hotfix **#53**); `fm_server_beta.sh rebuild-color green` (active); `smoke --color active` **PASS**. |
| **Last :8443 / D4 checkpoint** | **OPEN** — human manual verification **not** signed off. **Do not treat script smoke as PWA offline acceptance.** |
| **Active / inactive** | **Active color: green** (leave **as-is** for normal use). **Further experiments, tests, and fixes:** build and validate on the **inactive** color only (`rebuild-color blue` when blue is inactive, or the inverse per `fm_server_beta.sh status`); **do not** churn the active color for try/fix loops unless HitM explicitly approves a promote-after-verify. |
| **Offline → online offloading** | HitM reports **heavy or sensitive work is being shifted from strict offline paths to when the client is online** (offloading). The stack **still works** and sync/drain behavior is **not obtrusive**, but the **overall PWA sync model** (what runs offline vs deferred, how RQ + Dexie interact) may need a **dedicated revisit** once the offline transaction read path is honest. |
| **Human-verified offline gap (authoritative)** | **Transactions are still not populating in the UI when offline** (ledger lists / dashboard views empty or wrong vs expectation). Prior handoff bullets that implied “offline read parity” or “dashboard/transactions include queued rows after reload” as **fully fixed** were **overstated** — code landed for overlays, session, drain, and form parity, but **end-user offline transaction population remains broken or incomplete.** Next agent must treat this as **P0 unresolved**, not closed. |
| **Sync UX vs MVP** | **Banner/track deferred:** #48 fixed the **online drain loop**; follow-up sync UX is still **later** unless it blocks diagnosis of offline reads. |
| **Next execution priority** | **Prove why `listTransactions` / snapshot / seed caches do not surface rows when `navigator.onLine === false`** (installed PWA and/or `preferOfflineCaches`), then fix on **inactive color** first. |

### Correction — prior handoff / README wording (do not repeat)

- **Incorrect:** That **BP_OFFLINE_READ** or PR #52 alone meant “transactions and data populate offline” or “code complete” for full offline ledger coherence.
- **Correct:** PR #52 / #53 improved **invalidation, profile Dexie merge, rename overlay, `getTransaction` local-first, dashboard `forceNetwork` guard,** and **production build**. They did **not** establish verified **offline transaction list population** in the field.

### Breakpoint checklist (agent)

| BP | Status | Notes |
| --- | --- | --- |
| BP_OUTBOX | **In progress (code)** | Profile PATCH allowlisted API + web; overlays for lookups/upcoming/profile; pending tx edit. |
| BP_OFFLINE_READ | **NOT PASS — human verified:** transactions **still do not populate offline**. PR **#52/#53** merged and on **active green**; code includes overlays, invalidations, profile cache merge, etc., but **offline ledger visibility remains the blocking defect**. Next work: diagnose + fix on **inactive** color; update this row only after HitM confirms on device. |
| BP_D3_AUTH | **Verify** | Logout modal shows queue depth; `AUTH_CHANGED` aborts drain (existing `drain.ts`). |
| BP_BG_PWA | **Pending** | CPPRD: merge web+API PRs, rebuild inactive color, flip per `deploy/BLUEGREEN_SWITCHOVER.md`. |
| BP_D4_EXEC | **Pending** | Blocked on honest **BP_OFFLINE_READ**; record under `evidence/` after Chrome desktop + Android on :8443 when HitM is satisfied offline reads work. |

## Detailed change log — PWA offline end-to-end batch (for next agent)

Chronological **attempted** work (web repo `finance-manager-web`; ecosystem docs here). Use this to avoid re-litigating what already shipped.

| # | Item | Outcome / notes |
| --- | --- | --- |
| 1 | **PR-1** (plan): offline-first session (`auth.ts`, `SessionContext`, `RequireAuth`, lazy refresh in `api/client.ts`), `transactionOutboxOverlay` default-period for `pending:*`, snapshot `total_assets` from merged `source_balances`, tests, CHANGELOG. | **Merged** (prior session). Intended: cold reload offline with refresh token does not bounce to `/login`; pending rows not hidden by implicit current-month filter. **Does not guarantee** UI shows transactions offline if downstream readers never hit merged paths. |
| 2 | **PR-2** (plan): `drain.ts` 401 vs network on `postRefresh`, `AUTH_CHANGED` listener order, `SyncStatusBar` clear `auth_blocked` when reachable + empty outbox, SW banner gating (`swUpdateAck.ts`, `registerPwa.ts`, `SwUpdateBanner.tsx`), i18n `sync.status.refreshNetworkError`, tests, CHANGELOG. | **Merged** (prior session). Improves reconnect/drain/SW noise; **orthogonal** to offline transaction list population. |
| 3 | **PR #52** (plan PR-3): Data Hub query invalidations; `lookups.ts` `create*` returns `OfflineQueuedResult` on 202; QuickActions after queued category; `DashboardPage` `refetchSnapshotForced` without `forceNetwork` when `preferOfflineCaches()`; `queueMutating` + `optimisticProfileEnqueue.ts` Dexie merge on `PATCH /finance/appprofile/`; `transactionOutboxOverlay` FIFO rename overlay; `getTransaction` + `preferPwaLocalFirstReads()`; tests; CHANGELOG. | **Merged to `main`.** Form/cache parity improvements. **Did not** resolve HitM-reported **offline transaction population** failure. |
| 4 | **PR #53** (hotfix): remove unused `mergedTransactionMap` (TS6133) so `tsc -b` passes in Docker `npm run build`. | **Merged** — required because **#52** broke production image build on VPS first `rebuild-color` attempt. |
| 5 | **VPS deploy** | `git pull` `finance_manager_web` → `4c949a0`; `rebuild-color green` (active); `smoke --color active` **PASS**. **Blue** not rebuilt in this batch; follow **inactive color** rule for next fixes. |
| 6 | **Policy** | **Auto-merge for bug-fix PRs disabled** (see section above). |

**Still broken (P0):** Offline (or installed PWA offline) **transaction lists / dashboard transaction-derived views** not showing expected data — **treat as open investigation** (seed keys, `preferOfflineCaches` vs `preferPwaLocalFirstReads`, React Query `networkMode`, empty Dexie `txlist:*`, filter params, or route mount order vs `OfflineRoot` seed).

## Smoke log

| Date | Task / BP | Color | Result | Notes |
| ---- | --------- | ----- | ------ | ----- |
| 2026-05-03 | BP_D4_EXEC §2 / T14 | blue (active) | PASS | VPS `fm_server_beta.sh smoke --color active`; see evidence file. |
| 2026-05-03 | Post PR #44/#45 deploy | green (inactive) | PASS | Script smoke only; human PWA passes **not** closed. |
| 2026-05-03 | Continuation triage | — | — | HitM: green active + PWA regressions; see **Open issues (continuation)**. |
| 2026-05-03 | Web PR #48 online sync loop | green (active) | PASS | `git pull` web `main` @ `3d58e30`; `rebuild-color green`; `smoke --color active`. |
| 2026-05-03 | Web **PR #52** PWA offline PR-3 (form parity) | green (active) | **DEPLOYED** | Merged; first VPS rebuild **failed** TS6133 until **PR #53**. |
| 2026-05-03 | Web **PR #53** build hotfix + rebuild green | green (active) | PASS | `rebuild-color green`; `smoke --color active`. **Human:** transactions **still** not populating offline — **not** a smoke pass item. |

## Open issues — continuation (2026-05-03)

Operational / product (HitM):

1. **Blue/green (2026-05-03 policy):** **Active color (green):** leave stable; **do not** use it as the primary loop for speculative offline fixes. **Inactive color:** use for **further tests and fixes** (`rebuild-color <inactive>`), then promote only after HitM verification. Long-term drift between colors: still reconcile per `deploy/BLUEGREEN_SWITCHOVER.md` when convenient.
2. **Sync banner / status — defer only (no sprint work until offline lane closes):** Copy, reconnect prompts, **stuck “error”** phase until next reachability transition, hide/show rules, i18n gaps. **#48** already fixed the **continuous online drain** bug; anything left here is **polish**, not blocking offline correctness.
3. **Reachability / lie-fi enqueue (offline-adjacent — fix with offline lane if reproduced):** Second offline spell sometimes did not enqueue until a failing request flipped `lastReachable`; may share root with read paths not using offline state — **not** sync-bar copy work.
4. **Dashboard vs offline tx (P0 — reopened):** HitM confirms **transactions still do not populate offline** despite IndexedDB + overlay code paths. **Do not** assume “data persists in Dexie, therefore UI is fine.” Hypotheses for next agent: seed never wrote `txlist:*` / snapshot for the filters in use, `listTransactions` short-circuit when offline, React Query not reading from merged offline branch, PWA local-first vs `preferOfflineCaches()` mismatch, or UI mounted before caches warm. **Verify with runtime logging or Dexie inspection on device** on **inactive** color.
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
