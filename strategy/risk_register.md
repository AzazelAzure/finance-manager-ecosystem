# Risk Register

**Anticipated** risks — problems that have not yet occurred but are foreseeable. Distinct from
`strategy/anomalies/` (issues already *detected* mid-work) and `strategy/parking_lot/`
(deliberate "later," not problems).

Single rolling file (split into a directory later only if entries start needing per-risk
iteration, the way parking-lot items do). Review at each morning admin session; promote a risk to
an anomaly or a plan if it materializes.

**Last updated:** 2026-06-29

| ID | Risk | Likelihood | Impact | Trigger to watch | Mitigation / owner |
|---|---|---|---|---|---|
| R-01 | Cursor local credit exhaustion mid-feature (cloud already exhausted) | Med | High | Local usage % approaching HitM's halt threshold | HitM-set halt threshold; route content/governance to Claude Code; security to local audit suite |
| R-02 | Bill cadence miscalculation reaches real money via F-009 | Med | High | F-009 starts before bill recurrence engine ships | `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` hard-blocks F-009 (registry `blocks`) |
| R-03 | Documentation drift feeds false ops alerts (recurrence of 2026-06-29) | Med | Med | Any deploy where cached context outruns live state | D5 `vps_state.sh` spec + trust-but-verify tenet (AGENTS.md §1) |
| R-04 | eslint 8→9 (Web Dependabot #77) breaks the Web build on merge | Med | Med | Merging #77 without a build check | Defer #77; merge only after a Cursor local build check (D7) |
| R-05 | Single beta tester → low real-world signal; assumptions untested | High | Med | S1.B exit decision pending real usage data | F-014 usage monitoring; widen beta before monetization |
| R-06 | Versioning system breakdown obscures "what shipped when" | Low | Low | Need to reconstruct a release history | Parked rework (`parking_lot/versioning-system-rework.md`); Runtime Signup Sheet kept current |

Add rows as risks surface. When a risk materializes, file an anomaly (or plan) and note the
cross-reference here.
