# Terms of Service Requirements (Clause-by-Clause)

> **Source:** Extracted from `compass_artifact_wf-...md` — three-document legal framework  
> **Scope annotations added:** 2026-06-26 against actual implementation state  
> **Status:** Framework only — NOT legal text; attorney review required before publishing  
>
> **SCOPE KEY:** `[NOW]` = required before S1.B exit · `[CYA]` = keep for legal baseline even if not primary market · `[PLACEHOLDER]` = deferred until feature exists, but maintain the section · `[SKIP]` = genuinely out of scope for this product

---

## Key Findings (ToS-relevant)

- A **"not a financial advisor" disclaimer does NOT shield you if you actually provide advice for compensation** (US Investment Advisers Act). Keep features to budgeting/principles only — no recommendations, no portfolio guidance. [HitM comment:  We will offer basic financial literacy and budgeting information and such generally, but these will not be behind paywalls, will not include anything touching the stock market or Series license required financial tools, only basic financial literacy.  Discussion point for later.]
- **Arbitration language must be mandatory, not permissive.** A PH Supreme Court ruling (April 2025) held that permissive wording ("shall have the right to") merely creates an *option* to arbitrate — not a binding clause. Use: "any dispute *shall be resolved through* arbitration."
- PH Consumer Act (RA 7394) limits how far warranty disclaimers and liability caps can go against consumers. Do not use US-boilerplate "as-is" disclaimers verbatim — needs PH attorney calibration.

---

## 2.1 Acceptance & Eligibility `[NOW]`

- Clickwrap acceptance required (affirmative action — not just "by using this app you agree") [HitM comment:  Add this to the cookie banner, with a link to the ToS.  We will do this for the Privacy Policy as well.]
- Log: timestamp + ToS version accepted
- Binding-contract language; capacity to contract

---

## 2.2 Minimum Age / Minors `[NOW]` ⚠️ attorney review

- **Minimum age: 18** (PH contractual capacity threshold; recommended for financial app)
- State minimum age explicitly; reserve right to terminate underage accounts
- **[CYA][COPPA]** No knowing collection from under-13 — state this explicitly. Amended COPPA Rule took effect June 23, 2025, full compliance deadline April 22, 2026 (passed). Violation penalty: up to $53,088 per violation. Passive US Honorary Founders trigger this requirement.
- **[CYA][GDPR-K]** 16 default; 13-16 per EU member state. Keep as CYA baseline.
- **[PH-DPA]** Minor data is sensitive — avoid collecting it; state the age gate prominently.
- ⚠️ Attorney review required for age-gating implementation specifics.

---

## 2.3 Description of Service + "Not a Financial Advisor" `[NOW]`

- State the app is a **personal budgeting/management tool** — NOT a licensed financial/investment advisor, broker, or fiduciary; it provides no advice. [HitM comment:  We will need to walk the line and discuss what legally constitutes 'advice' in this context.]
- This disclaimer does NOT shield against providing actual advice for compensation — keep features to budgeting/projection only.
- **This clause must be prominent** — not buried in fine print. Consider a separate splash/onboarding disclosure in addition to the ToS.

---

## 2.4 No Fiduciary Duty / Accuracy of User Data `[NOW]`

- No fiduciary relationship is created
- User is solely responsible for the accuracy of data they enter [HitM comment: If/when we get to the point that we can integrate Stripe, this will not be entirely true, but I'm not entirely sure how that works legally if we're being provided transaction data from a third party.  This is worth noting for eventual android/ios releases and reading sms for Gcash/Maya/Ewallet data for auto transaction logging.  Not required for current implementation, but a necessary notation point for the future.]
- Calculations may contain rounding/errors; outputs are informational only
- **Include:** "past performance / projections are not guarantees" statement — applies to any budgeting/forecasting output (F-005 Savings Goals, F-003 Predictive Budgeting, F-001 Balance History all fall under this)

---

## 2.5 User Accounts & Responsibilities `[NOW]`

- Credential security obligations on the user
- One account per user
- Duty to notify operator on suspected breach
- User responsibility for account activity
- Accurate registration info requirement

---

## 2.6 Acceptable Use Policy `[NOW]`

Prohibit:
- Illegal use
- Reverse engineering
- Scraping / automated data extraction
- Malware / unauthorized access
- Infringing content
- Money-laundering, fraud, or terrorist financing use of the app

---

## 2.7 Intellectual Property `[NOW]`

- App, code, trademarks, and content owned by the operator
- Limited revocable license granted to the user
- **User retains rights in their own entered financial data** (critical for a financial app — do not claim data ownership)
- Feedback license to operator (if user submits feature requests, operator may use them without obligation)

---

## 2.8 Disclaimer of Warranties + Limitation of Liability `[NOW]` ⚠️ attorney review REQUIRED

- "As is / as available" disclaimer
- Disclaim implied warranties (merchantability, fitness for purpose)
- Exclude indirect/consequential/data-loss damages
- Cap aggregate liability (e.g., to fees paid in the prior period)
- ⚠️ **PH Consumer Act (RA 7394) limits enforceability** of warranty exclusions against consumers. US boilerplate is NOT directly transferable. PH attorney must review and calibrate these clauses before publishing.
- **[CYA]** EU consumer rules also limit liability exclusions — include a carve-out for EU consumers even if no EU users currently.

---

## 2.9 Offline Data Storage Disclosure `[NOW]`

- Dexie.js encrypted local storage is used for financial data
- Device-side only — operator does NOT receive financial data server-side [HitM comment:  This is ambiguous.  We DO recieve financial data server-side, at least in terms of whatever the user enters into the app.  This gets stored both locally and in the API backend for online syncing.]
- 3-month retention window with auto-purge
- User is responsible for device security
- Risk of data loss if browser storage is cleared — state this explicitly [HitM comment: As previously stated, this isn't entirely true.  If data is deleted that was added offline, and is deleted offline, that data loss is accurate.  However, if it is added while online, that data is saved in our DB, so browser storage deletion will not delete this.  This is also subject to PWA implementation changes to ensure data syncing per user can be opted out of.  See notes in privacy policy document.]

---

## 2.10 Data Retention & Deletion Rights `[NOW]`

- Local Dexie: 3-month rolling window with auto-purge (disclosed in §2.9)
- Server-side: anonymous/pseudonymous logs with 90-day rolling retention (per observability plan)
- Account deletion: must provide a deletion mechanism; describe what is deleted (server-side account record) vs what remains device-side (Dexie data, which persists until the browser purges it or the 3-month window expires)[HitM comment:  Account deletion is already set up and verified functional, at least server side.  Account deletion deletes ALL data related to the user, throughout the server, except for error logs, which are logged without PII, by UUID.]
- Cross-reference: Privacy Policy §3.8

---

## 2.11 Termination `[NOW]`

- User may terminate anytime (account deletion mechanism)
- Operator may terminate for breach; reasonable notice where practical
- Effect on local data (Dexie persists until auto-purge — operator cannot delete device-side data)
- Effect on server-side data (90-day log retention continues per observability plan; account record deleted)
- Survival clauses: IP ownership (§2.7), liability (§2.8), dispute resolution (§2.14)

---

## 2.12 GDPR-Specific Data Rights `[CYA]`

- Include a generic "data subject rights" clause cross-referencing the Privacy Policy
- No EU users currently, but CYA baseline requires this
- Rights: access, erasure, portability, restriction, objection, withdraw consent
- Do not duplicate full GDPR language — a short clause pointing to the Privacy Policy is sufficient
- Cross-reference: Privacy Policy §3.7

---

## 2.13 PH-DPA-Specific `[NOW]`

- Reference RA 10173 data-subject rights (same rights as GDPR-adjacent — access, correction, erasure, objection, portability, file a complaint with the NPC)
- DPO contact (once designated — see Gap #3 in scope_analysis.md)
- Accountability principle — **RA 10173 Section 21:** operator stays responsible for data transferred to any third party for processing, domestically or internationally; must use contractual or reasonable means to provide comparable protection
- NPC registration considerations: cross-reference Privacy Policy §3.14

---

## 2.14 Dispute Resolution & Governing Law `[NOW]` ⚠️ attorney review

- **Governing law:** Republic of the Philippines
- **Primary venue:** PH courts or arbitration seated in the Philippines
- **Arbitration fallback:** ADR Act (RA 9285) adopting the UNCITRAL Model Law; Philippines is a New York Convention signatory (with reciprocity reservation); PDRCI or PICCR; language: English; seat: Philippines
- **MANDATORY language required:** "any dispute *shall be resolved through* arbitration" — NOT permissive wording ("shall have the right to"). PH Supreme Court ruling (April 2025) held that permissive wording is merely an option, not binding.
- **[CYA]** Consumer arbitration waivers and class-action waivers may be unenforceable against EU and California consumers — include a carve-out for those jurisdictions
- ⚠️ PH attorney review required for final arbitration clause wording and consumer carve-out

---

## 2.15 Third-Party Integrations `[PLACEHOLDER — maintain for GCash/Maya]`

This section must be completed when GCash, Maya, or bank integrations are implemented.

Draft placeholder language:
- Data-sharing disclosure with the integration partner
- State that integrations are governed by the third party's own terms (e.g., GCash T&Cs make the user liable where they voluntarily disclose OTP/MPIN)
- Liability allocation between operator and integration partner
- KYC/AML obligations for payment integrations
- Recommended path: integrate via aggregator (PayMongo, Xendit, or Maya Business) rather than direct bank-by-bank — reduces PCI-DSS scope

---

## 2.16 Framework Placeholders `[PLACEHOLDER — maintain all]`

### OAuth Third-Party Login
- Store nothing from OAuth flow in localStorage
- Disclose that user authentication may be handled by a third-party provider
- Provider's own terms apply to the authentication
- **Complete this section when OAuth is implemented**

### Payment Processing
- Payment processor name(s) and governing terms
- What data is shared with the payment processor
- PCI-DSS scope statement
- **Complete when payment processing is added**

### Premium Subscription Tiers
- Billing cycle, auto-renewal, price changes
- Cancellation mechanics
- Refund policy (separate by tier: Pro, Pro+AI, PAYG, Founding)
- **[CYA][EU]** EU 14-day withdrawal right for digital services — include even if no EU users currently
- Price-change notice period
- **Complete when subscription billing is activated**

---

## 2.17 Miscellaneous Required Clauses `[NOW]`

- **Severability** — if one clause is invalid, the rest of the ToS stands
- **Entire agreement** — ToS + Privacy Policy + Cookie Policy = full agreement
- **Assignment** — operator may assign in connection with acquisition; user may not assign
- **Force majeure** — standard clause
- **Changes to terms** — notice mechanism; for material changes, reasonable notice before effective date; continued use = acceptance
- **Contact information** — operator email; DPO email once designated (see Gap #3)
