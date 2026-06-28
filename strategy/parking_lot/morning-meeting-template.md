---
parked: 2026-06-29
revisit_when: D5 (doc-accuracy) and D6 (doc-structure) are formalized
owner: Claude Code
status: parked
---

# Morning meeting template formalization (D8)

Formalize the admin morning-meeting structure into a reusable template + generation prompt so
sessions are consistent and don't require re-derivation.

**Proposed section order (from D8):** overnight wins → live VPS state (SSH-verified) → open
anomalies → doc sweep → discussion points → work order (by agent) → S1.B exit progress.

**Why parked:** HitM wants this after D5/D6 settle, because the template depends on (a) the
live-state source from the D5 `vps_state.sh` spec and (b) the documentation/file structure
decided in D6. The inline-comment file format is confirmed as the working medium.

**Revisit trigger:** once `vps_state.sh` lands and the D6 structure is approved/executed.
