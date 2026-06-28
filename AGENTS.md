# AGENTS.md — Workspace rules for all agents

Canonical bootstrap for Cursor, Claude Code, and Antigravity. Detail runbooks stay in `governance/` and are pulled only when needed.

---

## §0 Three-tool model

| Agent | Prefix | Owns | Does NOT own |
|---|---|---|---|
| **Cursor Pro+** | `cur/` | Sprint execution, code changes, tests, feature branches, deployments; PR-facing automation (review assignment, merge-readiness, CI triage, branch hygiene) | Governance docs, daily status, planning artifacts |
| **Claude Code** | `cla/` | Governance ops, PR admin, planning artifact edits, research synthesis | Code implementation, feature branches, daily status updates |
| **Antigravity Pro** | `agy/` | Daily status updates; admin automations configured natively in the Antigravity IDE (prompts + schedules there, not in this repo) | Code, governance overrides, strategic decisions |

**Coordination:** Task handoffs use the filesystem (`runtime_handoff.md`, `DECISION_LOG.md`). Do not route execution state through Slack or Discord. Legacy Slack bridges and `scripts/orchestrator.py` are **archived** — use native Cursor multitask/subagents for local execution; Antigravity-native workflows for admin automation.

Cursor-specific sprint task format: `.cursor/rules/sprint-task-specification.mdc`.

---

## §1 Universal rules

### CPPR / CPPRD / CPPR+D

- **CPPR** — commit, push, pull request.
- **CPPRD** — CPPR + **document** change (subrepo `CHANGELOG`, `deploy/`, or `design_docs` as appropriate). See `deploy/CPPR_AND_CPPRD.md`.
- **CPPR+D** — full deploy cycle including blue-green color flip per `governance/deployment_protocol.md`.

**CPPRD applies to:** feature merges (subrepo CHANGELOG + relevant design doc); governance doc changes (parent `CHANGELOG.md`).

**CPPR applies to:** submodule pointer bumps; chore/infra with no user-facing change.

**Retired:** daily-status-report PRs. Antigravity maintains `strategy/current_status.md` directly — no PR for daily status.

### Deployment and PR discipline

- **One feature at a time on inactive color** (locked 2026-04-30). See `governance/branching_guidelines.md` §1.
- When opening a pull request, **create it via GitHub CLI** (`gh pr create`). Post the PR URL in Cursor chat — not Slack.
- Before merge, confirm **GitHub** mergeability and required checks; `CONFLICTING` / failing checks block merge.
- Prefer **one** production API with a compatibility window and forced client refresh past end-of-support; no parallel API stacks; no Redis as HTTP version router.

### Plans and execution

- **Plan status values:** `draft`, `ready`, `in_progress`, `paused`, `blocked`, `completed`, `abandoned`, `archived`.
- **HitM gate types:** `required` (block), `optional` (proceed after post/timeout), `none`.
- **Tasks and slices:** `T##` for tasks; `T##.SL#` for slices (**`SL`** = slice, not Phase/Stage **`S`** like `S1.B`).
- **READ FIRST:** every plan README lists **≤7 files** to read before work starts.
- **`DECISION_LOG.md`** is append-only; check before any design choice.
- **`runtime_handoff.md`** hard limit: **200 lines**.
- **Anomaly logging:** If you notice something outside your current scope that seems broken, risky, or inconsistent — don't fix it inline, don't skip it. Log it to `strategy/anomalies/` using `.cursor/rules/anomaly-log.mdc`. Logs are swept nightly and dispatched via the daily summary.
- **i18n** is part of done; deferred coverage must be tracked as a follow-up slice.
- Governed scope: one slice per agent turn when possible; **ask clarifying questions** instead of guessing underspecified product scope. Bias slices to **one web route/page or one API model/domain** per pass.

### Product and ops defaults

- **PWA/offline bar:** Core ledger surfaces stay coherent offline (days–weeks); local-first + API sync when online. Password change and account deletion stay online-only.
- **VPS investigations:** SSH to `dev@159.198.75.194` (user `dev`) for compose status, logs, rebuilds under `~/finance_manager`. Authoritative stack: HTTPS **:8443** via blue-green proxy.
- **Rollout:** Prefer local execution over cloud agents when coordination bottlenecks; agent-owned PR + implementation, user-owned merge, VPS pull/rebuild for verification. Update active plan `runtime_handoff.md` at rollout breakpoints.
- **Pushback:** Prefer direct, candid product/business pushback over reassurance-only agreement.
- **Plans for agents:** Optimize artifacts for AI ingestion and handoffs over narrative polish.

---

## §2 Branch conventions

**New branches only** (historical `cursor/s1b/*` and `agy/s1b/*` names remain on merged PRs):

```
cur/s1b/feat/<slug>           ← Cursor feature
cur/s1b/fix/<slug>            ← Cursor bug fix
cur/s1b/chore/<slug>          ← Cursor chore
cur/s1b/hotfix/<slug>         ← Cursor hotfix
cla/s1b/admin/<slug>          ← Claude admin / governance
agy/s1b/chore/<slug>          ← Antigravity automation
```

Feature/task hierarchy and color-cycle workflow: `governance/branching_guidelines.md`.

Plans live under `plans/<Phase>/<Stage>/<sub-plan>/` (active S1.B: `plans/S1/S1.B/`).

---

## §3 Workspace facts

- **Strategic roadmap:** `strategy/strategic-roadmap-reframe-53be/` (historical `design_docs/20_Roadmap/Phase_*` is reference only).
- **Governance + plans:** `governance/` (protocols), `plans/` (tactical execution), `strategy/` (roadmap). VPS does not mirror `governance/` or `plans/`.
- **Active Phase/Stage:** S1 / S1.B. Flagship: `web`. Next gate: S1.B exit → S1.C.
- **Market:** PH-primary; US Honorary Founders passive. Multi-actor language = one human + AI agents unless stated otherwise.
- **Entity/commercial:** PH spouse-led MoR + US LLC vendor pipeline gates PSP KYB and payment integration (see entity-formation research plans).
- **PWA research locks:** Advanced tier, D0–D4 under `plans/S1/S1.B/pwa-install-offline-sync-research/`; implementation under `plans/S1/S1.B/pwa-implementation-branch/`.
- **F-012/F-013:** Support intake (durable API queue); F-013 = Loguru per-UUID diagnostic files on VPS (ops grep/tail), not in-app Activity UI.
- **Runtime ownership:** `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
- **Paying-user gate headcounts:** re-indexed per `strategy/strategic-roadmap-reframe-53be/validation_gates.md` and unit-economics doc §2 / §4.1.

---

## §4 Operating constraints (HitM)

- ₱100/mo runtime cost cap; Cursor cap as forcing function (no overages).
- Sprint: 10 hr/day, 55 hr/week max; Decompression: 6 hr/day, 30 hr/week.
- Baby born ~2026-06-15; decompression cadence is baseline.
- Quarterly self-review: `strategy/strategic-roadmap-reframe-53be/kill_commit_gates.md` §6 (first due 2026-06-30).

---

## §5 Sub-repo map

| Sub-repo | Tag | Role |
|---|---|---|
| `finance_manager_web` | `web:Tight Beta` | React+Vite SPA — **flagship** |
| `finance_manager_api` | `api:Tight Beta` | Django REST API |
| `finance_manager_cli` | `cli:Alpha` | CLI client |
| `finance_manager_android` | `android:Scaffold` | Pull-forward in S1.B |
| `finance_manager_rust_tools` | `rust_tools:Tight Beta` | Numerics (F-002, F-003) |
| `finance_manager_rust_middleware` | `middleware:Scaffold` | ZK middleware — S5 |
| `finance_manager_reflex` | `reflex:Archived` | Historical only |
| `design_docs` | submodule | Design vault |

Deploy: blue-green Docker/Podman; proxy on host **:8443**. Web is its own git submodule.

---

## §6 Reading order (by agent)

### Cursor (code execution)

1. `AGENTS.md`
2. `governance/plan_registry.md`
3. `plans/S1/S1.B/<target-sub-plan>/README.md`
4. READ FIRST files listed in that README (`DECISION_LOG.md`, `runtime_handoff.md`, subrepo `CHANGELOG`)

Pull `governance/glossary.md`, `deployment_protocol.md`, `definition_of_done.md` only when the task requires them.

### Claude Code (admin)

1. `AGENTS.md` + `CLAUDE.md`
2. `strategy/current_status.md` (admin snapshot — not required for Cursor executors)
3. `governance/plan_registry.md`

### Antigravity (automation / first session)

1. `AGENTS.md`
2. `governance/glossary.md`
3. `governance/plan_registry.md`
4. `governance/README.md`

Strategic depth when needed: `strategy/strategic-roadmap-reframe-53be/README.md` → `00_strategic_context.md` → active stage README → sub-plan README.

---

## Learned User Preferences

- Admin huddle artifacts belong under `strategy/huddles/`, not `plans/`.
- Resolve standby-queue PRs and partial code before VPS inactive-color deploy/test.
- Re-validate features already marked "completed" against definition of done; confirm claimed implementation actually exists before trusting completion status.
- Verify UI fixes on `jsdevtesting.thehivemanager.com` (inactive color) before rebuilding/flipping active production.
- When multiple agents share VPS access, enforce runtime signup-sheet ownership and handoff (`design_docs/30_Releases/Runtime_Signup_Sheet.md`) to avoid cross-contamination.
- Legacy S1.B plans using the old schema: use branch prefix `cur/s1b/feat/<slug>` per §2 and treat `slack_gates.pre_merge: required` as `manual_gates.pre_merge: required`.
- One agent per sub-repo at a time: avoid two agents concurrently modifying the same sub-repo (especially API); pause or revert one side to prevent code collisions.
- CPPR per task: open one PR per plan task and do not batch multiple tasks into a single PR; provide PRs in explicit merge order when several are ready.
- New feature/task work must include PWA/offline functionality as part of done, not deferred.
- Login UX: route already-authenticated users straight to the dashboard (no interstitial "already logged in" page); trigger the onboarding wizard only on new-user creation, not for existing users.
- Treat VPS deploy/cutover (inactive-color rebuild, smoke, color switch) and parent-repo governance closeout (plan registry, parent CHANGELOG, submodule pointers) as separate handoffs unless explicitly combined.

## Learned Workspace Facts

- VPS production blue-green ops use `scripts/fm_server_beta.sh` on the VPS (`status`, `rebuild-color`, `smoke`, `switch`); from the parent repo use `scripts/sprint_verify.sh` to SSH, pull API/Web, rebuild inactive color, and smoke (does not flip active color). Local dev uses `scripts/fm_docker.sh` and `scripts/fm_services.sh`.
- Django REST routes are mounted under `/finance/` (e.g. `/finance/savings-goals/`), not `/api/finance/` — VPS origin smokes must use the correct prefix with `curl --resolve` on `:8443`.
- Blue-green rebuild scripts must include Celery workers and actively tear down orphaned/outdated containers (recurring orphaned-container problem during color switches).
- Production hostnames: web `thehivemanager.com`, API `api.thehivemanager.com`; public HTTPS via blue-green proxy on host `:8443`.
- VPS `~/finance_manager` deploys from standalone `finance_manager_api/` and `finance_manager_web/` git clones — parent submodule pointers do not drive VPS pulls.
- VPS `docker-compose.bluegreen.yml` and `scripts/fm_server_beta.sh` are manually maintained on the host (with `.bak` backups), not auto-synced from parent `main`; `podman-compose` can echo interpolated `--env` secrets to stderr on any compose path (smoke/exec/build/config/logs), not only `up` — all compose invocations need stderr redaction.
- API repo uses `uv` + `pyproject.toml` + `uv.lock` for dependencies (not `requirements.txt`/pip); CI should use `uv sync --frozen`.
- GitHub Actions workflows should pin third-party actions to full commit SHAs and set least-privilege `permissions` (e.g. `contents: read`).
- Public hostnames are proxied through Cloudflare; GitHub Actions curls to those URLs can get edge `403` from datacenter IPs — VPS uptime checks should hit origin on `:8443` via `curl --resolve` (and `-k` for internal TLS).
- `main` branch protection is waived while repos stay private without GitHub Pro (explicit HitM decision).
- Bills currently support only monthly intervals; supporting differing bill cycles (non-monthly recurrence) requires a larger API revamp, tracked as future work via the anomaly log.
- Currently a closed loop with one beta tester; secret rotation is deferred — scrub leaked secrets from logs and clear terminal history instead, with rotation enforced later.
