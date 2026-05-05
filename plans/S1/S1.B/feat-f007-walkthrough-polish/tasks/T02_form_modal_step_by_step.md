# T02 — Form modal step-by-step guides

**Surfaces:** `QuickActions.tsx`, `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx`, shared modal/tour helpers in `TourProvider.tsx`.

## Slices

### T02.SL1 — Inventory modals

- [ ] [V0] List each modal type that must get steps (single tx, transfer, quick-add variants, bill form); note Joyride target selectors and mount timing risks.

### T02.SL2 — Transaction + transfer modals

- [ ] [V1] For **transaction** and **transfer** entry modals: Joyride `steps` array with **≥2** sequential steps each; tour starts only when modal DOM is stable (no fixed 100ms-only hack as sole solution).
- [ ] [V1] `cd finance_manager_web && npm run build` → `evidence/T02.SL2_web_build.log`.

### T02.SL3 — Quick-add, bill, upcoming modals

- [ ] [V1] For **quick-add**, **bill**, and **upcoming** modals: same ≥2-step rule per modal class; stable mount timing.
- [ ] [V1] `npm run build` → `evidence/T02.SL3_web_build.log` (if unchanged since SL2 in same branch, note in evidence table *log reused from SL2* and link path).

### T02.SL4 — Staging

- [ ] [V2] `./scripts/sprint_verify.sh` with `--repos web` on inactive color; log path in `runtime_handoff.md` and `evidence/sprint_verify_<ts>.log`.

### T02.SL5 — Browser verify

- [ ] [V3] Screenshots per modal class on jsdevtesting (`evidence/T02.SL5_<modal>.png`) showing steps 1→n.

## Evidence table

| Slice   | Required artifact |
| ------- | ------------------- |
| T02.SL2 | `evidence/T02.SL2_web_build.log` |
| T02.SL3 | `evidence/T02.SL3_web_build.log` (or explicit reuse note pointing at SL2 log) |
| T02.SL4 | `evidence/sprint_verify_<ts>.log` |
| T02.SL5 | `evidence/T02.SL5_*.png` |
