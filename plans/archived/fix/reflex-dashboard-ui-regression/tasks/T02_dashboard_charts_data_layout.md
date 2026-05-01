# T02 — Dashboard charts (data + layout)

## Objective
Ensure AgentDash **chart widgets** render graphics when backend/state provides series data; distinguish true empty data from **layout/zero-dimension** failures.

## Scope boundary
- **In:** `finance_manager_reflex/features/agentdash/view_components.py`, `state_load.py` / `state.py` / `mappers.py` as needed, `assets/index.css` for chart containers.
- **Out:** API serializers (unless investigation proves missing payload).

## Definition of done
- [ ] With non-empty snapshot/category/tag series, **Recharts** (or current chart primitive) draws visible geometry in the plot area (screenshot in PR optional).
- [ ] `validation_gates.md` **Gate V2** passes.
- [ ] No new unconditional `console.log` in production bundle.

## Investigation checklist
1. **Network:** After login, confirm `/finance/appprofile/snapshot/` (or equivalent) returns expected `expense_by_category` / tag series / `flow_series` keys.  
2. **State:** Log at **debug** only if needed—confirm `AgentDashState` (or loader) assigns series into vars bound to chart components.  
3. **Layout:** In devtools, verify chart wrapper **height** and `overflow` (`.dashboard-widget-chart`, `.recharts-responsive-container`). Remove or narrow `overflow: hidden` if it clips Recharts to zero height.  
4. **ResponsiveContainer:** Ensure explicit `height` or parent `min-height` where Reflex/Recharts requires it.

## Verification
- Gate V2 matrix + one **data-rich** account on staging.  
- Regression: KPI tiles and tables still populate (unchanged paths).

## Risks / follow-ups
- If data is present but chart library fails silently, add a **single** defensive empty-state when `width/height` from container are zero (document in changelog).  
- Large `min-width` on tables (`640px`) may coexist with charts; confirm horizontal scroll is intentional and does not shrink chart column to zero.

## Branch / PR
- Same Reflex branch as T01; can be **one PR** if commits are logically grouped, or **two PRs** (shell first, charts second) if orchestrator prefers smaller review units.
