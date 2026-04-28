# Runtime handoff — finance_manager_web beta rollout

_Update when pausing, switching Lane A ↔ B, or completing a breakpoint._

## Copy/paste handoff

- **Plan:** PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29
- **VPS SSH (shared with Reflex plan):** `dev@159.198.75.194`
- **Active lane:** **Primary: Lane B (VPS `jsdevtesting.thehivemanager.com` + prod API)** — integration truth per plan README. **Secondary (optional): Lane A** — local `runserver` + SQLite for fast UI iteration.
- **VITE_API_BASE_URL:** Lane A: `http://127.0.0.1:8000` (or match runserver bind). Lane B: `https://api.thehivemanager.com` (confirm against live API base).
- **API backend:** Lane A: local runserver | Lane B: `https://api.thehivemanager.com`
- **CORS origins added (if any):** T02 — ensure `http://localhost:5173`, `http://127.0.0.1:5173`, and `https://jsdevtesting.thehivemanager.com` in API settings when testing those Origins.
- **Vite dev URL:** `http://localhost:5173` (default Vite); document if using another port.
- **Sibling Reflex plan status:** See [../vps-reflex-bluegreen-recovery-53be/validation_gates.md](../vps-reflex-bluegreen-recovery-53be/validation_gates.md) before changing root compose/proxy.
- **PRs (2026-04-29):** Ecosystem / web / API — branch `cursor/finance-manager-web-beta-rollout-53be`; open from GitHub “new PR” if missing. Slack `#pull-requests` per workspace rule.
- **Blockers:** Breakpoint 2 blocked on **API merge + deploy** (or prod env CORS) for real-browser preflight against prod API.

## Local API note

**Lane A** commands and `VITE_API_BASE_URL` are documented in [`finance_manager_web/README.md`](../../../finance_manager_web/README.md) (section “Lane A — local API (SQLite) + Vite”). If you use a different bind port, update both the API command and the web env file.
