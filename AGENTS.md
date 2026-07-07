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
- **CPPR+D** — full deploy cycle including blue-green color flip per `governance/deployment/deployment_protocol.md`.

**CPPRD applies to:** feature merges (subrepo CHANGELOG + relevant design doc); governance doc changes (parent `CHANGELOG.md`).

**CPPR applies to:** submodule pointer bumps; chore/infra with no user-facing change.

**Retired:** daily-status-report PRs. Antigravity maintains `strategy/current_status.md` directly — no PR for daily status.

### Deployment and PR discipline

- **One feature at a time on inactive color** (locked 2026-04-30). See `governance/execution/branching_guidelines.md` §1.
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

**Pipeline gate discipline (D3):** no stage begins while the prior stage's gate is open.
Specifically: `review.queue` PENDING blocks `queue_done`, task completion, and status report
completion language. Deploy (Stage 7) does not begin while `review.queue` has PENDING entries
for merged PRs from the same task. This applies to all agents.

### Trust but verify

- Any agent or automation with live-access capability (SSH, GitHub API, VPS, repo) **must verify flagged state against ground truth before escalating** — do not present cached or prior-context state as current. Even when a cached doc is available: query live, then report.
- **Time-stamp point-in-time reads.** VPS/runtime state is point-in-time; mark it with the capture time so staleness is visible, never hidden. (Origin: 2026-06-29 false-alarm HIGH alerts from a stale cached context file — see `strategy/automations/specs/vps_state_and_doc_context_spec_2026-06-29.md`.)

### Documentation maintenance

- Keep the **VPS runtime checkout sheet** (`governance/deployment/Runtime_Signup_Sheet.md`) current — a known prior drift source. Update it on every deploy/cutover and treat its contents as point-in-time, not authoritative live state (live state comes from an SSH query per trust-but-verify).
- Doc/governance file lifecycle (what gets saved, updated, or archived — including within meetings) is governed by `governance/coordination/meeting_artifact_protocol.md`.
- Strategy-area navigation: `strategy/README.md` is the index of living-state homes (meetings, anomalies, projections, parking lot, risk register, audits, automations).

### Product and ops defaults

- **PWA/offline bar:** Core ledger surfaces stay coherent offline (days–weeks); local-first + API sync when online. Password change and account deletion stay online-only.
- **VPS investigations:** SSH to the production VPS (user `dev`) for compose status, logs, rebuilds under `~/finance_manager`. Authoritative stack: HTTPS **:8443** via blue-green proxy.
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

Feature/task hierarchy and color-cycle workflow: `governance/execution/branching_guidelines.md`.

Plans live under `plans/<Phase>/<Stage>/<status>/<sub-plan>/` where `<status>` is one of `proposed/`, `planning/`, `active/`, `inactive/`, `complete/` (active S1.B stage root: `plans/S1/S1.B/`). See `plans/S1/S1.B/README.md` for the stage dashboard.

---

## §3 Workspace facts

- **Strategic roadmap:** `strategy/strategic-roadmap-reframe-53be/` (historical roadmap archived at `strategy/archive/design_docs/20_Roadmap/`, reference only).
- **Governance + plans:** `governance/` (protocols), `plans/` (tactical execution), `strategy/` (roadmap). VPS does not mirror `governance/` or `plans/`.
- **Active Phase/Stage:** S1 / S1.B. Flagship: `web`. Next gate: S1.B exit → S1.C.
- **Market:** PH-primary; US Honorary Founders passive. Multi-actor language = one human + AI agents unless stated otherwise.
- **Entity/commercial:** PH spouse-led MoR + US LLC vendor pipeline gates PSP KYB and payment integration (see entity-formation research plans).
- **PWA research locks:** Advanced tier, D0–D4 under `plans/S1/S1.B/complete/pwa-install-offline-sync-research/`; implementation under `plans/S1/S1.B/complete/pwa-implementation-branch/`.
- **F-012/F-013:** Support intake (durable API queue); F-013 = Loguru per-UUID diagnostic files on VPS (ops grep/tail), not in-app Activity UI.
- **Runtime ownership:** `governance/deployment/Runtime_Signup_Sheet.md`.
- **Multi-workspace checkout, dispatch, and VPS-authority protocol:** `governance/execution/workspace_protocol.md` (filesystem layout `~/Hive_Financial_Manager/{HFM,WS1,WS2,WS3,WS-API,WS-WEB}`, sign-out sheet, FIFO queues, `ws_dispatch.sh`/`ws_review.sh` pipeline — supersedes `governance/archived/agent_workspace_isolation.md`).
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
2. `governance/plans/plan_registry.md`
3. `plans/S1/S1.B/<status>/<target-sub-plan>/README.md` (see `plans/S1/S1.B/README.md` for status bucket locations)
4. READ FIRST files listed in that README (`DECISION_LOG.md`, `runtime_handoff.md`, subrepo `CHANGELOG`)

Pull `governance/reference/glossary.md`, `deployment_protocol.md`, `definition_of_done.md` only when the task requires them.

### Claude Code (admin)

1. `AGENTS.md` + `CLAUDE.md`
2. `strategy/current_status.md` (admin snapshot — not required for Cursor executors)
3. `governance/plans/plan_registry.md`

### Antigravity (automation / first session)

1. `AGENTS.md`
2. `governance/reference/glossary.md`
3. `governance/plans/plan_registry.md`
4. `governance/README.md`

Strategic depth when needed: `strategy/strategic-roadmap-reframe-53be/README.md` → `00_strategic_context.md` → active stage README → sub-plan README.

---

## Learned User Preferences

- Admin huddle artifacts belong under `strategy/huddles/`, not `plans/`; canonical research lives under `strategy/research/` — avoid diverging duplicate copies under tactical `plans/` trees.
- Resolve standby-queue PRs and partial code before VPS inactive-color deploy/test.
- Re-validate features already marked "completed" against definition of done; confirm claimed implementation actually exists before trusting completion status.
- Verify UI fixes on `jsdevtesting.thehivemanager.com` (inactive color) before rebuilding/flipping active production.
- When multiple agents share VPS access, enforce runtime signup-sheet ownership and handoff (`governance/deployment/Runtime_Signup_Sheet.md`) to avoid cross-contamination.
- Legacy S1.B plans using the old schema: use branch prefix `cur/s1b/feat/<slug>` per §2 and treat `slack_gates.pre_merge: required` as `manual_gates.pre_merge: required`.
- One agent per sub-repo at a time: avoid two agents concurrently modifying the same sub-repo (especially API); pause or revert one side to prevent code collisions.
- CPPR per task: open one PR per plan task and do not batch multiple tasks into a single PR; provide PRs in explicit merge order when several are ready; after squash-merging a PR that edits subrepo `CHANGELOG`, re-sync each open PR's `[Unreleased]` against `main` before merging them in order (seen across #62/#64/#65/#89).
- Queue-origin work (`api.queue`/`web.queue`/`parent.queue`): dispatch via `queue_pop`/`ws_dispatch.sh` to `WS-API`, `WS-WEB`, or in-place `HFM/` respectively; on green implementation auto-continue through CPPRD, `review_push.sh`, and WS3 (`ws_review.sh --next` or `--auto`) without pausing for commit authorization — HitM manual verify stays at inactive-color deploy only; orchestration/subagent handoffs must state **Anomaly disposition** (`none found` or filed paths) before declaring complete.
- New feature/task work must include PWA/offline functionality AND guided-tour/guide-mode coverage as part of done, not deferred — extend the guided walkthrough and guide mode to every new feature, view, and form (including quick-add forms) site-wide.
- Product/UX invariants: route already-authenticated users straight to the dashboard (no interstitial "already logged in" page) and trigger the onboarding wizard only on new-user creation, not for existing users; never surface or manipulate the internal-only "Unknown" balance/transaction source (failsafe only — keep it out of balance trends and all user-facing views).
- Treat VPS deploy/cutover (inactive-color rebuild, smoke, color switch) and parent-repo governance closeout (plan registry, parent CHANGELOG, submodule pointers) as separate handoffs unless explicitly combined.

## Learned Workspace Facts

- VPS production blue-green ops use `scripts/fm_server_beta.sh` under `~/finance_manager/scripts/` on the VPS (`status`, `rebuild-color`, `smoke`, `switch`); from the parent repo use `scripts/ops/sprint_verify.sh` to SSH, pull API/Web, and rebuild inactive color (does not flip active color) — set `FM_SPRINT_FM_SCRIPT=scripts/fm_server_beta.sh` for remote calls (parent copy lives at `scripts/ops/fm_server_beta.sh`); then run `fm_server_beta.sh smoke --color <inactive>` manually to verify; `sprint_verify.sh --smoke` may skip the remote smoke step. Local dev uses `scripts/local-stack/fm_docker.sh` and `scripts/local-stack/fm_services.sh`. Primary admin checkout is `~/Hive_Financial_Manager/HFM` (legacy `~/Documents/python/finance_manager` retired; Cursor may still have transcripts under both project paths). Local `hfm-scripts` MCP: `scripts/mcp/` + `.cursor/mcp.json` — prefer MCP tools over ad-hoc shell for session/queue/PR checks (`scripts/SCRIPTS.md` is fallback). Local cron after scripts reorg: `scripts/ops/pull_backup.sh`, `scripts/gather_doc_context.sh`, optional `scripts/local/schedule_agent_sync.sh` — refresh via `./scripts/local/setup_backup_cron.sh` then manual `crontab -e`.
- Django REST routes are mounted under `/finance/` (e.g. `/finance/savings-goals/`), not `/api/finance/` — VPS origin smokes must use the correct prefix with `curl --resolve` on `:8443`. The API is service-oriented (project `finance_api`, single `finance` app): flat routes in `finance_api/urls.py` (no `finance/urls.py`), hand-written `APIView` subclasses (no routers/viewsets), denormalized `uid` CharFields instead of real FKs, and logic flowing views → serializers → validators → services → logic/updaters → calculators. **PaymentSource linkage:** dependent surfaces store **display names** (lowercase) in `Transaction.source`, `BalanceSnapshot.source`, `SavingsGoal.source`, and `AppProfile.spend_accounts` — not Django FK and not internal `source_id` keys; validators verify names per user `uid`; renames propagate via `Updater.source_changed()` like category/bill. Greenfield models must use validators + services — views-only slices bypass linkage conventions.
- Blue-green rebuild scripts must include Celery workers and actively tear down orphaned/outdated containers (recurring orphaned-container problem during color switches).
- `ws_dispatch.sh` maps `api`/`web`/`parent` → `WS-API`/`WS-WEB`/in-place `HFM`; claims `WS1`/`WS2`/`HFM`. Gitignored FIFO queues: `api.queue`, `web.queue`, `parent.queue`, `review.queue`. `review_push.sh` after `gh pr create`; WS3 drains via `ws_review.sh --next`. Parent dispatch is in-place in `HFM/` (no isolated clone) — collision risk with Claude Code admin per `workspace_protocol.md` §7.4.
- VPS `~/finance_manager` deploys from standalone `finance_manager_api/` and `finance_manager_web/` git clones — parent submodule pointers do not drive VPS pulls.
- VPS `docker-compose.bluegreen.yml` and `scripts/fm_server_beta.sh` under `~/finance_manager/scripts/` are manually maintained on the host (with `.bak` backups), not auto-synced from parent `main`; `podman-compose` can echo interpolated `--env` secrets to stderr on any compose path (smoke/exec/build/config/logs), not only `up` — all compose invocations need stderr redaction.
- API repo uses `uv` + `pyproject.toml` + `uv.lock` for dependencies (not `requirements.txt`/pip); CI should use `uv sync --frozen`.
- GitHub Actions workflows should pin third-party actions to full commit SHAs and set least-privilege `permissions` (e.g. `contents: read`).
- Production hostnames web `thehivemanager.com` and API `api.thehivemanager.com` use HTTPS via blue-green proxy `:8443`; Cloudflare edge can `403` GitHub Actions datacenter curls — uptime checks hit origin `:8443` via `curl --resolve` (and `-k`). Health Check / `vps_state.sh` / `sprint_verify.sh` read `VPS_ORIGIN_IP` from a GitHub secret or repo-root `.env` (allowlisted, not shell-sourced).
- `main` branch protection is waived while repos stay private without GitHub Pro (explicit HitM decision); the parent ecosystem repo is `github.com/AzazelAzure/finance-manager-ecosystem`.
- Bill recurrence: the historical stopgap inferred cadence from `start_date`/`due_date` deltas (`bill_recurrence.py`); the first-class `cadence` field engine is implemented via `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` (`plans/S1/S1.B/complete/feat-bill-recurrence-engine/`), landing on the inactive color ahead of F-009.
- Currently a closed loop with one beta tester; secret rotation is deferred — scrub leaked secrets from logs and clear terminal history instead, with rotation enforced later.
