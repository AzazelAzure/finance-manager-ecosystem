# T03 — Transaction calendar step-by-step tour

**Surfaces:** Calendar UI on transactions route (and shared calendar components if split).

## Slices

### T03.SL1 — Discovery

- [ ] [V0] Identify component tree for transaction calendar; pick tour id string consistent with `completed_tours` pattern; confirm no duplicate tour id with list tour.

### T03.SL2 — Implement tour

- [ ] [V1] Add Joyride (or shared tour helper) with steps covering: open calendar / change month / select a day (adjust to actual UI).
- [ ] [V1] `npm run build` → `evidence/T03.SL2_web_build.log`.

### T03.SL3 — Staging

- [ ] [V2] `sprint_verify.sh` log path recorded.

### T03.SL4 — Browser verify

- [ ] [V3] Screenshot walkthrough on jsdevtesting → `evidence/T03.SL4_calendar_tour.png`.

## Evidence table

| Slice | Required artifact |
|-------|---------------------|
| T03.SL2 | `evidence/T03.SL2_web_build.log` |
| T03.SL3 | `evidence/sprint_verify_<ts>.log` |
| T03.SL4 | `evidence/T03.SL4_calendar_tour.png` |
