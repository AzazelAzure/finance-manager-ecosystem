# Worked Example: Sprint Task Spec — F-007 Transaction Tour

*This is a concrete example of the [`.cursor/rules/sprint-task-specification.mdc`](../../.cursor/rules/sprint-task-specification.mdc) format. Use this as a reference when writing new task specs.*

---

# T01 — Guided Tour: Transactions Page

## End State

When a user navigates to `/transactions` for the first time (no `hfm_tour_transactions_completed` key in localStorage), a 5-step guided tour automatically begins using `react-joyride`:

1. **Step 1** highlights the "Quick Add" button (`data-tour="quick-add-btn"`). Tooltip text in English: *"Start here — tap this button to add a new transaction quickly."* Tooltip text in Filipino: *"Magsimula dito — i-tap ang button na ito para mabilis na mag-dagdag ng transaksyon."*
2. **Step 2** highlights the transaction list area (`data-tour="transaction-list"`). Tooltip: *"Your recent transactions appear here, with the newest at the top."*
3. **Step 3** highlights the source filter dropdown (`data-tour="source-filter"`). Tooltip: *"Filter by source — see only GCash, Maya, or Cash transactions."*
4. **Step 4** highlights the date range picker (`data-tour="date-range"`). Tooltip: *"Change the date range to look at older transactions."*
5. **Step 5** highlights the balance summary card (`data-tour="balance-summary"`). Tooltip: *"This is your total balance across all sources. 'Safe to Spend' is what's left after upcoming bills."*

**On completion:** User clicks "Done" on step 5 → `localStorage.setItem('hfm_tour_transactions_completed', 'true')`. Tour does not appear again unless user clicks the help icon in the app header (which resets the localStorage key and restarts the tour).

**Visual appearance:** Tour overlays use the existing app theme — `--color-primary` for spotlight border, `--color-surface` for tooltip background, `--color-text` for tooltip text. No hardcoded colors. Tooltip has a "Skip tour" link on every step and a "Next" / "Back" / "Done" button set.

**Offline behavior:** Tour works fully offline — no API calls. All tooltip text is bundled in the component. PWA class: **A** (offline-compatible).

**What does NOT change:** Transaction list rendering, API calls, data flow, source filter logic, balance calculation. This task only adds a visual overlay — zero functional changes to existing components.

## Acceptance Criteria

1. [V1] `npm run build` passes with zero errors and zero warnings
2. [V1] `npm run test` passes — new test file has ≥3 test cases (renders, completes, respects localStorage)
3. [V2] Deployed to inactive color; app loads without console errors
4. [V3] Browser: navigate to `/transactions` with cleared localStorage — tour starts automatically
5. [V3] Browser: complete all 5 steps — each tooltip renders correctly, no layout overflow
6. [V3] Browser: navigate away and back — tour does NOT restart (localStorage persists)
7. [V3] Browser: click help icon in header — tour restarts from step 1
8. [V3] Browser: disconnect network, reload page — tour still works (PWA class A)

## Scope Lock

### Files to create

- `src/components/GuidedTour/TransactionTour.tsx` — tour component
- `src/components/GuidedTour/TransactionTour.test.tsx` — unit tests
- `src/components/GuidedTour/tourSteps.ts` — step definitions (separates content from component)
- `src/components/GuidedTour/GuidedTour.css` — tour-specific styles (theme variable overrides only)

### Files to modify

- `src/pages/Transactions/TransactionsPage.tsx` — add `data-tour` attributes to 5 target elements; import and render `<TransactionTour />` conditionally
- `src/components/Header/Header.tsx` — add help icon button that dispatches tour reset event

### Files NOT to touch

- `src/offline/*` — PWA service worker layer (separate plan)
- `src/api/*` — no API changes
- `src/store/*` — no state management changes (tour uses localStorage, not Redux/context)
- `package.json` — `react-joyride` is already installed (verify before starting; if not installed, STOP and report scope gap)
- Any other page's components — this task is transactions page ONLY

## Technical Decisions (pre-locked)

- **D01:** Use `react-joyride` v2.8+ (already in dependencies)
- **D02:** Anchor tours with `data-tour="<step-name>"` attributes (not IDs, not CSS classes)
- **D03:** Tour state in localStorage (not React context, not API call)
- **D04:** One tour component per page (not a centralized tour manager)
- **D05:** Tooltip text hardcoded in `tourSteps.ts` (i18n wiring is a separate task — shelved follow-up)

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Component scaffold + types | V1 | Create all 4 new files. Tour component renders but is not wired to page. `npm run build` and `npm run test` pass. |
| T01.SL2 | Page integration + data-tour attrs | V2 | Wire tour to TransactionsPage. Add `data-tour` attributes to 5 elements. Deploy to inactive color. App loads without errors. |
| T01.SL3 | Help icon + reset | V1 | Add help icon to Header. Clicking resets localStorage and dispatches custom event. Unit test for reset logic. |
| T01.SL4 | Browser verification | V3 | Full walkthrough in browser. All 8 acceptance criteria verified. Screenshots captured as evidence. |

## Anti-Patterns (do NOT do these)

- **Do NOT** create a `TourManager` or `TourProvider` context that manages tours for all pages — one component per page, standalone
- **Do NOT** use CSS class selectors (`.transaction-list`) for tour anchoring — CSS modules mangle class names
- **Do NOT** use element IDs for anchoring — they conflict with form accessibility attributes
- **Do NOT** lazy-load the tour component — static import is fine, bundle impact is negligible (~15KB)
- **Do NOT** add tour analytics or tracking events — that's a separate future task
- **Do NOT** modify the existing `TransactionsPage` data flow or API calls — tour is a pure visual overlay
- **Do NOT** add a new npm dependency — `react-joyride` should already be installed
- **Do NOT** create tour content in a JSON file — use a TypeScript file (`tourSteps.ts`) for type safety

## Context Links

- Plan README: `plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`
- Decision Log: `plans/S1/S1.B/feat-f007-walkthrough-polish/DECISION_LOG.md`
- Sprint Queue Messages: `plans/pipeline_queue/` (drafted for SL1→SL4)
- Related prior work: `finance_manager_web/CHANGELOG.md` — F-007 initial implementation
- DoD checklist: `governance/definition_of_done.md`

---

## Sprint Queue Message (SL1 — ready to post)

```text
@CursorPA
Task Id: F-007
REPO: finance_manager_web
WORKSPACE_PATH: ~/agent-workspaces/cursor-executor/finance_manager/finance_manager_web
BRANCH: cursor/s1b/feat/f007-walkthrough-polish (checkout required)
SLICE: T01.SL1 — Component scaffold and types

READ FIRST:
- ~/finance_manager/governance/glossary.md
- ~/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/README.md
- ~/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/DECISION_LOG.md
- ~/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/runtime_handoff.md
- ~/finance_manager/.cursor/rules/sprint-task-specification.mdc
- ~/finance_manager_web/CHANGELOG.md

TASKS:

1. Read all READ FIRST files. Report context loaded before proceeding.
2. Create `src/components/GuidedTour/TransactionTour.tsx` — tour component using react-joyride. Renders a Joyride instance with steps from tourSteps.ts. Checks localStorage for completion state. Accepts `onComplete` callback prop.
3. Create `src/components/GuidedTour/tourSteps.ts` — array of 5 Step objects (quick-add-btn, transaction-list, source-filter, date-range, balance-summary). Each has target, content (English text per End State), and placement.
4. Create `src/components/GuidedTour/GuidedTour.css` — minimal styles using CSS custom properties (--color-primary, --color-surface, --color-text). Override only joyride tooltip background and border.
5. Create `src/components/GuidedTour/TransactionTour.test.tsx` — 3 test cases: (a) renders without crash, (b) reads localStorage on mount, (c) sets localStorage on complete callback.
6. Verify `npm run build` passes with zero errors.
7. Verify `npm run test` passes.

FILES TO MODIFY:

- src/components/GuidedTour/TransactionTour.tsx (NEW)
- src/components/GuidedTour/tourSteps.ts (NEW)
- src/components/GuidedTour/GuidedTour.css (NEW)
- src/components/GuidedTour/TransactionTour.test.tsx (NEW)

ACCEPTANCE:

- npm run build passes with zero errors and zero warnings
- npm run test passes with all new tests green
- No modifications to any existing files in this slice
- Commit message: "feat(f007): scaffold TransactionTour component and step definitions"
- Push to branch
- Do NOT start T01.SL2 — stop and report completion

SPEC: sprint-queue-v1
PLAN_ID: PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21
PLAN_ROOT: plans/S1/S1.B/feat-f007-walkthrough-polish/
SLICE_ID: T01.SL1
VERIFY_TIERS: V1
RETRY_OF: none
```
