# Hive Financial Manager — Agent Implementation Frameworks (ToS, Privacy Policy, Cookies)

**TL;DR**
- These are three agent-ready implementation frameworks — not final legal text — covering a cookie/consent system, Terms of Service, and Privacy Policy for a React PWA that uses JWT auth, collects anonymous usage + error logs, and stores 3 months of encrypted financial data locally via Dexie.js, targeting the Philippines while meeting GDPR, CCPA/CPRA, CalOPPA, and PH Data Privacy Act (RA 10173) baselines.
- The biggest compliance levers are: (1) a geo-aware, opt-in-by-default cookie/consent layer that blocks non-essential scripts and logs consent; (2) a ToS that disclaims financial-advice/fiduciary roles, caps liability, discloses local encrypted storage, and sets Philippines-first governing law with arbitration fallback; and (3) a Privacy Policy that maps each purpose to one GDPR lawful basis, satisfies NPC Circular 2023-04 notice content, includes a CCPA "we do not sell" statement, and addresses NPC registration/DPO duties.
- Every document is structured with [REQUIRED]/[RECOMMENDED] tags, jurisdiction flags (GDPR / CCPA / PH-DPA / GLOBAL), and [PLACEHOLDER] markers for OAuth, GCash/Maya, payments, and subscriptions; a PH-qualified attorney must review liability caps, arbitration, age-gating, the NPC registration trigger, lawful-basis mapping, and SCC selection before publishing.

---

## Key Findings

- **Opt-in vs opt-out is jurisdictional and must be geo-targeted.** Under the EU ePrivacy Directive (lex specialis over GDPR) plus GDPR, non-essential cookies and local-storage writes require prior, affirmative, granular consent and must be blocked until the user opts in. California (CCPA/CPRA) uses an opt-out model with a "Do Not Sell or Share" mechanism and Global Privacy Control (GPC) honoring. The Philippines requires consent that is freely given, specific, informed, evidenced, and an indication of will, with layered/just-in-time notices.
- **Enforcement is real and recent.** France's CNIL fined Google €325M on September 1, 2025 and American Express Carte France €1.5M on November 27, 2025 — the latter specifically because withdrawn-consent cookies kept firing. Pre-ticked boxes are invalid (CJEU *Planet49*, C-673/17, 1 Oct 2019), and asymmetric "Accept All"/buried "Reject All" designs are prohibited deceptive patterns (EDPB Guidelines 03/2022).
- **JWT storage has a clear 2026 best practice:** access token in memory, refresh token in an HttpOnly + Secure + SameSite cookie, with rotation and revocation — never PII in the token, never tokens in localStorage.
- **Dexie.js local storage must be disclosed and encrypted properly:** `dexie-encrypted` cannot encrypt indices, so sensitive fields must not be indexed, and the key must never live in localStorage/cookies.
- **Philippines specifics drive several mandatory clauses:** RA 10173 Section 21 accountability (operator stays responsible for data transferred to processors domestically or internationally), NPC Circular 2023-04 notice content, NPC Circular 2022-04 registration triggers, mandatory DPO designation, and 72-hour breach notification.

---

# DOCUMENT 1 — Cookie, Authentication & Consent Implementation Requirements

## 1.1 Legal baseline
- **[REQUIRED][GDPR]** GDPR + ePrivacy Directive (Art 5(3), "EU Cookie Law") require prior opt-in consent before any non-essential cookie or local-storage write. ePrivacy is *lex specialis* (takes precedence over GDPR for storage/access). Legitimate interest **cannot** justify analytics or marketing cookies — these need explicit consent (EDPB Guidelines 05/2020).
- **[GLOBAL]** The European Commission **withdrew the ePrivacy Regulation proposal on 11–12 February 2025** via its 2025 Work Programme, stating there was "no foreseeable agreement" and that "the proposal is outdated in view of some recent legislation." The **ePrivacy Directive 2002/58/EC and national transpositions remain in force** — design to the Directive, not the abandoned Regulation.
- **[REQUIRED][CCPA]** CCPA/CPRA opt-out model: cookies may load, but if data is "sold/shared" you must provide a "Do Not Sell or Share My Personal Information" mechanism and honor the GPC browser signal.
- **[REQUIRED][CCPA]** CalOPPA: the privacy policy must disclose tracking and the site's Do-Not-Track response.
- **[REQUIRED][PH-DPA]** Consent must be freely given, specific, informed, evidenced, and an indication of will (NPC Circular 2023-04). No standalone "cookie law," but cookies that process personal data need a lawful basis + notice.

## 1.2 What makes a consent banner compliant
- **[REQUIRED][GDPR]** "Reject All" as easy and prominent as "Accept All"; no pre-ticked boxes (CJEU **C-673/17 *Planet49***, 1 Oct 2019 — consent is invalid via a pre-checked box, and must be specific to cookie storage/access regardless of whether data is personal); no cookie walls; granular per-category toggles; withdrawal as easy as giving consent.
- **[REQUIRED][GDPR]** Block non-essential scripts/storage until opt-in (EDPB Guidelines 05/2020: no deposit before the user's choice). Asymmetric or buried-reject designs are deceptive design patterns prohibited under EDPB Guidelines 03/2022.
- **[REQUIRED][GLOBAL]** Geo-targeted logic: EU/EEA/UK users → opt-in; California users → opt-out + GPC; PH and other global users → notice + opt-in for non-essential.
- **[REQUIRED]** Log consent: timestamp, pseudonymized IP/country, consent text version, categories accepted/rejected; store securely and make exportable for audit (GDPR Art 7 requires you to *demonstrate* consent).
- **Enforcement context (avoid dark patterns):** CNIL fined **Google €325M on 1 September 2025** (€200M Google LLC + €125M Google Ireland; Deliberation SAN-2025-004) for setting Gmail ad cookies without valid consent across "more than 74 million accounts," under Article 82 of the French Data Protection Act. CNIL fined **American Express Carte France €1.5M on 27 November 2025** (Deliberation SAN-2025-011) because, per CNIL, "when a user accepted the deposit and reading of trackers, then withdrew their consent, the previously deposited trackers continued to be read" — i.e., withdrawal must actually stop cookies firing.

## 1.3 Cookie/storage categories to classify
1. **Strictly necessary** (exempt from consent; still disclose) — JWT session/refresh cookies, CSRF token, the consent-preference store itself.
2. **Functional** (consent) — UI preferences, language; arguably the user's own locally-stored financial data needed to deliver the requested service.
3. **Analytics** (consent — even first-party analytics require consent under EU law because they process IP/device identifiers).
4. **Marketing/advertising** (consent; highest scrutiny). **[PLACEHOLDER: none currently used — reserve category for future.]**

## 1.4 JWT cookie technical requirements **[REQUIRED][GLOBAL]**
- 2026 gold standard: **access token in memory** (JS variable, recoverable via silent refresh); **refresh token in HttpOnly + Secure + SameSite cookie** scoped to `/auth/refresh`.
- Flags: `HttpOnly` (blocks JS/XSS theft), `Secure` (HTTPS only), `SameSite=Strict` for the refresh cookie (or `Lax` as default for others). `SameSite=None` **requires** `Secure` or modern browsers silently drop the cookie.
- Short access-token expiry; refresh-token rotation + reuse detection; `jti` denylist for revocation.
- No PII in the JWT payload (it is base64, not encrypted). Validate `exp`, `iss`, `aud`; reject `alg:none` (RFC 8725 / OAuth BCP RFC 9700).
- Add CSRF tokens for state-changing routes when using cookie-borne tokens.

## 1.5 Local storage / Dexie.js (PWA offline) **[REQUIRED][GLOBAL]**
- IndexedDB/Dexie writes are "storage of information on terminal equipment" → covered by ePrivacy if non-essential. Storing the user's own financial data to deliver the requested service is arguably strictly-necessary/functional, but it **must still be disclosed**.
- `dexie-encrypted` (default tweetnacl) encrypts non-indexed fields but **cannot encrypt indices** — so do **not** index sensitive fields. The encryption key must **not** be stored in localStorage or cookies; derive it from a user secret (KDF) or fetch from the authenticated backend.
- Disclose: 3-month local retention window, encryption-at-rest, device-side-only storage, and the auto-purge logic.

## 1.6 Cookie/storage audit — disclose everything **[REQUIRED]**
Enumerate, with name / type / purpose / duration / first-or-third-party: JWT session + refresh cookies, CSRF cookie, consent-preference store, Dexie/IndexedDB databases, service-worker cache (PWA), and any analytics/error-logging cookies or identifiers.

## 1.7 CMP — build vs buy **[RECOMMENDED]**
- A compliant CMP must: block pre-consent scripts, offer granular categories, store tamper-evident consent logs (timestamp + version), support easy withdrawal, geo-target banners, and support GPC + Google Consent Mode v2.
- For a solo developer, a managed CMP (CookieYes/Termly free tiers, Enzuzo, iubenda) is cheaper and safer than rolling your own. Given this app's small cookie footprint, a self-built consent layer is acceptable **only if** it replicates consent logging and pre-consent script/storage blocking.

## 1.8 Cookie policy page contents **[REQUIRED]**
Definition of cookies/storage; categories used; per-cookie table; purposes; third parties + links to their policies; durations; how to withdraw/change consent; link from footer + banner; last-updated date.

## 1.9 OAuth placeholders
- **[PLACEHOLDER: OAuth/OIDC login]** — store nothing in localStorage; validate the ID token; the provider may set its own cookies (disclose them); add the provider to the cookie table and to the privacy policy's processors list.

## 1.10 Implementation checklist (agent-actionable)
- [ ] Geo-detection → banner mode (opt-in EU/UK; opt-out + GPC California; opt-in PH/global)
- [ ] Script/storage blocking until consent for analytics/marketing
- [ ] Granular category toggles + equal-prominence Reject All
- [ ] Consent log store (timestamp, version, categories) + export
- [ ] JWT refresh cookie HttpOnly/Secure/SameSite; access token in memory
- [ ] CSRF protection on state-changing routes
- [ ] Dexie encryption middleware; no sensitive indices; 3-month purge job
- [ ] Cookie policy page + footer link
- [ ] GPC signal listener
- [ ] [PLACEHOLDER: OAuth provider cookies]
- ⚠️ **Attorney review** of banner copy + category classification before launch.

---

# DOCUMENT 2 — Terms of Service Requirements (clause-by-clause)

## 2.1 Acceptance & eligibility **[REQUIRED][GLOBAL]**
Clickwrap acceptance (affirmative action, logged with timestamp/version). Binding-contract language. Capacity to contract.

## 2.2 Minimum age / minors **[REQUIRED][GLOBAL]**
Prohibit users under 18 (recommended for a financial app, since contractual capacity in PH is 18). State the minimum age; reserve the right to terminate underage accounts. **COPPA (US):** no collection from under-13 — per the FTC, "operators who violate the Rule can be held liable for civil penalties of up to **$53,088 per violation**"; the amended COPPA Rule took effect **June 23, 2025** with a full-compliance deadline of **April 22, 2026**. **GDPR-K:** 16 default, 13–16 per member state. **[PH-DPA: minors' data is sensitive — avoid collecting it.]** ⚠️ attorney review.

## 2.3 Description of service + "not a financial advisor" **[REQUIRED][GLOBAL]**
State the app is a personal budgeting/management tool, **NOT** a licensed financial/investment advisor, broker, or fiduciary; it provides no advice. Note: a "this is not financial advice" disclaimer does **not** shield you if you actually provide advice for compensation (US Investment Advisers Act). Keep features to budgeting/principles only.

## 2.4 No fiduciary duty / accuracy of user data **[REQUIRED]**
- No fiduciary relationship is created.
- The user is solely responsible for the accuracy of data they enter; calculations may contain rounding/errors; outputs are informational only.
- Include a "past performance / projections are not guarantees" statement if any forecasting feature exists.

## 2.5 User accounts & responsibilities **[REQUIRED][GLOBAL]**
Credential security; one account per user; duty to notify on suspected breach; responsibility for account activity; accurate registration info.

## 2.6 Acceptable use policy **[REQUIRED][GLOBAL]**
Prohibit: illegal use, reverse engineering, scraping, malware, infringing content, unauthorized access, and money-laundering/fraud use.

## 2.7 Intellectual property **[REQUIRED][GLOBAL]**
App, code, trademarks, and content owned by the operator; limited revocable license to the user; user retains rights in their entered data; feedback license to operator.

## 2.8 Disclaimer of warranties + limitation of liability **[REQUIRED][GLOBAL]**
"As is / as available"; disclaim implied warranties (merchantability, fitness for purpose); exclude indirect/consequential/data-loss damages; cap aggregate liability (e.g., to fees paid in the prior period). Enforceability varies — PH consumer law and EU consumer rules limit how far exclusions go. ⚠️ attorney review.

## 2.9 Offline data storage disclosure **[REQUIRED][GLOBAL]**
Disclose Dexie.js encrypted local storage, device-side only, 3-month retention with auto-purge, user responsibility for device security, and risk of data loss if browser storage is cleared.

## 2.10 Data retention & deletion rights **[REQUIRED][cross-ref Doc 3]**
Local 3-month window; server-side anonymous logs; how to delete account/data.

## 2.11 Termination **[REQUIRED][GLOBAL]**
By user anytime; by operator for breach; effect on local + server data; survival clauses (IP, liability, dispute resolution).

## 2.12 GDPR-specific **[REQUIRED][GDPR]**
Reference right to erasure, portability, and lawful basis; cross-reference the privacy policy.

## 2.13 PH-DPA-specific **[REQUIRED][PH-DPA]**
Reference RA 10173 data-subject rights; DPO contact; NPC registration considerations (see Doc 3 §3.14); and the accountability principle — **RA 10173 Section 21** provides that "each personal information controller is responsible for personal information under its control or custody, including information that have been transferred to a third party for processing, whether domestically or internationally," and must use "contractual or other reasonable means to provide a comparable level of protection."

## 2.14 Dispute resolution & governing law **[REQUIRED][GLOBAL]**
- **Governing law:** Republic of the Philippines.
- **Philippines-first:** venue in PH courts or arbitration seated in the Philippines.
- **International arbitration fallback:** arbitration under the ADR Act (RA 9285) adopting the UNCITRAL Model Law; the Philippines is a New York Convention signatory (with reciprocity reservation); institutions: PDRCI or PICCR; language English; seat Philippines.
- Use **mandatory** language ("any dispute *shall be resolved through* arbitration"), not permissive ("*shall have the right to*"). A PH Supreme Court ruling (April 2025) held that permissive wording merely creates an *option* to arbitrate.
- ⚠️ Consumer arbitration waivers and class-action waivers may be unenforceable against EU and California consumers — include a carve-out.

## 2.15 Third-party integrations placeholder
- **[PLACEHOLDER: GCash, Maya, bank integrations]** — add data-sharing disclosure; state that integrations are governed by the third party's own terms (e.g., GCash T&Cs make the user liable where they voluntarily disclose OTP/MPIN); allocate liability; address KYC; integrate via an aggregator (PayMongo, Xendit, or Maya Business) rather than direct bank-by-bank.

## 2.16 Framework placeholders
- **[PLACEHOLDER: OAuth third-party login terms]**
- **[PLACEHOLDER: Payment processing terms]**
- **[PLACEHOLDER: Premium subscription tiers]** — billing, auto-renewal, refunds, EU 14-day withdrawal right, price-change notice.

## 2.17 Miscellaneous required clauses **[REQUIRED]**
Severability, entire agreement, assignment, force majeure, changes to terms + notice mechanism, contact info.

---

# DOCUMENT 3 — Privacy Policy Requirements (section-by-section)

## 3.1 Controller identification **[REQUIRED][GLOBAL]**
Legal name, PH address, email; for a solo dev / small company, name the operating entity. **[PH-DPA]** provide the name + contact of the DPO / accountable individual (RA 10173 Sec 21(b) requires a designated accountable person disclosed to any data subject on request).

## 3.2 Data currently collected **[REQUIRED]**
- Anonymous usage data (analytics).
- Error logs (may contain IP/device/timestamps → potentially personal → disclose).
- Locally encrypted Dexie.js financial data — device-side only; clarify the operator does **not** receive it server-side.

## 3.3 Data collected in future **[PLACEHOLDER — clearly marked]**
- **[PLACEHOLDER: account data — email, name, hashed password]**
- **[PLACEHOLDER: financial transaction data synced server-side]**
- **[PLACEHOLDER: OAuth identity data]**
- **[PLACEHOLDER: GCash/Maya/payment + billing data]**

## 3.4 Lawful basis (GDPR Art 6) **[REQUIRED][GDPR]**
Map each purpose to **one** basis (no "just in case" stacking; the EDPB prohibits switching basis after the fact, and switching from consent to legitimate interest when consent is withdrawn is a recognized enforcement failure):
- Service delivery / local storage → **contract** (Art 6(1)(b)).
- Analytics/error-log cookies → **consent** (Art 6(1)(a)); or **legitimate interest** (Art 6(1)(f)) only for purely aggregate/anonymized statistics, with a documented Legitimate Interests Assessment.
- **[PLACEHOLDER: account/payments → contract.]**
- Note: special-category data requires an Art 9 condition — avoid collecting it.

## 3.5 PH-DPA privacy notice content **[REQUIRED][PH-DPA]**
Per **NPC Circular No. 2023-04** (issued 7 Nov 2023, effective ~29 Nov 2023; compliance deadline 27 May 2024), the "minimum specific information" to disclose at the point of consent is: description of the personal data; the **purpose, nature, extent, duration, and scope** of processing; the **identity of the PIC**; the **existence of data-subject rights and how to exercise them**; and the **identity of the DPO**. Use **layered + just-in-time notices as the default format**, and an **"at set-up notice"** (shown before the user installs the app/PWA). Honor the three principles — transparency, legitimate purpose, proportionality. Withdrawal of consent must be **"as easy as, if not easier than, giving consent"** and use the same interface in which it was given.

## 3.6 CCPA disclosures **[REQUIRED][CCPA]**
- Right to know/access; right to delete; right to correct; right to opt-out of sale/share; right to non-discrimination.
- **Even if you do NOT sell data**, explicitly state "we do not sell or share your personal information" — the disclosure is still required.
- Provide at least two contact methods (email-only acceptable for an online-only business). Honor GPC.

## 3.7 Data subject rights — all jurisdictions **[REQUIRED][GLOBAL]**
Access, rectification/correction, erasure/deletion, restriction, objection, portability, withdraw consent, and lodge a complaint (EU supervisory authority / NPC). Response time: GDPR one calendar month; describe the request mechanism.

## 3.8 Data retention **[REQUIRED][cross-ref Docs 1 & 2]**
- Local Dexie.js: 3-month rolling window, auto-purge, encrypted.
- Server-side anonymous logs: state a retention period or the criteria used (GDPR requires period or criteria).
- Delete on purpose completion (PH-DPA requires disposal once the collection purpose is served).

## 3.9 Third-party processors **[REQUIRED][GLOBAL]**
Disclose categories/names of analytics + error-logging services. **[PLACEHOLDER: name the actual processors — e.g., the chosen error-logging service (such as Sentry), analytics provider, and hosting provider]** with links to their policies. PH-DPA: the PIC remains accountable for its processors (Sec 21).

## 3.10 International data transfers **[REQUIRED][GDPR][PH-DPA]**
- **GDPR:** if any processor is outside the EEA, use the **2021 Standard Contractual Clauses** (Commission Implementing Decision (EU) 2021/914) plus a transfer impact assessment (post-*Schrems II*). List adequacy-decision countries where relevant.
- **PH-DPA Sec 21:** the operator remains responsible for data transferred to third parties "whether domestically or internationally" and must use "contractual or other reasonable means to provide a comparable level of protection." Reference **NPC Advisory No. 2024-01** (Model Contractual Clauses for cross-border transfers).
- **OFW context:** Filipino users abroad are covered by the DPA's extraterritorial reach (data of Philippine citizens/residents).

## 3.11 Children's privacy **[REQUIRED][GLOBAL]**
Minimum-age statement (18 recommended); no knowing collection from under-13 (COPPA — up to $53,088/violation); GDPR-K 16/13; delete on discovery of an underage user. **[PH-DPA: minor data is sensitive.]**

## 3.12 Security measures **[REQUIRED][GLOBAL]**
JWT auth + HttpOnly cookies; TLS/HTTPS; Dexie encryption-at-rest (tweetnacl); access controls; no PII in tokens. State that no method is 100% secure. PH-DPA requires organizational, physical, and technical measures.

## 3.13 Cookies / tracking technologies **[REQUIRED][cross-ref Doc 1]**
Summarize categories; link to the cookie policy.

## 3.14 DPO / contact & NPC registration **[REQUIRED][PH-DPA]**
- Provide DPO contact + a **dedicated DPO email** (required by NPC Circular 2022-04).
- **NPC registration (Circular 2022-04) is mandatory if:** the entity employs **≥250 persons**; OR processes **sensitive personal information of ≥1,000 individuals**; OR processing is **likely to pose a risk to the rights/freedoms** of data subjects; OR involves **automated decision-making/profiling** (always, regardless of thresholds). A financial app processing sensitive data at scale likely triggers registration; below the thresholds, file the sworn declaration or register voluntarily. **Designating a DPO is always required** regardless of registration status. Breach notification to the NPC + affected subjects within **72 hours**.
- ⚠️ attorney/DPO review of the registration trigger.

## 3.15 Breach notification **[REQUIRED][GLOBAL]**
GDPR: 72h to the supervisory authority; PH-DPA: 72h to the NPC + affected subjects (where sensitive info or identity-fraud/serious-harm risk); CCPA: data-breach private right of action.

## 3.16 Policy updates & effective date **[REQUIRED][GLOBAL]**
Last-updated date; notice of material changes; CCPA expects annual review.

## 3.17 Framework placeholders
- **[PLACEHOLDER: OAuth login data]**
- **[PLACEHOLDER: GCash/Maya integration data flows]**
- **[PLACEHOLDER: payment data — PCI-DSS considerations]**
- **[PLACEHOLDER: subscription billing data]**

---

## Recommendations (staged, with thresholds)

**Stage 1 — Before any public launch (MVP, no accounts yet):**
1. Ship the geo-aware consent banner with pre-consent script/storage blocking, equal-prominence Reject All, and a consent log. Publish a Cookie Policy, Privacy Policy, and ToS, cross-referenced and version-stamped.
2. Implement JWT refresh-in-HttpOnly-cookie + access-token-in-memory, CSRF protection, and Dexie encryption with non-indexed sensitive fields and the 3-month purge job.
3. In the Privacy Policy, name the actual analytics/error-logging processors and state plainly "we do not sell or share personal information" (CCPA). Designate a DPO and publish a dedicated DPO email.
4. Set governing law to the Philippines with mandatory arbitration language and a consumer carve-out for EU/CA users.

**Stage 2 — When you add server-side accounts or sync financial data:**
- Re-map GDPR lawful bases (account/payments → contract); re-issue NPC notices; **re-assess NPC registration** — once you process sensitive personal information of **≥1,000 individuals**, registration via NPCRS becomes mandatory (the threshold that most likely flips first for a finance app). Add SCCs for any non-EEA processor.

**Stage 3 — When you add OAuth, GCash/Maya, or subscriptions:**
- Fill each [PLACEHOLDER] with concrete data-flow disclosures, third-party terms references, and (for payments) PCI-DSS scope. Add provider cookies to the cookie table.

**Benchmarks that change the plan:** crossing **1,000 sensitive-PII subjects** or **250 employees** → mandatory NPC registration; introducing **profiling/automated decisions** → mandatory NPC registration regardless of size; serving **EU/UK users** → opt-in consent is non-negotiable; **selling/sharing** data or running ads → CCPA opt-out link + IAB TCF/Consent Mode becomes necessary.

---

## Caveats

- **Not legal advice; attorney review required.** These are implementation frameworks. A licensed attorney — ideally PH-qualified with data-privacy and cross-border expertise — must review liability caps, arbitration clauses, age-gating, the NPC registration trigger, lawful-basis mapping, and SCC selection before publishing.
- **Dates and thresholds verified to June 2026** but regulations move: the ePrivacy Regulation withdrawal (Feb 2025), the amended COPPA Rule (effective June 23, 2025; full compliance April 22, 2026), CNIL's 2025 fines, and NPC Circulars 2022-04/2023-04 and Advisory 2024-01 are current as cited, but confirm against primary sources at publication time.
- **The "strictly necessary" classification of locally-stored financial data is a reasonable interpretation, not settled law** — regulators scrutinize over-broad "necessary" labels, so disclose it transparently and obtain consent if in doubt.
- **CMP "build your own" is acceptable here only because the cookie footprint is small**; if marketing/advertising cookies or programmatic ads are added later, a TCF-registered managed CMP becomes the safer path.
- **Effective-date nuance:** NPC Circular 2023-04's text states only a "15 days after publication" rule; the 29 Nov 2023 effectivity and 27 May 2024 compliance deadline derive from law-firm analyses and the 180-day transitory period — verify before relying on the exact dates.