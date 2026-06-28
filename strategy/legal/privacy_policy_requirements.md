# Privacy Policy Requirements (Section-by-Section)

> **Source:** Extracted from `compass_artifact_wf-...md` — three-document legal framework  
> **Scope annotations added:** 2026-06-26 against actual implementation state  
> **Status:** Framework only — NOT legal text; attorney review required before publishing  
>
> **SCOPE KEY:** `[NOW]` = required before S1.B exit · `[CYA]` = keep for legal baseline even if not primary market · `[PLACEHOLDER]` = deferred until feature exists, but maintain the section · `[SKIP]` = genuinely out of scope for this product

---

## Key Findings (Privacy-relevant)

> ⚠️ **Architecture correction (2026-06-27, HitM comment):** The original framing — "financial data never leaves the device" — is INCORRECT. The actual model is **dual-write**: user-entered financial data is written simultaneously to both the server-side API and Dexie.js IndexedDB. This is NOT a sync; it is concurrent write at entry time. All privacy disclosures must reflect server-side financial data storage, not a local-only model. See §3.2 and §3.3 for corrected disclosure.

- **Actual data architecture:** Financial transaction data IS stored server-side. The strong privacy position is different: minimal PII (username + email only, no real name stored), no financial advisor relationship, no data sold, no third-party analytics. That's still a strong story — just an accurate one.
- **Hashed IPs are technically still "personal data"** under a strict GDPR/PH-DPA reading. Do not call the salted SHA256 hashed IP "anonymous." Call it a "pseudonymous security identifier" and disclose it transparently.
- **Third-party processors: minimal.** Namecheap VPS (phoenixNAP, Phoenix AZ, USA) + Cloudflare only. No third-party analytics, no Sentry, no external error logging. Disclose both explicitly.
- **DPO designation is always required** under NPC Circular 2022-04 — ✅ Done: `privacy@thehivemanager.com`, HitM designated DPO 2026-06-26.
- **72-hour breach notification** required by both GDPR (to supervisory authority) and PH-DPA (to NPC + affected subjects where sensitive info is involved or serious harm risk exists).

---

## 3.1 Controller Identification `[NOW]`

- Legal name of operating entity
- PH address
- Contact email (operator/support — NOT automated system aliases)
- DPO name and dedicated DPO email — **Gap #3: designate `privacy@thehivemanager.com`; add this Proton address before publishing**
- Cross-reference: ToS §2.17 contact information

---

## 3.2 Data Currently Collected `[NOW]`

Disclose each category accurately:

| Data | Description | Server-side? | Operator receives? |
|---|---|---|---|
| Username | Account identifier; not a real name | Yes (account record) | Yes |
| Email address | Account login; contact address | Yes (account record) | Yes |
| Hashed password | bcrypt/similar hash; raw password never stored | Yes (account record) | No (hash only) |
| Financial transaction data | User-entered income, expenses, categorizations, budgets | **Yes (dual-write — server + Dexie simultaneously)** | Yes |
| Pseudonymous security identifier (hashed IP) | Salted SHA256 of client IP; 16 hex chars; non-recoverable; security event correlation only | Yes (Redis counters → flat files) | Yes |
| User UUID | Pseudonymous account reference; not linked to name/email in logs | Yes (F-013 Loguru, F-014 DAU/MAU) | Yes (aggregate only) |
| User agent class | Classified as bot/crawler/user/unknown; raw string NOT stored | Yes (Redis counters) | Yes (aggregate only) |
| API endpoint + method + response code | Usage analytics; paths normalized (UUIDs/IDs stripped) | Yes (Redis counters → flat files) | Yes |
| DAU/MAU counts | Aggregate; no individual tracking | Yes (F-014 models) | Yes |
| Invite chain | UUID pairs only (inviter UUID + invitee UUID); no names/emails | Yes (F-014 InviteChainEvent) | Yes |
| Error/diagnostic logs | UUID-keyed Loguru files (F-013); per-device diagnostic traces | Yes (disk, VPS) | Yes (operator access only) |
| **Local encrypted financial data (Dexie copy)** | Dexie.js IndexedDB mirror; device-side; encrypted; 3-month auto-purge | No (device-only copy) | No (device copy not transmitted) |

> **Corrected statement (2026-06-27):** Financial transaction data entered by the user IS stored on the operator's server as well as locally on the device (dual-write model). The Dexie.js copy is a local mirror for offline access. The operator does NOT collect or store the user's real name, phone number, or other identity PII beyond username and email.

> **Retained strong privacy position:** No data is sold or shared. No third-party analytics. No advertising. Minimal PII (username + email only). Financial data is used solely to deliver the budgeting service.

---

## 3.3 Data Collected in Future `[PLACEHOLDER — maintain all sections]`

These sections must be filled when the corresponding feature is implemented. Do not remove — maintain as explicit PLACEHOLDER markers.

- ~~**[PLACEHOLDER: account data]**~~ → **LIVE NOW.** Account creation is server-side only. Stored fields: username, email, hashed password. No real name, no phone, no other PII collected. (Moved to §3.2 table.)
- ~~**[PLACEHOLDER: financial transaction data synced server-side]**~~ → **LIVE NOW (dual-write model).** User-entered data is written to both server API and Dexie simultaneously. Not technically a "sync" (no sync event; written concurrently at entry). Legally treated the same as server-side storage. (Moved to §3.2 table — see architecture correction in Key Findings.)
- **[PLACEHOLDER: Google OAuth login]** — confirmed future feature; disclose Google as provider, data received (sub, email, profile), retention, and add to §3.9 processors list when implemented
- **[PLACEHOLDER: Facebook OAuth login]** — pending research on Facebook OAuth requirements and long-term privacy policy implications before committing; do NOT add as confirmed placeholder yet
- **[PLACEHOLDER: GCash/Maya/payment + billing data]** — when payment processing is added; PCI-DSS scope statement

---

## 3.4 Lawful Basis (GDPR Art 6) `[CYA]`

Map each purpose to ONE basis. Do not stack — the EDPB prohibits switching basis after the fact, and switching from consent to legitimate interest when consent is withdrawn is a recognized enforcement failure.

| Purpose | Lawful basis | Notes |
|---|---|---|
| Local Dexie financial data storage | **Contract** (Art 6(1)(b)) — storage is necessary to deliver the requested service | Justified as functional storage |
| Security event correlation (hashed IP) | **Legitimate interest** (Art 6(1)(f)) — security of the service, non-recoverable hash | Requires documented Legitimate Interests Assessment |
| Aggregate usage analytics (UUID, endpoint) | **Legitimate interest** (Art 6(1)(f)) — purely aggregate/pseudonymous statistics | Requires documented LIA |
| Error/diagnostic logs (F-013, UUID-keyed) | **Legitimate interest** (Art 6(1)(f)) — service reliability | Requires documented LIA |
| **[PLACEHOLDER: account/payments]** | **Contract** (Art 6(1)(b)) | Fill when implemented |

> **PH-DPA framing:** PH-DPA uses purpose limitation + transparency + proportionality rather than Art 6 basis labeling. The disclosure itself is the mechanism — but mapping to GDPR bases supports CYA multi-jurisdiction coverage.

---

## 3.5 PH-DPA Privacy Notice Content `[NOW]`

Per **NPC Circular No. 2023-04** (issued 7 Nov 2023; compliance deadline 27 May 2024), minimum required disclosure at point of consent:

- Description of the personal data collected
- Purpose, nature, extent, duration, and scope of processing
- Identity of the Personal Information Controller (PIC)
- Existence of data-subject rights and how to exercise them
- Identity of the DPO (see Gap #3 — `privacy@thehivemanager.com`) 

**Format requirements:**
- Layered + just-in-time notices as default format
- "At set-up notice" shown before the user installs/registers on the PWA
- Withdrawal of consent must be "as easy as, if not easier than, giving consent" using the same interface

**Three governing principles:** transparency, legitimate purpose, proportionality.

---

## 3.6 CCPA Disclosures `[CYA]`

Even with no current California users and without selling data, these statements are required:

- **"We do not sell or share your personal information"** — this disclosure is required even if you don't sell; the absence of selling must be stated explicitly
- Right to know/access; right to delete; right to correct; right to opt-out of sale/share; right to non-discrimination
- At least two contact methods (email-only is acceptable for online-only business)
- Honor GPC (Global Privacy Control) browser signal — link to Do-Not-Track disclosure
- CalOPPA: disclose how the app responds to Do-Not-Track signals

---

## 3.7 Data Subject Rights — All Jurisdictions `[NOW]`

Provide a response mechanism for:

| Right | Applies under |
|---|---|
| Right of access | GDPR, PH-DPA, CCPA |
| Right to rectification/correction | GDPR, PH-DPA, CCPA |
| Right to erasure/deletion | GDPR, PH-DPA, CCPA |
| Right to restriction of processing | GDPR |
| Right to objection | GDPR, PH-DPA |
| Right to data portability | GDPR, PH-DPA |
| Right to withdraw consent | GDPR, PH-DPA |
| Right to lodge a complaint | GDPR (supervisory authority), PH-DPA (NPC) |

**Response time:** GDPR → one calendar month; PH-DPA → within a reasonable period (15 business days is standard practice). Describe the request mechanism in the policy (email the DPO at `privacy@thehivemanager.com`).

[HitM comment: We will need to make mechnisms for Dexie storage opt out and ensurance that this data is opted out from.  Will require delicate handling and potential adjustments to other areas of this policy for multiple users within a single system.  While unlikely, it is still potentially possible two users use one intance of the PWA on one machine, which would require two different dexies.  This is a notable gap in both operations and legal requirements.]

---

## 3.8 Data Retention `[NOW]`

| Data | Retention | Basis |
|---|---|---|
| Local Dexie financial data | 3-month rolling window; device-side auto-purge | Functional necessity; user can manually clear |
| Server-side pseudonymous logs (Redis, flat files) | 90-day rolling retention (per observability plan) | Security + aggregate analytics |
| F-013 Loguru diagnostic logs | TBD — confirm retention policy with Cursor before publishing | Diagnostic necessity |
| DAU/MAU aggregate counts | Indefinite (no PII) | Business analytics |
| Invite chain records | Indefinite (UUID pairs only, no PII) | Growth analytics |
| Account record | Deleted on account termination | Per user request |

**PH-DPA requirement:** dispose of data once the collection purpose is served. For log retention: state the criteria used (security/compliance period), not just the number of days.

[HitM comment: Will need to make a briefing report for which of these actually exist in current implementation, and in what status. We will tier these on a scale of 0-5, 0 being not at all, 5 being fully operational AND compliant. Each data point, if not compliant, will need a detailed note on what is required legally or operationally in order to meet compliance.]

---

## 3.9 Third-Party Processors `[NOW — current state; PLACEHOLDER for future]`

**Current processors (disclose only these):**

| Processor | Purpose | Data shared |
|---|---|---|
| Namecheap (Magnetar VPS) — phoenixNAP data center, Phoenix, Arizona, USA | App hosting + storage of all server-side data | Account records, financial transaction data, server logs, flat-file analytics, Loguru diagnostic logs |
| Cloudflare | CDN, DDoS protection, traffic routing | IP addresses (raw, not hashed — Cloudflare receives this), request metadata, CF-Ray identifiers |

[HitM comment: VPS is provided through namecheap, with no added aids or features.  Just a raw ubuntu vps, magnetar level.  location is 'phoenixNAP data center, Phoenix, Arizona, USA'.]

> **Note:** Cloudflare is confirmed in the traffic path (Singapore PoP, verified 2026-06-26). Cloudflare receives raw client IPs before our middleware hashes them. This must be disclosed. Cloudflare's privacy policy applies to traffic data they process.

**No other processors.** No third-party analytics service, no external error logging (e.g., Sentry), no advertising platform. This is a strong privacy position — state it explicitly.

**PLACEHOLDER sections (maintain):**
- **[PLACEHOLDER: OAuth provider]** — add when OAuth is implemented
- **[PLACEHOLDER: payment processor (PayMongo, Xendit, etc.)]** — add when payments are added
- **[PLACEHOLDER: GCash/Maya]** — add when integration exists

**PH-DPA:** The operator (PIC) remains accountable for data transferred to any processor, domestically or internationally (RA 10173 Section 21).

---

## 3.10 International Data Transfers `[CYA]`

- **[CYA][GDPR]** If any processor is outside the EEA: use 2021 Standard Contractual Clauses (Commission Implementing Decision (EU) 2021/914) + transfer impact assessment. Currently: Cloudflare (international) and VPS hosting provider are the only processors — list their data transfer mechanisms.
- **[NOW][PH-DPA]** Operator remains responsible for data transferred to third parties internationally (RA 10173 Section 21). Reference **NPC Advisory No. 2024-01** (Model Contractual Clauses for cross-border transfers).
- **OFW context:** Filipino users abroad are covered by PH-DPA's extraterritorial reach. This applies to Honorary Founders who may be traveling.
- **VPS location confirmed: USA (phoenixNAP, Phoenix AZ).** PH → USA data transfer is in play for all server-side data. Namecheap/phoenixNAP must be disclosed as the US-based processor. Reference NPC Advisory 2024-01 for cross-border transfer requirements — Philippines to USA is a known transfer requiring disclosure under RA 10173 Section 21.

---

## 3.11 Children's Privacy `[NOW]`

- **Minimum age: 18** (financial app; PH contractual capacity)
- "We do not knowingly collect information from persons under the age of 18"
- **[CYA][COPPA]** "We do not knowingly collect data from children under the age of 13" — required given passive US Honorary Founders
- **[PH-DPA]** Minor data is sensitive personal information — avoid collecting it; delete on discovery
- Describe discovery-and-deletion process
[HitM comment:  We may need to add an age selector on account creation (tangentally, account creation wizard will need some revamping entirely later, since it isn't exactly great.  Good for now, but that's a different issue).  This should only be handled on the front end for an accept/reject mechanism based on age, but we will not store or verify this.  We should make a note of that.]

---

## 3.12 Security Measures `[NOW]` — **Blocked on Gap #1 and Gap #5**

State (once Gaps #1 and #5 are confirmed):
- JWT authentication with HttpOnly + Secure + SameSite refresh cookie (if implemented — confirm Gap #1)
- TLS/HTTPS for all traffic (Cloudflare enforces this)
- Dexie.js encryption-at-rest for local financial data (confirm encryption key location — Gap #5)
- Access controls (operator-only access to diagnostic logs)
- No PII stored in JWT tokens
- IP hashing: salted SHA256, non-recoverable, used only for security event correlation
- Cloudflare DDoS protection and WAF baseline

**Required statement:** "No method of transmission over the internet or method of electronic storage is 100% secure. While we use commercially reasonable security measures, we cannot guarantee absolute security."

**[PH-DPA]** Organizational, physical, and technical security measures are required (RA 10173 Sec 20(f)).

---

## 3.13 Cookies / Tracking Technologies `[NOW]`

- Summarize categories (cross-reference Cookie Policy — `cookie_consent_requirements.md`)
- Link to the full Cookie Policy from this section
- Note: current tracking is server-side only (no client-side analytics cookie)

---

## 3.14 DPO Contact & NPC Registration `[NOW]` ⚠️ Gap #3 action required

**DPO Designation (required regardless of NPC registration status — NPC Circular 2022-04):**
- HitM (Patrick Proctor) is hereby the designated DPO at current scale
- Create `privacy@thehivemanager.com` on the Proton domain — this must exist before publishing
- Disclose DPO name and email in this section

**NPC Registration status (per NPC Circular 2022-04):**
- Registration is mandatory if: ≥250 employees OR processing sensitive personal information of ≥1,000 individuals OR processing likely to pose risk to data subject rights OR involves automated decision-making/profiling (always, regardless of size)
- **Current status:** below all numerical thresholds; registration not yet required
- **Checkpoint: when user base approaches 500 meaningful accounts** — re-assess; financial data may qualify as sensitive at that scale and trigger the ≥1,000 threshold earlier than expected
- **Automated profiling note:** F-003 Predictive Budgeting and any AI-driven features may trigger the "automated decision-making/profiling" registration requirement regardless of user count — ⚠️ attorney review before those features launch

**Breach notification:** 72 hours to NPC + affected subjects where sensitive information or identity-fraud/serious-harm risk exists (PH-DPA); 72 hours to supervisory authority (GDPR CYA).

---

## 3.15 Breach Notification `[NOW]`

| Jurisdiction | Requirement | Deadline |
|---|---|---|
| PH-DPA | Notify NPC + affected data subjects | 72 hours from discovery |
| GDPR (CYA) | Notify supervisory authority | 72 hours |
| CCPA | Data-breach private right of action applies to exposed non-encrypted data | Immediate notification to affected users |

Describe the notification process:
- DPO (`privacy@thehivemanager.com`) coordinates notification
- NPC notification via NPC's online reporting portal
- Affected subjects notified via registered email or in-app notification
- Breach log maintained

---

## 3.16 Policy Updates & Effective Date `[NOW]`

- Last-updated date on every published version
- Version numbering (e.g., `v1.0 — 2026-07-01`)
- Notice of material changes: in-app notification + email to registered users before effective date
- **CCPA:** Annual review expected
- Keep prior versions accessible with effective date ranges

---

## 3.17 Framework Placeholders `[PLACEHOLDER — maintain all]`

These sections must be filled when corresponding features are implemented. Do not remove.

- **[PLACEHOLDER: OAuth login data]** — provider name, data received (sub, email, profile), retention, purpose
- **[PLACEHOLDER: GCash/Maya integration data flows]** — transaction data, KYC data, what's shared with the aggregator/PSP
- **[PLACEHOLDER: payment data — PCI-DSS considerations]** — scope statement; what operator stores vs what payment processor handles
- **[PLACEHOLDER: subscription billing data]** — billing cycle, renewal dates, payment method tokens

---

## Implementation Sequence

**Before any new invitees (P0):**
1. Gap #3: Add `privacy@thehivemanager.com` to Proton domain; formally designate HitM as DPO [HitM Comment: Completed.]
2. Gap #1: Cursor agent audits JWT storage
3. Gap #5: Cursor agent verifies Dexie encryption key location
4. Confirm VPS hosting provider name for §3.9 processor disclosure

**Before S1.B exit gate (P1):**
5. Draft and publish Privacy Policy v1.0 using this framework
6. Disclose Cloudflare as processor in §3.9 (already confirmed in path)
7. Ensure ToS clickwrap logs timestamp + version

**Before F-003 Predictive Budgeting launches (P1.5):**
8. ⚠️ Attorney review: does F-003's predictive output qualify as "automated decision-making/profiling" triggering NPC registration regardless of user count?

**Before any paying users (P2):**
9. Attorney review of liability cap language (ToS §2.8)
10. PCI-DSS scope assessment when payment processor is selected
11. Fill PLACEHOLDER sections as applicable
