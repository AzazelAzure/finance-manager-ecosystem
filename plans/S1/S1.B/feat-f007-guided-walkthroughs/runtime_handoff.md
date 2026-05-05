# Runtime Handoff — F-007 Guided Walkthroughs

**`ACTIONS.md` #7 (2026-05-05):** HitM V3 findings in this file are the reconciliation source. Prior V2 claims lacked `sprint_verify.sh` logs; see [`evidence/V2_ORCHESTRATION_2026-05-05.md`](./evidence/V2_ORCHESTRATION_2026-05-05.md) for the evidence contract before the next verification cycle.

## Status: V3 FAIL — Requires Rework (2026-05-04)

**V3 Verifier:** HitM (browser verification on staging)
**Deployment:** Blue (inactive), `https://jsdevtesting.thehivemanager.com` (:8443)
**Branch:** `cursor/s1b/feat/f007-guided-walkthroughs`
**Latest Commit:** `7e6db58`

---

## HitM V3 Findings (2026-05-04 19:36 PHT)

### BUG 1: Dashboard tour fires once, never again — no `isTourCompleted` guard
- **Severity:** High
- **Detail:** `DashboardPage.tsx:153-202` calls `startTour('dashboard_linear_tour', ...)` inside a `useEffect` that fires when `data` loads. There is **no** `isTourCompleted('dashboard_linear_tour')` guard. The tour fires on every data load, then immediately gets marked as completed via `markTourCompleted` in the Joyride callback. After first completion, the tour ID is in `completed_tours` on the API, but the `startTour` call **ignores** that — it fires anyway, Joyride sees it's already completed, and silently skips. Result: works once on first load, never triggers again even if user wants it.
- **Root cause in code:** `startTour` does not check `isTourCompleted` before running. The `useEffect` has no guard either.

### BUG 2: Tour requires button press instead of being automatic for new users
- **Severity:** Medium
- **Detail:** While the dashboard `useEffect` auto-fires (broken per BUG 1), the transactions page (`TransactionsPage.tsx:502-519`) also has a `useEffect` auto-start, and other pages require explicit button clicks. Inconsistent UX — new users don't understand what "Start guide" means or why some pages auto-tour and others don't.
- **Expected:** First visit to any page should auto-trigger that page's tour (once, then mark completed). Manual "Start guide" buttons should re-trigger for users who want a refresher.

### BUG 3: Tours only work on Dashboard
- **Severity:** High
- **Detail:** Transactions, Upcoming Expenses, and Quick Actions tours exist in code but do not trigger for the user. The transactions `useEffect` auto-start exists but has the same no-guard problem. Upcoming/QuickActions only trigger on button clicks inside form modals — those buttons are not discoverable.
- **Expected:** Each page should have its own auto-trigger on first visit + a discoverable "Start guide" button.

### BUG 4: Help Mode green dotted outlines are ugly
- **Severity:** Low (cosmetic)
- **Detail:** `TourProvider.tsx:204` applies `outline: '2px dashed #10b981'` (Tailwind green) to `HelpModeWrapper` divs when help mode is active. This clashes with the app's dark theme and looks like a debug border, not a polished UX feature.
- **Expected:** Solid outline using brand accent color, or a subtle glow/shadow effect. Reference the app's existing CSS variables.

### BUG 5: Form guides don't work
- **Severity:** High
- **Detail:** `startTour` calls inside modal forms (e.g., `tx_single_tour`, `tx_transfer_tour`, `bill_form_tour`, `quick_*_tour`) target elements that don't exist when the modal hasn't been opened, or the tour fires before the modal DOM is ready. The `setTimeout(100)` hack in `startTour` is insufficient for modals that animate in.
- **Expected:** Form guide tours should only trigger AFTER the modal is fully mounted and visible. Need a `MutationObserver` or callback-based approach rather than a fixed timeout.

---

## Slice verification log

| Date | Slice | V-Tier | PASS/FAIL/WAIVE | Notes |
|------|-------|--------|-----------------|-------|
| 2026-05-04 | T03.SL1-3 | V2 (claimed) | **V3 FAIL** | Dashboard tour fires but has no completion guard; cosmetic issues |
| 2026-05-04 | T04.SL1-2 | V2 (claimed) | **V3 FAIL** | Transactions tour does not trigger for users |
| 2026-05-04 | T05.SL1 | V2 (claimed) | **V3 FAIL** | Quick Add form guides don't work — modal DOM timing |
| 2026-05-04 | T06.SL1 | V2 (claimed) | **V3 FAIL** | Upcoming form guide doesn't work — same modal timing issue |
| 2026-05-04 | T07.SL1 | V1 | PASS | Reset Tours button works in Settings |

---

## Rework Slices (Pipeline test — Cursor-first)

These slices will exercise the `#sprint-queue` → `#review-queue` → `#hitm-gate` flow with **Cursor PA** + JSONL outbox for Slack status (see `governance/cursor_pa_slack_visibility.md`); Antigravity is not the orchestration path for new work.

| Slice | Scope | Files | V-Tier | Acceptance |
|-------|-------|-------|--------|------------|
| **R01** | Add `isTourCompleted` guard to all auto-start `useEffect` hooks; per-page first-visit auto-trigger | `TourProvider.tsx`, `DashboardPage.tsx`, `TransactionsPage.tsx` | V2 | Each page auto-tours once on first visit; subsequent visits skip; reset button re-enables all |
| **R02** | Add discoverable "Start guide" button to every page header (dashboard, transactions, upcoming) | `DashboardPage.tsx`, `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx` | V2 | Button visible in page header; clicking triggers page tour regardless of completed state |
| **R03** | Fix form guide modal timing — replace `setTimeout(100)` with DOM-ready detection | `TourProvider.tsx`, `QuickActions.tsx`, `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx` | V3 | Opening any form modal → "Guide" button → tour targets render correctly over modal |
| **R04** | Replace help mode green dashed outline with brand-consistent styling | `TourProvider.tsx` | V2 | Help mode outlines use app's accent/brand color, solid or glow, not dashed green |
| **R05** | Per-page tour IDs instead of blanket flag | `TourProvider.tsx`, all page files | V1 | Each page has its own tour ID in `completed_tours`; resetting one page doesn't reset all |

**Execution order:** R05 → R01 → R02 → R03 → R04 (R05 is the data model fix that R01-R03 depend on)
