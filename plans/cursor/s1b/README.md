# Stage S1.B — Distribution Readiness

**Stage-level dashboard** per hierarchical plan structure (locked huddle 2026-04-30 Topic 11 Q11.3).

## Stage metadata

- **Phase:** S1
- **Stage:** S1.B (Distribution Readiness)
- **Strategic link:** `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` (Stage S1.B section + Appendix A)
- **Status:** active 2026-04-30 → estimated July 2026
- **Entry triggers:** S1.A exit met (✅); Strategic Plan revision complete (✅ huddle output); Topic 8 velocity controls operational
- **Exit triggers:** see `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md` Phase S1 Stage S1.B

## Sub-plan index

Sub-plans under this Stage. Each follows the canonical Execution Plan template (`plans/_governance/plan_template.md`) with hierarchical metadata.


| Sub-plan                         | Status  | Owner                           | Dependencies                                                   | Notes                                                                                                                          |
| -------------------------------- | ------- | ------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `drift-cleanup/`                 | `draft` | unassigned                      | none                                                           | Group B from huddle Topic 9; small/urgent items first (+Bill, email uniqueness S0, Reflex archival, bug triage). Order locked. |
| `entity-formation-research/`     | `draft` | unassigned (HitM-led decisions) | none                                                           | US LLC vs OPC. Gates everything financial.                                                                                     |
| `payment-provider-research/`     | `draft` | unassigned (HitM-led decisions) | `entity-formation-research` (entity choice constrains options) | Stripe vs PayMongo vs Xendit vs hybrid. Mobile-wallet primary path.                                                            |
| `ai-economics-deep-dive/`        | `draft` | unassigned (HitM-led decisions) | none                                                           | 16 questions per `phases/S1_`* Appendix A. Gates S1.C entry.                                                                   |
| `distribution-channel-research/` | `draft` | unassigned (HitM-led decisions) | none                                                           | PH-local channels (FB primary, AI video framing, family/friend WOM seed).                                                      |
| `wedge-consistency-audit/`       | `draft` | unassigned                      | landing polish underway                                        | ~1 hour slip-in audit per huddle Topic 7 Q7.3.                                                                                 |


## Branch naming convention

Per `plans/_governance/branching_guidelines.md`:

- Sub-plan branch: `cursor/s1b/<sub-plan-name>` (e.g. `cursor/s1b/drift-cleanup`)
- Feature branch on inactive color: `cursor/s1b/feat/<feature-name>` (e.g. `cursor/s1b/feat/email-uniqueness-fix`)
- Task branch under feature: `cursor/s1b/feat/<feature-name>/t<NN>-<slug>`

## Sequencing

Per huddle Topic 9 group ordering:

```
Group A (immediate, ~3 days):  drift-cleanup small items + monthly audit
Group B (S1.B early):          drift-cleanup major items
Group C (S1.B research):       entity → payment → ai-economics → distribution → wedge audit
Group D (S1.B features):       sequential after C; per-feature color cycle
Group E (parallel low-pri):    time-clock agent; huddle skill; hotfix workflow
Group F (S1.C entry prep):     founding member backend; pricing page; ToS
```

See `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` Stage S1.B Workstreams W1–W6 for full detail.

## Personal constraint reminders (HitM)

- Pre-baby velocity full through ~mid-June 2026; baby due 2026-06-15. Front-load deep-focus research workstreams (entity, payments, AI economics) into May–early June pre-baby window.
- 10hr/day, 55hr/week ceiling during Sprints; 6hr/day, 30hr/week during Decompression.
- ₱100/mo runtime cost cap; Cursor cap as forcing function (no overages).
- First quarterly self-review 2026-06-30.

## Cross-references

- Strategic context: `plans/cursor/strategic-roadmap-reframe-53be/00_strategic_context.md`
- Unit economics: `plans/cursor/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`
- Validation gates: `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md`
- Parking lot: `plans/cursor/strategic-roadmap-reframe-53be/PARKING_LOT.md`
- Branching workflow: `plans/_governance/branching_guidelines.md`
- Plan template: `plans/_governance/plan_template.md`
- Plan registry: `plans/_governance/plan_registry.md`

## Stage exit criteria summary (full detail in `validation_gates.md`)

- All sub-plans `completed`.
- Email uniqueness S0 fix shipped; +Bill hotfix in git; Reflex archival complete.
- Bug fixes for Issues #1, #4, #7 shipped.
- Entity, payment provider, AI economics decisions made.
- Distribution channel research complete; founder content cadence defined.
- Wedge consistency audit complete; landing-page polish landed.
- Founding member program backend ready.
- "Worth paying for" feature work complete (Pro tier demonstrably worth ₱200/mo).
- ToS + Privacy + Refund policies live.
- Android pulled forward to `android:Alpha` minimum.

When all of the above are met → S1.B → S1.C transition; deferred decisions resolved per huddle Topic 4 (US re-engagement Phase placement, AI tier final commitment).