# Runtime handoff — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

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

## Current snapshot

| Field | Value |
| ----- | ----- |
| **Runtime owner** | _(unassigned — set on first test batch)_ |
| **Mode** | VPS containerized blue/green (`~/finance_manager`, Podman) |
| **Last lifecycle command** | `rebuild-color green` after web **PR #45** merge (`main` @ `e3dc6e1` on VPS); `smoke --color green` + `active` PASS (2026-05-03) |
| **Last :8443 / D4 checkpoint** | **PAUSED** — HitM manual verification **blocked** on open issues below; prior **PARTIAL** — [`evidence/D4_EXEC_2026-05-03.md`](evidence/D4_EXEC_2026-05-03.md) |
| **Active / inactive** | **Active:** `blue` · **Inactive:** `green` (staging: `jsdevtesting` + `api-jsdevtesting` per `deploy/BLUEGREEN_SWITCHOVER.md`) |

## Smoke log

| Date | Task / BP | Color | Result | Notes |
| ---- | --------- | ----- | ------ | ----- |
| 2026-05-03 | BP_D4_EXEC §2 / T14 | blue (active) | PASS | VPS `fm_server_beta.sh smoke --color active`; see evidence file. |
| 2026-05-03 | Post PR #44/#45 deploy | green (inactive) | PASS | Script smoke only; human PWA passes **not** closed — see **Open issues (paused)**. |

## Open issues (paused — 2026-05-03)

Work **paused** pending HitM re-test or a fresh agent session. Logged from manual PWA verification on deployed stack (installed app, staging/inactive path as applicable).

### HitM test method (baseline)

1. **Install** the PWA (from the target origin, e.g. staging or `:8443`).
2. **Log in** to the app.
3. **Online:** open each main surface and confirm **loading + data** look correct.
4. **Go offline** and repeat / exercise offline flows.

### Issue A — Online transaction create → network error

- **Symptom:** While **still online**, adding a **transaction** from the installed PWA surfaced a **network error** (not isolated to offline queue).
- **Status:** Uninvestigated — capture **exact route** (Quick add vs ledger), **browser console / Network tab** (failed URL, status, CORS), and whether the hit was **production API** vs **staging API** (`api-jsdevtesting` on `jsdevtesting` host per `resolveApiBaseUrl`).
- **Suspects (for later):** token refresh / `X-Client-Build` / **409** upgrade path misread as generic network; wrong API base for installed PWA hostname; proxy or mixed active/inactive color confusion.

### Issue B — Offline shell / navigation error unchanged

- **Symptom:** After **PR #45** (removed duplicate Workbox `navigate` + SWR route; probe short-circuit when `!navigator.onLine`), **offline** use still shows the **same hard failure as before** (user-facing: prior **ERR_ADDRESS_UNREACHABLE** class symptom — full document / app load failure, not just a failed API `fetch`).
- **Status:** Unresolved — confirm **which URL** Chrome shows in the error UI, **Service Worker** “controlling this page” after install + one online load, **Clear site data** timing vs first offline open, and whether testing was on **inactive green** (`jsdevtesting`) vs **active blue** vs raw **:8443**.
- **Suspects (for later):** cold open offline with **no SW / empty precache** (browser limit); **DNS/TLS** to web origin when “offline”; SW not updating after deploy (stale worker); Nginx/proxy edge only.

## Rollback

- SW-related production incident: disable SW registration via feature flag (per research README §10) after HitM approval; hotfix branch per `git-repo-workflow`.
