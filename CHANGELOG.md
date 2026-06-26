# Changelog — finance-manager-ecosystem (parent)

Notable changes to this **parent** repository: submodule pins, `governance/`, `plans/`, `deploy/`, and cross-cutting docs. Product changelogs live in each component repository.

## [Unreleased]

### 2026-06-26 — Stale PR report refresh

- **Strategy:** [`strategy/standby/open_prs_assessment.md`](strategy/standby/open_prs_assessment.md) rewritten as the single stale-PR report across ecosystem, android, API, CLI, design docs, rust middleware, rust tools, and web repos; flags API #33/#34 and Web #60/#61 as 7+ day stale with merge/conflict evidence and duplication/order risks. [`strategy/standby/README.md`](strategy/standby/README.md) pointer/action summary aligned to the refreshed report.

### 2026-06-26 — Admin governance overhaul (three-tool model)

- **`AGENTS.md`:** Restructured §0–§6 — three-tool model (`cur/` / `cla/` / `agy/`), universal rules inline, branch conventions, per-agent reading order, CPPR/CPPRD discipline, retired daily-status PR pattern.
- **`CLAUDE.md`:** New Claude Code–specific admin rules.
- **`governance/README.md`:** Trimmed to router table + enums; reading sequences moved to `AGENTS.md`.
- **`governance/branching_guidelines.md`:** Branch prefix table updated to `cur/` / `cla/` / `agy/` (new branches only).
- **Archived:** `governance/archived/` — `orchestration.md`, skill mirrors, `agent_context_delivery.md`; index README added.
- **Cursor rule:** `.cursor/rules/sprint-task-specification.mdc` (from former `governance/sprint_task_specification.md`).
- **Scripts archived:** Slack bridges + `orchestrator.py` → `scripts/archived/` (see `scripts/archived/README.md`).
- **Strategy:** Admin-only header on `strategy/current_status.md`; superseded note on `cursor_vs_claude_max_cba.md`.
- **Cross-links:** `plans/README.md`, `agent_workspace_isolation.md`, orchestration-manager skill paths updated.

- **Sprint pipeline queue:** shared next-slice Slack bodies live under [`plans/pipeline_queue/README.md`](plans/pipeline_queue/README.md); set **`SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`** there (replaces per-plan `…/feat-f007-walkthrough-polish/evidence/pipeline_queue/`). [`plans/README.md`](plans/README.md) index updated; [`governance/sprint_queue_message_spec_v1.md`](governance/archived/sprint_queue_message_spec_v1.md) runbook + archived [`scripts/sprint_slack_pipeline_bridge.py`](scripts/archived/sprint_slack_pipeline_bridge.py) example env aligned.

### 2026-05-22 — Definition of done, F-011 beta subpages, rollout-order huddle

- **Governance:** [`governance/definition_of_done.md`](governance/definition_of_done.md) — PWA completeness note, class **A/B**, mandatory localization vs **shelved** signoff, SEO matrix + in-sprint P0 expectation, F-011 beta comms, completion checklist; §5b + checklist for **`#sprint-queue`** when used. [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) — normative **`sprint-queue-v1`** post shape (Cursor PA → cursor-agent). Cross-links: [`governance/plan_template.md`](governance/plan_template.md) §1b, [`governance/glossary.md`](governance/glossary.md) §12–§13, [`governance/README.md`](governance/README.md), [`governance/orchestration.md`](governance/orchestration.md) (protocols table), [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md).
- **Huddle:** [`strategy/huddles/2026-05-22-feature-rollout-sprint-order/`](strategy/huddles/2026-05-22-feature-rollout-sprint-order/) — README (incl. transcript provenance), talking points, `DECISIONS`/`ACTIONS` stubs for product · beta · infra sprint order.
- **F-011:** [`plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md`](plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md) — beta subpages scope (about, pipeline, release notes + bugfixes).
- **F-007 polish:** [`plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/README.md) — shelved i18n for tours + `definition_of_done` cross-links; [`SLACK_SPRINT_QUEUE.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md) — examples + slice order (spec lives under `governance/`). **Design:** [`design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`](design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md) — `#sprint-queue` pointers aligned to governance + `Task Id:` spelling.
- **`#sprint-queue` first line:** [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md), [`governance/glossary.md`](governance/glossary.md), [`governance/definition_of_done.md`](governance/definition_of_done.md), bridge doc, F-007 polish Slack example — require **`@CursorPA`** (no space); `@Cursor PA` does not trigger the runner mention in HitM’s Slack workspace.
- **Sprint pipeline gap (narrowed):** [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) **Pipeline continuity** + [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md) — `#sprint-queue` intake alone does not post `#review-queue`; run the bridge (and optional local inbox) on the PA host for continuity. Phase 1 manual relay envelopes remain valid without the bridge.
- **Sprint Slack bridge:** [`scripts/sprint_slack_pipeline_bridge.py`](scripts/sprint_slack_pipeline_bridge.py) — Web API poller for `SPRINT_PIPELINE_JSON` (`READY_FOR_REVIEW` / `REVIEW_VERDICT`), optional **`SPRINT_PIPELINE_LOCAL_INBOX`** JSONL on the same host (no sprint-thread READY required), [`scripts/sprint_pipeline_emit_ready.py`](scripts/sprint_pipeline_emit_ready.py) helper, reviewer-agent verdict mode enabled via **`SPRINT_BRIDGE_REVIEW_AGENT_ENABLED`** + workspace/timeout env, conservative defaults with **`SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM=0`** and **`SPRINT_BRIDGE_AUTO_PASS_V0=0`**, next-slice file under `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`, and HitM gate routing when `requires_hitm: true`. Spec: [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) §Machine-readable pipeline.
- **Cursor PA paths:** [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md) §Runtime layout — `~/CursorAgent/headless-cursor-agent/scripts/cursor_slack_runner.py`, inbox/outbox filenames (`cursor_slack_inbox.jsonl`, `cursor_slack_outbox.jsonl`); sprint bridge docstring + sprint spec cross-link for co-running with Socket Mode.
- **design_docs submodule:** bumped to **`finance-manager-design-docs` `main` @ `b7fdab3`** (GitHub merge of bridge PR #19) so clones/rebases track the same Slack sprint-queue contract as `governance/sprint_queue_message_spec_v1.md`.

### 2026-05-21 — AGENTS.md sync + F-007 walkthrough polish plan

- **AGENTS.md:** Continual-learning updates (Cursor PA / Antigravity orchestration, slice-scope bias, breakpoint handoff) for agent workspaces.
- **Plans:** [`plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/README.md) — T00–T03 tasks with V0–V3 evidence hooks + `sprint_verify.sh`; registry + S1.B index + F-007 README cross-link.

### 2026-05-05 — Orchestration huddle execution: sprint verify + Cursor PA Slack docs

- **Scripts:** [`scripts/sprint_verify.sh`](scripts/sprint_verify.sh) — SSH to VPS, git update selected subrepos, `fm_server_beta.sh rebuild-color` + optional `smoke`; evidence logs under `--evidence`. [`scripts/jsdevtesting_stack_check.sh`](scripts/jsdevtesting_stack_check.sh) — HTTPS probes for `jsdevtesting` + `api-jsdevtesting`.
- **Governance:** [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md); [`governance/agent_workspace_isolation.md`](governance/agent_workspace_isolation.md) and [`governance/README.md`](governance/README.md) / [`governance/orchestration.md`](governance/orchestration.md) updated for Cursor PA + JSONL outbox vs IDE MCP; Antigravity runner marked legacy in [`scripts/antigravity_slack_runner.py`](scripts/antigravity_slack_runner.py); note in [`scripts/cursor_headless_slack_agent.py`](scripts/cursor_headless_slack_agent.py).
- **Huddle:** [`strategy/huddles/2026-05-04-orchestration-overhaul/VERIFICATION_DELTA.md`](strategy/huddles/2026-05-04-orchestration-overhaul/VERIFICATION_DELTA.md); [`implementation_plan.md`](strategy/huddles/2026-05-04-orchestration-overhaul/implementation_plan.md) exit table synced to canonical [`ACTIONS.md`](strategy/huddles/2026-05-04-orchestration-overhaul/ACTIONS.md); [`README.md`](strategy/huddles/2026-05-04-orchestration-overhaul/README.md) pointers.
- **F-007:** [`plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/V2_ORCHESTRATION_2026-05-05.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/V2_ORCHESTRATION_2026-05-05.md) + `runtime_handoff.md` ACTIONS #7 line.

### 2026-05-04 — F-007 guided walkthroughs: slice-based rebuild plan

- **Plans:** [`plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md) — rebuild stance, code inventory, tasks **T00–T07** with **T##.SL#** verify-first gates; [`tasks/T00_baseline_rebuild_audit.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/tasks/T00_baseline_rebuild_audit.md); [`runtime_handoff.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/runtime_handoff.md) aligned (PR placeholder removed, slice log table).

### 2026-05-04 — Task slices (`T##.SL#`) and clarifying-questions protocol

- **Governance:** [`governance/plan_template.md`](governance/plan_template.md) §1a defines **tasks** `T##` and **slices** `T##.SL#` (**`SL`** distinct from Phase/Stage **S** notation); validator, body template, and execution-order examples updated. [`governance/glossary.md`](governance/glossary.md) §3, [`governance/branching_guidelines.md`](governance/branching_guidelines.md) §2.1, [`governance/plan_registry.md`](governance/plan_registry.md) hierarchy note, [`governance/orchestration.md`](governance/orchestration.md) directives, [`governance/plan_lifecycle.md`](governance/plan_lifecycle.md) §A, [`governance/README.md`](governance/README.md) Sequence A, and skill mirrors [`governance/skill_orchestration_manager.md`](governance/skill_orchestration_manager.md), [`governance/skill_roadmap_rollout_planning.md`](governance/skill_roadmap_rollout_planning.md) aligned.
- **Cursor:** [`feature-implementation-loop`](.cursor/skills/feature-implementation-loop/SKILL.md), [`bugfix-investigation-loop`](.cursor/skills/bugfix-investigation-loop/SKILL.md), [`orchestration-manager`](.cursor/skills/orchestration-manager/SKILL.md) (+ [`AGENT_PROMPT_TEMPLATE.md`](.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md)), [`roadmap-rollout-planning`](.cursor/skills/roadmap-rollout-planning/SKILL.md), [`multi-repo-orchestration`](.cursor/skills/multi-repo-orchestration/SKILL.md), [`shared-subagent-handoff`](.cursor/skills/shared-subagent-handoff/SKILL.md); [`.cursor/rules/core-standards.mdc`](.cursor/rules/core-standards.mdc) and [`.cursor/rules/agent-delegation.mdc`](.cursor/rules/agent-delegation.mdc).
- **Parent docs:** [`AGENTS.md`](AGENTS.md), [`GEMINI.md`](GEMINI.md), [`plans/README.md`](plans/README.md), [`plans/templates/README.md`](plans/templates/README.md), [`plans/S1/S1.B/README.md`](plans/S1/S1.B/README.md).
- **Stage S1.B plan READMEs:** Task-and-slice section added (or research-oriented variant); **F-007** (`feat-f007-guided-walkthroughs`) received a **shelved** note only pending a future slice pass.

### 2026-05-04 — Archive `plans/templates/GEMINI_PLAN_TEMPLATE*.md`

- **Moved** `GEMINI_PLAN_TEMPLATE.md`, `GEMINI_PLAN_TEMPLATE_V2.md`, and `GEMINI_PLAN_TEMPLATE_QUICK.md` to [`plans/archived/gemini_plan_templates/`](plans/archived/gemini_plan_templates/) with index README. **`governance/plan_template.md`** is the only active plan schema; [`plans/templates/README.md`](plans/templates/README.md) points authors there. Updated [`governance/plan_template.md`](governance/plan_template.md) intro and [`GEMINI.md`](GEMINI.md).

### 2026-05-04 — Plans health: `plans/README.md`, remove duplicate `plans/feat/` tree

- **Added** [`plans/README.md`](plans/README.md) as the entry map for active `plans/<Phase>/<Stage>/`, `plans/archived/`, and `plans/templates/` (vs **`strategy/`** and **`governance/`**).
- **Removed** residual duplicate `plans/feat/web-reflex-parity-sweep-1/` (canonical frozen plan: [`plans/archived/feat/web-reflex-parity-sweep-1/`](plans/archived/feat/web-reflex-parity-sweep-1/)).
- **Docs:** `AGENTS.md` orchestration bullet Markdown fix; `plans/S1/S1.B/drift-cleanup/tasks/T01_bill_disable_retro_commit.md` uses submodule-relative wording for the QuickActions comparison; `plans/cursor/_TEMP_ECOSYSTEM_HEALTH_AND_DIRECTIVES_2026-05-04.md` parity item marked resolved; parent [`README.md`](README.md) links [`plans/README.md`](plans/README.md).
- **Governance — orchestration:** [`governance/orchestration.md`](governance/orchestration.md) (single index: strategy, plans, governance table, Cursor layer, runtime, read order, directives snapshot). Skill mirrors: [`governance/skill_roadmap_rollout_planning.md`](governance/skill_roadmap_rollout_planning.md), [`governance/skill_orchestration_manager.md`](governance/skill_orchestration_manager.md). [`governance/README.md`](governance/README.md) table + Sequence F; forbidden-actions bullet aligned with Cursor PR links + GitHub merge checks. [`plans/README.md`](plans/README.md) and [`GEMINI.md`](GEMINI.md) link the orchestration index; `_TEMP` consolidation item marked done.
- **Cursor:** [`.cursor/skills/orchestration-manager/SKILL.md`](.cursor/skills/orchestration-manager/SKILL.md) and [`AGENT_PROMPT_TEMPLATE.md`](.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md) use hierarchical `plans/<Phase>/<Stage>/<sub-plan>/` and PR protocol consistent with `AGENTS.md`.

### 2026-05-04 — `GEMINI.md` aligned with ecosystem layout and governance

- **Rewrote** root [`GEMINI.md`](GEMINI.md): parent vs submodules, `governance/` + `strategy/` + hierarchical `plans/`, canonical **`governance/plan_template.md`**, API `finance/` layout, flagship web, Docker/proxy `:8443` and `scripts/` pointers, CPPRD/PR rules, archived Reflex, and archived root Python scratches path.

### 2026-05-04 — Archive repo-root one-off Python scripts

- **Moved** nine ad-hoc `*.py` files from the parent repo root into [`scripts/archived/root_one_off_python/`](scripts/archived/root_one_off_python/) with an index [`README.md`](scripts/archived/root_one_off_python/README.md). They were Reflex-era / local-smoke scratches (hardcoded paths, not CI); real tests live in `finance_manager_api/` and `finance_manager_web/`.

### 2026-05-04 — Strategic roadmap: `strategy/strategic-roadmap-reframe-53be/`

- **`plans/cursor/strategic-roadmap-reframe-53be/` → `strategy/strategic-roadmap-reframe-53be/`:** Canonical multi-year roadmap tree moved to repo-root **`strategy/`** (sibling to `plans/`). Added [`strategy/README.md`](strategy/README.md) as the entry router.
- **Pointers:** `AGENTS.md`, `governance/*`, `README.md`, `.cursor/` skills/rules, `plans/S1/S1.B/**`, `design_docs/**`, `scripts/schedule_agent_sync.sh`, archives, and plan YAML `strategic_link` fields updated; relative markdown links recomputed per file depth.

### 2026-05-04 — Active S1.B plans: `plans/S1/S1.B/` + `cursor-layout-era` archive

- **`plans/cursor/s1b/` → `plans/S1/S1.B/`:** All active Stage S1.B implementation sub-plans, research, feature drafts, and backlog markdown (`FEATURE_IDEAS.md`, `PRODUCT_FEATURE_BACKLOG_INDEX.md`) now live under phase/stage paths. Cross-links, `AGENTS.md`, `governance/*`, strategic README §8, and `.cursor/skills/roadmap-rollout-planning/SKILL.md` updated.
- **`plans/archived/cursor-layout-era/`:** Closed pre-governance umbrellas formerly under `plans/cursor/` (api-reflex beta readiness, web beta rollout, server blue-green install, VPS ops, security hardening, vps-reflex recovery) moved here; index `README.md` explains scope.
- **Submodules / web:** `design_docs` path text updates; `finance_manager_web` comment pointer in `QuickActions.tsx`.

### 2026-05-04 — Governance protocols moved to repo-root `governance/`

- **`plans/_governance/` → `governance/`:** Plan ops manuals (registry, lifecycle, deploy, branching, glossary, HitM schedule docs) now live at the workspace root, sibling to `plans/`. Tactical execution plans use hierarchical `plans/<Phase>/<Stage>/<sub-plan>/` (see later 2026-05-04 S1.B lift in this changelog).
- **Pointers:** `AGENTS.md`, parent `README.md`, `.gitignore` (schedule snapshot path), `scripts/schedule_agent_sync.sh`, `.cursor/` skills/rules, `design_docs/` vault links, and plan/strategic markdown cross-references updated to the new layout.

### 2026-05-21 — Parent CPPRD: submodule pins, PWA pause registry, plans + brand pack

- **Submodules:** `finance_manager_api` → **`main`** (merge **`cb02b24`** — PWA D2 idempotency allowlist for categories/tags/sources). `finance_manager_web` → **`main`** (merge **`e3dc6e1`** — offline outbox lookup allowlist + Workbox navigate fix PR #45).
- **PWA implementation sprint:** `plans/S1/S1.B/pwa-implementation-branch/runtime_handoff.md` — paused snapshot + **Open issues (paused)** (online transaction network error; offline shell error unchanged post-#45). `validation_gates.md` touch-up. `governance/plan_registry.md` — sprint row moved to **Paused** (deduped from Draft).
- **Plans / research:** `plans/S1/S1.B/entity-formation-research/ACTION_SEQUENCE.md` (new). `plans/feat/web-reflex-parity-sweep-1/` (parity sweep plan tree). Ongoing edits: `FEATURE_IDEAS.md`, `PRODUCT_FEATURE_BACKLOG_INDEX.md`, `SEO_PRIORITY_MATRIX.md`, `feat-f007-guided-walkthroughs/README.md`.
- **Brand assets:** `resources/hfm_icon_web/` (F-011 README–referenced HitM icon pack; PNG set for wedge / manifest work).
- **`AGENTS.md`:** workspace memory / alignment updates.
- **Branch:** merged **`origin/main`** into `cursor/s1b/feat/s1b-feature-plans-registry` so parent history includes latest ecosystem `main`.

### 2026-05-06 — `fm_server_beta.sh rebuild-color` (Podman blue/green)

- **`scripts/fm_server_beta.sh`:** New **`rebuild-color [--no-build] <blue|green>`** command: builds `api-*`/`web-*` for one color, stops **proxy** plus that color’s app containers, removes those containers via compose **labels** (no `podman-compose rm`, which does not exist), then `up -d` db/redis/api/web/proxy. Avoids Podman **`--requires`** / `depends_on` failures when replacing inactive backends. Parallel compose file keeps `up -d --force-recreate` only (no proxy). **`wait_api_service_ready`** polls `/api/health/` so immediate `smoke` after `rebuild-color` does not race Django startup.
- **`deploy/BLUEGREEN_SWITCHOVER.md`**, **`deploy/SERVER_BETA_INSTALL.md`**, **`governance/deployment_protocol.md`:** Runbook updated to prefer `rebuild-color` after on-host image changes.

### 2026-05-05 — KNOWN_ISSUES: P0 #8 source balance after transaction delete

- **`plans/archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md`:** Issue **#8** (S1) — source balance recalculation broken when transactions are deleted; summary table updated.

### 2026-05-05 — Gemini research CPPRD batch (PSP locks, distribution SEO, entity counsel prep)

- **`plans/S1/S1.B/payment-provider-research/`:** HitM-confirmed **PM1–PM4** (PayMongo primary, Xendit secondary, Maya auto-debit + GCash manual invoice, **~2.0%** blended wallet MDR); `DECISION_MATRIX` Matrices 1–3 filled; `PSP_COMPARISON_MATRIX`, `PAYMENT_ARCHITECTURE_SPLIT`, `README` §0.6/§1/§5 gates; new **`PSP_RESEARCH_NOTES_2026_05.md`** (rationale). Governance note: re-verify on PSP sites before production.
- **`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`:** §2 bullets — PSP MDR **~2.0%** (PM4); §4.1 modeling note vs **~0.85** shortcut.
- **`plans/S1/S1.B/distribution-channel-research/`:** `README` deliverables expanded; **`DECISION_MATRIX.md`**, **`DISTRIBUTION_RESEARCH_NOTES.md`**, **`SEO_GUIDE_01–03`**, **`SEO_PRIORITY_MATRIX.md`** (Gemini-assisted SEO / channel research).
- **`plans/S1/S1.B/entity-formation-research/`:** `RESEARCH_ARTIFACTS` index; **`DTI_VS_OPC_COMPARISON.md`**, **`PH_COUNSEL_QUESTIONNAIRE.md`**, **`TAX_ADVISOR_QUESTIONNAIRE.md`**.

### 2026-05-05 — Wedge consistency audit execution pack

- **`plans/S1/S1.B/wedge-consistency-audit/README.md`:** canonical wedge quote, sequencing vs PWA/W3, **`i18n.ts`** surface map (`en-US` + `tl-PH`), method + deliverables + gates.
- **`plans/S1/S1.B/wedge-consistency-audit/AUDIT_REPORT.md`:** findings table template + P0/P1 + signoff.
- **`plans/S1/S1.B/wedge-consistency-audit/RESEARCH_ARTIFACTS.md`:** artifact index.
- **`plans/S1/S1.B/README.md`**, **`GEMINI_RESEARCH_README.md`:** stage table + Gemini handoff for wedge audit.

### 2026-05-05 — Payment provider `DECISION_MATRIX.md` (PM locks)

- **`plans/S1/S1.B/payment-provider-research/DECISION_MATRIX.md`:** Matrix 1–3 (PSP path, capabilities, settlement economics) + **PM1–PM5** HitM signoff slots (distinct from entity **L** locks).
- **`plans/S1/S1.B/payment-provider-research/README.md`:** **§0.65** hub link; deliverables + §3 pointers; `updated` metadata.
- **`PSP_COMPARISON_MATRIX.md`**, **`PAYMENT_ARCHITECTURE_SPLIT.md`**, **`plans/S1/S1.B/README.md`**, **`GEMINI_RESEARCH_README.md`:** cross-links.

### 2026-05-04 — Entity formation execution posture + US LLC pathways workbook

- **`plans/S1/S1.B/entity-formation-research/README.md`:** **§0.4** — counsel-heavy tail continues; **not** a PWA implementation blocker; **PSP go-live** still gated; hub table + **§7** payment/PWA nuance.
- **`plans/S1/S1.B/entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md`:** pathway **decision matrix** (P1–P9), Gemini protocol, dated research log, handoff checklist.
- **`plans/S1/S1.B/entity-formation-research/RESEARCH_ARTIFACTS.md`**, **`plans/S1/S1.B/README.md`:** index + stage table pointers.

### 2026-05-03 — S1.B operating entity pipeline lock + Gemini research protocol

- **`plans/S1/S1.B/entity-formation-research/`:** README **§0.2** (spouse-led PH MoR + HitM US LLC vendor, US-later + future regional split); **§0.3** payment coupling; objectives/scope; `DECISION_MATRIX` HitM locks **L2–L4** (2026-05-03) with L1 still time-gated; `RESEARCH_ARTIFACTS` touch; `HITM_LOCAL_CONTEXT` open question 4 aligned to pipeline + payment §0.6.
- **`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`:** **§5.0** operating entity pipeline mirror; **§5.1** advisory note that §5.0 supersedes generic FEIE-trigger list for initial wedge; **§5.3** points at §5.0 for settlement dual-entity.
- **`plans/S1/S1.B/payment-provider-research/`:** README objective + **§0.6** (L2–L4 locked, PH spouse-led primary column, next dependency tax deep dive); §3 source line + §4 deliverables pipeline-aligned; `PSP_COMPARISON_MATRIX` + `PAYMENT_ARCHITECTURE_SPLIT` aligned to 2026-05-03 pipeline.
- **`plans/S1/S1.B/README.md`:** pointer to **`GEMINI_RESEARCH_README.md`** for external research tools.
- **`plans/S1/S1.B/GEMINI_RESEARCH_README.md`:** first-read protocol for Gemini/Antigravity (folder bounds, HitM-only locks, sources, CPPRD, no secrets).

### 2026-05-03 — PWA implementation + SEO orchestration plan (S1.B)

- **`plans/S1/S1.B/pwa-implementation-branch/`:** Execution-ready plan **`PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`** — `README.md` (YAML + phase compass), `validation_gates.md` (BP0–BP_SEO_P1, **SEO P1** gated on **BP_SPRINT_CLOSE**), `runtime_handoff.md`, `CROSS_AGENT_COORDINATION.md`, `governance_validator_run_2026-05-03.md`, tasks **T00–T16** (API D2, web build/manifest/SW, IndexedDB seed, outbox, D3 auth, D4-exec, docs CPPRD, **SEO P0** parallel / **SEO P1** deferred). Host branch: `cursor/s1b/pwa-implementation-branch`. Plan stays **`draft`** until `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` is **`completed`** in registry.
- **`governance/plan_registry.md`:** Draft row for the implementation sprint plan.
- **`plans/S1/S1.B/README.md`:** Sub-plan index row + sprint activation index link to `pwa-implementation-branch/README.md`.

### 2026-05-02 — S1.B entity/payment research governance + continual-learning memory

- **`plans/S1/S1.B/entity-formation-research/`:** Gemini-sourced drafts reconciled to plan governance (no premature `LOCKED` without HitM signoff); `DECISION_MATRIX`, `US_ENTITY_PH_OPERATIONS`, `PH_SPOUSE_LED_AND_TRANSFER`, `REGISTRATION_BREAKPOINTS`, `HITM_LOCAL_CONTEXT`, `SPOUSE_INVOLVEMENT_REQUIREMENTS.md`, `RESEARCH_ARTIFACTS`, plan `README` **draft** status restored; FIA / minimum-capital framed as activity-specific counsel verification.
- **`plans/S1/S1.B/payment-provider-research/`:** `README` §0.6 restored to **L1 time-gated** scenario coupling; Stripe back in scope; `PSP_COMPARISON_MATRIX.md` + `PAYMENT_ARCHITECTURE_SPLIT.md` as labeled research drafts with verify-on-provider disclaimers.
- **`strategy/strategic-roadmap-reframe-53be/`:** Reverted unintended Gemini edits to `01_unit_economics_and_costs.md`, `PARKING_LOT.md` P-2, and phase files (locks belong in entity plan after HitM signoff, not in strategic locks from chat).
- **`.gitignore` / `README.md`:** `.cursorignore` is **local-only** again (not tracked); Antigravity/agent ignore patterns live in the untracked file for per-machine Cursor index hygiene.
- **`AGENTS.md`:** Continual-learning memory — normalize parallel-assistant tagged research before CPPRD; add overlapping agent trees to `.cursorignore`.

### 2026-05-01 — Submodule pins: track `design_docs` + `finance_manager_web` `main` merge commits

- **`design_docs` submodule:** **`15045e1`** (`main`, includes design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16) squash merge onto `main`; supersedes ecosystem pin **`94b2fbf`**).
- **`finance_manager_web` submodule:** **`a5d5f80`** (`main`, merge of web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34); supersedes pin **`39398ae`**).

Keeps the parent checkout aligned with each child’s canonical `main` after GitHub merge, so future submodule updates are a simple fast-forward.

### 2026-05-01 — S1.B CPPRD batch: PWA plans, strategic/governance research, vault + web submodule pins

- **`plans/S1/S1.B/pwa-install-offline-sync-research/`:** New sub-plan (README §1.1–§1.7, §6 bar, D0/D2/D3/D4 specs, `SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`, `API_VERSION_AND_CLIENT_WINDOW.md`, `RESEARCH_ARTIFACTS.md`, smoke/ADR).
- **`plans/S1/S1.B/README.md`:** **Sprint activation index — PWA** (`#pwa-sprint-activation-index`), sub-plan table pointers, exit summary tied to D4-exec.
- **`strategy/strategic-roadmap-reframe-53be/`:** `validation_gates.md`, `phases/S1_public_beta_position.md`, `README.md` — PWA exit language, W2/W6 handoffs, Advanced tier reference; plus **`00_strategic_context.md`**, **`01_unit_economics_and_costs.md`**, **`PARKING_LOT.md`** updates from parallel research threads.
- **`governance/`:** `plan_registry.md` (PWA plan row); **`README.md`**, **`deployment_protocol.md`**, **`execution_protocols.md`**, **`plan_lifecycle.md`** — governance/lifecycle alignment.
- **`plans/S1/S1.B/ai-economics-deep-dive/`:** `README.md` plus new artifacts `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md`, `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`, `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md`, `LLM_PROVIDER_COST_SNAPSHOT.md`, `PAYG_VOLUME_BUNDLES_RESEARCH.md`.
- **`plans/S1/S1.B/drift-cleanup/README.md`**, **`plans/S1/S1.B/payment-provider-research/README.md`:** README touch-ups (other threads).
- **`AGENTS.md`:** PWA §1.7 seeding file + sprint activation path.
- **`.cursor/settings.json`:** Workspace/editor settings updates.
- **`design_docs` submodule:** Pinned to **`94b2fbf`** (design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16)) — Web PWA bridge doc (`12_Web_PWA_Install_Offline_Sync.md`), Android cross-ref, **`01_Business_Vision.md`** + **`Beta_Launch_Cutline`** touch-ups, vault `CHANGELOG`.
- **`finance_manager_web` submodule:** Pinned to **`39398ae`** (web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34)) — `CHANGELOG.md` touch-ups.

### 2026-05-01 — Strategic PH pricing lock + PAYG bundle research

- **`strategy/strategic-roadmap-reframe-53be/`:** `01_unit_economics_and_costs.md` **§2.0** locks **Pro ₱249/mo**, **Pro+ ₱349/mo**, **PAYG floor ₱99→100 credits**, **≤100 founding seats** (₱999–₱1,499); PAYG **volume bundles** explicitly **research** (`PAYG_VOLUME_BUNDLES_RESEARCH.md`). `00_strategic_context.md` §3.5 / §3.11, `validation_gates.md` indexing note, `phases/S1_public_beta_position.md` Appendix A snapshot + Q4–Q6 updates.
- **`plans/S1/S1.B/ai-economics-deep-dive/`:** `PAYG_VOLUME_BUNDLES_RESEARCH.md`; `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` **§8.5**; README link; `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md` assumes **§2.0** locks.
- **`design_docs` submodule:** `01_Business_Vision.md` tier table aligned to **₱249** Pro list and **100**-seat founding cap (commit in design_docs repo when batching vault changes).

### 2026-05-01 — S1.B plan hygiene: drift-cleanup complete, AI economics shelved

- **`plans/S1/S1.B/drift-cleanup/README.md`:** `status: completed`; completion note (HitM-confirmed W1; evidence pointers).
- **`plans/S1/S1.B/ai-economics-deep-dive/README.md`:** `status: shelved`; `depends_on` entity + payment plans; status section explains resume trigger.
- **`plans/S1/S1.B/README.md`:** sub-plan table — drift-cleanup **completed**, ai-economics-deep-dive **shelved** with deps; Group C sequencing + personal constraint line updated.
- **`strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`:** W2 AI Economics bullet + S1.B exit line note **shelved** until entity + payment research (exit still requires Appendix A closure).

### 2026-05-01 — Canonical web stack: docs, Cursor rules, scripts

- **Docs:** `docs/agent-delegation-pilot.md`, `docs/SPDX_COMPLIANCE.md`, `docs/DEPENDENCY_LOCKFILES.md` — flagship **`finance_manager_web`**; Reflex framed as archived.
- **PR template:** `.github/pull_request_template.md` — target repos and changelog line use **Web** instead of Reflex.
- **Scripts:** `scripts/repos.txt`, `scripts/README.md`, `scripts/check_spdx.py` — include **web** (and Android) in multi-repo helpers; SPDX checker docstring notes **web** policy (web not bulk-scanned until headers are consistent).
- **Cursor:** `.cursor/rules/git-repo-workflow.mdc`, `agent-delegation.mdc`, `reflex-frontend.mdc`; `.cursor/skills/multi-repo-orchestration/SKILL.md`, `design-docs-sync/SKILL.md`, `.cursor/skills/README.md` — align with canonical **API + web + CLI** and archived Reflex.
- **Submodules:** `design_docs` pinned to **`8c4dc65`** (`main`, includes design-docs PR [#15](https://github.com/AzazelAzure/finance-manager-design-docs/pull/15) beta cutline + runtime sheet).

### 2026-05-01 — Plans archive, governance hygiene, design_docs CPPRD (ecosystem)

- **Plans:** Moved legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/`, and `plans/volatile_standby/` under `plans/archived/`; refreshed cross-references; corrected post-beta huddle and PH Android archive paths; `governance/README.md`, `plan_registry.md`, and `glossary.md` updated for hierarchical layout and archive index row; strategic plan README stage line and `00_strategic_context.md` broken-path fix.
- **Cursor skills:** `huddle-facilitation` and `roadmap-rollout-planning` aligned with `plans/<Phase>/<Stage>/<sub-plan>/` and archived volatile conventions.
- **Submodules:** `design_docs` pinned to `7c9a57e` on branch `cursor/strategic-doc-sync-2026-05-01` (vault strategic alignment, `design_docs/CHANGELOG.md`, **resolved** strategic-doc conflict set: PH-first `07_Server_Runtime_and_Scaling.md` §2, web-first golden rule / phase triggers, `20_Roadmap/_historical/` for calendar + orchestration_manager packs).

### 2026-05-01 — Plans, deploy runbook, submodule sync

- **Plans:** S1.B drift-cleanup and strategic roadmap README/context updates; T04/T06 task note refresh; governance branching doc table and list formatting.
- **Deploy:** `deploy/BLUEGREEN_SWITCHOVER.md` — Podman `depends_on` / proxy ordering when recycling inactive `api-*` / `web-*` after image rebuilds; API `--no-cache` rebuild caveat.
- **Submodules:** Pinned `finance_manager_api`, `finance_manager_web`, and `finance_manager_reflex` to current `origin/main` after merged beta work (email uniqueness, web onboarding, Reflex archival record). `design_docs` bumped to `main` including design-docs PR [#12](https://github.com/AzazelAzure/finance-manager-design-docs/pull/12) (runtime validation, deployment strategy, triage cross-refs).
