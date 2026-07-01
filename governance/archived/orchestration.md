# Orchestration index (parent repo)

**Purpose:** Single entry map for how **strategy**, **governance**, **tactical plans**, **Antigravity plugins/skills**, and **runtime** fit together. Supplements `governance/README.md` (protocols and enums) with **cross-cutting navigation** for multi-agent work.

**Audience:** AI agents and HitM. For manual gate text and lifecycle mechanics, use `execution_protocols.md` and `plan_lifecycle.md`.

---

## 1) Canonical roots

| Layer | Path | Role |
| --- | --- | --- |
| **Vocabulary** | `governance/glossary.md` | Phase / Stage / Sprint; product launch states; retired terms. |
| **Portfolio** | `governance/plan_registry.md` | Plan IDs, status, dependencies, hierarchical plan paths. |
| **Strategic roadmap** | `strategy/strategic-roadmap-reframe-53be/` | Multi-year anchor; `design_docs/20_Roadmap/` is historical where they conflict. |
| **Active tactical plans** | `plans/<Phase>/<Stage>/<sub-plan>/` | Example: `plans/S1/S1.B/`. Stage umbrella: `plans/S1/S1.B/README.md`. |
| **Archives** | `plans/archived/` | Closed umbrellas, `feat/` / `fix/` / `volatile*` trees, `cursor-layout-era/`, huddles. |
| **Operating memory** | `AGENTS.md` (repo root) | Sub-repo map, PWA bar, VPS default, D0/D2/D3/D4 pointers, CPPRD. |
| **Plans tree map** | `plans/README.md` | What belongs under `plans/` vs `strategy/` vs `governance/`. |

**Do not** resurrect top-level **`plans/feat/`**, **`plans/fix/`**, or **`plans/volatile/`** for new work (consolidated under `plans/archived/` per `plan_registry.md` hygiene).

---

## 2) Governance directory (protocols)

| File | Function |
| --- | --- |
| `README.md` | Router, enums, reading sequences. |
| `orchestration.md` | **This file** — orchestration map and agent workflow index. |
| `skill_roadmap_rollout_planning.md` | Mirror of roadmap / rollout planning skill (materialize plans under `plans/<Phase>/<Stage>/`). |
| `skill_orchestration_manager.md` | Mirror of orchestration-manager skill (delegate, gates, retask). |
| `plan_registry.md` | Single portfolio table. |
| `plan_template.md` | Schema for new governed plans. |
| `execution_protocols.md` | Manual gates, handoffs. |
| `definition_of_done.md` | PWA, localization, SEO, F-011 bars + sprint order huddle link. |
| (Archived) | Antigravity PA + JSONL outbox vs IDE Slack MCP. |
| (Archived) | `#sprint-queue` post shape. |
| (Archived) | Polls Slack for pipelines. |
| `deployment_protocol.md` | CPPR+D, blue-green, VPS. |
| `branching_guidelines.md` | Inactive-color feature work; one feature at a time on inactive color (locked 2026-04-30). |

---

## 3) IDE layer

| Area | Path |
| --- | --- |
| **Rules** | User Rules in IDE settings. |
| **Skills** | Antigravity skills. |
| **Delegation map** | `AGENTS.md` and `governance/` protocols. |

**Skill mirrors in `governance/`:** The `skill_*.md` files duplicate the **substance** of selected skills for agents that read `governance/` only.

---

## 4) Runtime and verification

- **Authoritative product check:** VPS blue-green **HTTPS on host :8443** (see `AGENTS.md`, `finance_manager_web/README.md`). Not Vite-only ports for full-stack truth.
- **Containers:** `scripts/local-stack/fm_docker.sh`, `scripts/local-stack/fm_services.sh`.
- **Runtime ownership:** `design_docs/30_Releases/Runtime_Signup_Sheet.md` (when `design_docs` submodule is present).

---

## 5) Suggested read order (execution session)

1. `governance/glossary.md`
2. `governance/plan_registry.md`
3. `strategy/strategic-roadmap-reframe-53be/README.md`
4. Active stage `plans/S1/S1.B/README.md` (or current Stage path)
5. Target sub-plan `README.md` / task files
6. `governance/skill_orchestration_manager.md` or `governance/skill_roadmap_rollout_planning.md` as needed
7. `governance/execution_protocols.md` when producing HitM-facing gates

---

## 6) Current directives snapshot (derive from live files)

Treat **`plan_registry.md`**, **`strategy/.../README.md`**, **`plans/S1/S1.B/README.md`**, and **`AGENTS.md`** as authoritative; this list is a **navigation aid** only.

- **Phase / stage:** Forward-looking execution is **S1.B** (distribution readiness; flagship **web**; PH-only new acquisition unless plan says otherwise).
- **PWA / offline:** Research locks under `plans/S1/S1.B/pwa-install-offline-sync-research/`; implementation sprint hub `plans/S1/S1.B/pwa-implementation-branch/` — follow registry row for **paused** vs active.
- **Git:** One commit scope per sub-repo; feature branches, not default `main` for feature work; changelogs in touched sub-repo; when opening a PR, send the **PR link in the Antigravity chat** (repo, branch, URL) per workspace rules; reconcile **GitHub** mergeability and required checks before merge.
- **Tasks and slices:** Delegation uses **slice IDs** `T##.SL#` when plans split work (see `governance/plan_template.md` §1a, `glossary.md` §3). Agents **ask clarifying questions** instead of guessing when specs are silent.
- **Reflex:** Archived product stream — not production architecture.
- **D0 browser matrix:** See `AGENTS.md` (Chrome desktop + Chrome Android for certified exit smoke).

---

## 7) Retiring scratch snapshots

Disposable health snapshots under `plans/agy/_TEMP_*.md` should fold into this file + `governance/README.md` over time, then **delete** the temp path when superseded.
