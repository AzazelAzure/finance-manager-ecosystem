# Post-Beta Huddle — 2026-04-30

Working scratch space for the post-beta-launch planning conversation between HitM (`pproctor`) and AI agent. Volatile by intent — once decisions are locked, they migrate into governance / strategic roadmap / design docs and this directory is archived.

## Purpose

The first beta launched 2026-04-29 with a JS pivot that wasn't in the strategic roadmap and a Reflex frontend that's now formally archived. Calendar projections were wrong by ~6 months. Several pre-governance plans are still open. The strategic roadmap, the Phase 1/Phase 2 docs in `design_docs/20_Roadmap/`, and the actual on-disk reality have all drifted from each other.

This huddle is the **reconciliation step** before the next sprint. No major restructuring or infra changes happen until the roadmap is overhauled and locked.

## Files

| File | Purpose |
|---|---|
| `README.md` | This file — agenda, exit criteria, scope |
| `TALKING_POINTS.md` | Per-topic discussion record (status + notes + decision) |
| `KNOWN_ISSUES.md` | HitM-supplied list of bugs/issues from beta usage (incl. critical distribution-blocker) |
| `DECISIONS.md` | Append-only log of locked decisions as they're reached |

## Exit criteria for this huddle

The huddle is "done" when **all** of:

- [ ] Known issues list is captured and triaged by severity
- [ ] Reflex archival scope is fully defined (compose, proxy, plans, design docs)
- [ ] Phase definitions reconciled: `Phase_1_Alpha_Stabilization.md`, `Phase_2_Beta_Preparation.md`, `Roadmap_Overview.md`, and strategic roadmap S1–S6 agree
- [ ] "Public launch" milestone is defined with explicit entry/exit triggers
- [ ] Distribution-readiness gap is sequenced (what blocks first 10 users)
- [ ] Wedge / hero copy decision made (with or without polish queued)
- [ ] Velocity + Cursor cost management plan agreed for next 4–6 weeks
- [ ] Drift cleanup queue ordered (what gets done during decompression weeks)
- [ ] Family / personal cadence cadence confirmed
- [ ] Trigger condition for next sprint resume defined
- [ ] All `DECISIONS.md` entries are signed off by HitM

When complete: a single follow-up plan packet under `plans/cursor/<branch>/` covers the cleanup work, the strategic roadmap is updated to reflect locked decisions, and this huddle directory moves to `plans/archived/post_beta_huddle_2026-04-30/`.

## Agenda (suggested order)

The order is sequenced so each topic feeds the next. We can re-order if HitM has a stronger preference.

1. **Known issues sweep** — including the critical distribution-blocker (Topic 1)
2. **Reflex archival scope** — what to remove, where, in what order (Topic 2)
3. **JS pivot retro-formalization** — mark complete, update strategic context (Topic 3)
4. **Phase definition overhaul** — reconcile old Phase 1/2 docs with strategic S1–S6 (Topic 4)
5. **"Public launch" milestone definition** — what's between current tight beta and that (Topic 5)
6. **Distribution readiness gap** — billing, founding-member program, PH channels (Topic 6)
7. **Wedge audit + landing polish queue** — hero vs product preview placement (Topic 7)
8. **Velocity + Cursor cost management** — decompression rules, sprint resume trigger (Topic 8)
9. **Drift cleanup queue** — +Bill hotfix, governance sync, plan close-outs (Topic 9)
10. **Family / personal cadence** — quarterly review setup, velocity assumption check (Topic 10)
11. **Lock and consolidate** — pull `DECISIONS.md` into governance, draft next-sprint plan (Topic 11)

## Scope guardrails

- **No code changes during the huddle** except Topic 9 (drift cleanup) — and even those wait until the relevant decisions are locked.
- **No autonomous strategic roadmap edits** — every change to `plans/cursor/strategic-roadmap-reframe-53be/` waits for explicit HitM signoff in `DECISIONS.md`.
- **Preserve pre-governance plan progress** — don't retroactively force them into governance metadata until they close.

## Pace expectation

This is a multi-session conversation, not a single push. Pause at any topic. Resume on `TALKING_POINTS.md` whichever topic was last marked `discussing`. Decompression cadence applies — short focused sessions are better than marathon ones.
