# T03 — Reorder + Resize (drag-and-drop)

## End State

Users can reorder widgets via drag-and-drop and change a widget's size tier. Changes persist
(debounced) to the layout API. Drag handles are accessible.

## Acceptance Criteria

1. [V1] Widgets are reorderable by drag-and-drop; the new order persists via the T01 layout API.
2. [V1] Each widget supports a small set of size tiers (e.g. S / M / L spanning columns); changing size persists.
3. [V1] Persistence is **debounced** (don't PUT on every pixel/drag frame) and reconciles cleanly if a save fails (revert or retry, documented).
4. [V1] **A11y on drag handles** (plan §6): keyboard-operable reordering or an accessible alternative; handles are labeled; meets the project's a11y bar.
5. [V1] Offline: reorder/resize edits are online-only (follow the offline guard); the read render still works offline from cache.
6. [V1] No layout corruption: a drag interrupted mid-flight leaves a valid layout.

## Scope Lock

### Files to modify
- `DashboardPage.tsx` + a layout-grid wrapper
- the manage/grid interaction components
- `api/dashboardLayout.ts` (debounced save)

### Files NOT to touch
- API (T01), catalog (T02 — consume it), device variants (T04)

## Slices

### T03.SL1 — Reorder
DnD reorder with persisted order. Pick a maintained, a11y-capable DnD approach consistent with the existing stack — confirm the library choice if introducing a new dependency.

### T03.SL2 — Resize tiers
Per-widget size tier with persisted value; widgets render responsively at each tier.

### T03.SL3 — Debounce + a11y + offline
Debounced save with failure reconciliation; keyboard-accessible handles; offline-guard on edits.

## Notes

- **Persistence before DnD** is the plan's execution order (§5) — T01 must be in place so drag results are never lost to a local-only state.
- Keep the size-tier set small and opinionated; freeform resize/canvas is out of scope (plan §2).
- If adding a DnD dependency, prefer one already a11y-friendly to satisfy the drag-handle a11y gate without bespoke work.
