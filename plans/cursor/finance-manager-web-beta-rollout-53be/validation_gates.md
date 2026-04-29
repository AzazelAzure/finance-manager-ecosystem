# Validation gates — finance_manager_web beta rollout

Plan ID: `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29`  
Sibling plan: [vps-reflex-bluegreen-recovery-53be](../vps-reflex-bluegreen-recovery-53be/README.md)

## Breakpoint 0 — Lane selection

- **Pass when:** README documents **Lane A (local API+SQLite)** or **Lane B (VPS + jsdevtesting + prod API)** as primary for this sprint; secondary lane noted optional.
- **2026-04-29:** **PASS** — `runtime_handoff.md` records Lane B primary, Lane A optional.

## Breakpoint 1 — Submodule and repo hygiene

- **Pass when:** `finance_manager_web` is a submodule in parent [`.gitmodules`](../../../.gitmodules) pointing at `git@github.com:AzazelAzure/finance-manager-web.git`; remote `origin` set; initial hygiene commit pushed; `npm ci` / `npm run build` documented.
- **2026-04-29:** **PASS** — submodule added on ecosystem branch `cursor/finance-manager-web-beta-rollout-53be`; web remote pushed; local `npm ci` / `npm run build` green.

## Breakpoint 2 — Auth + snapshot (API contract)

- **Pass when:** Login obtains JWT; dashboard loads snapshot; **CORS** preflight passes for the **actual** browser **Origin** (`https://` public hostname, `http://localhost:5173`, etc.).
- **Failure triage:** Log API response status + `access-control-allow-origin` header in task notes.
- **T03 (Lane A docs):** **PASS** (2026-04-29) — see web README “Lane A — local API (SQLite) + Vite”.

## Breakpoints 2 + 3 — Lane B combined (default)

- **Context:** All tunneled traffic is **HTTPS in the browser**; an **internal proxy** may use **`https://127.0.0.1:[port]`** toward the app with **TLS off** to Vite so edge TLS + correct Origin still work. See [finance_manager_web README](../../../finance_manager_web/README.md) (Lane B §5–6).
- **Pass when (single run):** Open the **public** URL (e.g. `https://jsdevtesting…` or `https://jsdevprodtest…`); **POST `/api/token/`** and **GET snapshot** succeed; no CORS failures. This satisfies **B2** and **B3** together.
- **Alternative — B2 only (Lane A):** local `runserver` + Vite; no public HTTPS; documents **B2** without **B3**.
- **2026-04-30:** **IN PROGRESS** — set `VITE_API_BASE_URL=https://api.thehivemanager.com` for prod API smoke.

## Final — CPPR + manual verification

- **Pass when:** Required PRs merged; if API changed, deployment_protocol satisfied for API deploy; human clicks through login + dashboard on target URL; sibling **Last API changes** updated in [CROSS_AGENT_COORDINATION.md](./CROSS_AGENT_COORDINATION.md).
- **2026-04-30:** Ecosystem **main** includes web rollout; complete **B2+B3** smoke, then mark Final when sign-off is recorded.
