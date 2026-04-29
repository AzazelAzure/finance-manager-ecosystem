## Learned User Preferences

- **CPPRD** (commit, push, pull request, **document** change): merged work should have a durable summary in repo docs (subrepo `CHANGELOG`, `deploy/`, or `design_docs` as appropriate) for accountability. **CPPR** = commit, push, pull request only. See `deploy/CPPR_AND_CPPRD.md`.
- When multi-step rollout work hits coordination bottlenecks, prefer continuing execution locally in this workspace over delegating to a separate cloud agent.
- For rollout increments, prefer agent-owned PR creation and implementation, then user-owned validation/merge; after merge, proceed with VPS pull/rebuild for verification.
- Unless specified otherwise, automatically SSH to the dev VPS (`dev@159.198.75.194`, user `dev`) to run investigation and operational commands there (compose status, logs, rebuilds, layout under `~/finance_manager`) instead of assuming work stays on the local machine only.
- When tunneling or documenting HTTPS reachability for dev hostnames, spell out the private origin explicitly (today the live stack is unified on host **:8443** via the blue/green proxy, not legacy Vite-only ports).
- When advancing named breakpoints in an active rollout plan, update that plan’s runtime handoff note with progress so later sessions stay aligned.

## Learned Workspace Facts

- Canonical web beta rollout plan directory is `plans/cursor/finance-manager-web-beta-rollout-53be`; a shorter name like `plans/cursor/finance-manager-web-rollout` may be mentioned in chat but is not the on-disk path.
- `finance_manager_web` is its own git repository (submodule from the ecosystem parent). Deployed and tunneled flows use **blue-green Docker** with the **proxy** exposing **HTTPS on host :8443** (e.g. `8443:443` in compose) to the active color’s static web and API—**not** split across Vite dev ports `5173`/`4173` for real stack verification (see `finance_manager_web/README.md`, `deploy/BLUEGREEN_SWITCHOVER.md`).
- Optional local “Lane A” (SQLite + Vite) may still exist in docs for occasional local edits; authoritative production-style behavior matches the **VPS blue-green stack on :8443**.
- Dev VPS for live deploy: `dev@159.198.75.194` (hostname `server1.thehivemanager.com`), application root `~/finance_manager` with `docker-compose.bluegreen*.yml`, subrepos `finance_manager_api`, `finance_manager_reflex`, `finance_manager_web`, plus `deploy/` and `proxy/`—**compare with the local workspace clone** when reconciling orchestration with what is actually running.
- Multi-agent **orchestration and plan markdown** live under this workspace’s `plans/` tree only (for example `plans/cursor/vps-reflex-bluegreen-recovery-53be`, `plans/feat/web-reflex-parity-sweep-1/` with `AGENT_LAUNCH_PROMPT.md`, `validation_gates.md`, `runtime_handoff.md`); the VPS does not mirror those files—SSH there for runtime truth, read `plans/` here for coordinated work definition. Runtime ownership when the design-docs submodule is present: `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
