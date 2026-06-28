# T01 — Help Mode Hover Tooltips

## End State
When the user clicks the "Guide" (Help Mode) button in the navigation, `isHelpModeActive` becomes true. Instead of intercepting clicks to launch a Joyride tour, any element wrapped in `HelpModeWrapper` will now display a native or CSS-based hover tooltip containing its `title` and `content`.

- What the user sees: A styled popover/tooltip near the hovered element explaining its function. Clicking the element does not trigger Joyride. The tooltip is styled to match the app's theme (e.g., dark background with white text).
- What the developer sees: `HelpModeWrapper` modified to use a local state or CSS `data-tooltip` to show the tooltip on `mouseenter`.
- What does NOT change: The global `TourProvider` context shape for `useHelpMode()`.

## Acceptance Criteria
1. [V1] `npm run build` passes with zero errors and zero warnings
2. [V3] Browser: toggle Guide mode, hover over a wrapped element, see tooltip, no Joyride starts on click.

## Scope Lock

### Files to modify
- `finance_manager_web/src/components/tours/TourProvider.tsx` (Update HelpModeWrapper to use hover state/css tooltips, remove `startTour` from `handleClick`).
- `finance_manager_web/src/components/ui/ui.css` (Add tooltip styling if using pure CSS approach).

### Files NOT to touch
- Backend APIs or unrelated components.

## Technical Decisions (pre-locked)
- Per D01: Do not add new tooltip libraries. Use simple React state (`onMouseEnter` / `onMouseLeave`) or CSS `data-tooltip` attributes within `HelpModeWrapper`.

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | HelpModeWrapper Refactor | V1 | Remove Joyride hook, implement hover tooltip. Build passes. |
| T01.SL2 | CSS Styling | V1 | Style the tooltip to be modern and readable. |

## Anti-Patterns (do NOT do these)
- Do NOT install `floating-ui`, `tippy.js`, or other heavy tooltip libraries. Keep it simple.
- Do NOT break keyboard accessibility (tooltips should show on focus).
