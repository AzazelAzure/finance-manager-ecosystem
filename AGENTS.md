## Learned User Preferences

- **CPPRD** (commit, push, pull request, **document** change): merged work should have a durable summary in repo docs (subrepo `CHANGELOG`, `deploy/`, or `design_docs` as appropriate) for accountability. **CPPR** = commit, push, pull request only. **CPPR+D** (commit, push, pull request, **deploy**) = the full deploy cycle including blue-green color flip per `plans/_governance/deployment_protocol.md`. See `deploy/CPPR_AND_CPPRD.md` for the documentation discipline; see `plans/_governance/branching_guidelines.md` for the per-feature color-cycle workflow.
- When multi-step rollout work hits coordination bottlenecks, prefer continuing execution locally in this workspace over delegating to a separate cloud agent.
- For rollout increments, prefer agent-owned PR creation and implementation, then user-owned validation/merge; after merge, proceed with VPS pull/rebuild for verification. **Manual merge is a verification gate, not bureaucracy** (per Lesson 6.7 in strategic context).
- Unless specified otherwise, automatically SSH to the dev VPS (`dev@159.198.75.194`, user `dev`) to run investigation and operational commands there (compose status, logs, rebuilds, layout under `~/finance_manager`) instead of assuming work stays on the local machine only. Auto-login configured; no `--identity` flag needed.
- When tunneling or documenting HTTPS reachability for dev hostnames, spell out the private origin explicitly (today the live stack is unified on host **:8443** via the blue/green proxy, not legacy Vite-only ports).
- When advancing named breakpoints in an active rollout plan, update that plan's runtime handoff note with progress so later sessions stay aligned.
- **One feature at a time on inactive color** (locked 2026-04-30). See `plans/_governance/branching_guidelines.md` §1.

## Learned Workspace Facts

- **Strategic Plan is canonical** at `plans/cursor/strategic-roadmap-reframe-53be/`. Original `design_docs/20_Roadmap/Phase_1_*` and `Phase_2_*` are historical reference only.
- **Plan governance** at `plans/_governance/` — read `plans/_governance/glossary.md` first every session for canonical vocabulary.
- **Hierarchical plan structure (locked 2026-04-30):** new plans live at `plans/cursor/<phase-stage>/<sub-plan>/` (e.g. `plans/cursor/s1b/drift-cleanup/`). Pre-existing plans NOT retroactively moved.
- **Sub-repos active:**
  - `finance_manager_api` — Django REST API (`api:Tight Beta`)
  - `finance_manager_web` — React+Vite SPA, **flagship product** (`web:Tight Beta`)
  - `finance_manager_cli` — CLI client (`cli:Alpha`)
  - `finance_manager_android` — Android scaffold (`android:Scaffold`; pull-forward begins S1.B)
  - `finance_manager_rust_middleware` — Rust ZK middleware stub (`middleware:Scaffold`; full work S5)
- **Sub-repos archived:**
  - `finance_manager_reflex` — `reflex:Archived` 2026-04-30. Repo retained as historical evidence only; removed from production architecture.
- **Future product streams (Concept):**
  - `desktop:Concept` — desktop standalone (was Track E); future-only.
- **Canonical web beta rollout plan** (historical) directory was `plans/cursor/finance-manager-web-beta-rollout-53be`; closed 2026-04-30 in registry.
- `finance_manager_web` is its own git repository (submodule from the ecosystem parent). Deployed and tunneled flows use **blue-green Docker** with the **proxy** exposing **HTTPS on host :8443** to the active color's static web and API—**not** split across Vite dev ports `5173`/`4173` for real stack verification (see `finance_manager_web/README.md`).
- Optional local "Lane A" (SQLite + Vite) may still exist in docs for occasional local edits; authoritative production-style behavior matches the **VPS blue-green stack on :8443**.
- Dev VPS for live deploy: `dev@159.198.75.194` (hostname `server1.thehivemanager.com`), application root `~/finance_manager` with `docker-compose.bluegreen*.yml`, subrepos `finance_manager_api`, `finance_manager_web`, plus `deploy/` and `proxy/`. Compare with the local workspace clone when reconciling orchestration with what is actually running.
- Multi-agent **orchestration and plan markdown** live under this workspace's `plans/` tree only; the VPS does not mirror those files. SSH there for runtime truth, read `plans/` here for coordinated work definition.
- Runtime ownership tracking (active session): `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
- **Active market: PH only.** US users are grandfathered as Honorary Founders. New US acquisition deferred behind P-6 trigger condition (`plans/cursor/strategic-roadmap-reframe-53be/PARKING_LOT.md`).
- **HitM is the sole human operator.** All multi-actor terminology in plans/governance assumes single human + many AI agents unless explicitly stated otherwise.

## Operating Constraints (HitM-specific)

- ₱100/mo runtime cost cap. New infrastructure proposals must fit this or be blocked.
- Cursor monthly cap as forcing function — no overage purchases. Stop work; resume on cycle reset.
- Daily 10hr / weekly 55hr work ceiling during Sprints; 6hr/day, 30hr/week during Decompression. Local time-clock agent enforces (when implemented).
- Baby due 2026-06-15. Pre-baby velocity full through ~mid-June; 30–50% velocity reduction expected June onward.
- Family/health quarterly self-review per `plans/cursor/strategic-roadmap-reframe-53be/kill_commit_gates.md` §6. First execution 2026-06-30.

## Active Strategic State (snapshot 2026-04-30)

- **Active Phase:** S1.
- **Active Stage:** S1.B (entering after S1.A complete).
- **Flagship product:** `web`.
- **Next major gate:** S1.B exit → S1.C entry (~Aug 2026).
- **Current focus:** drift cleanup, S1.B research workstreams, "worth paying for" feature work, founding member program backend, Android pull-forward.

## Reading Order for New Agents

1. `AGENTS.md` (this file) — operating constraints + learned facts.
2. `plans/_governance/glossary.md` — canonical vocabulary.
3. `plans/_governance/README.md` — governance overview.
4. `plans/cursor/strategic-roadmap-reframe-53be/README.md` — strategic phase map.
5. `plans/cursor/strategic-roadmap-reframe-53be/00_strategic_context.md` — locked decisions.
6. `plans/_governance/plan_registry.md` — active plans + status.
7. Active Stage README at `plans/cursor/<phase-stage>/README.md`.
8. Specific sub-plan README before executing.
