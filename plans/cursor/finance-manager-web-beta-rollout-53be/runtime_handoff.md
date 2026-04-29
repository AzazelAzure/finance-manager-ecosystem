# Runtime handoff — finance_manager_web beta rollout

_Update when pausing, switching Lane A ↔ B, or completing a breakpoint._

## Copy/paste handoff

- **Plan:** PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29
- **VPS SSH (shared with Reflex plan):** `dev@159.198.75.194`
- **Active lane:** **Primary: Lane B (VPS `jsdevtesting.thehivemanager.com` + prod API)** — integration truth per plan README. **Secondary (optional): Lane A** — local `runserver` + SQLite for fast UI iteration.
- **VITE_API_BASE_URL:** Lane A: `http://127.0.0.1:8000` (or match runserver bind). Lane B: `https://api.thehivemanager.com` (confirm against live API base).
- **API backend:** Lane A: local runserver | Lane B: `https://api.thehivemanager.com`
- **CORS origins added (if any):** Code defaults include Vite + `https://jsdevtesting.thehivemanager.com` and `https://jsdevprodtest.thehivemanager.com`. If deploy uses env overrides, keep them in sync. **2026-04-30:** Blue/green stack is **parallel** to the live service; **prod API is expected up** for Lane B.
- **Vite dev URL:** `http://localhost:5173` (default Vite); document if using another port.
- **Cloudflare Tunnel (Lane B):** Public URL **`https://jsdevtesting…`** / **`https://jsdevprodtest…`**. In Zero Trust, set private **Service** to **`http://127.0.0.1:5173`** and **`http://127.0.0.1:4173`** (Vite is **HTTP** only). **`https://127.0.0.1:…` + `noTLSVerify` still yields 502** — that scheme needs a real TLS listener. See `finance_manager_web/README.md` *Lane B* §4.
- **VPS (`dev@159.198.75.194`):** Vite on **127.0.0.1:5173** / **4173** at `/home/dev/finance_manager_web` — **`./scripts/vps-serve.sh`**. Tunnels: `jsdevtesting` → 5173, `jsdevprodtest` → 4173 (or your internal proxy in front of those ports).
- **Sibling Reflex plan status:** See [../vps-reflex-bluegreen-recovery-53be/validation_gates.md](../vps-reflex-bluegreen-recovery-53be/validation_gates.md) before changing root compose/proxy.
- **Merge status (2026-04-30):** Ecosystem **PR #18** merged to `main` (this plan + submodule pins). Per-repo follow-ups: merge or align **finance-manager-web** and **finance-manager-api** default branches as needed; post PR links to `#pull-requests` for any new work.
- **Blockers / triage (2026-04-30):** If **ERR_NETWORK** on login from `https://jsdev…` but **Reflex** works: `OPTIONS` to **public** `api.thehivemanager.com` may lack CORS (edge cache). **Direct** `https://127.0.0.1:8443` on the VPS can still be correct. See `finance_manager_api/docs/CORS_PRODUCTION_TROUBLESHOOTING.md` — **Cloudflare: bypass cache** for `api` + purge. Deploy API with `CorsMiddleware` first (commit `2d85099`+).

## Local API note

**Lane A** commands and `VITE_API_BASE_URL` are documented in [`finance_manager_web/README.md`](../../../finance_manager_web/README.md) (section “Lane A — local API (SQLite) + Vite”). If you use a different bind port, update both the API command and the web env file.
