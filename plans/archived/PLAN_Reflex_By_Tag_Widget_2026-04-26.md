# PLAN: Reflex Dashboard "By Tag" Widget

## Reconciliation Status
- Status: `completed`
- Completed on: `2026-04-27`
- Execution notes:
  - Tag series model/mapper/state/load/UI and dashboard integration were implemented.
  - Workstream proceeded through PR hygiene and merged workflow in prior orchestration cycle.

## Goal
Add a dashboard widget that mirrors the existing "Expense by category" widget, but groups by transaction tags.

## Scope
- Primary: `finance_manager_reflex`
- Conditional dependency: `finance_manager_api` only if snapshot/contracts do not already expose tag-level data required for stable aggregation.

## Implementation Steps
1. **Confirm data contract**
   - Inspect dashboard source payloads in `agentdash` load flow to verify tags are present in transaction rows.
   - If tags are missing or inconsistent, create a handoff note for an API contract update plan (do not expand scope in-flight).
2. **Extend dashboard models**
   - Add a typed point model for tag chart data in `features/agentdash/models.py`.
3. **Add mapper aggregation**
   - Add `build_tag_series(...)` in `features/agentdash/mappers.py`, using deterministic color assignment parity with category chart.
4. **Wire state + loading**
   - Add `tag_series` state field and data-presence computed var in `features/agentdash/state.py`.
   - Populate `tag_series` in `features/agentdash/state_load.py`.
5. **Add widget UI**
   - Implement a new chart widget in `features/agentdash/view_components.py`.
   - Include in dashboard layout and widget customization controls.
6. **Quick filter integration**
   - Add tag quick-filter affordances to existing dashboard quick-filter area.
7. **Validation**
   - No-tag datasets show a clear empty state.
   - Multi-tag datasets render distinct slices and legible labels.
   - Widget visibility toggle works and layout remains symmetrical.

## Verification
- Run Reflex app in Docker-oriented runtime flow and validate widget updates with live API-backed data.
- Confirm no regressions in category chart or dashboard filter behavior.

## Notes for Host Agent
- Keep this as a follow-up plan after current dashboard/expense stabilization is merged.
- If API changes are required, create a separate API plan and execute repo-scoped handoff.
