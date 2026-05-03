# US LLC — registration requirements and tax pathways (research)

**Status:** Research stub — **not** legal or tax advice. **HitM + qualified US / PH advisors** own conclusions.

**Pipeline context:** This file supports the **locked** pattern in [README.md](./README.md) **§0.2** (PH spouse-led merchant of record + **HitM US LLC** as contracted technical/IP vendor). It does **not** re-open L2–L4; it fills **operational and tax detail** before production PSP onboarding.

---

## 1) Sequencing (what this blocks)

| Workstream | Blocked by completing this research? |
| ---------- | ------------------------------------ |
| **PWA implementation** (S1.B Group D) | **No** — ship PWA per [`../pwa-install-offline-sync-research/README.md`](../pwa-install-offline-sync-research/README.md). |
| **PSP integration / production billing** | **Effectively yes** — KYB, settlement name, and intercompany reality must align with counsel-approved US + PH setup. |
| **HitM-only locks** in [DECISION_MATRIX.md](./DECISION_MATRIX.md) (e.g. L1, vehicle fine print) | Only after evidence / advisor memos — **never** from external tools alone. |

---

## 2) Pathway decision matrix (fill as you research)

**Instructions:** Add rows or split columns as needed. Keep **primary sources + access date** in footnotes or a “Sources” section per row. Use **`TBD`**, **`Open`**, **`Counsel`**, **`Confirmed (advisor)`** — not **`LOCKED`** (that word is reserved for HitM signoff in `DECISION_MATRIX.md`).

| # | Topic | Path / option A | Path / option B | PH link (if any) | Owner | Status |
| - | ----- | --------------- | --------------- | ---------------- | ----- | ------ |
| P1 | **US state of formation** | e.g. WY / DE / home state — why | | N/A | HitM + US advisor | `Open` |
| P2 | **LLC tax classification** | Default disregarded vs **elect** S-corp / C-corp (if ever) | | Flows to intercompany + personal comp | US CPA / attorney | `Open` |
| P3 | **Formation checklist** | Articles / COI, OA, RA, EIN, bank KYC | | | HitM | `Open` |
| P4 | **Operating agreement** | IP / software license + **services** scope vs PH entity needs | | Must pair with PH counsel draft B2B terms | Counsel | `Open` |
| P5 | **US reporting** | Federal + state annual / franchise | | | US CPA | `Open` |
| P6 | **PH → US payments** | Fee type (royalty vs services), **arm’s-length** method, invoicing | | BIR / withholding questions | PH + US advisors | `Open` |
| P7 | **Founder economics** | How HitM (individual) is paid by US LLC vs PH entity — **no chat percentages as tax positions** | | Residency / FEIE interaction | US CPA | `Open` |
| P8 | **PE / nexus** | Does US LLC + PH customers create **permanent establishment** or similar exposure at low revenue? | | | US + PH tax | `Open` |
| P9 | **PSP alignment** | US LLC **not** PH PSP merchant; confirm no accidental KYB under wrong name | | [../payment-provider-research/README.md](../payment-provider-research/README.md) §0.6 | Joint with payment plan | `Open` |

---

## 3) Gemini / external assistant protocol

1. Read [`../GEMINI_RESEARCH_README.md`](../GEMINI_RESEARCH_README.md) first.
2. Output **question lists**, **checklists**, and **citations** — not final entity elections or fee splits.
3. Paste summaries into new dated subsections **below** (§4) or attach memos by reference (filename + date); Cursor agents normalize into matrices / `DECISION_MATRIX` **only** after HitM review.

---

## 4) Research log (dated drops)

*(Append Gemini or advisor notes here — newest first.)*

| Date | Source | Summary |
| ---- | ------ | ------- |
| | | |

---

## 5) Handoff when “ready to implement”

- Update [DECISION_MATRIX.md](./DECISION_MATRIX.md) **Matrix 3** (US LLC row: state, RA, classification **if** HitM locks).
- Refresh [US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md) with **costs + compliance** grounded in chosen state.
- Mirror any **economic** lock into [`../../../../strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`](../../../../strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) §5 **only** with advisor-backed wording + HitM signoff.
- **`CHANGELOG.md`** (parent) if the batch is CPPRD-worthy.

---

*Last updated: 2026-05-04 — created as execution-pause scratchpad; entity hub README §0.4.*
