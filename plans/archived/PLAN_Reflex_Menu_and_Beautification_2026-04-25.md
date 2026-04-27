# PLAN_Reflex_Menu_and_Beautification_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Menu_and_Beautification_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: `finance_manager_reflex` (Shell/Data Hub/Tokens)

## 1) Objective
Refine the application's aesthetics to create a clearer, more professional user experience. This includes transforming the sidebar menu into a collapsing icon-drawer, updating background colors to better delineate cards, relocating the help system, and cleaning up the Data Hub view.

## 2) Scope
### In scope
- Modifying `app/shell.py` to create a collapsible sidebar (icon-only mode that expands on hover).
- Changing the global `bg_canvas` token to a slightly darker off-white to make `surface_card` (white) pop more clearly.
- Moving the global "Help/Tutorial" trigger into the sidebar menu.
- Auditing and beautifying the Data Hub layout (categories/sources).

### Out of scope
- Implementing the widget dashboard (handled in separate plan).
- Modifying underlying data logic.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/app/shell.py`
- `finance_manager_reflex/finance_manager_reflex/ui/tokens.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Design Fidelity:** The expanded menu must use smooth, physics-based transitions so it feels responsive, not jerky.
- **Rule #3 (Lean Files):** If the new sidebar logic becomes complex, extract it into a dedicated `sidebar.py` component instead of keeping it in `shell.py`.

## 5) Execution Breakdown

### Task T1: Off-White Canvas & Delineation
- **Goal:** Improve contrast between the background and UI cards.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/tokens.py`.
- **Implementation notes:** Update `COLOR_TOKENS["bg_canvas"]` to a subtle off-white/gray (e.g., `#f3f4f6`) to ensure the pure white `#ffffff` cards cast visible shadows.

### Task T2: Icon-Drawer Sidebar
- **Goal:** Implement a collapsible sidebar that expands on hover.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/shell.py`.
- **Implementation notes:** 
    - Default state: Sidebar width ~60px, showing only icons.
    - Hover state: Sidebar width expands (e.g., 240px), revealing text labels. Use CSS `transition` for width.
    - Move the Help/Tutorial trigger into this sidebar as a dedicated item.

### Task T3: Data Hub Beautification
- **Goal:** Make the Data Hub page more aesthetic and user-friendly.
- **Files to edit:** `finance_manager_reflex/features/data_hub/`.
- **Implementation notes:** 
    - Ensure forms and lists use the updated `surface_card`.
    - Improve spacing, alignment, and empty states.

## 6) Verification Plan
- Visual check: Ensure the sidebar expands smoothly without shifting main content abruptly (use absolute positioning or careful flexbox layouts). Verify contrast between cards and canvas.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for Reflex.
- [ ] Move plan to `plans/archived/` upon completion.
