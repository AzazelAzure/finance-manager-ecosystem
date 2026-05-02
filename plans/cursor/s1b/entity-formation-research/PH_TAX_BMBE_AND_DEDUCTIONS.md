# Philippines tax research — PH entity assumption (not locked)

**Working assumption:** Operating company is a **Philippine domestic** enterprise (sole proprietorship, OPC, or stock corporation) for planning only. **HitM has not locked** this path; reconcile with [TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md) and [DECISION_MATRIX.md](./DECISION_MATRIX.md).

**Disclaimer:** This file compiles **public sources and statute mirrors**. It is **not** tax, legal, or BIR advice. Rates, thresholds, and BIR issuances change. Before relying on BMBE or any election, confirm with a **Philippine tax advisor** and your **BIR Revenue District Office (RDO)**.

---

## 1) BMBE — what the law actually says

**Statute:** Republic Act No. 9178 — *Barangay Micro Business Enterprises (BMBEs) Act of 2002*.

| Source | URL | Use |
| ------ | --- | --- |
| Full text (mirror) | [Lawphil — RA 9178](https://lawphil.net/statutes/repacts/ra2002/ra_9178_2002.html) | Cite Sections 3–7 in discussions |
| Official Gazette (primary publisher) | [Official Gazette — RA 9178](https://www.officialgazette.gov.ph/2002/11/13/republic-act-no-9178/) | Prefer this when reachable (403 errors may occur from some networks) |

### 1.1 Eligibility (assets — not revenue)

**Section 3(a)** defines a BMBE as an enterprise engaged in production, processing, manufacturing, trading, or **services**, with **total assets** (including assets from loans) **not more than ₱3,000,000**, **excluding the land** on which office, plant, and equipment are situated. The definition notes possible **review and upward adjustment** by the SMED Council under RA 6977 / RA 8289 — treat the **operative ceiling** as whatever **current DTI/BIR guidance** states when you register.

**Section 3(a)** also excludes, from the BMBE definition of “service,” services rendered by anyone **duly licensed** after a **government licensure examination** in connection with exercising a **profession**. Whether a given **SaaS / software subscription** business is classified as an excluded professional service is a **fact-specific** question for DTI/BIR and counsel—not something to infer from Gemini alone.

### 1.2 Core incentive (income tax)

**Section 7** states: *“All BMBEs shall be exempt from tax for income arising from the operations of the enterprise.”*

That is **income tax** on operating income, not a blanket exemption from **all** national or local taxes.

### 1.3 Registration mechanics (Certificate of Authority)

**Sections 4–6:** LGU Treasurer registers BMBEs and issues a **Certificate of Authority**; certificate **two years**, renewable for two years; transfers of ownership must be reported and the certificate surrendered for notation.

**Section 5:** Natural or juridical persons, cooperatives, or associations meeting Section 3(a) may apply.

### 1.4 What BMBE does **not** automatically solve

Even with RA 9178 income tax exemption, a domestic enterprise typically still must address (non-exhaustive):

- **VAT** vs **percentage tax** (or other gross-based levies), depending on registration and activity — see **Section 3** below.
- **Withholding taxes** on payments to and from the business (salaries, certain payors, cross-border payments where relevant).
- **Local taxes and fees** (Section 7 only **encourages** LGUs to reduce or exempt BMBEs).
- **BIR registration, books, and filings** — exemption from income tax is not exemption from **compliance**; see e.g. practitioner summaries on BIR obligations for BMBEs such as [Respicio — BIR compliance for BMBE owners](https://www.respicio.ph/commentaries/bir-compliance-requirements-for-bmbe-owners) (secondary; use for checklist ideas, not as law).

**FOI / clarifications:** The Philippine FOI portal has hosted BIR responses on BMBE income tax topics (e.g. searches for “BMBE income tax exemption” on [foi.gov.ph](https://www.foi.gov.ph/)); URLs sometimes move—if you need a **written BIR position**, route through your advisor or a formal ruling request.

### 1.5 DTI / IRR layer

RA 9178 **Section 15** requires DTI (consulting DILG, DOF, BSP) to issue **Implementing Rules and Regulations**. For registration steps and Negosyo Center flow, use **current DTI publications**, e.g. materials linked from DTI’s site or e-library (example host used in practice: [DTI e-library PDF — Guide to RA 9178](https://dtiwebfiles.s3-ap-southeast-1.amazonaws.com/e-library/Growing+a+Business/2016+Guide+to+RA+9178+BMBEs+Act+of+2002.pdf) — verify you have the **latest** revision, not a 2016 snapshot alone).

---

## 2) If you are **not** BMBE-qualified — domestic corporation baseline

Useful **second-line** comparison when assets or activity disqualify BMBE, or when you outgrow the cap.

**Summary (PwC Worldwide Tax Summaries — Philippines, corporate income tax):**

- [PwC — Philippines — Taxes on corporate income](https://taxsummaries.pwc.com/philippines/corporate/taxes-on-corporate-income)

| Item (domestic corporation) | PwC-stated rule (verify against current NIRC / RRs) |
| --------------------------- | ---------------------------------------------------- |
| Standard CIT | **25%** on net income from all sources |
| Reduced CIT for smaller domestic corporations | **20%** if **total assets ≤ ₱100M** (excl. land per summary) **and** **net taxable income ≤ ₱5M** |
| MCIT | **2%** on **gross income**, from the **fourth taxable year** after commencement of operations, **if** MCIT exceeds regular CIT |

**Net operating loss (NOL):** PwC’s [Philippines — Corporate — Deductions](https://taxsummaries.pwc.com/philippines/corporate/deductions) notes NOL carryforward rules (generally **three years**; special extensions applied to certain pandemic-era years under Bayanihan). **BMBE income tax exemption** interacts with NOL analysis—model with counsel if you transition from BMBE to taxable.

---

## 3) Revenue-oriented breakpoints (VAT and digital services)

These are **planning triggers**, not entity-formation locks by themselves.

### 3.1 VAT registration threshold (₱3M)

**PwC — Philippines — Other taxes** ([link](https://taxsummaries.pwc.com/philippines/corporate/other-taxes)), *VAT on Digital Services* discussion: persons required to register for VAT include those with **gross sales exceeding PHP 3 million** in the past **12 months** or reasonably expected to exceed that threshold in the **next** 12 months; **12% VAT** on digital services from **2 June 2025** in that summary’s narrative.

Also read the same page for **general VAT** (12% basis, invoicing changes under EOPT / CREATE MORE).

**Practical note:** SaaS MRR × 12 must be compared to the **correct gross sales / receipts basis** as defined for your taxpayer class—your advisor maps **subscription revenue** to BIR reporting categories.

### 3.2 Non-VAT path — percentage tax (corporations)

If the business is **not VAT-registered** and statutes apply, **Section 116** of the Tax Code historically imposes **percentage tax on gross receipts** (commonly cited as **3%** for many non-VAT corporations; **CREATE** temporarily lowered rates for some periods). **Do not lock a number** without checking the **NIRC section as amended** and current BIR issuances for your fiscal year. Starting point for reading: same NIRC compilation as below.

---

## 4) Deductions and “write-offs” (income tax base)

### 4.1 Statutory basis — NIRC

**National Internal Revenue Code of 1997 (RA 8424), as amended** — mirror:

- [Lawphil — RA 8424 / Tax Code](https://lawphil.net/statutes/repacts/ra1997/ra_8424_1997.html)

**Section 34** begins: *“… there shall be allowed the following deductions from gross income …”* and enumerates itemized categories (ordinary and necessary trade expenses, interest, taxes, losses, bad debts, depreciation, charitable contributions, etc.). Use the official consolidated NIRC PDF from BIR or Congress if you need pagination for filings.

### 4.2 Optional Standard Deduction (OSD)

**PwC — Philippines — Corporate — Deductions** ([link](https://taxsummaries.pwc.com/philippines/corporate/deductions)):

- Corporations may elect **optional standard deduction** of **40% of gross income** **in lieu of** itemized operating expenses.

Election timing and irrevocability are **Code- and RR-specific**—implement through your accountant.

### 4.3 Relationship to BMBE income tax exemption

If **all** operating income is **fully exempt** from income tax under a valid BMBE Certificate of Authority, **income-tax deductions** (Section 34 / OSD) do **not** reduce Philippine income tax on that exempt income—because there is **no** income tax on that slice. You still care about deductions for:

- **Non-exempt** income streams (if any),
- **Years after** BMBE disqualification or asset cap breach,
- **Other tax bases** (e.g. gross-based taxes, or activities taxed separately).

### 4.4 Documentation

BIR expects **substantiation** (registered receipts, payroll records, etc.) for itemized deductions. **RMC 81-2025** (digest on BIR CDN) has been cited in practice for definitional emphasis on **ordinary** and **necessary** expenses—pull the full PDF from [BIR publications / CDN](https://bir-cdn.bir.gov.ph/) when validating wording.

---

## 5) Verification checklist (real-world, before you treat BMBE as “locked strategy”)

1. **DTI / SEC + LGU:** Certificate of Authority path for your **actual** legal vehicle and barangay.
2. **BIR RDO:** Registration, books, return types for **BMBE + non-VAT or VAT** combination you intend.
3. **Asset test:** Model **balance sheet** assets used in the business (cloud prepaids, laptops, capitalized software, receivables)—compare to **₱3M** test; plan for **exit** from BMBE if you fund through equity or debt that pushes assets up.
4. **Revenue test:** Model **₱3M** annualized **gross sales** against **VAT** registration rules (PwC summary + advisor).
5. **Service characterization:** Written confirmation that your **subscription SaaS** is an eligible **BMBE service** and not excluded as a **licensed professional service** under Section 3(a).
6. **Cross-border:** If any income or payors are **non-PH**, add **treaty / withholding / digital VAT** layer (outside this note’s depth).

---

## 6) Links back to HitM plans

- [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) — when revenue forces registration or PSP KYB.
- [DECISION_MATRIX.md](./DECISION_MATRIX.md) — vehicle + BMBE yes/no when PH path locks.
- [`../payment-provider-research/README.md`](../payment-provider-research/README.md) — settlement and invoice rules interact with VAT status.

---

## 7) Changelog

| Date | Change |
| ---- | ------ |
| 2026-05-02 | Initial compile: RA 9178, NIRC Sec. 34, PwC summaries for CIT/VAT/OSD, BMBE caveats. |
