# `plans/` — tactical execution markdown (parent repo)

This directory holds **governed execution plans** and **archives**. It does **not** replace **`strategy/`** (multi-year roadmap) or **`governance/`** (registry, lifecycle, vocabulary).

| Area | Path | Notes |
| --- | --- | --- |
| **Active stage work** | **`S1/S1.B/`** | Current example: Stage **S1.B** plans, research, feature drafts, PWA sprint. |
| **Archives** | **`archived/`** | Completed umbrellas, huddles, **`cursor-layout-era/`**, legacy **`feat/`** / **`fix/`** / **`volatile*`** trees. |
| **Plan template stubs** | **`templates/README.md`** | Points to **`governance/plan_template.md`** (single schema for all agents). |
| **Legacy Gemini templates** | **`archived/gemini_plan_templates/`** | Historical only. |
| **Scratch** | **`cursor/_TEMP_*.md`** | Disposable; not in **`governance/plan_registry.md`**. |
| **Sprint pipeline queue** | **`pipeline_queue/`** | Next `#sprint-queue` message bodies for [`scripts/sprint_slack_pipeline_bridge.py`](../scripts/sprint_slack_pipeline_bridge.py); set **`SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`** here. See [`pipeline_queue/README.md`](pipeline_queue/README.md). |

**Do not** recreate top-level **`plans/feat/`**, **`plans/fix/`**, or **`plans/volatile/`** — new work belongs under **`plans/<Phase>/<Stage>/<sub-plan>/`** per **`governance/plan_template.md`**. Execution decomposition uses **tasks** `T##` and **slices** `T##.SL#` (§1a; **`SL`** distinct from Phase **S** notation).

See also: [`../strategy/README.md`](../strategy/README.md), [`../governance/README.md`](../governance/README.md), [`../governance/orchestration.md`](../governance/orchestration.md) (strategy / plans / Cursor / runtime map).
