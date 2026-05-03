# Changelog — finance-manager-ecosystem (parent)

Notable changes to this **parent** repository: submodule pins, `plans/`, `deploy/`, and cross-cutting docs. Product changelogs live in each component repository.

## [Unreleased]

### 2026-05-05 — Wedge consistency audit execution pack

- **`plans/cursor/s1b/wedge-consistency-audit/README.md`:** canonical wedge quote, sequencing vs PWA/W3, **`i18n.ts`** surface map (`en-US` + `tl-PH`), method + deliverables + gates.
- **`plans/cursor/s1b/wedge-consistency-audit/AUDIT_REPORT.md`:** findings table template + P0/P1 + signoff.
- **`plans/cursor/s1b/wedge-consistency-audit/RESEARCH_ARTIFACTS.md`:** artifact index.
- **`plans/cursor/s1b/README.md`**, **`GEMINI_RESEARCH_README.md`:** stage table + Gemini handoff for wedge audit.

### 2026-05-05 — Payment provider `DECISION_MATRIX.md` (PM locks)

- **`plans/cursor/s1b/payment-provider-research/DECISION_MATRIX.md`:** Matrix 1–3 (PSP path, capabilities, settlement economics) + **PM1–PM5** HitM signoff slots (distinct from entity **L** locks).
- **`plans/cursor/s1b/payment-provider-research/README.md`:** **§0.65** hub link; deliverables + §3 pointers; `updated` metadata.
- **`PSP_COMPARISON_MATRIX.md`**, **`PAYMENT_ARCHITECTURE_SPLIT.md`**, **`plans/cursor/s1b/README.md`**, **`GEMINI_RESEARCH_README.md`:** cross-links.

### 2026-05-04 — Entity formation execution posture + US LLC pathways workbook

- **`plans/cursor/s1b/entity-formation-research/README.md`:** **§0.4** — counsel-heavy tail continues; **not** a PWA implementation blocker; **PSP go-live** still gated; hub table + **§7** payment/PWA nuance.
- **`plans/cursor/s1b/entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md`:** pathway **decision matrix** (P1–P9), Gemini protocol, dated research log, handoff checklist.
- **`plans/cursor/s1b/entity-formation-research/RESEARCH_ARTIFACTS.md`**, **`plans/cursor/s1b/README.md`:** index + stage table pointers.

### 2026-05-03 — S1.B operating entity pipeline lock + Gemini research protocol

- **`plans/cursor/s1b/entity-formation-research/`:** README **§0.2** (spouse-led PH MoR + HitM US LLC vendor, US-later + future regional split); **§0.3** payment coupling; objectives/scope; `DECISION_MATRIX` HitM locks **L2–L4** (2026-05-03) with L1 still time-gated; `RESEARCH_ARTIFACTS` touch; `HITM_LOCAL_CONTEXT` open question 4 aligned to pipeline + payment §0.6.
- **`plans/cursor/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`:** **§5.0** operating entity pipeline mirror; **§5.1** advisory note that §5.0 supersedes generic FEIE-trigger list for initial wedge; **§5.3** points at §5.0 for settlement dual-entity.
- **`plans/cursor/s1b/payment-provider-research/`:** README objective + **§0.6** (L2–L4 locked, PH spouse-led primary column, next dependency tax deep dive); §3 source line + §4 deliverables pipeline-aligned; `PSP_COMPARISON_MATRIX` + `PAYMENT_ARCHITECTURE_SPLIT` aligned to 2026-05-03 pipeline.
- **`plans/cursor/s1b/README.md`:** pointer to **`GEMINI_RESEARCH_README.md`** for external research tools.
- **`plans/cursor/s1b/GEMINI_RESEARCH_README.md`:** first-read protocol for Gemini/Antigravity (folder bounds, HitM-only locks, sources, CPPRD, no secrets).

### 2026-05-02 — S1.B entity/payment research governance + continual-learning memory

- **`plans/cursor/s1b/entity-formation-research/`:** Gemini-sourced drafts reconciled to plan governance (no premature `LOCKED` without HitM signoff); `DECISION_MATRIX`, `US_ENTITY_PH_OPERATIONS`, `PH_SPOUSE_LED_AND_TRANSFER`, `REGISTRATION_BREAKPOINTS`, `HITM_LOCAL_CONTEXT`, `SPOUSE_INVOLVEMENT_REQUIREMENTS.md`, `RESEARCH_ARTIFACTS`, plan `README` **draft** status restored; FIA / minimum-capital framed as activity-specific counsel verification.
- **`plans/cursor/s1b/payment-provider-research/`:** `README` §0.6 restored to **L1 time-gated** scenario coupling; Stripe back in scope; `PSP_COMPARISON_MATRIX.md` + `PAYMENT_ARCHITECTURE_SPLIT.md` as labeled research drafts with verify-on-provider disclaimers.
- **`plans/cursor/strategic-roadmap-reframe-53be/`:** Reverted unintended Gemini edits to `01_unit_economics_and_costs.md`, `PARKING_LOT.md` P-2, and phase files (locks belong in entity plan after HitM signoff, not in strategic locks from chat).
- **`.gitignore` / `README.md`:** `.cursorignore` is **local-only** again (not tracked); Antigravity/agent ignore patterns live in the untracked file for per-machine Cursor index hygiene.
- **`AGENTS.md`:** Continual-learning memory — normalize parallel-assistant tagged research before CPPRD; add overlapping agent trees to `.cursorignore`.

### 2026-05-01 — Submodule pins: track `design_docs` + `finance_manager_web` `main` merge commits

- **`design_docs` submodule:** **`15045e1`** (`main`, includes design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16) squash merge onto `main`; supersedes ecosystem pin **`94b2fbf`**).
- **`finance_manager_web` submodule:** **`a5d5f80`** (`main`, merge of web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34); supersedes pin **`39398ae`**).

Keeps the parent checkout aligned with each child’s canonical `main` after GitHub merge, so future submodule updates are a simple fast-forward.

### 2026-05-01 — S1.B CPPRD batch: PWA plans, strategic/governance research, vault + web submodule pins

- **`plans/cursor/s1b/pwa-install-offline-sync-research/`:** New sub-plan (README §1.1–§1.7, §6 bar, D0/D2/D3/D4 specs, `SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`, `API_VERSION_AND_CLIENT_WINDOW.md`, `RESEARCH_ARTIFACTS.md`, smoke/ADR).
- **`plans/cursor/s1b/README.md`:** **Sprint activation index — PWA** (`#pwa-sprint-activation-index`), sub-plan table pointers, exit summary tied to D4-exec.
- **`plans/cursor/strategic-roadmap-reframe-53be/`:** `validation_gates.md`, `phases/S1_public_beta_position.md`, `README.md` — PWA exit language, W2/W6 handoffs, Advanced tier reference; plus **`00_strategic_context.md`**, **`01_unit_economics_and_costs.md`**, **`PARKING_LOT.md`** updates from parallel research threads.
- **`plans/_governance/`:** `plan_registry.md` (PWA plan row); **`README.md`**, **`deployment_protocol.md`**, **`execution_protocols.md`**, **`plan_lifecycle.md`** — governance/lifecycle alignment.
- **`plans/cursor/s1b/ai-economics-deep-dive/`:** `README.md` plus new artifacts `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md`, `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`, `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md`, `LLM_PROVIDER_COST_SNAPSHOT.md`, `PAYG_VOLUME_BUNDLES_RESEARCH.md`.
- **`plans/cursor/s1b/drift-cleanup/README.md`**, **`plans/cursor/s1b/payment-provider-research/README.md`:** README touch-ups (other threads).
- **`AGENTS.md`:** PWA §1.7 seeding file + sprint activation path.
- **`.cursor/settings.json`:** Workspace/editor settings updates.
- **`design_docs` submodule:** Pinned to **`94b2fbf`** (design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16)) — Web PWA bridge doc (`12_Web_PWA_Install_Offline_Sync.md`), Android cross-ref, **`01_Business_Vision.md`** + **`Beta_Launch_Cutline`** touch-ups, vault `CHANGELOG`.
- **`finance_manager_web` submodule:** Pinned to **`39398ae`** (web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34)) — `CHANGELOG.md` touch-ups.

### 2026-05-01 — Strategic PH pricing lock + PAYG bundle research

- **`plans/cursor/strategic-roadmap-reframe-53be/`:** `01_unit_economics_and_costs.md` **§2.0** locks **Pro ₱249/mo**, **Pro+ ₱349/mo**, **PAYG floor ₱99→100 credits**, **≤100 founding seats** (₱999–₱1,499); PAYG **volume bundles** explicitly **research** (`PAYG_VOLUME_BUNDLES_RESEARCH.md`). `00_strategic_context.md` §3.5 / §3.11, `validation_gates.md` indexing note, `phases/S1_public_beta_position.md` Appendix A snapshot + Q4–Q6 updates.
- **`plans/cursor/s1b/ai-economics-deep-dive/`:** `PAYG_VOLUME_BUNDLES_RESEARCH.md`; `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` **§8.5**; README link; `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md` assumes **§2.0** locks.
- **`design_docs` submodule:** `01_Business_Vision.md` tier table aligned to **₱249** Pro list and **100**-seat founding cap (commit in design_docs repo when batching vault changes).

### 2026-05-01 — S1.B plan hygiene: drift-cleanup complete, AI economics shelved

- **`plans/cursor/s1b/drift-cleanup/README.md`:** `status: completed`; completion note (HitM-confirmed W1; evidence pointers).
- **`plans/cursor/s1b/ai-economics-deep-dive/README.md`:** `status: shelved`; `depends_on` entity + payment plans; status section explains resume trigger.
- **`plans/cursor/s1b/README.md`:** sub-plan table — drift-cleanup **completed**, ai-economics-deep-dive **shelved** with deps; Group C sequencing + personal constraint line updated.
- **`plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`:** W2 AI Economics bullet + S1.B exit line note **shelved** until entity + payment research (exit still requires Appendix A closure).

### 2026-05-01 — Canonical web stack: docs, Cursor rules, scripts

- **Docs:** `docs/agent-delegation-pilot.md`, `docs/SPDX_COMPLIANCE.md`, `docs/DEPENDENCY_LOCKFILES.md` — flagship **`finance_manager_web`**; Reflex framed as archived.
- **PR template:** `.github/pull_request_template.md` — target repos and changelog line use **Web** instead of Reflex.
- **Scripts:** `scripts/repos.txt`, `scripts/README.md`, `scripts/check_spdx.py` — include **web** (and Android) in multi-repo helpers; SPDX checker docstring notes **web** policy (web not bulk-scanned until headers are consistent).
- **Cursor:** `.cursor/rules/git-repo-workflow.mdc`, `agent-delegation.mdc`, `reflex-frontend.mdc`; `.cursor/skills/multi-repo-orchestration/SKILL.md`, `design-docs-sync/SKILL.md`, `.cursor/skills/README.md` — align with canonical **API + web + CLI** and archived Reflex.
- **Submodules:** `design_docs` pinned to **`8c4dc65`** (`main`, includes design-docs PR [#15](https://github.com/AzazelAzure/finance-manager-design-docs/pull/15) beta cutline + runtime sheet).

### 2026-05-01 — Plans archive, governance hygiene, design_docs CPPRD (ecosystem)

- **Plans:** Moved legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/`, and `plans/volatile_standby/` under `plans/archived/`; refreshed cross-references; corrected post-beta huddle and PH Android archive paths; `plans/_governance/README.md`, `plan_registry.md`, and `glossary.md` updated for hierarchical layout and archive index row; strategic plan README stage line and `00_strategic_context.md` broken-path fix.
- **Cursor skills:** `huddle-facilitation` and `roadmap-rollout-planning` aligned with `plans/cursor/<phase-stage>/<sub-plan>/` and archived volatile conventions.
- **Submodules:** `design_docs` pinned to `7c9a57e` on branch `cursor/strategic-doc-sync-2026-05-01` (vault strategic alignment, `design_docs/CHANGELOG.md`, **resolved** strategic-doc conflict set: PH-first `07_Server_Runtime_and_Scaling.md` §2, web-first golden rule / phase triggers, `20_Roadmap/_historical/` for calendar + orchestration_manager packs).

### 2026-05-01 — Plans, deploy runbook, submodule sync

- **Plans:** S1.B drift-cleanup and strategic roadmap README/context updates; T04/T06 task note refresh; governance branching doc table and list formatting.
- **Deploy:** `deploy/BLUEGREEN_SWITCHOVER.md` — Podman `depends_on` / proxy ordering when recycling inactive `api-*` / `web-*` after image rebuilds; API `--no-cache` rebuild caveat.
- **Submodules:** Pinned `finance_manager_api`, `finance_manager_web`, and `finance_manager_reflex` to current `origin/main` after merged beta work (email uniqueness, web onboarding, Reflex archival record). `design_docs` bumped to `main` including design-docs PR [#12](https://github.com/AzazelAzure/finance-manager-design-docs/pull/12) (runtime validation, deployment strategy, triage cross-refs).
