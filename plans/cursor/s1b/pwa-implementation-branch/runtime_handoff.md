# Runtime handoff — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Orchestration root:** `plans/cursor/s1b/pwa-implementation-branch/` (not `plans/cursor/pwa-implementation-branch/`).

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
| **Last :8443 / D4 checkpoint** | **OPEN** for full D4-exec signoff — web **#48** fixes **continuous sync while online** (`isApiReachabilityRecovery` gating in `OfflineRoot`); prior parity batch items unchanged for evidence. |
| **Active / inactive** | **Live:** confirm on VPS (`fm_server_beta.sh active` / proxy). **Intent after fix window:** align both colors to the same good build. |

### Breakpoint checklist (agent)

| BP | Status | Notes |
| --- | --- | --- |
| BP_OUTBOX | **In progress (code)** | Profile PATCH allowlisted API + web; overlays for lookups/upcoming/profile; pending tx edit. |
| BP_OFFLINE_READ | **In progress (code)** | `getTransaction` + calendar/viz read bypass. |
| BP_D3_AUTH | **Verify** | Logout modal shows queue depth; `AUTH_CHANGED` aborts drain (existing `drain.ts`). |
| BP_BG_PWA | **Pending** | CPPRD: merge web+API PRs, rebuild inactive color, flip per `deploy/BLUEGREEN_SWITCHOVER.md`. |
| BP_D4_EXEC | **Pending** | Record under `evidence/` after Chrome desktop + Android on :8443. |

## Smoke log

| Date | Task / BP | Color | Result | Notes |
| ---- | --------- | ----- | ------ | ----- |
| 2026-05-03 | BP_D4_EXEC §2 / T14 | blue (active) | PASS | VPS `fm_server_beta.sh smoke --color active`; see evidence file. |
| 2026-05-03 | Post PR #44/#45 deploy | green (inactive) | PASS | Script smoke only; human PWA passes **not** closed. |
| 2026-05-03 | Continuation triage | — | — | HitM: green active + PWA regressions; see **Open issues (continuation)**. |
| 2026-05-03 | Web PR #48 online sync loop | green (active) | PASS | `git pull` web `main` @ `3d58e30`; `rebuild-color green`; `smoke --color active`. |

## Open issues — continuation (2026-05-03)

Operational / product (HitM):

1. **Blue/green:** Green holds broken PWA; cannot undo user-facing release — treat as reset, ship fixes, then **sync good build to active color** (see `deploy/BLUEGREEN_SWITCHOVER.md`).
2. **Sync banner / status:** Banner and copy felt wrong offline and after reconnect; **stuck “error”** phase after a failed drain until the next successful reachability transition. **Update:** **#48** stops **continuous drain/refetch while online** (recovery-only `fm-api-reachable` handling).
3. **Outbox “once”:** Suspected **reachability module** not aligned on `offline` / lie-fi transitions — second offline spell did not enqueue as expected until a failing request flipped `lastReachable`.
4. **Offline tx not on dashboard:** Data **does** persist in **IndexedDB** (Dexie); dashboard reads `fetchAppSnapshot` → `applyTransactionOutboxToSnapshot`. Gaps are usually **filter window** (e.g. tx date not in dashboard’s current-month slice), **stale React Query view**, or **enqueue path** not firing — not “browser cannot store.”
5. **Parity:** Full offline parity (except password / account delete) remains the sprint bar — calendar, viz, upcoming, data hub, etc. need the same outbox + cache discipline as transactions.

Agent / web (this workspace batch):

- **`markApiReachable(false)` on `window.offline`** in `OfflineRoot` and `SyncStatusBar` so `lastReachable` matches browser offline immediately (helps second offline enqueue + UI).
- **`SyncStatusBar`:** hide when **browser offline** + idle + empty outbox + no reconnect prompt; **clear `error` → `idle`** when `fm-api-reachable` reports `ok`; split copy for **offline + queue** vs **reachable-but-API-down + no queue**; add missing i18n keys `sync.status.queuedWillSync`, `sync.status.offlineNoQueue`; clear stale `syncDetail` when phase returns to `idle`.

## Previously resolved batch (2026-05-03) — keep for history

- **Issue A — CORS:** `X-Client-Build`, `Idempotency-Key` on `CORS_ALLOW_HEADERS` (API).
- **Issue B — SW shell:** `clientsClaim: true` in Workbox (`vite.config.ts`).
- **Issue C — RQ offline pause + first-write loss:** `networkMode: "always"`; retroactive queue in Axios error path + `canRetroactivelyQueue()`.

## Rollback

- SW-related production incident: disable SW registration via feature flag (per research README §10) after HitM approval; hotfix branch per `git-repo-workflow`.
