# T04 — Responsive Navigation Shell

## End State
On desktop (≥lg / 1024px), a sidebar navigation renders with a collapsed/expanded state. On mobile (<lg), a bottom tab bar renders with a Sheet drawer for secondary nav. The existing navigation works in PWA standalone mode with no z-index conflicts against modals or the Joyride tour overlay.

## Acceptance Criteria
1. [V3] Desktop (≥1024px): sidebar visible, keyboard-navigable (Tab/Enter), renders correctly in dark mode
2. [V3] Mobile (<1024px): bottom tab bar visible; Sheet drawer opens/closes on tap
3. [V1] `npm run build` passes; no console errors on route transitions in browser
4. [V1] PWA standalone mode: navigation renders without viewport overflow or safe-area violations

## Scope Lock

### Approach
- Use shadcn `Sidebar` component (if available in shadcn registry) OR implement with a `<nav>` + Tailwind `hidden lg:flex` / `flex lg:hidden` pattern
- Use shadcn `Sheet` for the mobile drawer (already in shadcn registry)
- Bottom tab bar: fixed `bottom-0` `<nav>` with 4–5 primary routes (Dashboard, Transactions, Calendar, Settings); icons from existing icon set

### Files to modify
- `src/layout/ProtectedShell.tsx` — the single protected-route shell (desktop sidebar + mobile nav live here). The F-007 read-only constraint was **lifted 2026-06-26** (see README §2); T04 now owns this file.
- `src/layout/shells.css` — shell + nav styling
- `src/lib/i18n.ts` — nav/drawer labels (`shell.nav.more`, `shell.drawer.*`)

### Files to create (only if no nav component exists)
- Not needed — nav already lives inline in `ProtectedShell.tsx`.

### Files NOT to touch
- Tour/help-mode wiring inside `ProtectedShell.tsx` (`useHelpMode`/`toggleHelpMode`) — preserved as-is.
- Any tour/Joyride components (`TourProvider.tsx`).

### z-index contract (as implemented against the existing token system)
- Sticky top bar: `z-index: 10`
- Mobile bottom tab bar (`.protected-top-strip`): `z-index: 20`
- Mobile "More" drawer (`.shell-drawer`): `z-index: 100`
- Modals (logout, etc.): `z-index: 200`
- Help-mode / tour overlays: `z-index: 10000` (above all shell chrome — no conflict)

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T04.SL1 | Sidebar (desktop) | V3 | Implement sidebar nav for ≥lg; keyboard nav; dark mode; build passes; screenshot |
| T04.SL2 | Bottom tab + Sheet (mobile) | V3 | Bottom tab bar for <lg; Sheet drawer for secondary items; viewport + safe-area check; screenshot |

## Evidence
- `evidence/T04.SL1_sidebar_desktop.png` — [V3] desktop view, sidebar expanded
- `evidence/T04.SL2_bottom_nav_mobile.png` — [V3] mobile view, bottom bar; Sheet open state
- `evidence/T04.SL2_standalone_pwa.png` — [V3] PWA standalone mode on mobile

## Clarifying Questions — RESOLVED 2026-06-26
1. **Primary bottom-tab routes:** Dashboard / Transactions / Upcoming / Calendar (4 tabs) + a "More" trigger.
2. **Sidebar:** persistent icon rail on desktop (≥900px) with hover-revealed labels — unchanged existing behaviour.
3. **Nav component:** lives inline in `src/layout/ProtectedShell.tsx` (no separate Sidebar/BottomNav files).

## Implementation Notes (2026-06-26)

**Adapted approach (no shadcn/Tailwind):** the repo uses a hand-rolled CSS-variable system, not
shadcn + Tailwind. The Sheet/Sidebar were implemented against the existing primitives + `shells.css`
rather than installing shadcn. Breakpoint is the existing **900px** (not 1024px).

Delivered:
- **Bottom tab bar** (`.protected-top-strip` → `.shell-tab`): 4 fixed equal-width tabs (Dashboard,
  Transactions, Upcoming, Calendar) + a "More" trigger; icon + small label; active state uses
  `--color-brand-primary`; safe-area bottom inset preserved.
- **"More" drawer** (`.shell-drawer`): bottom sheet with Data / Profile / Support / Guide toggle /
  Logout. Closes on backdrop tap, Escape, and item selection. Slide-up animation gated by
  `prefers-reduced-motion`. `role="dialog"` + `aria-modal` + labelled close button. Hidden ≥900px.
- **Tier A token alignment:** logout-modal inline px styles swapped to `--spacing-*`; shell nav
  surfaces/borders use `--color-surface-*` / `--color-brand-primary`.

Verification: `npm run build` passes (exit 0); `npm run lint` holds at the pre-existing 18-problem
baseline (no new issues). `[V3]` browser/PWA screenshots still pending on inactive-color deploy.
