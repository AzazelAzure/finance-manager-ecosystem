# Product & feature backlog — consolidated index

**Created:** 2026-05-05  
**Updated:** 2026-05-21 (+F-012/F-013 infra intake + user activity logs; governed plans under `feat-f`* and `feat-infra-`*.)

**Purpose:** One entry point that ties together **brain-dump feature ideas**, **post-beta huddle (2026-04-30) planned product work**, **S1.B strategic workstreams**, **known issues with a feature shape**, and **pointers into design docs**. It does **not** replace detailed specs elsewhere; it dedupes and cross-references.

**Rich narrative ideas (keep editing there):** `[FEATURE_IDEAS.md](./FEATURE_IDEAS.md)` — **F-001**–**F-013**, plus **B-001**–**B-003** (sticky-note bugs).

**How to use:** When adding a new idea, give it an **F-** or **B-** id in `FEATURE_IDEAS.md` if it is product-sized, and add **one row** to the [Master crosswalk](#4-master-crosswalk) below (or extend a huddle/W3 row with that id).

---

## 1) Source documents (authority by topic)


| Source                              | Path                                                                                                                                                   | What it contains                                                                                      |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Feature ideas (brain dump)          | `[plans/cursor/FEATURE_IDEAS.md](./FEATURE_IDEAS.md)`                                                                                                  | **F-001–F-013** narratives; B-001–B-003 onboarding/upcoming bugs                                      |
| Post-beta huddle — issues           | `[plans/archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md](../archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md)`                                | Issues **#1–#8** triage (bugs, design, feature gaps)                                                  |
| Post-beta huddle — decisions        | `[plans/archived/post_beta_huddle_2026-04-30/DECISIONS.md](../archived/post_beta_huddle_2026-04-30/DECISIONS.md)`                                      | Locked decisions; **Topic 6 Q6.4** “worth paying for” candidate list; **Topic 9** drift/feature queue |
| Post-beta huddle — parking          | `[plans/archived/post_beta_huddle_2026-04-30/PARKING_LOT.md](../archived/post_beta_huddle_2026-04-30/PARKING_LOT.md)`                                  | **P-1–P-6** deferred strategic items (revenue, entity, US re-entry), not app feature backlog          |
| Post-beta huddle — topics           | `[plans/archived/post_beta_huddle_2026-04-30/TALKING_POINTS.md](../archived/post_beta_huddle_2026-04-30/TALKING_POINTS.md)`                            | Topic notes; roadmap / parity / QoL threads                                                           |
| S1 stage + workstreams              | `[plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md](../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md)` | **W1–W6**; S1.B exit criteria; **W3** lines up with huddle Group D                                    |
| S1.B stage dashboard                | `[plans/cursor/s1b/README.md](./s1b/README.md)`                                                                                                        | Sub-plans (PWA, drift, research, wedge audit, …)                                                      |
| Wedge audit template                | `[plans/cursor/s1b/wedge-consistency-audit/AUDIT_REPORT.md](./s1b/wedge-consistency-audit/AUDIT_REPORT.md)`                                            | Surface checklist vs canonical wedge sentence                                                         |
| Quick pay bill (+Bill)              | `[plans/cursor/s1b/quick-pay-bill-design/DESIGN_DECISION.md](./s1b/quick-pay-bill-design/DESIGN_DECISION.md)`                                          | Staged UX for **KNOWN_ISSUES #2**                                                                     |
| Design vault — vision               | `design_docs/01_Business_Vision.md`                                                                                                                    | Wedge, persona (SSoT for positioning)                                                                 |
| Design vault — current state        | `design_docs/10_Current_State/`                                                                                                                        | Alpha/beta overview, runtime checklist                                                                |
| Design vault — roadmap (historical) | `design_docs/20_Roadmap/`                                                                                                                              | **Historical** Phase 1/2; strategic plan is canonical per huddle Q1                                   |


---

## 2) Post-beta huddle — product / UX items (planned or gap-shaped)

Captured from `**KNOWN_ISSUES.md`**, `**DECISIONS.md` Topic 6–9**, and `**S1_public_beta_position.md` W3**.


| ID      | Item                                                      | Type               | Notes                                                                                                                                                                     | Spec / next doc                                                                                                  |
| ------- | --------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| H-ISS-2 | Dashboard **+Bill** → **Quick pay bill**                  | Design → implement | Transaction seeded from bill; v1 omit description/category/tags. **Staged.**                                                                                              | `[quick-pay-bill-design/DESIGN_DECISION.md](./s1b/quick-pay-bill-design/DESIGN_DECISION.md)`, `QuickActions.tsx` |
| H-ISS-3 | Quick-add **full parity** (expense / income / transfer)   | Feature gap        | Same fields as main tx editor except tx-type (button-chosen).                                                                                                             | **Completed** (2026-05); see `finance_manager_web/CHANGELOG.md`                                                  |
| H-ISS-6 | **Mobile:** quick actions **above** KPIs                  | UX / layout        | PH wedge; quick reach to add flows.                                                                                                                                       | **Completed** (2026-05); see `finance_manager_web/CHANGELOG.md`                                                  |
| H-W3-1  | **Landing polish** + wedge in **hero**                    | Marketing / UX     | Bundled larger splash; US-quality polish for PH. **Living:** hero/showcase must be **revisited as F-008+ ship** so bullets stay honest and wedge-aligned (see **F-011**). | W3; wedge audit report; `[FEATURE_IDEAS.md](./FEATURE_IDEAS.md)` **F-011**                                       |
| H-W3-2  | **“Worth paying for”** Pro tier feature mix               | Epic               | Not a single ticket — see §3 candidate list.                                                                                                                              | S1.B exit; `validation_gates.md`                                                                                 |
| H-W4    | Time-clock agent, huddle skill, hotfix follow-up workflow | Tooling            | Not user-facing PFM features.                                                                                                                                             | W4 in S1 doc                                                                                                     |


**Huddle bugs (fix-shaped, not new features):** **#1** recurring upcoming edit, **#4** heatmap intensity, **#5** email uniqueness (S0), **#7** calendar daily active, **#8** source balance on delete — track in `**KNOWN_ISSUES.md`** and changelogs; optional B-ids already overlap **B-003** (rollover) style issues in `FEATURE_IDEAS.md`.

---

## 3) S1.B “worth paying for” candidates (Topic 6 Q6.4)

Verbatim candidate list from `**DECISIONS.md`** (Topic 6). “Final list is Topic 11” — this index maps each to the **closest** `FEATURE_IDEAS.md` id.


| Candidate (huddle)              | `FEATURE_IDEAS.md` id                    | Relationship / meaning                                                                                                                                                                            |
| ------------------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AI safe-to-spend forecasting    | **F-003**, **F-004**                     | Projection + pay-cycle STS evolution                                                                                                                                                              |
| Automatic GCash/Maya parsing    | **TBD** (suggest **F-012** when drafted) | Ingestion / parser; PH wedge                                                                                                                                                                      |
| Family ledger                   | **F-008**                                | Household / multi-person; full narrative in FEATURE_IDEAS                                                                                                                                         |
| Bill payment reminders          | **TBD**                                  | Notifications / calendar on top of upcoming                                                                                                                                                       |
| Recurring expense automation    | **F-009**                                | **Means:** less manual admin **around** existing recurring upcoming rows (rollover, paid+link, templates/suggestions, later rules/batch) — **not** “we need recurring bills” alone. See **F-009** |
| Historical pattern analysis     | **F-002**, **F-003**                     | Tags + projections                                                                                                                                                                                |
| Export / sharing                | **F-010**                                | Portability + share surfaces; **necessary alongside PWA**; PWA code merged — **owner manual / D4-exec** still gates “done” per research README                                                    |
| OFW-tax-relevant categorization | **TBD**                                  | Tax / category templates (PH persona)                                                                                                                                                             |


---

## 4) Master crosswalk

Governed **draft** plans: `plans/cursor/s1b/feat-f`* + `feat-infra-`* (see `[FEATURE_IDEAS.md](./FEATURE_IDEAS.md)` table); registry `[../../governance/plan_registry.md](../../governance/plan_registry.md)`.


| Theme                                    | F-id / B-id                            | Execution plan `README`                                                                                        | Huddle / W3                                                 | Status (high level)                                                         |
| ---------------------------------------- | -------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------- |
| Balance history & trends                 | **F-001**                              | `[s1b/feat-f001-balance-history/README.md](./s1b/feat-f001-balance-history/README.md)`                         | W3 / worth paying                                           | Draft plan; not started                                                     |
| Smart tag value estimation               | **F-002**                              | `[s1b/feat-f002-smart-tag-estimation/README.md](./s1b/feat-f002-smart-tag-estimation/README.md)`               | Historical pattern analysis                                 | Draft plan; `finance_manager_rust_tools` stub                               |
| Predictive budgeting & projections       | **F-003**                              | `[s1b/feat-f003-predictive-budgeting/README.md](./s1b/feat-f003-predictive-budgeting/README.md)`               | AI STS forecasting; W3                                      | Draft plan                                                                  |
| Configurable STS periods & bill juggling | **F-004**                              | `[s1b/feat-f004-sts-pay-cycles-bill-realism/README.md](./s1b/feat-f004-sts-pay-cycles-bill-realism/README.md)` | AI STS; partial pay (Quick pay v1 defers mark-paid linkage) | Draft plan (**P1**); expansion annex in README                              |
| Savings goals                            | **F-005**                              | `[s1b/feat-f005-savings-goals/README.md](./s1b/feat-f005-savings-goals/README.md)`                             | Worth paying candidate pool                                 | Draft plan                                                                  |
| Customizable dashboard widgets           | **F-006**                              | `[s1b/feat-f006-dashboard-widgets-custom/README.md](./s1b/feat-f006-dashboard-widgets-custom/README.md)`       | W3 polish                                                   | Draft plan                                                                  |
| Guided walkthroughs (not one popup)      | **F-007**                              | `[s1b/feat-f007-guided-walkthroughs/README.md](./s1b/feat-f007-guided-walkthroughs/README.md)`                 | Onboarding / education                                      | Draft plan                                                                  |
| Family ledger (household)                | **F-008**                              | `[s1b/feat-f008-family-ledger/README.md](./s1b/feat-f008-family-ledger/README.md)`                             | Topic 6 Q6.4                                                | Draft plan                                                                  |
| Recurring expense automation             | **F-009**                              | `[s1b/feat-f009-recurring-auto-deduct/README.md](./s1b/feat-f009-recurring-auto-deduct/README.md)`             | Topic 6 Q6.4                                                | Draft plan; source → **auto_deduct** funnel                                 |
| Export & sharing                         | **F-010**                              | `[s1b/feat-f010-export-sharing/README.md](./s1b/feat-f010-export-sharing/README.md)`                           | PWA + trust                                                 | Draft plan (**P1**); with PWA exit / verification                           |
| Wedge-aligned landing & hero             | **F-011**                              | `[s1b/feat-f011-wedge-landing-hero/README.md](./s1b/feat-f011-wedge-landing-hero/README.md)`                   | **H-W3-1**                                                  | **Living draft** — refresh when material features ship                      |
| Bug reports & feature requests (intake)  | **F-012**                              | `[s1b/feat-infra-support-intake/README.md](./s1b/feat-infra-support-intake/README.md)`                         | Infra / support product                                     | Draft plan                                                                  |
| Per-user activity & diagnostic logs      | **F-013**                              | `[s1b/feat-infra-user-activity-logs/README.md](./s1b/feat-infra-user-activity-logs/README.md)`                 | Infra / trust + PWA debug                                   | Draft plan                                                                  |
| Cash / source currency onboarding        | **B-001**, **B-002**                   | —                                                                                                              | QoL / bugs                                                  | Triaged in FEATURE_IDEAS                                                    |
| Upcoming rollover when paid untagged     | **B-003**                              | —                                                                                                              | Bug                                                         | Triaged in FEATURE_IDEAS                                                    |
| Quick pay bill (+Bill)                   | *(optional F-012 or keep design-only)* | `[s1b/quick-pay-bill-design/DESIGN_DECISION.md](./s1b/quick-pay-bill-design/DESIGN_DECISION.md)`               | **H-ISS-2**, KNOWN_ISSUES #2                                | **Design staged**                                                           |
| Quick-add full editor                    | **F-007** adjacency                    | —                                                                                                              | **H-ISS-3**, #3                                             | **Shipped** (2026-05)                                                       |
| Mobile quick actions layout              |                                        | —                                                                                                              | **H-ISS-6**, #6                                             | **Shipped** (2026-05)                                                       |
| PWA install / offline / outbox           |                                        | `pwa-implementation-branch`                                                                                    | S1.B exit                                                   | **Merged in repo**; **manual / D4-exec verification** outstanding per owner |
| Android pull-forward                     |                                        | —                                                                                                              | **W6**                                                      | Scaffold → Alpha in S1.B                                                    |
| Founding member + pricing + legal        |                                        | —                                                                                                              | **W5**                                                      | S1.C prep, not same as “PFM feature list”                                   |


---

## 5) Gaps — still not in `FEATURE_IDEAS.md` as full F-* narratives

Promote to **F-014+** in `[FEATURE_IDEAS.md](./FEATURE_IDEAS.md)` when you want the same long-form treatment as F-001–F-013:

- GCash/Maya **SMS or statement parsing** (Topic 6 candidate).
- **Bill payment reminders** (notifications / calendar).
- **OFW / tax-aware categorization** presets.

*(Family ledger, recurring automation meaning, export/sharing, living landing/hero **F-008–F-011**; support intake + user activity logs **F-012–F-013**.)*

---

## 6) Parking lot vs product backlog

`**[PARKING_LOT.md](../archived/post_beta_huddle_2026-04-30/PARKING_LOT.md)`** items (**P-1–P-6**) are **strategic / business** deferrals (partnerships, dual entity, US re-entry, ads rejected, curated revenue). They are **out of scope** for this product-feature index unless a line item explicitly becomes an app feature (e.g. P-1 partnership might later imply in-app surfaces).

---

## 7) Maintenance

- **Owner:** HitM + agents during roadmap passes.  
- **Cadence:** After each huddle or quarterly planning, scan §2–§5 and update crosswalk + `FEATURE_IDEAS.md` ids.  
- **Do not** duplicate full issue write-ups here — link to `**KNOWN_ISSUES.md`** for severity and acceptance.