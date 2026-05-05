# T02 — Form modal step-by-step guides

**Surfaces:** `QuickActions.tsx`, `TransactionsPage.tsx`, `UpcomingExpensesPage.tsx`, shared modal/tour helpers in `TourProvider.tsx`.

## Slices

### T02.SL1 — Inventory modals

- [ ] [V0] List each modal type that must get steps (single tx, transfer, quick-add variants, bill form); note Joyride target selectors and mount timing risks.

### T02.SL2 — Implement steps

- [ ] [V1] For each inventoried modal: Joyride `steps` array with **≥2** sequential steps; tour starts only when modal DOM is stable (no fixed 100ms-only hack as sole solution).
- [ ] [V1] `npm run build` → `evidence/T02.SL2_web_build.log`.

### T02.SL3 — Staging

- [ ] [V2] `sprint_verify.sh` with web repo; log path in `runtime_handoff.md`.

### T02.SL4 — Browser verify

- [ ] [V3] Screenshots per modal class (`evidence/T02.SL4_<modal>.png`) on jsdevtesting showing steps 1→n.

## Evidence table

| Slice | Required artifact |
|-------|---------------------|
| T02.SL2 | `evidence/T02.SL2_web_build.log` |
| T02.SL3 | `evidence/sprint_verify_<ts>.log` |
| T02.SL4 | `evidence/T02.SL4_*.png` |
