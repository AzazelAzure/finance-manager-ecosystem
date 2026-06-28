# Legal Framework Scope Analysis — thehivemanager.com

> **Purpose:** Maps the three legal framework documents against actual current app state. Determines what is IN SCOPE now vs what is PLACEHOLDER/deferred. Flags critical gaps and cross-plan issues. Use this as the implementation checklist when writing the actual ToS/Privacy/Cookie documents.

**Analyzed:** 2026-06-26  
**Against:** `feat-celery-observability` §10, `feat-f014-usage-monitoring-notify`, `strategy/current_status.md`, `strategy/projections/success_projection_2026-06.md`  
**Source framework:** `compass_artifact_wf-...md` (three documents combined)

---

## Current App State (for scoping)

> ⚠️ **Correction 2026-06-27:** Original entry for "Financial data" was wrong. See corrected entry below.

| Factor | Current reality |
|---|---|
| Users | Single-digit; PH family + US Honorary Founders (passive) |
| Market | PH primary; no EU/UK presence |
| Auth | JWT — storage mechanism needs audit (see §Critical Gaps #1) |
| Account PII stored | Username + email + hashed password ONLY. No real name, no phone. Server-side (live now). |
| Financial data | **Dual-write model:** user-entered data written simultaneously to server API AND Dexie.js IndexedDB. Operator receives and stores financial transaction data. Dexie copy is an offline mirror (3-month auto-purge). NOT a sync — concurrent write. |
| Server-side analytics | Redis counters → flat JSON files; hashed IP (salted SHA256); UUID refs; no raw PII |
| Error logging | F-013 Loguru per-UUID disk files; pseudonymous; retention TBD (Cursor audit needed) |
| Third-party processors | Namecheap VPS (phoenixNAP, Phoenix AZ, USA) + Cloudflare (Singapore PoP). No third-party analytics. |
| OAuth | Not implemented; Google confirmed future; Facebook pending research |
| Payments | Not implemented; deliberately deferred to mid-2027 |
| Account deletion | Functional server-side: deletes all user data including financial data; UUID-keyed error logs exempt (no PII in them) |
| Employees | 1 (solo founder) |
| PH → US data transfer | ACTIVE — VPS is in Phoenix AZ; all server-side data (account + financial) is in USA; requires NPC Advisory 2024-01 disclosure |

---

## Document 1 — Cookie, Auth & Consent

### IN SCOPE NOW (must be done before S1.B exit)

| Section | Requirement | Action |
|---|---|---|
| §1.1 | PH-DPA consent baseline | Cookie/consent notice required; consent must be freely given, specific, informed |
| §1.3 | Classify cookie/storage categories | Strictly necessary (JWT, CSRF, consent store) + functional (Dexie financial data) — that's it currently; analytics/marketing categories are EMPTY |
| §1.4 | JWT technical requirements | **See Critical Gap #1** — audit current JWT storage; if still in localStorage, switch refresh token to HttpOnly cookie |
| §1.5 | Dexie.js disclosure | Must disclose: local-only, encrypted, 3-month window, auto-purge, operator does NOT receive data |
| §1.6 | Cookie/storage audit table | Enumerate: JWT session cookie (if switched), CSRF cookie, consent store, Dexie IndexedDB, SW cache |
| §1.8 | Cookie policy page contents | Required; footer link |
| §1.10 | Implementation checklist | JWT HttpOnly/Secure/SameSite; Dexie encryption key not in localStorage; 3-month purge job |

### OUT OF SCOPE / DEFERRED

| Section | Why deferred |
|---|---|
| §1.1 EU ePrivacy / GDPR opt-in cookie banner | No EU/UK users; not required now. Flag for S1.D if EU traffic emerges |
| §1.1 CCPA opt-out + GPC | No California users at meaningful scale. **However:** "we do not sell" statement is still required even without a full CCPA banner — add to Privacy Policy as a single line |
| §1.2 Full geo-targeted banner (EU opt-in / CA opt-out) | Overkill at current scale. A single PH-first consent notice is sufficient now |
| §1.7 Managed CMP (CookieYes, Termly, iubenda) | Cookie footprint is tiny (strictly necessary + functional only). Self-built consent layer acceptable. Revisit if marketing cookies ever added |
| §1.9 OAuth cookies | Not implemented |

### SIMPLIFIED RECOMMENDATION FOR NOW
A single consent layer is sufficient: disclose strictly-necessary cookies (JWT, CSRF, consent store) as exempt; disclose Dexie local storage as functional; no analytics/marketing categories to gate. No geo-targeting needed yet. Build a minimal self-contained consent disclosure, not a full CMP.

---

## Document 2 — Terms of Service

### IN SCOPE NOW

| Section | Requirement | Notes |
|---|---|---|
| §2.1 | Clickwrap acceptance + logging | Timestamp + version logged |
| §2.2 | Minimum age 18 | PH contractual capacity; COPPA "no under-13" statement required given passive US users |
| §2.3 | "Not a financial advisor" disclaimer | **Critical — must be prominent.** App calculates safe-to-spend figures; fiduciary/advice disclaimer is non-negotiable |
| §2.4 | No fiduciary duty; user responsible for data accuracy | Include "projections are not guarantees" for any budgeting/forecasting output |
| §2.5 | User accounts + responsibilities | Basic credential hygiene requirements |
| §2.6 | Acceptable use policy | Standard prohibitions |
| §2.7 | Intellectual property | Operator owns app; user retains rights to their own financial data |
| §2.8 | Disclaimer of warranties + liability cap | **See Critical Gap #2** — enforceability under PH consumer law needs attorney review |
| §2.9 | Offline data storage disclosure | Dexie.js encrypted local storage; device-side only; 3-month purge; user responsible for device security |
| §2.10 | Data retention + deletion rights | 90-day rolling for server logs (per observability plan); account deletion mechanism needed |
| §2.11 | Termination | Standard; effect on local + server data |
| §2.13 | PH-DPA specific clauses | Reference RA 10173 data-subject rights; DPO contact |
| §2.14 | Governing law: Philippines | Mandatory arbitration (use mandatory language — see PH Supreme Court April 2025 ruling flagged in doc) |
| §2.17 | Severability, entire agreement, force majeure, changes notice | Standard |

### OUT OF SCOPE / DEFERRED

| Section | Why deferred |
|---|---|
| §2.12 GDPR-specific right-to-erasure/portability in ToS | No EU users. Include a generic "data subject rights" clause cross-referencing Privacy Policy — don't need full GDPR ToS language |
| §2.15 GCash/Maya/payment integration | Not implemented; **[PLACEHOLDER] only** |
| §2.16 OAuth, payment processing, premium subscription billing, EU 14-day withdrawal | Not implemented; **[PLACEHOLDER] only** |

### ONE IMPORTANT FLAG — §2.14 Arbitration Language
The document notes a PH Supreme Court ruling (April 2025) that **permissive** arbitration wording ("shall have the right to") is NOT binding — mandatory language ("shall be resolved through arbitration") is required. This is a specific local nuance that must be in the actual ToS copy. Note for attorney review.

---

## Document 3 — Privacy Policy

### IN SCOPE NOW

| Section | Requirement | Notes |
|---|---|---|
| §3.1 | Controller identification | Operating entity name, PH address, email; DPO contact — **See Critical Gap #3** |
| §3.2 | Data currently collected | Anonymous usage (Redis counters — technically pseudonymous due to hashed IP); error logs (Loguru UUID-keyed); Dexie financial data (device-local, operator does NOT receive) |
| §3.4 | Lawful basis (GDPR-adjacent) | Service delivery → contract; server-side analytics (hashed IP, UUID) → legitimate interest (aggregate/pseudonymous) OR consent. Given PH-DPA framing, purpose limitation + transparency is the mechanism rather than Art 6 basis labeling |
| §3.5 | PH-DPA NPC Circular 2023-04 notice | Layered notice required; "at set-up notice" before PWA install |
| §3.6 | CCPA "we do not sell" statement | Required even without selling — one line |
| §3.7 | Data subject rights (access, deletion, correction, objection) | Response mechanism; 1 calendar month for GDPR-adjacent response time |
| §3.8 | Data retention | Server logs: 90-day rolling; Dexie: 3-month device-side with auto-purge; state criteria |
| §3.11 | Children's privacy | Age 18 minimum; no knowing collection from under-13 (COPPA — US honorary founders trigger this) |
| §3.12 | Security measures | JWT auth; TLS; Dexie encryption; no PII in tokens |
| §3.13 | Cookies/tracking cross-reference | Link to Cookie Policy |
| §3.14 | DPO contact + NPC registration status | DPO designation required regardless of registration; **See Critical Gap #3** |
| §3.15 | Breach notification | 72h to NPC + affected subjects |
| §3.16 | Policy updates + effective date | Version stamp + last-updated date |

### OUT OF SCOPE / DEFERRED

| Section | Why deferred |
|---|---|
| §3.3 Placeholders (account sync, OAuth, payments) | Not implemented; mark clearly as [PLACEHOLDER] |
| §3.9 Third-party processors | **Currently NONE** — no third-party analytics, no Sentry, no external error logging. This is actually a strong privacy position. Disclose only: VPS hosting provider. Everything else is first-party |
| §3.10 International data transfers / SCCs | No significant cross-border processor transfers identified. VPS hosting location disclosure is sufficient now |
| §3.14 NPC registration | Below 1,000 sensitive PII threshold — not required now. **Checkpoint: when user base approaches 500 meaningful accounts, revisit** |
| §3.17 OAuth, GCash/Maya, payment, subscription data | Placeholders only |

---

## Critical Gaps (fix before publishing)

### Gap #1 — JWT Storage Mechanism (cross-plan: API security + Cookie consent)
**Status: UNKNOWN.** The legal framework requires refresh tokens in HttpOnly + Secure + SameSite cookies. The current app may still use localStorage. This affects:
- Cookie consent category classification (if HttpOnly cookie: strictly necessary; if localStorage: still functional but different disclosure)
- Security posture (HttpOnly blocks XSS token theft)
- API security hardening plan should include a JWT storage audit

**Action:** Cursor agent to grep for JWT storage in `finance_manager_web` and `finance_manager_api` before writing the cookie policy. If localStorage: add JWT cookie migration to the API security hardening plan scope.

### Gap #2 — Liability Cap Enforceability (attorney review required)
PH Consumer Act (RA 7394) limits disclaimer enforceability against consumers. The liability cap and warranty disclaimer cannot be "as-is" boilerplate for PH users — needs a qualified PH attorney to review and calibrate. **Do not publish liability clauses without this review.**

### Gap #3 — DPO Designation ✅ RESOLVED 2026-06-26
`privacy@thehivemanager.com` created on Proton domain. HitM (Patrick Proctor) is the designated DPO.
- Disclose this address in both ToS and Privacy Policy when published
- This address is inbound/contact only — not used for automated Celery outbound

### Gap #4 — Hashed IP as "Personal Data"
The observability plan collects salted SHA256 hashed IPs. The legal framework notes that "hashed IPs/device identifiers can still be personal data." Our salted hash is non-recoverable — this is the "reasonable interpretation" caveat. However, in the privacy policy, disclose it transparently and note it is a one-way salted hash not linked to any identity. Don't call it "anonymous" — call it "pseudonymous technical identifier used for security event correlation."

### Gap #5 — Dexie Encryption Key Location
Framework requires the Dexie encryption key NOT be in localStorage or cookies. Current implementation unknown. Cursor agent must verify before the privacy policy states encryption-at-rest is in place.

---

## What Doesn't Apply At All (safely ignore)

- **EU ePrivacy geo-targeted opt-in banner** — no EU users
- **SCCs (Standard Contractual Clauses)** — no EU-jurisdiction transfers identified
- **IAB TCF / Google Consent Mode v2** — no ad tech, no programmatic advertising
- **PCI-DSS** — no payment card data
- **NPC registration** — below threshold (revisit at ~500 accounts)
- **COPPA detailed compliance program** — include an age minimum + "no under-13" statement; full COPPA program is for intentional children's app operators, which this isn't
- **CalOPPA detailed compliance** — passive US users; include "we do not sell" and Do-Not-Track policy disclosure; full CalOPPA compliance program is disproportionate

---

## Implementation Priority

| Priority | Item | Status |
|---|---|---|
| P0 — Before any new invitees | Audit JWT storage location (Gap #1) | ⏳ Cursor audit needed |
| P0 — Before any new invitees | Designate DPO + create privacy@ address (Gap #3) | ✅ Done 2026-06-26 |
| P1 — Before S1.B exit gate | Publish ToS + Privacy Policy + Cookie Policy; clickwrap on account creation | 🔲 Parked — awaiting attorney |
| P1.5 — Before F-003 ships | Attorney review: does F-003 predictive output trigger NPC automated-profiling registration? | 🔲 Parked — attorney contact |
| P2 — Before S1.C (first paying users) | Attorney review: liability cap (Gap #2); subscription billing clauses; refund policy | 🔲 Parked — attorney contact |
| P3 — When user base approaches 500 | Re-assess NPC registration trigger | 🔲 Future checkpoint |
| Defer | PLACEHOLDER sections — fill when features exist | — |

**Parked standby note (2026-06-26):** HitM has a PH attorney contact. Legal review items will be addressed in the months approaching either entity creation or the F-003 Predictive Budgeting launch, whichever comes first. These are seated action items — not forgotten, not blocking current sprint.

**Gaps remaining open:**
- Gap #1 — JWT storage audit (Cursor, no attorney needed)
- Gap #2 — Liability cap enforceability (attorney)
- Gap #4 — Hashed IP disclosure language (governance, no attorney — use "pseudonymous security identifier")
- Gap #5 — Dexie encryption key audit (Cursor, no attorney needed)

---

## New Open Items (from HitM comments 2026-06-27)

| # | Item | Owner | Priority |
|---|---|---|---|
| N1 | **Financial advice line-drawing** — App will offer basic financial literacy content (general principles, not stock market / Series-license tools); need legal definition of what constitutes "advice" in this context to correctly scope the disclaimer | Attorney | Before any literacy content is published |
| N2 | **Clickwrap + ToS/Privacy links in cookie banner** — §2.1 requires ToS acceptance + Privacy Policy link be present in the cookie/consent banner at account creation | Cursor | P1 (before S1.B exit) |
| N3 | **Future: auto-transaction logging via SMS/bank data** — When/if Stripe, GCash/Maya, or Android SMS integration is added, the "user is responsible for accuracy of entered data" clause becomes inaccurate; requires ToS amendment + new PLACEHOLDER | Architecture note | Flag at integration design time |
| N4 | **Dexie opt-out mechanism** — Users must be able to opt out of Dexie local storage; data subject rights require this; mechanism not yet designed | Cursor + design | P1 — before policy publication |
| N5 | **Multi-user single PWA instance gap** — Two users sharing one device/browser would share a Dexie instance; legally and operationally unresolved; requires either per-user Dexie namespacing or explicit policy disclosure that each Dexie instance is scoped to one browser/device | Cursor + attorney | P1.5 — before scale |
| N6 | **F-013 Loguru retention policy** — Retention period unknown; must be confirmed before §3.8 can be published; Cursor audit needed | Cursor | P1 |
| N7 | **§3.8 data retention compliance tiering** — HitM requests a 0-5 tier audit of each data retention item: 0=not operational, 5=fully operational AND compliant. Items below 5 need a note on what's required to reach compliance. | Claude Code (briefing) | Morning meeting deliverable |
| N8 | **Age gate implementation** — Front-end accept/reject only; NOT stored or verified; policy must explicitly state age is self-declared and not independently verified | Cursor + policy | P1 |
| N9 | **Facebook OAuth research** — Before adding as a PLACEHOLDER or committing, research FB OAuth requirements + privacy policy implications | HitM research | Before OAuth sprint |
| N10 | **PH → USA transfer disclosure** — VPS is Namecheap/phoenixNAP Phoenix AZ; active cross-border transfer; needs NPC Advisory 2024-01 reference in privacy policy §3.10 | Attorney + policy | P1 |
| N11 | **§2.9 disclosure correction** — Original draft said data doesn't leave device; incorrect; ToS §2.9 must be rewritten to reflect dual-write model with accurate data-loss risk statement | Cursor + attorney | P1 |
| N12 | **Account creation wizard revamp** — HitM notes this needs eventual revamping (age gate, consent flow); not current sprint scope; flag for S1.C | Cursor | S1.C |
