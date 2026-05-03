# S1.B external research protocol (Gemini / Antigravity / parallel assistants)

**Purpose:** When HitM uses **Gemini**, **Antigravity**, or other external research tools for **Stage S1.B** work, this file is the **first read** so outputs land in the **right folders**, use **correct vocabulary**, and never **fake** product decisions.

**Workspace root:** `finance_manager` (parent). **Plans live here only** — the dev VPS does **not** mirror `plans/`; do not assume deploy paths for research-only edits.

---

## 1) Authority stack (read order)

1. [`../../AGENTS.md`](../../AGENTS.md) — operating constraints, CPPRD, sub-repo map, PWA locks (when relevant).
2. [`../_governance/glossary.md`](../_governance/glossary.md) — canonical terms (HitM, MoR, gates, etc.).
3. **Active sub-plan README** in `plans/cursor/s1b/<sub-plan>/README.md` — scope, objectives, and **what is already locked**.
4. This file — **how** to write research so Cursor agents can normalize and CPPRD.

**Strategic mirrors:** When entity or payment **pipeline** changes, [`../strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`](../strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) may need a short cross-reference (see §5.0 for operating entity pipeline). Do not duplicate long legal analysis there unless HitM asks.

---

## 2) Folder boundaries — S1.B sub-plans

| Sub-plan folder | Topic | Do **not** |
| ---------------- | ----- | ---------- |
| [`entity-formation-research/`](./entity-formation-research/) | PH/US entity, Anti-Dummy, spouse involvement, KYB shape; **US LLC registration/tax prep** → [`entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md`](./entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md) §4 log | Invent **HitM locks** in `DECISION_MATRIX.md` — only **Patrick (HitM)** fills HitM lock rows after counsel review. |
| [`payment-provider-research/`](./payment-provider-research/) | PayMongo, Xendit, Stripe, wallets, PSP economics; **locks** → [`payment-provider-research/DECISION_MATRIX.md`](./payment-provider-research/DECISION_MATRIX.md) **PM1–PM5** | Claim **PSP chosen** without HitM signoff; set **PM*** rows as `LOCKED` without HitM; mix US merchant rails into PH wedge without labeling contingency. |
| [`pwa-install-offline-sync-research/`](./pwa-install-offline-sync-research/) | PWA, D0–D4, outbox, API version window | Contradict **locked** D0/D2/D3/D4 decisions in that folder’s README §1.x — those are **research locks** until governance reopens them. |
| [`ai-economics-research/`](./ai-economics-research/), [`distribution-channels-research/`](./distribution-channels-research/), [`founder-content-cadence-research/`](./founder-content-cadence-research/), [`wedge-consistency-audit/`](./wedge-consistency-audit/), [`founding-member-program-backend/`](./founding-member-program-backend/) | Wedge audit: fill [`wedge-consistency-audit/AUDIT_REPORT.md`](./wedge-consistency-audit/AUDIT_REPORT.md) §2–§3; **verbatim** wedge only from [`00_strategic_context.md`](../strategic-roadmap-reframe-53be/00_strategic_context.md) §1 | Drop unrelated entity/PSP essays into the wrong folder; do not change §1 wedge sentence from research. |

**PWA long-form drafts** belong under `pwa-install-offline-sync-research/` per [`AGENTS.md`](../../AGENTS.md); do not park them under `finance_manager_web/docs/` unless HitM explicitly migrates after lock.

---

## 3) HitM-only locks — **critical**

- **Never** set `DECISION_MATRIX.md` **HitM locks** (L1–L4) or write **“LOCKED”** for HitM decisions unless **Patrick** has stated the lock in chat or an existing dated section already says so.
- **External tools may:** draft **counsel questions**, **comparison tables**, **risk lists**, **source links**, and **“recommended for HitM review”** language.
- **External tools may not:** present a final entity, tax position, or PSP choice as **decided** without HitM signoff.

**Operating pipeline (HitM lock — 2026-05-03)** for entity/payment alignment is documented in:

- [`entity-formation-research/README.md`](./entity-formation-research/README.md) §0.2  
- [`entity-formation-research/DECISION_MATRIX.md`](./entity-formation-research/DECISION_MATRIX.md) (L2–L4 HitM locks)  
- [`../strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`](../strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) §5.0  

If new research **conflicts** with those sections, add a **dated “Tension / open question”** subsection in the relevant sub-plan README or artifact — do not silently overwrite locks.

---

## 4) Legal, tax, and PSP content — quality bar

- **Primary sources:** Link **official** sites (SEC/DTI/BIR guidance pages, PSP pricing/API docs, IRS publications) with **retrieval date** in prose.
- **No fabricated citations** — if unsure, say **“verify with counsel / PSP support”** and list **what to ask**.
- **Tax:** Frame as **questions for PH + US advisors** (transfer pricing, PE risk, withholding, individual residency). **Do not** prescribe percentages or structures as **tax advice**.
- **Anti-Dummy / spouse-led:** Cross-check with [`entity-formation-research/SPOUSE_INVOLVEMENT_REQUIREMENTS.md`](./entity-formation-research/SPOUSE_INVOLVEMENT_REQUIREMENTS.md) and related files; flag gaps as **checklist items**, not conclusions.

---

## 5) Engineering and repo hygiene

- **Code and production config** live in **sub-repos** (`finance_manager_api/`, `finance_manager_web/`, etc.) — see [`.cursor/rules/git-repo-workflow.mdc`](../../.cursor/rules/git-repo-workflow.mdc). Research under `plans/` does **not** change API/Web behavior by itself.
- **Future split repos / regional deploy lanes** (PH PSP vs US PSP) are **planning** topics — document under `entity-formation-research` or `payment-provider-research` as **architecture notes**, not as if the split already exists in git.
- **Secrets:** Never paste API keys, tokens, bank account numbers, or passport data into plans.

---

## 6) Output format for handoff to Cursor

When producing a research batch for HitM + Cursor:

1. **One executive summary** (5–15 bullets): findings, gaps, **recommended next human step**.
2. **File map:** which new/updated markdown paths under `plans/cursor/s1b/...` (full repo-relative paths).
3. **Explicit “not locked”** footer on any recommendation that needs HitM or counsel signoff.
4. If touching locks or roadmap economics, note whether **[`CHANGELOG.md`](../../CHANGELOG.md)** (parent repo) needs an **[Unreleased]** bullet — Cursor agents usually add that on merge prep.

---

## 7) Changelog and CPPRD

- Material behavior or **decision** changes that ship through the parent repo’s PR process should get a **`CHANGELOG.md`** entry when the human/agent completes the workstream ([`deploy/CPPR_AND_CPPRD.md`](../../deploy/CPPR_AND_CPPRD.md)).
- Gemini-only drafts that **never** merge through git still benefit from a short **“Last updated / Author tool”** line in the edited artifact for audit trail.

---

## 8) Re-read triggers

Re-read this file when:

- Starting a **new** S1.B sub-topic or a **new** external tool session.
- Governance changes **glossary**, **validation_gates**, or **entity/payment** README locks.
- You are about to edit **`entity-formation-research/DECISION_MATRIX.md`**, **`payment-provider-research/DECISION_MATRIX.md`** (PSP **PM*** locks), **`validation_gates.md`**, or **`01_unit_economics_and_costs.md`** — confirm HitM intent first.

---

*Last updated: 2026-05-05 — payment plan `DECISION_MATRIX.md` + PM lock naming in folder table.*
