---
logged: 2026-06-29
agent: cursor
plan_context: inactive-blue polish batch / Theme 4 (PR #95) / jsdevtesting checklist
status: unreviewed
severity_guess: medium
---

## What was found

Auto-start Joyride form walkthroughs on Quick Add, Transactions editor, and Upcoming bill
editor fire while the modal is the foreground layer. The tour spotlight/tooltip renders behind
or outside the modal, producing a broken UX (tour appears to run "in the background"). HitM
jsdevtesting flagged this on inactive blue 2026-06-29.

Per-field **guide mode** (`HelpModeWrapper` on form fields) works correctly inside modals and
is the preferred pattern for modal forms.

## Where

- `finance_manager_web/src/components/dashboard/QuickActions.tsx` — `useEffect` auto-starts
  `QUICK_ADD_TOUR_ID` when modal opens (`~200–208`)
- `finance_manager_web/src/pages/transactions/TransactionsPage.tsx` — `TRANSACTIONS_FORM_TOUR_ID`
  auto-start on editor open (`~509–518`)
- `finance_manager_web/src/pages/upcoming/UpcomingExpensesPage.tsx` — `UPCOMING_FORM_TOUR_ID`
  auto-start on editor open (`~526–534`)
- Step builders: `QuickAddTourSteps.ts`, `TransactionsTourSteps.ts` (`buildTransactionsFormSteps`),
  `UpcomingTourSteps.ts` (`buildUpcomingBillFormSteps`)

## What agent was doing

Inactive-blue jsdevtesting closeout; checklist item "Quick Add / transaction / bill forms:
walkthrough steps into fields" failed. HitM directed disable tours for now and log anomaly.

## Why outside scope

Immediate fix is disable broken auto-tours (flip gate). Proper fix needs a design pass: either
portal Joyride into modal z-index stack, or replace modal form tours with guide-mode-only (no
Joyride) — likely the latter per HitM preference.

## Possible owner

Cursor / web UX polish follow-up (post-flip or S1.B guide-mode hardening slice)

## Notes

Page-level tours (Transactions list, Upcoming list, Data Hub, Profile, Goals) remain enabled and
work. Only **modal form** auto-tours disabled in `cur/s1b/fix/disable-modal-form-tours`. Tour
step files retained for a future rework.
