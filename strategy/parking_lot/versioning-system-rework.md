---
parked: 2026-06-29
revisit_when: after all S1.B features ship (except pay methods)
owner: HitM
status: parked
---

# Versioning system rework

The versioning system is effectively broken as-practiced: development is many small fixes rather
than discrete large versioned changes, so the "summary of each version" docs in
`design_docs/30_Releases/` no longer reflect reality.

**Decision (D6 Q3, 2026-06-29):** pull the `30_Releases` versioning-summary material out
entirely as part of the design-docs restructure (it's not serving its purpose). Revisit whether
a real versioning scheme is worth introducing **after S1.B features are done** — assessed as
*likely unnecessary* at current scale.

**Does NOT include** `Runtime_Signup_Sheet.md` (the VPS checkout sheet) — that stays and is kept
current per the AGENTS.md documentation-maintenance tenet.

**Revisit trigger:** S1.B feature-complete (minus pay methods). If small-fix cadence continues to
work, close as `dropped`.
