---
plan_id: PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29
execution_model: delegated_agents
orchestration_branch: cursor/finance-manager-web-beta-rollout-53be
sibling_plan: plans/cursor/vps-reflex-bluegreen-recovery-53be
deployment:
  required: true
  target_services:
    - api
    - proxy
    - js
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - "OPTIONS+POST /api/token/ from browser Origin"
    - "GET /finance/appprofile/snapshot/?current_month=true with Authorization"
    - "GET https://jsdevtesting.thehivemanager.com/ (Lane B)"
  notes: >-
    bundle_required may become true when JS is served from VPS via same bundle pipeline as other services; initial CORS/API/nginx may be false.
---

# finance_manager_web — beta rollout (Reflex successor track)

**Execution:** Assigned to a **dedicated JS frontend agent**. Phases are run by that agent to completion; orchestrator does not inline-run them.

## Blue/green and production hostname (later)

When the JS app is ready to ride the same **deploy / smoke / switch** path as API+Reflex, follow [`design_docs/40_System_Design/14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md`](../../../design_docs/40_System_Design/14_Parallel_Blue_Green_Deploy_and_JS_Web_Integration.md) (optional `web-blue` / `web-green`, nginx maps, bundle pipeline). Sibling: [vps-reflex-bluegreen-recovery-53be](../vps-reflex-bluegreen-recovery-53be/README.md).

## Execution status (living)

**Last updated:** 2026-04-29 (local execution continues; ecosystem cleaned/synced on `cursor/finance-manager-web-beta-rollout-53be`)

| Area | Status |
|------|--------|
| **Accomplished** | Breakpoint 0 (lane B primary) in `runtime_handoff.md`. T01: `finance_manager_web` submodule wired. T02: CORS/CSRF + dev login diagnostics (API + web feature branches; API checkout in ecosystem includes those defaults). T03: Lane A runbook in `finance_manager_web/README.md` (migrate, `createsuperuser`, `VITE_API_BASE_URL`, Runtime Signup pointer). `CROSS_AGENT_COORDINATION.md` API note. |
| **In flight** | Open PRs (per repo) + Slack `#pull-requests` workflow; **prod API** may still not return full CORS headers for browser preflight to `https://api.thehivemanager.com` from all Origins—use **Lane A** to validate app+API, or fix deploy/env. |
| **In progress** | T04: **local Cloudflare Tunnel** to `http://127.0.0.1:5173` or `:4173` documented in web README + `vite.config.ts`; user wires Zero Trust public hostname. **VPS** nginx/static for `jsdevtesting` still optional/follow-up (coordinate Reflex + Runtime sheet). |
| **Not started** | Breakpoint 2 / 3 full green: manual JWT + snapshot from `https://jsdevtesting...` (after tunnel) and/or prod; final CPPR + human verification. |
| **Next** | You: set tunnel private origin to **127.0.0.1:5173** (dev) or **:4173** (preview). Then login smoke with `VITE_API_BASE_URL=https://api.thehivemanager.com`. Merge PRs. [PASSDOWN.md](./PASSDOWN.md). |

## Agent startup

1. Paste **[AGENT_LAUNCH_PROMPT.md](./AGENT_LAUNCH_PROMPT.md)** (VPS is `dev@159.198.75.194`; branch `cursor/finance-manager-web-beta-rollout-53be`).
2. Read **[CROSS_AGENT_COORDINATION.md](./CROSS_AGENT_COORDINATION.md)** — Reflex sibling + API handoff footer.
3. Read **[PASSDOWN.md](./PASSDOWN.md)** for branch/SHA state and what to do next (any execution plane).

## Phase 0 — Choose primary testing lane

| Lane | When to use | Tradeoff |
|------|----------------|----------|
| **A — Local** | Fast UI iteration; offline-safe | API [`runserver`](../../../finance_manager_api) + SQLite (or local Postgres) — must mirror CORS and `VITE_API_BASE_URL`; not production data |
| **B — VPS `jsdevtesting.thehivemanager.com`** (recommended for integration truth) | Match prod DB + prod API contract | Needs DNS, Cloudflare tunnel, nginx server block, static build deploy; fewer “works on my machine” surprises |

Document choice in [`runtime_handoff.md`](./runtime_handoff.md) and gate **Breakpoint 0** in [`validation_gates.md`](./validation_gates.md).

## Phase 1 — Submodule + GitHub remote

- Parent repo: workspace root [`.gitmodules`](../../../.gitmodules).
- Add submodule: path `finance_manager_web` → `git@github.com:AzazelAzure/finance-manager-web.git` (repo already created by owner).
- Work in **web submodule repo** for JS commits; parent commit updates submodule pointer per [git-repo-workflow.md](../../../.cursor/rules/git-repo-workflow.md).
- Add `finance_manager_web/README.md` env section: `VITE_API_BASE_URL`, local vs prod.

## Phase 2 — Unblock auth + data (CORS and diagnostics)

- **Symptom:** Generic “Login failed” often masks **CORS** (wrong `Access-Control-Allow-Origin`) or wrong API base URL.
- **Actions:**
  - Ensure [`finance_manager_api/finance_api/settings.py`](../../../finance_manager_api/finance_api/settings.py) `CORS_ALLOWED_ORIGINS` includes **every** dev Origin (typically `http://localhost:5173`, `http://127.0.0.1:5173`, and Lane B `https://jsdevtesting.thehivemanager.com`).
  - Optionally improve login error UI to show status code / network error in dev builds only.
- **API changelog:** [`finance_manager_api/CHANGELOG.md`](../../../finance_manager_api/CHANGELOG.md) when CORS/env behavior changes.

## Phase 3 — Lane A (optional): JS_DEV local API

- Document env pattern (e.g. `JS_DEV=1` or `FM_ENV_FILE`) for SQLite-backed `runserver` — align with existing [`finance_manager_api/finance_api/settings.py`](../../../finance_manager_api/finance_api/settings.py) DB auto-selection via `DB_*` vars (empty → SQLite).
- **Do not** commit secrets; only `.env.example` patterns in web or API repo.

## Phase 4 — Lane B (recommended): VPS JS dev hostname

1. DNS: `jsdevtesting.thehivemanager.com` → Cloudflare (proxied or tunnel per your standard).
2. Tunnel: public hostname → local nginx HTTPS port on VPS (same pattern as existing beta hosts).
3. Nginx: new `server_name jsdevtesting.thehivemanager.com`; `root` or `proxy_pass` to static `dist/` from CI/bundle or a minimal `nginx:alpine` static container — **do not** steal ports from active Reflex stack without coordination.
4. API: extend `CORS_ALLOWED_ORIGINS` / `CSRF_TRUSTED_ORIGINS` if cookies or future forms need it.

## Phase 5 — Parity + polish (post-MVP)

- Landing/splash parity with former Reflex experience is **explicitly later**; track as follow-up tasks after Breakpoint 2–3 green.

## CPPR+D through manual verification

| Step | Owner | Notes |
|------|--------|------|
| C/P/PR/M | JS agent (+ API agent if API repo PR) | Separate PRs per submodule repo |
| D | Execution plane per [deployment_protocol.md](../../_governance/deployment_protocol.md) when deploying API or proxy to VPS |

**Human manual verification:** Login, dashboard charts/tables, hard refresh — record in `runtime_handoff.md` or PR verification section.

## Task packets

| Task | Purpose |
|------|---------|
| [tasks/T01_submodule_and_remote.md](./tasks/T01_submodule_and_remote.md) | Wire `finance_manager_web` to GitHub |
| [tasks/T02_cors_and_login_diagnostics.md](./tasks/T02_cors_and_login_diagnostics.md) | Fix generic login failure class |
| [tasks/T03_lane_a_local_api.md](./tasks/T03_lane_a_local_api.md) | Optional local runserver lane |
| [tasks/T04_lane_b_vps_jsdev_host.md](./tasks/T04_lane_b_vps_jsdev_host.md) | DNS + tunnel + nginx + static |
