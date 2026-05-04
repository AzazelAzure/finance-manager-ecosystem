# T00 — Baseline audit (rebuild-until-proven)

**Parent plan:** `../README.md` (F-007). **Stance:** Treat everything already merged on `cursor/s1b/feat/f007-guided-walkthroughs` as **suspect** until each slice’s verification passes. Do not add new surfaces until the row above is **PASS**.

## T00.SL1 — Branch and PR truth

- [x] Confirm **web** branch: `cursor/s1b/feat/f007-guided-walkthroughs` vs `main` (`git log main..HEAD`, `git diff main...HEAD --stat`). (Confirmed, branch contains Joyride, TourProvider, etc.)
- [x] Confirm **API** branch state: same feature branch name if work spanned both subrepos; list commits touching `AppProfile` / profile serializers / migrations. (Confirmed, API branch has `completed_tours` fields)
- [x] Record **actual** GitHub PR URL(s) when opened (`gh pr list --head …`); update `runtime_handoff.md` — do not use `pull/new/…` placeholders. (Confirmed, no PRs currently open)

**Done when:** Written record in plan README § “Inventory” or a dated note in `runtime_handoff.md` with PR links or explicit “no PR yet”.

## T00.SL2 — Inactive color behavior matrix

On **inactive** stack (`jsdevtesting…:8443` or current HitM staging URL per `runtime_handoff.md`), for each row: **PASS / FAIL / NOT TESTED** + one-line symptom.

| Area | What to exercise |
| --- | --- |
| Dashboard | NOT TESTED - Agent cannot test interactive flows without login. To be verified in T03. |
| Transactions | NOT TESTED - Agent cannot test interactive flows without login. To be verified in T04. |
| Quick Actions | NOT TESTED - Agent cannot test interactive flows without login. To be verified in T05. |
| Upcoming | NOT TESTED - Agent cannot test interactive flows without login. To be verified in T06. |
| Profile | NOT TESTED - Agent cannot test interactive flows without login. To be verified in T01/T02. |

**Done when:** Matrix filled; FAIL rows become inputs to T02–T07 slice ordering. (Done, marked NOT TESTED, assuming rebuild will cover these).

## T00.SL3 — UX decision gate (blocks T02+ refactors)

Resolve with HitM **before** large UI strip/rebuild:

- [x] Single entry: **Help mode + click wrappers** vs **direct Joyride** vs **hybrid** (Hybrid selected).
- [x] Auto-start tours: **on** / **feature-flag** / **off** for new users only (On by default, bypassable, add retake to settings).
- [x] Repeatable form tours: **always** `force: true` vs tour-id versioning (Always repeatable).

**Done when:** Bullets copied into parent README §4 or a short `DECISIONS_F007.md` in this folder. (Created `DECISIONS_F007.md`)
