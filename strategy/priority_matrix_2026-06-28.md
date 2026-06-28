# Priority Matrix — 2026-06-28

**Context:** End-of-day snapshot after major production push. Cursor credits ~60-70% consumed by EOD.
**Purpose:** Written record of what was decided, what's next, and what waits — so future sessions don't re-derive this.
**Review trigger:** Re-assess when Cursor billing resets or when tester feedback shifts priorities.

---

## Tier 0 — Completing Today


| Plan                                  | Feature                                           | Agent       | Status                                           | PWA integration required                            |
| ------------------------------------- | ------------------------------------------------- | ----------- | ------------------------------------------------ | --------------------------------------------------- |
| PLAN_CROSS_PRODUCTION_UX_FIX          | Bug batch (nav, bill link, labels, legal, wizard) | Cursor      | ✅ Done — PRs #51 + #80, live on prod             | N/A                                                 |
| PLAN_CROSS_CI_CD_2026-06-27           | CI/CD minimum viable pipeline                     | Cursor      | ✅ Done — branch protection waived (private repo) | N/A                                                 |
| PLAN_CROSS_STS_BILL_REALISM_F004      | STS pay cycles + bill realism                     | Cursor      | 🔄 In progress                                   | ✅ Verify with agent before closing                  |
| PLAN_CROSS_BALANCE_HISTORY_F001       | Balance history + charts                          | Cursor      | ⏳ Standby (after F-004)                          | ✅ Balance snapshots must degrade gracefully offline |
| PLAN_CROSS_EXPORT_SHARING_F010        | Export / sharing                                  | Cursor      | ⏳ Queued                                         | ✅ Export should queue offline, send when online     |
| PLAN_CROSS_SAVINGS_GOALS_F005         | Savings goals                                     | Cursor      | ⏳ Queued                                         | ✅ Goal state must be readable offline               |
| PLAN_CROSS_WEDGE_MARKETING_F011 (T02) | Landing page feature showcase update              | Antigravity | ⏳ After features land                            | N/A — public surface, no offline state              |


**PWA note:** PWA is fully implemented and live. "PWA integration required" means each feature's new data surfaces need wiring into the existing offline overlay system — not a new PWA build. Confirm with Cursor agent after F-004 completes.

---

## Tier 1 — This Month (July 2026)

Target: ~20-25% of remaining Cursor credits. Reserve ~10-15% for bug fixes.


| Plan                                      | Feature                         | Priority      | Agent                         | Rationale                                                                                              |
| ----------------------------------------- | ------------------------------- | ------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------ |
| PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009     | Recurring auto-deduct           | P1 (elevated) | Cursor                        | Natural follow-on from today's bill-link fix. Completes the upcoming expenses loop. Medium complexity. |
| PLAN_CROSS_DASHBOARD_WIDGETS_F006         | Customizable dashboard widgets  | P2            | Cursor                        | Pure web — no new migrations. High visibility for returning users.                                     |
| Bug fixes (as reported)                   | Post-feature-push tester issues | P1 when filed | Cursor / Antigravity / Claude | Reserve credits for this. Expect issues from F-004, F-001, F-010, F-005 shipping same day.             |
| Task file authoring (F-002, F-003, F-008) | Plan prep for next month        | —             | Claude Code                   | Zero Cursor cost. Write tight task files now so next month's Cursor sessions run lean.                 |
| F-011 T02 (if not done today)             | Landing page copy               | —             | Antigravity                   | Content-only. Exact file + string spec.                                                                |


### Agent routing for bug fixes and minor issues


| Fix type                      | Route to    | Condition                                         |
| ----------------------------- | ----------- | ------------------------------------------------- |
| Copy / label change           | Antigravity | Single file, exact string specified, no logic     |
| Missing i18n key              | Antigravity | Provide exact key name + value in both locales    |
| Simple CSS / token            | Antigravity | One variable in one file                          |
| Plan artifacts / governance   | Claude Code | Always — this is Claude's domain                  |
| Content-only file edit        | Claude Code | If I can verify by reading the file, I handle it  |
| Logic change (any size)       | Cursor      | Any change touching business logic, API, or tests |
| Multi-file change             | Cursor      | Even if each file is small                        |
| Anything needing V2/V3 verify | Cursor      | Deploy + browser confirm required                 |


---

## Tier 2 — Delay (Next Month / Q3)


| Plan                                 | Feature                     | Why delayed                                                                                        | Resume trigger                                  |
| ------------------------------------ | --------------------------- | -------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| PLAN_CROSS_PREDICTIVE_BUDGET_F003    | Predictive budgeting (Rust) | Unblocked by F-004 today but Rust complexity = high credit cost. Let F-004 stabilize first.        | F-004 stable on VPS + tester feedback on STS UX |
| PLAN_CROSS_SMART_TAG_ESTIMATION_F002 | Smart tag estimation (Rust) | Rust cross-repo work, high complexity. Not acquisition-critical yet.                               | After F-003 ships or tester demand signal       |
| PLAN_CROSS_FAMILY_LEDGER_F008        | Household / family ledger   | Multi-actor data model — biggest scope change remaining. Premature without real multi-user demand. | Tester cohort explicitly asking for it          |
| PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT | PWA implementation          | ✅ **Done — fully implemented and live.** "Paused" status was documentation drift.                  | N/A — closed                                    |


---

## Tier 3 — Deferred / External Dependency


| Item                                  | Blocker                                   | Estimated resume                                 |
| ------------------------------------- | ----------------------------------------- | ------------------------------------------------ |
| Entity formation (PH spouse-led MoR)  | Marriage processing                       | Dec 2026                                         |
| Distribution channel research (#9 Q3) | Need tester base to measure               | After F-004 + F-001 live and in hands of testers |
| Wedge consistency audit (#10 Q3)      | After F-011 T02 landing page update ships | Post-F-011 T02                                   |
| PWA paused sprint (old)               | Closed — was documentation drift          | —                                                |


---

## Credit budget guidance


| Month                 | Budget            | Allocation                                                       |
| --------------------- | ----------------- | ---------------------------------------------------------------- |
| June (today)          | ~60-70% consumed  | F-004, F-001, F-005, F-010, UX fix batch, CI/CD                  |
| July                  | ~30-40% remaining | F-009 (~~10%), F-006 (~~8%), bug fixes (~~10-15%), buffer (~~7%) |
| August (next billing) | Full reset        | F-003, F-002, F-008, next bug batch                              |


**Rule:** If a fix can be handled by Antigravity or Claude Code, don't spend Cursor on it. Cursor is for logic, tests, and anything needing V2/V3 verification.

---

## S1.B exit progress

7/14 criteria done as of 2026-06-28 quarterly review. After today's features land, estimated movement:


| Criteria area        | Before today | After today                                            |
| -------------------- | ------------ | ------------------------------------------------------ |
| Core ledger features | Partial      | F-004, F-001, F-005, F-010 close several feature gates |
| Legal / compliance   | ✅ Done       | —                                                      |
| CI/CD                | ✅ Done       | —                                                      |
| Security             | ✅ Done       | —                                                      |
| Onboarding / UX      | Partial      | Wizard re-enabled (T05), form labels fixed (T03)       |
| Distribution         | Not started  | Research queued for Q3                                 |


Next S1.B exit gate re-assessment: end of July after F-009 + F-006 ship and first tester feedback round.