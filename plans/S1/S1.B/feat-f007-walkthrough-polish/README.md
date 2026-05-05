---

plan_id: PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21
status: draft
priority: P2
created: 2026-05-21
updated: 2026-05-21
owner: pproctor

plan_root: plans/S1/S1.B/feat-f007-walkthrough-polish/
intended_branch: cursor/s1b/feat/f007-walkthrough-polish
target_repos:

- finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/ (inactive stack via fm_server_beta smoke)
    - Tour flows on jsdevtesting :8443
  notes: Extends F-007 Joyride/help-mode work; uses sprint_verify.sh for V2 evidence per orchestration huddle.

## standalone: true

standalone_notes: "Protocol test: first plan authored explicitly for V0–V3 + sprint_verify evidence discipline."

# F-007 walkthrough polish — help flow, forms, calendar

**Parent context:** [feat-f007-guided-walkthroughs README](../feat-f007-guided-walkthroughs/README.md) (F-007 core). **Handoff baseline:** [parent runtime_handoff](../feat-f007-guided-walkthroughs/runtime_handoff.md).

**Shelved (HitM):** Tour / Joyride **copy does not yet go through i18n** — acceptable **only for this verification pass**; follow-up localization is a **next step** after HitM signs this pass. Record per [`governance/definition_of_done.md`](../../../governance/definition_of_done.md) §2.

## 1) Objective

Close gaps HitM reported after the first F-007 pass:

1. **Help / widget flow:** After focusing a widget in help mode, users still must press an extra control to open the step-by-step guide — reduce or remove that friction where consistent with a11y.
2. **Form guides:** Add real **step-by-step** Joyride (or agreed pattern) inside transaction / quick-add / bill modals, not only spotlight + manual start.
3. **Transaction calendar:** Add a dedicated **step-by-step** tour for the calendar surface (month grid / navigation), currently missing.

## 2) Scope

- **In scope:** `TourProvider.tsx`, transaction pages, calendar component(s), QuickActions / Upcoming modals as needed; no API contract change unless completion persistence requires it (unlikely). Declare **PWA class A or B** per [`governance/definition_of_done.md`](../../../governance/definition_of_done.md) in PR / handoff when behavior touches install/offline surfaces.
- **Out of scope:** New tour library; Settings global redesign; **full** PWA offline tour redesign (track under PWA sprint). **i18n for tour strings** — **shelved** until after this pass is verified (see above).

## 3) Automation protocol (this plan is the test)

Per `[governance/plan_template.md](../../../governance/plan_template.md)` §1a and `[governance/cursor_pa_slack_visibility.md](../../../governance/cursor_pa_slack_visibility.md)`:


| Tier | Executor may self-run                         | Evidence                                                                               |
| ---- | --------------------------------------------- | -------------------------------------------------------------------------------------- |
| V0   | Yes                                           | Plan / doc / code audit notes in slice file or `evidence/`                             |
| V1   | Yes                                           | `npm run build` log path under `evidence/`                                             |
| V2   | Reviewer or scripted                          | `scripts/sprint_verify.sh` log under `evidence/` (attach path in `runtime_handoff.md`) |
| V3   | HitM or browser-capable agent with screenshot | `evidence/T##.SL#_*.png` (or webp) + row in `runtime_handoff.md`                       |


**Executor must not** mark V2/V3 PASS without the matching artifact.

## 4) Tasks (execute in order)


| Task    | File                                                                                     | Summary                                                     |
| ------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| **T00** | [tasks/T00_protocol_and_acceptance.md](./tasks/T00_protocol_and_acceptance.md)           | V0 acceptance + dry-run `sprint_verify.sh`; evidence naming |
| **T01** | [tasks/T01_help_mode_single_action_flow.md](./tasks/T01_help_mode_single_action_flow.md) | Help-mode → guide without extra dismissible step            |
| **T02** | [tasks/T02_form_modal_step_by_step.md](./tasks/T02_form_modal_step_by_step.md)           | Step-by-step tours inside modals                            |
| **T03** | [tasks/T03_transaction_calendar_tour.md](./tasks/T03_transaction_calendar_tour.md)       | Calendar surface Joyride                                    |


### 4a) Slice catalog (subletting for V0–V3)

Each row is one **`T##.SL#`** checkpoint. Checklist detail and evidence filenames live in the linked task file. **Executor** may self-run **V0/V1** only; **V2/V3** require Reviewer or HitM per `governance/plan_template.md` D5.


| Slice   | Summary                                                | Tiers in slice | Evidence (required)                                        |
| ------- | ------------------------------------------------------ | -------------- | ---------------------------------------------------------- |
| T00.SL1 | Definition of done + parent BUG links                  | V0             | Task file + optional `evidence/` notes                     |
| T00.SL2 | `sprint_verify.sh --dry-run` → log                     | V1             | `evidence/T00.SL2_sprint_verify_dryrun.log`                |
| T01.SL1 | Audit help-mode → spotlight → Joyride state machine    | V0             | Task file                                                  |
| T01.SL2 | Implement streamlined start; web build                 | V1             | `evidence/T01.SL2_web_build.log`                           |
| T01.SL3 | Inactive-color `sprint_verify.sh` (non–dry-run)        | V2             | `evidence/sprint_verify_*.log`                             |
| T01.SL4 | Browser: help-mode → tour without extra step           | V3             | `evidence/T01.SL4_help_flow.png` (or `.webp`)              |
| T02.SL1 | Inventory modals + selector/timing risks               | V0             | Task file                                                  |
| T02.SL2 | Transaction / transfer modals: ≥2 Joyride steps each   | V1             | `evidence/T02.SL2_web_build.log`                           |
| T02.SL3 | Quick-add + bill + upcoming modals: ≥2 steps each      | V1             | `evidence/T02.SL3_web_build.log` (or reuse note → SL2 log) |
| T02.SL4 | `sprint_verify.sh` web on inactive color               | V2             | `evidence/sprint_verify_*.log`                             |
| T02.SL5 | Browser: screenshots per modal class                   | V3             | `evidence/T02.SL5_<modal>.png`                             |
| T03.SL1 | Calendar component tree + tour id vs `completed_tours` | V0             | Task file                                                  |
| T03.SL2 | Implement calendar tour + build                        | V1             | `evidence/T03.SL2_web_build.log`                           |
| T03.SL3 | `sprint_verify.sh` log                                 | V2             | `evidence/sprint_verify_*.log`                             |
| T03.SL4 | Browser: calendar tour screenshot                      | V3             | `evidence/T03.SL4_calendar_tour.png`                       |


**Slack intake:** [SLACK_SPRINT_QUEUE.md](./SLACK_SPRINT_QUEUE.md) — **`sprint-queue-v1`** per [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md): `@Cursor PA` line 1, **`Task Id:`** line 2 (exact label the runner parses); **`BRANCH:`** must end with **`(already checked out)`** or **`(checkout required)`**.

## 4b) Rollout phases by verification tier (V0–V3)

Use these as orchestration breakpoints; align evidence with §3 automation table.

### Phase — V0 (audit / spec lock)

- **Goal:** No code ambiguity: acceptance criteria written, flows inventoried, tour IDs and parent handoff links recorded.
- **Entry criteria:** Plan README + task files present.
- **Exit criteria:** T00.SL1, T01.SL1, T02.SL1, T03.SL1 checklists complete with PASS notes in task files or `evidence/`.
- **Breakpoints:** HitM may WAIVE non-blocking doc gaps with a one-line note in `runtime_handoff.md`.
- **Triggers:** Post T00.SL2 to queue only after T00.SL1 PASS.
- **Dependencies:** Parent F-007 `runtime_handoff.md` available for BUG row links.
- **Required implementation updates:** None (docs only).
- **Verification gate:** V0 checklist items checked with file paths cited.
- **Risks and mitigations:** Underspecified a11y → ask HitM before coding (plan_template clarifying questions).

### Phase — V1 (local build)

- **Goal:** Typecheck/build green after each implement slice.
- **Entry criteria:** V0 exit for the same task stream.
- **Exit criteria:** T00.SL2, T01.SL2, T02.SL2+SL3, T03.SL2 with `npm run build` logs in `evidence/` as specified in task files.
- **Breakpoints:** Build failure stops queue; fix or revert before next slice message.
- **Triggers:** Merge slice PRs to feature branch per branching guidelines.
- **Dependencies:** `finance_manager_web` only unless noted.
- **Required implementation updates:** `TourProvider.tsx`, modals, calendar per task files.
- **Verification gate:** Log path recorded in task evidence tables + `runtime_handoff.md` row.
- **Risks and mitigations:** Joyride mount races → document stable DOM hook strategy in PR.

### Phase — V2 (staging + sprint_verify)

- **Goal:** Inactive color deploy smokes clean for web.
- **Entry criteria:** V1 complete for that task’s implement slices.
- **Exit criteria:** T01.SL3, T02.SL4, T03.SL3 with `scripts/sprint_verify.sh` logs under `evidence/`; **Reviewer** (or scripted reviewer) attaches path in `runtime_handoff.md`.
- **Breakpoints:** Attach log filename in Slack thread when posting to `#review-queue` if used.
- **Triggers:** HitM or reviewer signs V2 before browser V3 work.
- **Dependencies:** VPS/jsdevtesting access; branch on inactive color.
- **Required implementation updates:** None beyond merged V1 code.
- **Verification gate:** `sprint_verify_*.log` present; D5 role separation enforced.
- **Risks and mitigations:** Flaky smoke → capture log excerpt + open row in `runtime_handoff.md`.

### Phase — V3 (browser / HitM)

- **Goal:** Human-visible tour behavior confirmed on `https://jsdevtesting.thehivemanager.com:8443` (or agreed host).
- **Entry criteria:** V2 PASS for the same task.
- **Exit criteria:** T01.SL4, T02.SL5, T03.SL4 screenshots in `evidence/` + `runtime_handoff.md` rows.
- **Breakpoints:** One screenshot set per task minimum for release batch signoff (per §3).
- **Triggers:** `#hitm-gate` when all T01–T03 V3 rows complete (see orchestration huddle doc).
- **Dependencies:** Browser-capable agent or HitM.
- **Required implementation updates:** None if V2 already green.
- **Verification gate:** PNG/WebP artifacts named per task evidence tables.
- **Risks and mitigations:** Auth/session → document test account or HitM-only capture in handoff.

## 5) Execution order

T00 (SL1→SL2) → T01 (SL1→SL4) → T02 (SL1→SL5) → T03 (SL1→SL4) — verify-first between slices inside each task file. Queue **one slice per Slack message** unless PA documents a batched exception.

## 6) Documentation

- `[finance_manager_web/CHANGELOG.md](../../../finance_manager_web/CHANGELOG.md)` when user-visible tour behavior ships.
- Update both `runtime_handoff.md` (this plan) and optionally the parent F-007 `runtime_handoff.md` pointer when slices close.

## 7) Completion

- All slices in T00–T03 PASS or WAIVE with HitM note.
- At least one full **V2** `sprint_verify_*.log` attached for a release batch and **V3** evidence for T01–T03 user-visible slices.

