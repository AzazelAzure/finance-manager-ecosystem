# Finance Manager — coding and agent guidelines (Gemini-facing)

This file orients parallel assistants (e.g. Gemini) to **how this workspace is actually laid out**, where **authoritative plans** live, and how **product code** is structured. It complements **`AGENTS.md`** (HitM preferences and reading order) and **`governance/glossary.md`** (vocabulary). If anything here disagrees with those, **`AGENTS.md`** and live **`governance/`** files win.

---

## 1) Repository shape (ecosystem parent)

The directory **`finance_manager/`** (this clone) is the **parent** repo: Docker/proxy/deploy/scripts, **`governance/`**, **`plans/`**, **`strategy/`**, and **git submodules** for each shipping codebase.

| Area | Role |
| --- | --- |
| **`finance_manager_api/`** | Django REST API (**flagship backend**). Own repo; own `CHANGELOG.md`. |
| **`finance_manager_web/`** | React + Vite SPA, **PWA / flagship UI**. Own repo; own `CHANGELOG.md`. |
| **`finance_manager_cli/`** | CLI client. Own repo. |
| **`design_docs/`** | Architecture and narrative vault (submodule). Cross-links parent `plans/` and `strategy/`. |
| **`finance_manager_reflex/`** | **Archived** (2026-04-30). Historical only; **do not** treat as production. |
| **`finance_manager_android/`**, **`finance_manager_rust_*`** | Scaffold / future lanes; own repos. |

Initialize submodules after clone:

```bash
git submodule update --init --recursive
```

**Authoritative stack checks** for web + API use the **blue/green Docker** layout and **HTTPS on host `:8443`** via **`proxy/`** (not “Vite-only” ports as the source of truth for production parity). Local `docker-compose.yml` + **`scripts/fm_docker.sh`** / **`scripts/fm_services.sh`** follow the same project conventions as VPS (`deploy/`, `~/finance_manager` on the dev host).

---

## 2) Plans, strategy, and governance (where “truth” lives)

| Layer | Path | Use |
| --- | --- | --- |
| **Strategic plan** | **`strategy/strategic-roadmap-reframe-53be/`** | Multi-year phases S1–S6, locks, `validation_gates.md`, `kill_commit_gates.md`. |
| **Plan operations** | **`governance/`** | Registry, lifecycle, deploy protocol, branching, **`plan_template.md`**, **`glossary.md`**. Read **`governance/README.md`** first when authoring or executing governed work. |
| **Tactical execution plans** | **`plans/<Phase>/<Stage>/<sub-plan>/`** | Active example: **`plans/S1/S1.B/`** (PWA research, drift cleanup, feature drafts, etc.). |
| **Archives** | **`plans/archived/`** | Completed umbrellas, huddles, **`cursor-layout-era/`**, legacy `feat/` / `fix/` trees. **Do not** add new active work here. |
| **Legacy Gemini templates (archived)** | **`plans/archived/gemini_plan_templates/`** | Historical copies only; **do not** use for new work. |

New governed work: **materialize** a directory under **`plans/<Phase>/<Stage>/<sub-plan>/`**, YAML header in **`README.md`** per **`governance/plan_template.md`**, register in **`governance/plan_registry.md`**, and tie to a **`strategic_link`** under **`strategy/strategic-roadmap-reframe-53be/phases/`** (not the strategic README alone).

---

## 3) API codebase layout (`finance_manager_api`)

Django app code lives under **`finance_manager_api/finance/`** (not the old generic “root `views/`” wording):

| Area | Typical path | Responsibility |
| --- | --- | --- |
| **Views / routing** | `finance/views/` | HTTP handling, validation, responses. |
| **Business logic** | `finance/logic/` | Calculations, aggregations, domain rules. |
| **Services** | `finance/services/` | Orchestration, external integrations. |
| **Models** | `finance/models.py` | ORM models. |
| **Validators** | `finance/validators/` | Input and consistency checks. |
| **API helpers** | `finance/api_tools/` | Serializers, shared helpers, query utilities. |

**Tests** live under **`finance_manager_api/finance/tests/`** (pytest). Prefer extending that suite over one-off scripts at the parent root (historical scratches live under **`scripts/archived/root_one_off_python/`**).

---

## 4) Web codebase layout (`finance_manager_web`)

**Flagship** UI: React, Vite, TypeScript, PWA (service worker, offline/outbox patterns under `src/offline/`, etc.). Product and contract details belong in **`finance_manager_web/README.md`** and that repo’s **`CHANGELOG.md`**.

---

## 5) Golden rules (engineering discipline)

### 1. Efficiency

Optimize hot paths; use appropriate structures; avoid redundant queries and N+1 patterns.

### 2. Readability

Clear names, straightforward control flow; comment only where intent is non-obvious.

### 3. Lean files

Prefer **~300–500 lines** per file as a soft ceiling; split when responsibilities mix.

### 4. Separation of concerns

One responsibility per unit; do not combine routing, core domain logic, and persistence in one place.

### 5. Reuse via shared modules

Shared logic belongs in **`api_tools/`**, **`services/`**, or **`logic/`** — not copy-pasted.

### 6. Database discipline

Avoid excessive round-trips per request; use **`select_related` / `prefetch_related`** and batching. (Numeric “12 hits” caps in older docs are **aspirational** — treat them as a smell test, not a hard CI gate unless a test enforces them.)

### 7. Professional dependencies

Prefer maintained libraries and clear patterns; call out better options when they materially reduce risk or debt.

### 8. Changelogs and traceability

Before overlapping work, scan the relevant **`CHANGELOG.md`** (**`finance_manager_api`**, **`finance_manager_web`**, **`finance_manager_cli`**, etc.). **Shipped behavior changes** get an **`[Unreleased]`** (or versioned) entry in the **same repo you changed**. Parent-repo-only doc/governance/plan moves update the **parent** **`CHANGELOG.md`** per **CPPRD** (`deploy/CPPR_AND_CPPRD.md`).

### 9. CPPRD and production alignment

Follow **`governance/branching_guidelines.md`** (inactive color, one feature at a time where applicable) and **`governance/deployment_protocol.md`** when shipping to VPS. Opening a PR: post the **full URL** in Cursor chat (workspace rule); do not use Slack for PR notification.

### 10. Root cause fixes

Fix the underlying cause, not only the symptom, when it is safe to do so.

### 11. Collaborative tone

Propose improvements with tradeoffs; document non-obvious choices for the next agent.

### 12. Git reality (per repo)

Each submodule is its **own** git repo: **feature branch → PR → merge to that repo’s `main`** (or its governed default). The parent repo tracks **submodule SHAs** when ecosystem layout or pins change. **Version tags** follow each product’s release practice; do not invent repo-wide `vX.Y.Z` tags from agents unless HitM asks.

### 13. Plan-based execution

Significant governed work uses **`governance/plan_template.md`**, **`governance/plan_registry.md`**, and **`governance/plan_lifecycle.md`**. For tiny single-file fixes, use the **same** template’s YAML header and a shorter body; do not invent a second plan shape. Completed plan **trees** remain under **`plans/archived/`** (or marked complete in the registry) per governance — not deleted casually.

### 14. Knowledge hierarchy

- **Primary:** live files in **`governance/`**, **`strategy/`**, **`plans/`**, touched **`design_docs/`**, and each subrepo’s source + **`CHANGELOG.md`**.
- **Secondary:** chat summaries, external KI blocks. If a KI conflicts with the repo, **the repo wins**.

### 15. Multi-repo and “worker” scripts

**`scripts/hive_worker.py`** and other **`scripts/*.sh`** helpers automate **git operations across `scripts/repos.txt`** (see **`scripts/README.md`**). They are **not** a substitute for governed **`plans/`** metadata; use them for branch/sync hygiene, not as the system of record for plan state.

---

## 6) Where to read next

1. **`AGENTS.md`** — constraints, VPS, PWA bar, reading order.  
2. **`governance/glossary.md`** — terms.  
3. **`strategy/strategic-roadmap-reframe-53be/README.md`** — phase map.  
4. **`plans/S1/S1.B/README.md`** — active stage hub (when working S1.B).  
5. Subrepo **`README.md`** / tests for the code you touch.
