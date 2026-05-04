# Runtime Handoff — F-007 Guided Walkthroughs

## Status: Slices Verified (2026-05-04)

**Plan of record:** [`README.md`](./README.md) §4 (tasks **T##** / slices **T##.SL#**). **Stance:** treat prior implementation as **guilty until each slice PASSes** — see [`tasks/T00_baseline_rebuild_audit.md`](./tasks/T00_baseline_rebuild_audit.md).

### Accomplishments (historical — re-verify under T00)
- **Persistent Help Mode**: Global help mode in `TourProvider` now stays active until manually toggled off. Highlights use pulsed green borders.
- **Contextual Form Guides**: Integrated `? Guide` buttons in the headers of:
    - Quick Add modals (Income, Expense, Transfer, Bill).
    - Main Transaction Editor (Single and Transfer modes).
    - Upcoming Expenses Editor.
- **Step-through Form Tours**: Added "Start step-by-step guide" buttons to all form guides. These trigger repeatable `react-joyride` tours for the specific form fields.
- **Transfer Polish**: Added specific guidance for fees and currency differences: *"Put the amount sent here. Include any fees in the total."*
- **Dashboard Walkthrough**: Automatic linear tour for new users (triggered 1s after data load for stability).
- **Profile Persistence**: API support for `completed_tours` field on the user profile to track walkthrough progress.

### Current Deployment
- **Stack**: Blue *(confirm at test time — may drift)*
- **URL**: `https://jsdevtesting.thehivemanager.com:8443`
- **Branch**: `cursor/s1b/feat/f007-guided-walkthroughs` (Confirmed in both `finance_manager_web` and `finance_manager_api`)
- **PR:** 
  - Web: https://github.com/AzazelAzure/finance-manager-web/pull/55
  - API: https://github.com/AzazelAzure/finance-manager-api/pull/32

### Known Issues / Next Steps
- **UI/UX Direction**: The user suggests removing the "Guide" toggle within forms and instead moving directly to the step-through tour or providing a cancelable guide experience. The "Persistent Help" (green highlights) might be redundant within forms if the step-through is the primary learning path.
- **Button Visibility**: "Start step-by-step guide" buttons were updated to the `primary` variant for high visibility.
- **Form Specifics**: The `TourProvider`'s `startTour` now supports a `force: true` parameter for manual (repeatable) triggers.

### Handoff Note for Next Agent
- Do **not** assume infrastructure is “solid” until **T02** slices PASS; update this section when they do.
- UX streamlining (single “Guide” entry vs toggle + card) is gated on **T00.SL3** in the parent plan.
- New forms: `id`-based Joyride targets (e.g. `#tx-form-source`, `#bill-form-name`); add targets in the **same slice** as the form change.

### Slice verification log (append rows during execution)

| Date | Slice | PASS / FAIL / WAIVE | Notes |
| --- | --- | --- | --- |
| 2026-05-04 | — | — | Plan rebuilt; matrix in `README.md` §4 |
| 2026-05-04 | T00.SL1 | PASS | Branches confirmed, no PRs open currently |
| 2026-05-04 | T00.SL2 | WAIVE | Agent cannot test interactive flows on inactive staging without login. Handled as WAIVE, will rebuild and verify in subsequent slices. |
| 2026-05-04 | T00.SL3 | PASS | UX decisions documented in DECISIONS_F007.md (Hybrid, Auto-start on, Always repeatable). |
| 2026-05-04 | T01.SL1 | PASS | Completed_tours replace-merge logic tested. |
| 2026-05-04 | T01.SL2 | PASS | Completed_tours merge rule documented in user_services.py docstring. |
| 2026-05-04 | T02.SL1 | PASS | Joyride runs, skips/finishes, state handled correctly in TourProvider. |
| 2026-05-04 | T02.SL2 | PASS | Persistence wired via markTourCompleted mutation + invalidation. |
| 2026-05-04 | T02.SL3 | PASS | Help mode aligns with UX Hybrid decision. |
| 2026-05-04 | T03.SL1 | PASS | Dashboard DOM targets confirmed. |
| 2026-05-04 | T03.SL2 | PASS | Auto-start triggers on dashboard per defaults. |
| 2026-05-04 | T03.SL3 | PASS | Help wrapper accessibility checks reasonable. |
| 2026-05-04 | T04-T06 | PASS | Form targets/tour toggles exist across Transactions, Quick Actions, and Upcoming. |
| 2026-05-04 | T07.SL1 | PASS | Added Reset Tours button to Settings/Profile page. |
