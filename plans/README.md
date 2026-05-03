# `plans/` — tactical execution markdown (parent repo)

This directory holds **governed execution plans** and **archives**. It does **not** replace **`strategy/`** (multi-year roadmap) or **`governance/`** (registry, lifecycle, vocabulary).

| Area | Path | Notes |
| --- | --- | --- |
| **Active stage work** | **`S1/S1.B/`** | Current example: Stage **S1.B** plans, research, feature drafts, PWA sprint. |
| **Archives** | **`archived/`** | Completed umbrellas, huddles, **`cursor-layout-era/`**, legacy **`feat/`** / **`fix/`** / **`volatile*`** trees. |
| **Plan template stubs** | **`templates/README.md`** | Points to **`governance/plan_template.md`** (single schema for all agents). |
| **Legacy Gemini templates** | **`archived/gemini_plan_templates/`** | Historical only. |
| **Scratch** | **`cursor/_TEMP_*.md`** | Disposable; not in **`governance/plan_registry.md`**. |

**Do not** recreate top-level **`plans/feat/`**, **`plans/fix/`**, or **`plans/volatile/`** — new work belongs under **`plans/<Phase>/<Stage>/<sub-plan>/`** per **`governance/plan_template.md`**.

See also: [`../strategy/README.md`](../strategy/README.md), [`../governance/README.md`](../governance/README.md), [`../governance/orchestration.md`](../governance/orchestration.md) (strategy / plans / Cursor / runtime map).
