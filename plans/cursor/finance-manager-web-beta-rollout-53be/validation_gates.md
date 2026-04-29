# Validation gates — finance_manager_web beta rollout

Plan ID: `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29`  
Sibling plan: [vps-reflex-bluegreen-recovery-53be](../vps-reflex-bluegreen-recovery-53be/README.md)

## Breakpoint 0 — Lane selection

- **Pass when:** README documents **Lane A (local API+SQLite)** or **Lane B (VPS + jsdevtesting + prod API)** as primary for this sprint; secondary lane noted optional.
- **2026-04-29:** **PASS** — `runtime_handoff.md` records Lane B primary, Lane A optional.

## Breakpoint 1 — Submodule and repo hygiene

- **Pass when:** `finance_manager_web` is a submodule in parent [`.gitmodules`](../../../.gitmodules) pointing at `git@github.com:AzazelAzure/finance-manager-web.git`; remote `origin` set; initial hygiene commit pushed; `npm ci` / `npm run build` documented.
- **2026-04-29:** **PASS** — submodule added on ecosystem branch `cursor/finance-manager-web-beta-rollout-53be`; web remote pushed; local `npm ci` / `npm run build` green.

## Breakpoint 2 — Auth + snapshot against chosen API

- **Pass when:** Login obtains JWT; dashboard loads snapshot; **CORS** preflight passes for the **actual** browser Origin (verify 5173 vs 4173 vs https jsdevtesting).
- **Failure triage:** Log API response status + `access-control-allow-origin` header in task notes.
- **2026-04-29:** **OPEN** — **Lane A** path documented in `finance_manager_web/README.md` (local `runserver` + `VITE_API_BASE_URL`); use it to complete this gate without prod. **Prod** preflight to `api.thehivemanager.com` from `http://localhost:5173` may still show no `Access-Control-*` headers (edge/nginx)—treat prod **Lane B** as separate until fixed.
- **T03 (Lane A docs):** **PASS** (2026-04-29) — see web README “Lane A — local API (SQLite) + Vite”.

## Breakpoint 3 — Lane B only (VPS JS dev host)

- **Pass when:** DNS `jsdevtesting.thehivemanager.com`; tunnel route; nginx location serves JS build; HTTPS; manual smoke from external network.
- **2026-04-29 (tunnel-first):** App-side ready for **Cloudflare Tunnel → laptop**: private origin **`http://127.0.0.1:5173`** (`npm run dev`) or **`http://127.0.0.1:4173`** (`npm run preview`). Configure public hostname `jsdevtesting.thehivemanager.com` in Zero Trust to that URL; then run external HTTPS smoke (login + snapshot). **VPS static/nginx** still optional for shared hosting.

## Final — CPPR + manual verification

- **Pass when:** Required PRs merged; if API changed, deployment_protocol satisfied for API deploy; human clicks through login + dashboard on target URL; sibling **Last API changes** updated in [CROSS_AGENT_COORDINATION.md](./CROSS_AGENT_COORDINATION.md).
- **2026-04-29:** **OPEN** — PRs and deploy pending; coordination file updated for API branch intent.
