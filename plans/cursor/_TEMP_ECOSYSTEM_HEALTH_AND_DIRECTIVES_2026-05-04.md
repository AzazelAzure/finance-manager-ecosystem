# Ecosystem health snapshot and current directives (temporary)

**Created:** 2026-05-04  
**Audience:** HitM + agents planning a governance / orchestration / layout overhaul  
**Scope:** Parent repo `finance_manager` + `**design_docs` submodule only** for deep file references. Other product submodules (`finance_manager_api`, `finance_manager_web`, etc.) are treated as **named boundaries and git pointers**, not audited for internal code health in this pass.  
**Status:** **Scratch / disposable.** Not listed in `governance/plan_registry.md`, not an execution plan. Delete or replace after consolidation work lands.

---

## 1) What this workspace is

The **parent repository** is the integration shell: Docker blue-green compose files, `proxy/`, `deploy/`, `scripts/`, root `AGENTS.md`, `.cursor/` rules and skills, and the `**plans/`** tree used for multi-agent orchestration. Each shipping codebase lives in a **separate git repo** wired as a **submodule** (see `.gitmodules`).

**Submodules (from `.gitmodules`):**


| Path                              | Role in ecosystem (summary)                                                                    |
| --------------------------------- | ---------------------------------------------------------------------------------------------- |
| `design_docs`                     | Architecture, roadmap-adjacent narrative, release/runbook prose — **included in detail below** |
| `finance_manager_web`             | Flagship SPA (React + Vite + PWA track)                                                        |
| `finance_manager_api`             | Django REST API                                                                                |
| `finance_manager_cli`             | CLI client                                                                                     |
| `finance_manager_android`         | Android scaffold                                                                               |
| `finance_manager_rust_tools`      | Rust numerics library                                                                          |
| `finance_manager_rust_middleware` | ZK middleware stub (S5-scale)                                                                  |
| `finance_manager_reflex`          | **Archived** product stream; submodule kept for history                                        |


---

## 2) Orchestration model (how work is supposed to flow)

### 2.1 Canonical strategy and vocabulary

- **Strategic anchor:** `strategy/strategic-roadmap-reframe-53be/` (Phase **S1**, Stage **S1.B** as of locked README). Supersedes informal long-horizon planning in older `design_docs/20_Roadmap/` tone where they conflict.  
- **Vocabulary SSOT:** `governance/glossary.md` (Phase / Stage / Sprint; product launch states like `web:Tight Beta`; retired terms such as legacy “Phase 1/2”, “Track”).  
- **Portfolio status:** `governance/plan_registry.md` — plan IDs, `draft` / `ready` / `in_progress` / `paused` / `completed`, dependencies, and the **hierarchical plan path convention** (Topic 11 lock).

### 2.2 Governance layer (agent-facing)

Directory: `governance/`


| Artifact                  | Function                                                                                   |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| `README.md`               | Router: reading sequences for author vs execute vs deploy                                  |
| `plan_registry.md`        | Single portfolio table; conflict pre-check                                                 |
| `plan_template.md`        | Schema for new governed plans                                                              |
| `plan_lifecycle.md`       | Status machine                                                                             |
| `execution_protocols.md`  | Slack gates, handoffs                                                                      |
| `deployment_protocol.md`  | CPPR+D, blue-green, VPS                                                                    |
| `branching_guidelines.md` | Inactive-color feature work; “one feature at a time on inactive color” (locked 2026-04-30) |


### 2.3 Cursor / IDE orchestration

- **Rules:** `.cursor/rules/` — multi-repo boundaries, container testing via `scripts/`, git workflow per sub-repo, core standards.  
- **Skills:** `.cursor/skills/` — e.g. `orchestration-manager`, `feature-implementation-loop`, `repo-exploration-briefing`, `pr-ops-merge-readiness`.  
- **Delegation map:** `.cursor/rules/agent-delegation.mdc` maps user intents to skills/subagents.

### 2.4 Runtime and verification expectations

- **Authoritative stack check:** VPS blue-green on **HTTPS :8443** (per `AGENTS.md` / web README); not Vite-only ports for “real” verification.  
- **Scripts:** `scripts/fm_docker.sh`, `scripts/fm_services.sh` per container-testing rule.  
- **Runtime ownership:** `design_docs/30_Releases/Runtime_Signup_Sheet.md` (when design_docs is checked out).

### 2.5 Human-facing operating memory

- `**AGENTS.md` (repo root):** Learned preferences, sub-repo map, PWA sprint pointers (`plans/S1/S1.B/…`), VPS SSH default for ops, CPPRD discipline, strategic plan path, **browser matrix D0**, **D2/D3/D4** research locks under `plans/S1/S1.B/pwa-install-offline-sync-research/`.

---

## 3) File structure — intended vs observed drift

### 3.1 Intended (post–Topic 11) hierarchy

From `plan_registry.md` and `branching_guidelines.md`, **new** work should live under:

```text
plans/<Phase>/<Stage>/          # e.g. plans/S1/S1.B/
  README.md                          # Stage umbrella
  <sub-plan>/README.md               # Execution plan body
  feat-<id>-<slug>/                  # Feature-track plans (F-001…)
```

Branches: `cursor/s1b/<sub-plan>`, `cursor/s1b/feat/<feature>`, etc.

### 3.2 Observed layout issues (consolidation candidates)

1. **Mixed plan roots under `plans/`**
  Closed **cursor-era** umbrellas now live under `plans/archived/cursor-layout-era/`; active Stage work is under `plans/S1/S1.B/`. Any remaining stray top-level plan folders outside those patterns should be triaged into `plans/archived/` or deleted.  
   **Health impact:** Residual top-level plan dirs (outside `plans/S1/` and `plans/archived/`) still confuse “active vs historical” unless registry rows stay strict.
2. ~~**`plans/feat/web-reflex-parity-sweep-1/` still present**~~ **Resolved (2026-05-04 sweep):** residual top-level `plans/feat/` tree removed; canonical parity sweep artifacts live under **`plans/archived/feat/web-reflex-parity-sweep-1/`** only.
3. **Root README vs governance**
  `README.md` still says plans live at `plans/<proposed-git-branch-name>/` and points at `roadmap-rollout-planning` for structure; governance and `AGENTS.md` now center `plans/<Phase>/<Stage>/` plus repo-root `strategy/`.  
   **Health impact:** Onboarding mismatch.
4. **Large binary-ish artifacts at repo root**
  e.g. `migration_dump_*.json` (~10MB each) — clutter and accidental commit risk; not orchestration-critical but affects “ecosystem hygiene” perception.
5. **Misc top-level files**
  `business_notes.txt`, `GEMINI.md`, `notes.txt`, `fix_*.py`, `test_*.py` — useful personally but blur the boundary between **product shell** and **scratch pad**.

---

## 4) `design_docs` submodule (included scope)

**Remote:** `git@github.com:AzazelAzure/finance-manager-design-docs.git`  
**Parent pointer (snapshot):** submodule at commit on branch `cursor/s1b/pwa-vault-bridge` (see `git submodule status` in parent).

**Role:** Long-lived architecture, runbooks, and historical roadmap packets. **Canonical strategy** for forward-looking decisions is still the `strategy/strategic-roadmap-reframe-53be/` tree (repo-root `strategy/` in the parent); `design_docs` is updated on behavior/contract changes per documentation sync protocol (`design_docs/10_Current_State/02_Documentation_Sync_Protocol.md`).

**Notable paths:**


| Area                      | Path pattern                    | Notes                                                                                                                                               |
| ------------------------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Current state             | `design_docs/10_Current_State/` | Runtime checklists, resume checkpoints                                                                                                              |
| Roadmap (historical tone) | `design_docs/20_Roadmap/`       | Many files **explicitly historical** or superseded by strategic plan; `Strategic_doc_conflicts_pending_direction.md` records 2026-05-01 resolutions |
| Releases / Git            | `design_docs/30_Releases/`      | Runtime signup, PR protocol, handoff templates                                                                                                      |
| System design             | `design_docs/40_System_Design/` | Some sections rewritten for PH-primary / web flagship (per conflict log)                                                                            |


**Health:** Design docs underwent a **post-beta alignment pass** (2026-05-01) documented in `10_Current_State/Strategic_doc_conflicts_pending_direction.md`. Residual risk is **stale cross-links** inside older packets, not missing strategic SSOT (that lives under repo-root `strategy/` in the parent).

---

## 5) Health check (evidence-based, 2026-05-04)


| Check                                   | Observation                                                                                                                                                                                                                              |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Parent branch                           | `main` tracking `origin/main`                                                                                                                                                                                                            |
| Uncommitted parent changes              | Modified `finance_manager_web` submodule pointer; modified `plans/S1/S1.B/PRODUCT_FEATURE_BACKLOG_INDEX.md`                                                                                                                               |
| `finance_manager_web` submodule         | Shows `+` ahead of registered commit — **local web repo has commits not recorded in parent superproject** until submodule SHA is updated and committed                                                                                   |
| Strategic plan registry                 | **In progress:** empty row (explicit placeholder). **Ready:** empty. **Draft:** many S1.B feature plans + PWA research. **Paused:** PWA implementation sprint (human verification paused; online tx / offline shell issues per registry) |
| Stage umbrella                          | `plans/S1/S1.B/README.md` — active Stage S1.B index; drift-cleanup marked completed; several research tracks `draft` / `shelved`                                                                                                      |
| Orchestration docs internal consistency | Glossary + registry + strategic README **align** on S1 / S1.B; **layout** under `plans/` is the main inconsistency                                                                                                                       |
| README onboarding                       | Parent `README.md` **partially outdated** vs governance paths                                                                                                                                                                            |
| `design_docs`                           | Present; conflict table shows intentional resolution toward `plans/` + web flagship                                                                                                                                                      |


**Overall:** Strategy and agent **directives** are **coherent** in the governance layer; **physical organization** of plan folders and a few README / feat remnants create **navigation debt** and false “active plan” signals.

---

## 6) Current directives overview (what agents should treat as law today)

Derived from `plan_registry.md`, `strategy/strategic-roadmap-reframe-53be/README.md`, `plans/S1/S1.B/README.md`, and `AGENTS.md`:

1. **Phase / stage:** **S1.B — Distribution readiness** (flagship **web**; PH-only market for new acquisition; US deferred per parking lot).
2. **Strategic read order:** `glossary.md` → `plan_registry.md` → `strategy/strategic-roadmap-reframe-53be/README.md` → active stage `plans/S1/S1.B/README.md` → specific sub-plan README.
3. **PWA / offline:** Research decisions locked under `plans/S1/S1.B/pwa-install-offline-sync-research/`; implementation sprint hub `plans/S1/S1.B/pwa-implementation-branch/` is **paused** in registry until HitM re-test after fixes.
4. **Feature backlog:** F-001–F-013 plans exist as **draft** registry rows under `plans/S1/S1.B/feat-*` / `feat-infra-*`; execution is gated by normal `ready` / branch / color-cycle rules.
5. **Git workflow:** **One commit scope per sub-repo**; feature branches, not `main`; changelogs in touched sub-repo; PR link posted in Cursor chat when opened.
6. **Deploy / CPPRD:** Follow `deploy/CPPR_AND_CPPRD.md` and `deployment_protocol.md` when changes ship to VPS.
7. **Reflex:** **Archived** — do not treat Reflex paths as production architecture; historical docs may still mention it in past tense.
8. **Browser certification (D0):** Chrome desktop + Chrome Android for exit smoke; others secondary / best-effort per research locks in `AGENTS.md`.

---

## 7) Recommended consolidation themes (for a follow-on plan, not executed here)

These are **opinionated next steps** derived from this snapshot:

1. **Normalize all active and reference-only plan trees** under `plans/<Phase>/<Stage>/` or `plans/archived/`, and eliminate stray `plans/feat/` remnants or symlink them to archived canonical copies.
2. **Update parent `README.md`** to match hierarchical `plans/<Phase>/<Stage>/` + `strategy/` layout and link to `governance/plan_registry.md`.
3. **Add a single “orchestration index”** (could replace this temp file later) listing: governance files, strategic root, active stage root, paused items, and “do not use” legacy paths.
4. **Submodule hygiene:** When web work stabilizes, commit parent with updated `finance_manager_web` SHA; avoid long-lived `+` drift without documenting intent.
5. **design_docs:** Periodic link sweep using `Strategic_doc_conflicts…` as baseline; avoid duplicating strategy in design_docs when `strategy/` + `plans/` already own execution sequencing.

---

## 8) How to retire this file

After the overhaul:

- Fold any still-true bullets into `governance/README.md` (or a short repo-root orchestration index if you adopt that pattern).  
- Delete this path: `plans/cursor/_TEMP_ECOSYSTEM_HEALTH_AND_DIRECTIVES_2026-05-04.md`.

