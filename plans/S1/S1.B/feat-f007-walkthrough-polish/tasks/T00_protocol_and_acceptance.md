# T00 — Protocol smoke + acceptance (F-007 polish)

## Slices

### T00.SL1 — Acceptance criteria (HitM-visible)

- [x] [V0] Document in this file the **definition of done** for: (a) help-mode → linear tour without an extra button press after widget select, unless a11y requires an explicit confirm; (b) form modals — minimum step count ≥ 2 visible Joyride steps per primary modal type; (c) calendar — tour covers month nav + cell selection path.
- [x] [V0] Link parent F-007 `runtime_handoff.md` BUG rows that this plan supersedes or extends.

#### Definition of done (V0 — concrete)

**(a) Help-mode → linear tour (no redundant confirm)**

- After the user finishes **help-mode** widget selection (the flow that picks what to explain next), the **linear Joyride tour** starts on the chosen target **without** a separate in-between control press (no extra “Start tour”, “Continue”, or duplicate primary action) solely to bridge help-mode into the tour.
- **Exception:** If product a11y review requires an **explicit confirm** (for example focus management, screen-reader announcement of context change, or a modal that must receive intentional activation), that step is allowed and must be **documented per surface** in the slice or page tour notes with rationale.
- **Verify:** Staging pass: enter help-mode → complete widget pick → first tour tooltip appears with at most the documented a11y confirm in the way.

**(b) Form modals — minimum Joyride depth**

- For each **primary modal type** in scope for F-007 polish (single transaction, transfer, bill / upcoming expense, and each distinct Quick Add modal class the product treats as a first-class entry), the guided tour exposes **at least two visible Joyride steps** after the tour is running inside the mounted modal (steps must target real, on-screen elements—not empty or skipped targets).
- Steps should read as a **sequence** (for example context of the modal → a key field or action), not two copies of the same tooltip.
- **Verify:** Open modal → start that modal’s guide from the discoverable control → count ≥2 rendered steps before dismiss/skip; repeat per primary modal type.

**(c) Calendar — month navigation + cell selection**

- Any **calendar** tour slice must include both: **month navigation** (previous/next month or equivalent control surfaced in the UI), and **cell selection** (user can follow the tour to a specific day cell and the narration targets that path).
- **Verify:** Staging: from calendar entry point, complete the tour through at least one month change and one date-cell selection without dead targets.

#### Parent F-007 handoff — BUG linkage

This polish plan lives under `plans/S1/S1.B/feat-f007-walkthrough-polish/`. It **extends** acceptance and sequencing expectations relative to the parent guided-walkthroughs handoff:

| Parent BUG | Parent file | Relationship to this polish plan / T00.SL1 |
|------------|-------------|-----------------------------------------------|
| **BUG 2** | [`feat-f007-guided-walkthroughs/runtime_handoff.md`](../feat-f007-guided-walkthroughs/runtime_handoff.md) — tour requires button press; inconsistent auto vs manual | **Extended** by DoD **(a)**: help-mode → linear tour must not add a redundant press after widget select (aligns first-run / help-mode UX with the “no mystery extra click” expectation; manual “Start guide” for refresh remains separate). |
| **BUG 3** | Same — tours effectively dashboard-only; other surfaces weak | **Extended** by DoD **(c)**: calendar surface must meet month-nav + cell-selection coverage when its tour ships in this plan (subset of “every page owns its tour” intent). |
| **BUG 5** | Same — form guides / modal DOM timing | **Superseded for acceptance** by DoD **(b)** once R03-class fixes land: beyond “tour runs”, **pass** means ≥2 visible steps per primary modal type on staging. Implementation still tracks parent rework slice **R03**. |

BUG 1 (no `isTourCompleted` guard), BUG 4 (help-mode outline cosmetics), and parent **R01/R02/R04/R05** remain tracked in the parent `runtime_handoff.md`; they are not redefined here but must stay green with polish work.

### T00.SL2 — Tooling dry-run

- [x] [V1] From parent repo, run `./scripts/sprint_verify.sh --dry-run --color blue --branch cursor/s1b/feat/f007-walkthrough-polish --repos web --evidence plans/S1/S1.B/feat-f007-walkthrough-polish/evidence/` and save stdout to `evidence/T00.SL2_sprint_verify_dryrun.log` (path in table below).

## Evidence

| Slice | Artifact |
|-------|----------|
| T00.SL1 | `evidence/T00.SL1_V0_acceptance_notes.md` |
| T00.SL2 | `evidence/T00.SL2_sprint_verify_dryrun.log` |
