# Reflex dashboard UI regression — execution plan

**Proposed git branch (Reflex repo):** `fix/reflex-dashboard-ui-regression`  
**Primary codebase:** `finance_manager_reflex/` (ecosystem submodule)  
**Orchestration handoff:** `/orchestration-manager` should treat this directory as the **plan root**.

## Problem statement (current beta evidence)

1. **Protected shell navigation**  
   Prior mobile-oriented changes to the dashboard/shell layout appear to have regressed **wider-screen** behavior: the **vertical rail / slide-out style** navigation (collapsed sidebar with hover expansion in `protected_app_shell`) no longer behaves as before.  
   On **narrow viewports**, the sidebar is flattened into a **horizontal lane** (`@media (max-width: 900px)` in `assets/index.css`). Users report that horizontal controls end up **under or behind the sticky header** (`protected-header` in `app/shell.py`), hurting discoverability and tap targets.

2. **Dashboard charts empty**  
   Category/tag (and related) chart regions show **titles and footer hints** (e.g. “Other includes: …”) but **no rendered graphics** in the chart plot area. Non-chart flows still work, suggesting **data may be present** but **Recharts / layout / overflow** is failing or dimensions are zero.

## Architecture touchpoints (for implementers)

| Area | Files to own |
|------|----------------|
| Shell layout, header z-index, sidebar structure | `finance_manager_reflex/app/shell.py`, `finance_manager_reflex/assets/index.css` |
| Dashboard composition, chart widgets | `finance_manager_reflex/features/agentdash/view_components.py`, related `state_*.py`, `mappers.py` |
| Global chart/table responsive rules | `assets/index.css` (`.dashboard-widget-chart`, `.recharts-*` rules under `@media (max-width: 1200px)`) |

**Evidence in tree today**

- `shell.py`: sidebar `z_index="100"`, header `z_index="40"`, `position="sticky"`; main column `margin_left` tied to collapsed rail width.  
- `index.css`: `@media (max-width: 1200px)` flattens sidebar; `@media (max-width: 900px)` makes `.sidebar-container` `position: sticky; top: 0; z-index: 120` and horizontal nav; `.dashboard-widget-chart { overflow: hidden }` may interact badly with Recharts measurement.

## Operational note (outside Reflex code)

**API blue/green:** Staging `api-green` and parity checks are **deploy/runtime** work (compose, `ALLOWED_HOSTS` including `api-blue`/`api-green`, image tags). This plan does **not** block on green cutover; Reflex UI work assumes both API colors remain reachable as today.

**VPS source of truth:** Until git is wired on the server, **rsync + image rebuild** remains the delivery path; document the same verification gates locally and on VPS.

---

## Phase A — Reproduce and instrument

- **Goal:** Stable repro matrix (viewport widths, browsers) and one **screenshot or DOM note** per failure mode (nav obscured, empty chart canvas).
- **Entry criteria:** Plan acknowledged; Reflex branch available.
- **Exit criteria:** Written repro table; browser devtools confirms **layout box** for chart container (width/height non-zero vs zero); nav stacking context identified (which ancestor creates stacking).
- **Breakpoints:** None block merge; evidence gates Phase B/C.
- **Triggers:** Evidence doc linked from `tasks/T01` / `T02` or appended to this README.
- **Dependencies:** None.
- **Required implementation updates:** None (readonly); optional temporary `rx.console_log` / server log markers **only** if needed and removed before merge.
- **Verification gate:** At least two widths: **>1200**, **900–1200**, **<900**; confirm header vs nav order and `z-index` in computed styles.
- **Risks and mitigations:** False “works on my machine” — mitigate with recorded viewport list and VPS smoke URL.

## Phase B — Navigation shell: wide + narrow correctness

- **Goal:** Restore **wide** vertical rail + hover/slide affordances without breaking **narrow** horizontal nav; ensure horizontal nav is **never** trapped behind `protected-header` (order, `z-index`, `padding-top` on main, or dedicated **drawer / menu button** pattern).
- **Entry criteria:** Phase A exit met.
- **Exit criteria:** UX signoff checklist in `validation_gates.md` passes; no regression on desktop KPI grid from prior mobile work.
- **Breakpoints:** Stop if any change breaks **keyboard** nav or **LTR/TL** layouts.
- **Triggers:** PR-ready Reflex diff scoped to `shell.py` + `index.css` (and primitives only if unavoidable).
- **Dependencies:** None cross-repo.
- **Required implementation updates:** Prefer **CSS stacking / scroll-padding / flex order** fixes before introducing new components; if a **drawer** is required, use existing Reflex/Radix patterns consistent with the app.
- **Verification gate:** Manual matrix + optional Playwright later; see `tasks/T01_nav_shell_breakpoints.md`.
- **Risks and mitigations:** `!important` wars in `index.css` — consolidate breakpoints; avoid duplicating width constants between Python and CSS where one source of truth is possible.

## Phase C — Dashboard charts: data path + layout

- **Goal:** Chart canvases render when series data exists; empty state is explicit when data is truly empty (distinct from “layout bug”).
- **Entry criteria:** Phase A chart box sizing known.
- **Exit criteria:** Category + tag (and at least one time-series) charts render on desktop and mobile widths with real data; no horizontal scroll trap unless intentional for tables.
- **Breakpoints:** If API payload shape changes, stop and document API handoff (unlikely).
- **Triggers:** PR-ready Reflex diff in `agentdash` + `index.css` as needed.
- **Dependencies:** API unchanged unless investigation proves **400/empty series** (then file separate API task).
- **Required implementation updates:** Inspect `rx.recharts` usage, `ResponsiveContainer` height, parent `min-height`, `overflow` on `.dashboard-widget-chart`; confirm `map_to_view_model` / state still supplies series after login (network tab already healthy per user).
- **Verification gate:** See `tasks/T02_dashboard_charts_data_layout.md`.
- **Risks and mitigations:** Polling transport vs WebSocket should not affect chart JSON; if suspicion arises, compare network responses before blaming transport.

## Phase D — Release hygiene

- **Goal:** Shippable Reflex release with changelog and optional design-doc note for shell breakpoints.
- **Entry criteria:** Phases B and C complete.
- **Exit criteria:** `finance_manager_reflex/CHANGELOG.md` updated; image build + smoke on **blue** (and **green** when cutover is scheduled).
- **Triggers:** PR opened per repo workflow.
- **Dependencies:** Ecosystem submodule pointer update when merging.
- **Required implementation updates:** Changelog; optional short note in design_docs if public URL behavior changes.
- **Verification gate:** `reflex export` / Docker build succeeds; dashboard smoke on VPS path used in beta.
- **Risks and mitigations:** Submodule drift — bump ecosystem after Reflex merge.

---

## Task index

| ID | Task packet |
|----|----------------|
| T01 | [tasks/T01_nav_shell_breakpoints.md](tasks/T01_nav_shell_breakpoints.md) |
| T02 | [tasks/T02_dashboard_charts_data_layout.md](tasks/T02_dashboard_charts_data_layout.md) |

## Suggested orchestration order

1. T01 (shell + CSS breakpoints + stacking)  
2. T02 (charts + overflow + Recharts sizing)  
3. Changelog + image validation (Phase D)

---

## Execution log (orchestration)

| Date (UTC) | Actor | Notes |
|------------|-------|--------|
| 2026-04-29 | Agent | **T01+T02 implemented** on Reflex branch `fix/reflex-dashboard-ui-regression`: `shell.py` + `index.css` (column shell ≤900px; removed sidebar flatten at 1200px); `view_components.py` pie `width="100%"`; changelog updated. **Gate V3/V4:** run `reflex export` / Docker build + VPS smoke before merge. |
