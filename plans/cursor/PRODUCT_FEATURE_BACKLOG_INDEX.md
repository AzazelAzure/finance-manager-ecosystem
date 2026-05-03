# Product & feature backlog — consolidated index

**Created:** 2026-05-05  
**Purpose:** One entry point that ties together **brain-dump feature ideas**, **post-beta huddle (2026-04-30) planned product work**, **S1.B strategic workstreams**, **known issues with a feature shape**, and **pointers into design docs**. It does **not** replace detailed specs elsewhere; it dedupes and cross-references.

**Rich narrative ideas (keep editing there):** [`FEATURE_IDEAS.md`](./FEATURE_IDEAS.md) — **F-001** … **F-007**, plus **B-001** … **B-003** (sticky-note bugs).

**How to use:** When adding a new idea, give it an **F-** or **B-** id in `FEATURE_IDEAS.md` if it is product-sized, and add **one row** to the [Master crosswalk](#4-master-crosswalk) below (or extend a huddle/W3 row with that id).

---

## 1) Source documents (authority by topic)

| Source | Path | What it contains |
| ------ | ---- | ---------------- |
| Feature ideas (brain dump) | [`plans/cursor/FEATURE_IDEAS.md`](./FEATURE_IDEAS.md) | F-001–F-007 narratives; B-001–B-003 onboarding/upcoming bugs |
| Post-beta huddle — issues | [`plans/archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md`](../archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md) | Issues **#1–#8** triage (bugs, design, feature gaps) |
| Post-beta huddle — decisions | [`plans/archived/post_beta_huddle_2026-04-30/DECISIONS.md`](../archived/post_beta_huddle_2026-04-30/DECISIONS.md) | Locked decisions; **Topic 6 Q6.4** “worth paying for” candidate list; **Topic 9** drift/feature queue |
| Post-beta huddle — parking | [`plans/archived/post_beta_huddle_2026-04-30/PARKING_LOT.md`](../archived/post_beta_huddle_2026-04-30/PARKING_LOT.md) | **P-1–P-6** deferred strategic items (revenue, entity, US re-entry), not app feature backlog |
| Post-beta huddle — topics | [`plans/archived/post_beta_huddle_2026-04-30/TALKING_POINTS.md`](../archived/post_beta_huddle_2026-04-30/TALKING_POINTS.md) | Topic notes; roadmap / parity / QoL threads |
| S1 stage + workstreams | [`plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`](../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md) | **W1–W6**; S1.B exit criteria; **W3** lines up with huddle Group D |
| S1.B stage dashboard | [`plans/cursor/s1b/README.md`](./s1b/README.md) | Sub-plans (PWA, drift, research, wedge audit, …) |
| Wedge audit template | [`plans/cursor/s1b/wedge-consistency-audit/AUDIT_REPORT.md`](./s1b/wedge-consistency-audit/AUDIT_REPORT.md) | Surface checklist vs canonical wedge sentence |
| Quick pay bill (+Bill) | [`plans/cursor/s1b/quick-pay-bill-design/DESIGN_DECISION.md`](./s1b/quick-pay-bill-design/DESIGN_DECISION.md) | Staged UX for **KNOWN_ISSUES #2** |
| Design vault — vision | `design_docs/01_Business_Vision.md` | Wedge, persona (SSoT for positioning) |
| Design vault — current state | `design_docs/10_Current_State/` | Alpha/beta overview, runtime checklist |
| Design vault — roadmap (historical) | `design_docs/20_Roadmap/` | **Historical** Phase 1/2; strategic plan is canonical per huddle Q1 |

---

## 2) Post-beta huddle — product / UX items (planned or gap-shaped)

Captured from **`KNOWN_ISSUES.md`**, **`DECISIONS.md` Topic 6–9**, and **`S1_public_beta_position.md` W3**.

| ID | Item | Type | Notes | Spec / next doc |
| -- | ---- | ---- | ----- | ---------------- |
| H-ISS-2 | Dashboard **+Bill** → **Quick pay bill** | Design → implement | Transaction seeded from bill; v1 omit description/category/tags. **Staged.** | [`quick-pay-bill-design/DESIGN_DECISION.md`](./s1b/quick-pay-bill-design/DESIGN_DECISION.md), `QuickActions.tsx` |
| H-ISS-3 | Quick-add **full parity** (expense / income / transfer) | Feature gap | Same fields as main tx editor except tx-type (button-chosen). | Extend F-007 / new F-* when drafted |
| H-ISS-6 | **Mobile:** quick actions **above** KPIs | UX / layout | PH wedge; quick reach to add flows. | Dashboard layout task |
| H-W3-1 | **Landing polish** + wedge in **hero** | Marketing / UX | Bundled larger splash; US-quality polish for PH. | W3; wedge audit report |
| H-W3-2 | **“Worth paying for”** Pro tier feature mix | Epic | Not a single ticket — see §3 candidate list. | S1.B exit; `validation_gates.md` |
| H-W4 | Time-clock agent, huddle skill, hotfix follow-up workflow | Tooling | Not user-facing PFM features. | W4 in S1 doc |

**Huddle bugs (fix-shaped, not new features):** **#1** recurring upcoming edit, **#4** heatmap intensity, **#5** email uniqueness (S0), **#7** calendar daily active, **#8** source balance on delete — track in **`KNOWN_ISSUES.md`** and changelogs; optional B-ids already overlap **B-003** (rollover) style issues in `FEATURE_IDEAS.md`.

---

## 3) S1.B “worth paying for” candidates (Topic 6 Q6.4)

Verbatim candidate list from **`DECISIONS.md`** (Topic 6). “Final list is Topic 11” — this index maps each to the **closest** existing F-id or leaves **TBD** for a future F-id.

| Candidate (huddle) | Nearest `FEATURE_IDEAS.md` id | Relationship |
| ------------------ | ----------------------------- | ------------ |
| AI safe-to-spend forecasting | **F-003**, **F-004** | Projection + pay-cycle STS evolution |
| Automatic GCash/Maya parsing | **TBD** (new F-* suggested) | Ingestion / parser feature; ties wedge PH |
| Family ledger | **TBD** | Multi-user / household — not in F-001–007 yet |
| Bill payment reminders | **TBD** | Adjacent upcoming expenses + notifications |
| Recurring expense automation | **TBD** | Automation on top of upcoming/recurring model |
| Historical pattern analysis | **F-002**, **F-003** | Tags + projections |
| Export / sharing | **TBD** | Data hub / compliance / social |
| OFW-tax-relevant categorization | **TBD** | Tax / category templates (PH persona) |

---

## 4) Master crosswalk

Rows combine **feature-idea ids**, **huddle refs**, and **notes**.

| Theme | F-id / B-id | Huddle / W3 | Status (high level) |
| ----- | ----------- | ----------- | --------------------- |
| Balance history & trends | **F-001** | W3 / worth paying | Idea only |
| Smart tag value estimation | **F-002** | Historical pattern analysis | Idea only; `finance_manager_rust_tools` stub |
| Predictive budgeting & projections | **F-003** | AI STS forecasting; W3 | Idea only |
| Configurable STS periods & bill juggling | **F-004** | AI STS; partial pay (Quick pay v1 defers mark-paid linkage) | Idea only |
| Savings goals | **F-005** | Worth paying candidate pool | Idea only |
| Customizable dashboard widgets | **F-006** | W3 polish | Idea only |
| Guided walkthroughs (not one popup) | **F-007** | Onboarding / education | Idea only |
| Cash / source currency onboarding | **B-001**, **B-002** | QoL / bugs | Triaged in FEATURE_IDEAS |
| Upcoming rollover when paid untagged | **B-003** | Bug | Triaged in FEATURE_IDEAS |
| Quick pay bill (+Bill) | *(add F-008 in FEATURE_IDEAS when desired)* | **H-ISS-2**, KNOWN_ISSUES #2 | **Design staged** |
| Quick-add full editor | | **H-ISS-3**, #3 | Gap; deferred post-huddle |
| Mobile quick actions layout | | **H-ISS-6**, #6 | Gap; deferred |
| Landing + hero wedge | | **H-W3-1**, Topic 7 | Queued W3 |
| PWA install / offline / outbox | | S1.B exit; `pwa-implementation-branch` | **Sprint / merged** (coordinate with agents) |
| Android pull-forward | | **W6** | Scaffold → Alpha in S1.B |
| Founding member + pricing + legal | | **W5** | S1.C prep, not same as “PFM feature list” |

---

## 5) Gaps — in huddle or strategy, not yet in `FEATURE_IDEAS.md`

Consider promoting these to **F-008+** in [`FEATURE_IDEAS.md`](./FEATURE_IDEAS.md) when you want narrative + rough notes in one style:

- GCash/Maya **SMS or statement parsing** (Topic 6 candidate).
- **Family ledger** (multi-user household view).
- **Bill payment reminders** (notifications / calendar).
- **Recurring expense automation** (rules beyond manual upcoming).
- **Export / sharing** (CSV, PDF, share sheet).
- **OFW / tax-aware categorization** presets.

---

## 6) Parking lot vs product backlog

**[`PARKING_LOT.md`](../archived/post_beta_huddle_2026-04-30/PARKING_LOT.md)** items (**P-1–P-6**) are **strategic / business** deferrals (partnerships, dual entity, US re-entry, ads rejected, curated revenue). They are **out of scope** for this product-feature index unless a line item explicitly becomes an app feature (e.g. P-1 partnership might later imply in-app surfaces).

---

## 7) Maintenance

- **Owner:** HitM + agents during roadmap passes.  
- **Cadence:** After each huddle or quarterly planning, scan §2–§5 and update crosswalk + `FEATURE_IDEAS.md` ids.  
- **Do not** duplicate full issue write-ups here — link to **`KNOWN_ISSUES.md`** for severity and acceptance.
