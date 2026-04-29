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
- **Cloudflare Tunnel (Lane B on laptop):** set public hostname `jsdevtesting.thehivemanager.com` → private origin **`http://127.0.0.1:5173`** (dev) or **`http://127.0.0.1:4173`** (`npm run preview` after build). See `finance_manager_web/README.md` *Lane B — … Cloudflare Tunnel*.
- **VPS (`dev@159.198.75.194`):** Vite bound to **127.0.0.1:5173** (dev) and **127.0.0.1:4173** (preview) at `/home/dev/finance_manager_web` — **`./scripts/vps-serve.sh {start|stop|status}`** (no Docker/compose; Reflex stack untouched). Tunnels: `jsdevtesting` → 5173, `jsdevprodtest` → 4173. API CORS must include `https://jsdevprodtest.thehivemanager.com` (see API branch / deploy).
- **Sibling Reflex plan status:** See [../vps-reflex-bluegreen-recovery-53be/validation_gates.md](../vps-reflex-bluegreen-recovery-53be/validation_gates.md) before changing root compose/proxy.
- **Merge status (2026-04-30):** Ecosystem **PR #18** merged to `main` (this plan + submodule pins). Per-repo follow-ups: merge or align **finance-manager-web** and **finance-manager-api** default branches as needed; post PR links to `#pull-requests` for any new work.
- **Blockers:** None for **API availability** (parallel blue/green). If login fails, triage CORS + `VITE_API_BASE_URL` + tunnel Origin first.

## Local API note

**Lane A** commands and `VITE_API_BASE_URL` are documented in [`finance_manager_web/README.md`](../../../finance_manager_web/README.md) (section “Lane A — local API (SQLite) + Vite”). If you use a different bind port, update both the API command and the web env file.
