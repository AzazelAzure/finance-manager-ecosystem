# Known Issues — Post-Beta Huddle

HitM-supplied list of user-facing issues from beta usage. Triaged using severity rubric from `design_docs/40_System_Design/15_Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md`:

- **S0**: production unusable, data integrity/security risk, urgent rollback/cutover decision
- **S1**: critical feature broken, high user impact, patch in same day
- **S2**: functional but degraded behavior, schedule in active beta backlog
- **S3**: minor UX/documentation/non-blocking enhancement

Note: HitM uses "user-facing issues" as the umbrella term; this list deliberately mixes bugs, design decisions, and feature gaps because all three present to the user as "something isn't right." Fix-process differs by category — see "Type" column.

---

## P0 — Distribution-blocking

### Issue 5 (S0): Email uniqueness not enforced in DB

- **Severity:** **S0**
- **Type:** bug — data integrity / security
- **Description:** Database `User` model enforces `username` uniqueness only, not `email`. Two accounts can be created with the same email address.
- **Discovered:** During HitM onboarding testing.
- **Surface:** `finance_manager_api/` — User model, signup serializer, possibly auth serializers.
- **Why this is the distribution-blocker:**
  - Inviting any second user is unsafe until fixed.
  - Password-reset flow keyed on email becomes ambiguous (which account?) — auth-collision / account-hijack risk.
  - Account-deletion flow (per `PLAN_API_Account_Deletion`) may not behave correctly with duplicate emails.
- **Existing branch/PR:** _(none known)_
- **Action items beyond the fix itself:**
  - Audit current `auth_user` table for duplicate emails before any new user is invited.
  - Confirm behavior of password-reset flow under duplicate-email conditions (probably broken or unsafe today).
  - Confirm whether email-based login is enabled (if yes, needs disambiguation logic; if no, just enforce uniqueness going forward).
- **Constraint on current beta:** No additional invitees until this is fixed.

### Issue 1 (S1): Upcoming expense edit for `is_recurring=true` does not work

- **Severity:** **S1**
- **Type:** bug
- **Description:** Editing an existing upcoming expense whose `is_recurring=true` flag fails. Either the edit form doesn't bind the field correctly or the save handler rejects the payload.
- **Surface:** `finance_manager_web/src/` upcoming-expenses edit modal + `finance_manager_api/` upcoming expenses serializer.
- **Note:** `finance_manager_web/CHANGELOG.md` shows a recent fix for `is_recurring` field mapping in the **list** view; the **edit** path likely has a parallel mismatch.
- **Why this matters for distribution:** Every user with a recurring bill will hit this the moment they need to edit it (changing amount, due date, etc.). Recurring bills are a primary use case for the persona.
- **Existing branch/PR:** _(none known)_

---

## P1 — Should fix before scaling beta

### Issue 7 (S1 or S2): Calendar daily active does not populate correctly

- **Severity:** **S1 if calendar is unusable for navigation; S2 if just visual markers wrong**
- **Type:** bug
- **Description:** Daily activity indicators on the calendar view do not populate correctly.
- **Likely root cause overlap with #4:** date-binding, timezone (UTC vs local), or aggregation-payload mismatch.
- **Surface:** `finance_manager_web/src/` calendar view + possibly `finance_manager_api/` aggregate endpoint.
- **Recommendation:** Investigate jointly with #4; one fix may resolve both.

### Issue 4 (S2): Heatmap days don't light up by spending intensity

- **Severity:** **S2**
- **Type:** bug
- **Description:** Calendar heatmap shipped but per-day intensity coloring isn't working — days don't visually encode spending magnitude.
- **Likely shared root cause with #7.**
- **Existing context:** BP7 polish list per `plans/feat/web-reflex-parity-sweep-1/runtime_handoff.md`.
- **User impact:** Users won't know heatmap is "supposed to" do this, but they'll perceive a visual feature that's flat and wonder why.

### Issue 6 (S2): Mobile dashboard quick buttons should be top-of-page

- **Severity:** **S2** (re-rated from initial S3 — wedge-relevant)
- **Type:** UX / layout — feature gap on mobile
- **Description:** On mobile viewport, dashboard quick-add buttons (`Add expense`, `Add income`, `Add transfer`) are not above the fold; users have to scroll past KPIs / charts to reach them.
- **Why S2 not S3:** PH-wedge persona is mobile-first, intermittent connectivity, often opening the app to log a quick expense at point-of-sale. Friction here is friction on the primary use case.
- **Note:** HitM deliberately deferred specific layout decision to feature-roadmap conversation post-Topic 4.

---

## P2 — Design decisions blocking implementation

### Issue 2 (S2): `+Bill` button needs rework

- **Severity:** **S2**
- **Type:** **design decision, not bug** (the implementation is currently disabled, not broken)
- **Description:** Dashboard `Quick add → +Bill` quick-action is disabled in production via VPS hotfix pending product decision on what bill-flow semantics should be.
- **Three candidate behaviors HitM has named:**
  - Create an upcoming expense
  - Record a pay-bill flow
  - A hybrid of the two
- **Surface (when re-enabled):** `finance_manager_web/src/components/dashboard/QuickActions.tsx`
- **Cross-reference:** Topic 9 (Drift cleanup) — the disable is a runtime hotfix not yet in git; needs retroactive commit even if final design isn't decided yet.
- **Note:** HitM confirmed this is **not** the critical distribution-blocker.

### Issue 3 (S2): Quick-add tx/income/transfer need full features (minus tx-type)

- **Severity:** **S2**
- **Type:** **feature gap, not bug** (incomplete implementation)
- **Description:** Dashboard quick-add flows (tx / income / transfer buttons) currently launch a partial editor. Tx-type is correctly pre-filled by which button was clicked, but other fields (description, category, source, tags, currency, date, etc.) need full feature parity with the regular add flow.
- **Workaround:** Use the full add transaction flow.
- **Surface:** `finance_manager_web/src/` quick-add flow components and underlying editor modal.
- **Note:** HitM deliberately deferred behavior decision to feature-roadmap conversation post-Topic 4.

---

## QoL items deliberately not on this list

HitM kept QoL items off this list pending the feature-roadmap conversation post-Topic 4. Confirmed (2026-04-30) that none of the QoL items currently masks a distribution-blocking issue, though some are a mixture of design features and changes that need deeper dive.

When the feature-roadmap conversation opens, those QoL items will be captured and triaged separately.

---

## Out-of-scope items (acknowledged but in other queues)

| Item | Where it lives |
|---|---|
| `+Bill` hotfix not in git | Topic 9 (Drift cleanup) — retroactive commit required regardless of design decision |
| Reflex zombie branch | Topic 2 (Reflex archival scope) |
| Strategic doc drift | Topic 9 (Drift cleanup) |
| Wedge / hero copy | Topic 7 (Wedge audit) — wedge IS in dashboard KPI top-level, only landing-hero placement is open |

---

## Summary triage

| Priority | Issue | Severity | Type |
|---|---|---|---|
| **P0** | #5 email uniqueness | **S0** | bug — distribution-blocker |
| **P0** | #1 recurring expense edit | S1 | bug |
| **P1** | #7 calendar daily active | S1/S2 | bug (likely shared root with #4) |
| **P1** | #4 heatmap intensity | S2 | bug (likely shared root with #7) |
| **P1** | #6 mobile quick buttons | S2 | UX gap (wedge-relevant) |
| **P2** | #2 +Bill rework | S2 | design decision pending product spec |
| **P2** | #3 quick-add fullness | S2 | feature gap; workaround exists |
