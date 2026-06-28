# T02 — Sandbox Overlay and Global Tour

## End State
A comprehensive, multi-step Joyride tour that runs over a "Sandbox" overlay. The overlay looks exactly like the real app but contains hardcoded, seeded data (dummy transactions, balances, upcoming bills).

- What the user sees: On first login, a full-screen overlay appears mimicking the Dashboard. A Joyride tour guides them through fake charts, lists, and forms, explaining financial literacy concepts. The user can skip or complete it. The Sandbox has an internal state to switch between "Dashboard", "Transactions", and "Calendar" views during the tour.
- What the developer sees: `OnboardingSandbox.tsx` which renders a fake layout. `GlobalOnboardingTour.tsx` which configures Joyride steps pointing to elements inside the Sandbox.
- What does NOT change: The actual `ProtectedShell` content remains untouched, it just conditionally renders the Sandbox overlay on top.

## Acceptance Criteria
1. [V1] `npm run build` passes with zero errors and zero warnings
2. [V3] Browser: On fresh load (no `completed_tours`), the sandbox tour launches, steps through multiple simulated pages, highlights elements, and dims the background.

## Scope Lock

### Files to create
- `finance_manager_web/src/components/tours/OnboardingSandbox.tsx`
- `finance_manager_web/src/components/tours/GlobalOnboardingTour.tsx`

### Files to modify
- `finance_manager_web/src/layout/ProtectedShell.tsx` (Render `OnboardingSandbox` conditionally, add replay button).
- `finance_manager_web/src/components/tours/TourProvider.tsx` (Add `hasCompletedGlobalTour` helper).

### Files NOT to touch
- Real API endpoints or actual page components like `DashboardPage.tsx`.

## Technical Decisions (pre-locked)
- Per D02: The Sandbox must be self-contained. Fake data should be hardcoded within `OnboardingSandbox.tsx`.
- Per D03: Joyride steps must include financial literacy text, not just UI explanations.

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | Sandbox UI | V1 | Create OnboardingSandbox matching app layout with dummy data. |
| T02.SL2 | Joyride Config | V1 | Create GlobalOnboardingTour with steps targeting the sandbox. |
| T02.SL3 | Shell Integration | V1 | Trigger sandbox on first load, provide replay button. Build passes. |

## Anti-Patterns (do NOT do these)
- Do NOT try to route the actual application during the tour. The tour only drives the internal state of the Sandbox.
- Do NOT use real data fetching inside the Sandbox.
