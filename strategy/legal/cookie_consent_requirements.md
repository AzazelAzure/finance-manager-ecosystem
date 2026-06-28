# Cookie, Authentication & Consent Implementation Requirements

> **Source:** Extracted from `compass_artifact_wf-...md` — three-document legal framework  
> **Scope annotations added:** 2026-06-26 against actual implementation state  
> **Status:** Framework only — NOT legal text; attorney review required before publishing  
>
> **SCOPE KEY:** `[NOW]` = required before S1.B exit · `[CYA]` = keep for legal baseline coverage even if not primary market · `[PLACEHOLDER]` = deferred until feature exists · `[SKIP]` = genuinely out of scope for this product

---

## Key Findings (Cookie-relevant)

- Opt-in vs opt-out is jurisdictional and must be geo-targeted. EU ePrivacy Directive + GDPR require prior affirmative consent for non-essential storage. California uses opt-out with GPC honoring. PH requires freely given, specific, informed consent with layered/just-in-time notices.
- Enforcement is real: CNIL fined Google €325M (Sept 2025) and American Express Carte France €1.5M (Nov 2025) — the latter specifically because withdrawn-consent cookies kept firing.
- **2026 JWT gold standard:** access token in memory, refresh token in HttpOnly + Secure + SameSite cookie, with rotation and revocation — never PII in the token, never tokens in localStorage. **[Gap #1 — audit current implementation before writing this policy.]**
- Dexie.js: `dexie-encrypted` cannot encrypt indices; sensitive fields must not be indexed; encryption key must never live in localStorage or cookies. **[Gap #5 — verify current Dexie key storage before stating encryption-at-rest is in place.]**
- ePrivacy Regulation was withdrawn by the European Commission (Feb 2025) — design to the ePrivacy **Directive** (still in force), not the abandoned Regulation.

---

## 1.1 Legal Baseline

- **[CYA][GDPR]** GDPR + ePrivacy Directive (Art 5(3), "EU Cookie Law") require prior opt-in consent before any non-essential cookie or local-storage write. ePrivacy is *lex specialis* over GDPR for storage/access. Legitimate interest **cannot** justify analytics or marketing cookies — those need explicit consent (EDPB Guidelines 05/2020). Keep as CYA baseline even with no current EU users.
- **[GLOBAL]** The EC withdrew the ePrivacy Regulation proposal (Feb 2025) — ePrivacy Directive 2002/58/EC and national transpositions remain in force. Design to the Directive.
- **[CYA][CCPA]** CCPA/CPRA opt-out model: cookies may load, but if data is sold/shared you must provide a "Do Not Sell or Share" mechanism and honor GPC. Add a one-line "we do not sell" statement regardless.
- **[CYA][CCPA]** CalOPPA: the privacy policy must disclose tracking and the site's Do-Not-Track response.
- **[NOW][PH-DPA]** Consent must be freely given, specific, informed, evidenced, and an indication of will (NPC Circular 2023-04). Cookies that process personal data need a lawful basis + notice.

---

## 1.2 What Makes a Consent Banner Compliant

- **[CYA][GDPR]** "Reject All" must be as easy and prominent as "Accept All"; no pre-ticked boxes (CJEU *Planet49*, C-673/17, 1 Oct 2019); no cookie walls; granular per-category toggles; withdrawal as easy as giving consent. EDPB Guidelines 03/2022 prohibit asymmetric or buried-reject designs as deceptive patterns.
- **[CYA][GDPR]** Block non-essential scripts/storage until opt-in (EDPB Guidelines 05/2020: no deposit before the user's choice).
- **[CYA][GLOBAL]** Geo-targeted logic: EU/EEA/UK users → opt-in; California users → opt-out + GPC; PH and other global users → notice + opt-in for non-essential.
- **[NOW]** Log consent: timestamp, pseudonymized identifier, consent text version, categories accepted/rejected; store securely.

> **Simplified recommendation for current scale:** Cookie footprint is tiny (strictly necessary + functional only; no analytics or marketing cookies). A minimal self-built consent disclosure is acceptable now — no managed CMP needed. Revisit if marketing/advertising cookies are ever added.

---

## 1.3 Cookie/Storage Categories to Classify `[NOW]`

Current state of each category:

| Category | Current status | Consent required |
|---|---|---|
| **Strictly necessary** — JWT session/refresh cookies (if HttpOnly), CSRF token, consent-preference store | Active (if JWT switched to HttpOnly cookie — see Gap #1) | Exempt from consent; still disclose |
| **Functional** — Dexie.js local financial data, UI preferences | Active (Dexie confirmed) | Disclose; arguably strictly necessary to deliver requested service |
| **Analytics** — usage counters, error logs | Active (Redis counters, Loguru F-013 logs) — but these are server-side only, no client-side tracking cookie | Server-side only; no cookie consent trigger for current implementation |
| **Marketing/Advertising** | Not implemented | **[PLACEHOLDER: reserve category; do not add without consent mechanism]** |

> **Note:** Current analytics (Redis counters, flat-file aggregation, Loguru UUID-keyed logs) are entirely server-side. No client-side analytics cookie or identifier is set. This significantly reduces cookie consent obligations — only strictly necessary + Dexie functional disclosure is needed now.

---

## 1.4 JWT Cookie Technical Requirements `[NOW]` — **Blocked on Gap #1**

**2026 gold standard:**
- **Access token in memory** (JS variable; recovered via silent refresh on page reload — never localStorage)
- **Refresh token in HttpOnly + Secure + SameSite cookie** scoped to `/auth/refresh`

**Required flags:**
- `HttpOnly` — blocks JS/XSS theft
- `Secure` — HTTPS only
- `SameSite=Strict` for the refresh cookie (or `Lax` as minimum default); `SameSite=None` requires `Secure` or browsers silently drop the cookie

**Other requirements:**
- Short access-token expiry; refresh-token rotation + reuse detection; `jti` denylist for revocation
- No PII in the JWT payload (it is base64, not encrypted). Validate `exp`, `iss`, `aud`; reject `alg:none` (RFC 8725 / OAuth BCP RFC 9700)
- Add CSRF tokens for state-changing routes when using cookie-borne tokens

> ⚠️ **Gap #1:** Current JWT storage location is UNKNOWN. Cursor agent must grep `finance_manager_web` for JWT storage before this cookie policy can accurately state which category the JWT falls into. If localStorage is currently used for the access token, the policy disclosure changes. If localStorage is used for the refresh token, that needs to be migrated to HttpOnly cookie — this belongs in the API security hardening plan.

---

## 1.5 Local Storage / Dexie.js (PWA offline) `[NOW]`

- IndexedDB/Dexie writes are "storage of information on terminal equipment" → covered by ePrivacy if non-essential. Storing the user's own financial data to deliver the requested service is arguably strictly-necessary/functional, but **must still be disclosed**.
- `dexie-encrypted` (default tweetnacl) encrypts non-indexed fields but **cannot encrypt indices** — do NOT index sensitive fields.
- The encryption key must **not** be stored in localStorage or cookies; derive it from a user secret (KDF) or fetch from the authenticated backend.
- **Required disclosure:** 3-month local retention window, encryption-at-rest, device-side-only storage, auto-purge logic, operator does NOT receive financial data server-side.

> ⚠️ **Gap #5:** Dexie encryption key location in current implementation is UNKNOWN. Cursor agent must verify before the privacy policy can state encryption-at-rest is in place.

---

## 1.6 Cookie/Storage Audit — Disclose Everything `[NOW]`

Enumerate with name / type / purpose / duration / first-or-third-party:

| Item | Type | Purpose | Duration | Party |
|---|---|---|---|---|
| JWT refresh cookie (if implemented) | HttpOnly cookie | Auth session | Per rotation policy | First |
| CSRF token | Cookie | CSRF protection on state-changing routes | Session | First |
| Consent preference store | localStorage or cookie | Remember consent choices | 1 year | First |
| Dexie/IndexedDB | IndexedDB (not a cookie) | Local encrypted financial data | 3-month rolling auto-purge | First |
| Service Worker cache | Cache API | PWA offline support | Managed by SW lifecycle | First |
| **[PLACEHOLDER: OAuth provider cookies]** | TBD | OAuth session | Provider-defined | Third |

> **Note:** No third-party analytics, ad, or error-logging service cookies currently exist. This is a clean slate — do not overcomplicate the disclosure.

---

## 1.7 CMP — Build vs Buy `[NOW]`

A compliant CMP must: block pre-consent scripts, offer granular categories, store tamper-evident consent logs (timestamp + version), support easy withdrawal, geo-target banners, and support GPC.

For solo developer with small cookie footprint: **self-built consent layer is acceptable** given this app's current cookie profile (strictly necessary + functional Dexie only). A self-built layer must replicate:
- Consent logging (timestamp + version + categories)
- Pre-consent script/storage blocking (currently less relevant since no third-party analytics)
- Withdrawal mechanism

Managed CMP (CookieYes, Termly, iubenda) becomes the safer path if marketing/advertising cookies are ever added.

---

## 1.8 Cookie Policy Page Contents `[NOW]`

Required elements:
- Definition of cookies/storage
- Categories in use (see §1.6 table)
- Per-cookie/storage table with purposes, durations, first/third-party
- How to withdraw/change consent
- Link from footer and from consent banner
- Last-updated date

---

## 1.9 OAuth Placeholders `[PLACEHOLDER — maintain for future OAuth feature]`

- Store nothing from OAuth flow in localStorage; validate the ID token properly
- OAuth provider may set its own cookies — these must be disclosed in the cookie table once implemented
- Add the OAuth provider to both the cookie table and the privacy policy's processors list
- **This section must be completed when OAuth login is implemented** — do not remove, just fill in

---

## 1.10 Implementation Checklist (Agent-Actionable)

### NOW (before S1.B exit or first new invitees)
- [ ] **Gap #1 audit:** Cursor agent greps `finance_manager_web` for JWT storage location
- [ ] If localStorage used: migrate refresh token to HttpOnly + Secure + SameSite cookie (add to API security hardening plan scope)
- [ ] **Gap #5 audit:** Verify Dexie encryption key is not in localStorage or cookies
- [ ] Write cookie policy page with §1.6 table
- [ ] Add footer link to cookie policy
- [ ] Basic consent disclosure (PH-first; minimal — cookie footprint is strictly necessary + functional Dexie only)
- [ ] Consent log store (timestamp, version, categories)

### CYA baseline (include in implementation for legal coverage)
- [ ] Geo-targeted banner mode (EU opt-in; CA opt-out + GPC; PH/global notice + opt-in for non-essential)
- [ ] Equal-prominence Reject All (even if there's currently nothing to reject beyond Dexie functional)
- [ ] GPC signal listener
- [ ] "We do not sell" statement in privacy policy (§3.6 — CCPA even without selling)
- [ ] Do-Not-Track disclosure in privacy policy (CalOPPA)

### PLACEHOLDER — fill when feature exists
- [ ] OAuth provider cookies → add to §1.6 table and privacy policy processors list
- [ ] Marketing/advertising cookies → implement full CMP with managed solution (e.g., CookieYes) at that point

### Attorney review required
- [ ] Banner copy + category classification before publishing
- [ ] Confirm "functional" classification for Dexie local financial data is defensible under PH-DPA
