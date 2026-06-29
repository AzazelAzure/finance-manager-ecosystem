# Analytics & Data Sharing Overview

**Owner:** Claude Code (admin)  
**Last updated:** 2026-06-30  
**Status:** Draft — source material for Privacy Policy accuracy review and beta user trust comms  
**Related:** `governance/definition_of_done.md`, F-010 RCA (`strategy/audits/2026-06-29_share-link-exposure_rca.md`), F-013, F-014

---

## 1. Philosophy

Hive Finance Manager is built for users living on thin margins. The product's trust position depends on users believing their financial data is not being exploited — that it exists to serve them, not to monetize them. This is not a legal compliance document; it is a statement of intent and a record of what is actually true in the codebase today.

**What this means in practice:**
- No third-party analytics SDKs (no Google Analytics, Mixpanel, Segment, Meta Pixel, or equivalent)
- No behavioral profiling or ad targeting pipelines
- No data sold or shared with third parties
- Operator telemetry (what the operator can see) is diagnostic and operational, not commercial
- User data exports are user-initiated; no automated egress to external systems

---

## 2. Data We Collect

### 2a. Account Data
Stored in `AppProfile` (Django model, Postgres):

| Field | Purpose | User-visible |
|---|---|---|
| `email`, `username` | Identity and auth | Yes |
| `tos_version`, `tos_accepted_at` | Consent record (N2 clickwrap) | No (internal) |
| `BETA_FEATURE_REQUESTS` flag | Feature access gating | Indirectly (feature availability) |

### 2b. Financial Data
All financial data is user-entered and user-owned:

- Transactions, upcoming expenses, savings goals, bill cadences
- Balance history (computed from transaction records)
- Stored in Postgres; accessible only to the authenticated user and operator DB access

No financial data is transmitted to third parties. No enrichment, aggregation, or profiling is performed on financial records beyond what the user explicitly triggers (e.g., STS pay-cycle calculations).

### 2c. Offline / Local Storage (Dexie — IndexedDB)
The PWA caches financial data locally in the browser's IndexedDB via Dexie for offline read/write capability:

- Mirrors server-side transaction and balance data for offline access
- Outbox queue stores pending writes for sync when connectivity returns
- **Scoped to the authenticated user's session in that browser/device**

**Known gap (2026-06-30):** No functional opt-out mechanism exists yet. The Privacy Policy states opt-out is available, but the setting has not been built. This is a P1 Cursor task. Until resolved, all users have Dexie storage active.

**Known unknown (2026-06-30):** Multi-user behavior on a shared device (two accounts, same PWA/browser) is not fully characterized. Parked for investigation before any multi-user features ship.

### 2d. Diagnostic Logs (F-013)
Per-user Loguru log files with rotation, stored on the VPS:

- **Operator-visible only** — not surfaced to users in any UI
- Logs user actions at the application level (requests, errors, key state transitions) for debugging and support
- **PII posture:** Logs contain user IDs and action types; they should not contain raw financial amounts or full account data. Exact PII boundary should be confirmed in a Cursor review pass before any log-sharing or export tooling is built
- Retention policy: rotation-based (Loguru default); no explicit retention period set yet — this is a gap

### 2e. Support Submissions
Bug reports and feature requests submitted via the in-app support intake (F-012):

- Stored in the durable intake queue (Postgres) with rate-limiting (5-minute cooldown)
- User-submitted content only; not instrumented or analyzed beyond routing to operator
- Confirmation email sent to submitting user

### 2f. Consent Records
Captured at signup via the N2 clickwrap (shipped 2026-06-27):

- `tos_version` — version of ToS accepted (e.g., `"2026-06-27"`)
- `tos_accepted_at` — timestamp of acceptance
- Stored on `AppProfile`; persists through the account lifecycle

---

## 3. What We Do NOT Collect

This list is intended as an explicit trust signal for user communications:

| Category | Status |
|---|---|
| Third-party analytics SDKs (GA, Mixpanel, Segment, etc.) | **Not present** |
| Ad tracking pixels (Meta, Google Ads, TikTok, etc.) | **Not present** |
| Behavioral profiling or session recording (Hotjar, FullStory, etc.) | **Not present** |
| Device fingerprinting | **Not present** |
| Cross-site tracking cookies | **Not present** |
| Automated data export to third parties | **Not present** |
| AI/ML training on user financial data | **Not present** |
| Push notification opt-in without user action | **Not present** |

---

## 4. Data Export & Portability

### Current state
Two export mechanisms exist, both user-initiated:

| Export | Route | Output | Auth |
|---|---|---|---|
| Full backup (JSON) | `GET /finance/export/full-backup/` | All user data as JSON | JWT required |
| Transactions CSV | `GET /finance/export/transactions-csv/` | Transaction records | JWT required |

Both require a valid authenticated session. No public or unauthenticated access.

### F-010 Share Link (removed 2026-06-28)
A "Share Data" feature shipped with F-010 that generated public bearer URLs allowing unauthenticated access to a user's export. This was an architectural error — a public URL containing financial data with no expiry and no user-revocation UX. The feature was disabled and removed in production (route returns 404).

**Status as of 2026-06-30:** Route removed ✅ | Token revocation migration (`0018`) not yet applied ❌ — 1 stale token remains in `finance_exportsharetoken` table. Residual risk is low (no route to redeem), but cleanup is a pending Cursor P0 task.

### Future: Proper Data Portability
The *intent* behind F-010's share feature (user-authorized egress to another service) is valid and should be revisited — but with a proper auth model: user-authorized, time-limited, revocable tokens with explicit scope. This is parked long-term. CSV export covers current user needs.

---

## 5. Usage Monitoring (F-014 — Not Yet Built)

F-014 is in the plan registry as `ready` but not yet executed. Planned scope:

**Operator-visible (what the operator/admin sees):**
- Active user counts, DAU/WAU/MAU trends
- Feature adoption rates (which features are used, which aren't)
- Error rate and API health signals
- Celery task success/failure rates

**User-visible:**
- Potentially: a usage dashboard within the app (own data only)
- No behavioral comparison against other users

**What F-014 must NOT do:**
- No cross-user profiling for commercial purposes
- No data export to third-party analytics platforms without explicit consent
- Operator telemetry stays internal

The `analytics_and_data_sharing_overview.md` (this file) should be updated when F-014 is scoped and built to reflect what is actually implemented.

---

## 6. Consent Framework

| Touchpoint | Mechanism | Stored |
|---|---|---|
| Signup | N2 clickwrap (checkbox + ToS/Privacy Policy link) | `tos_version`, `tos_accepted_at` on `AppProfile` |
| Login | Legal footnote link (no re-consent required unless ToS version changes) | N/A |
| Offline storage | **Not yet implemented** — Dexie opt-out pending | N/A |
| Data export | User-initiated only; no separate consent required | N/A |

**Gap:** No mechanism exists to prompt re-consent on ToS version change. If the Privacy Policy or ToS is materially updated, the app cannot currently identify users who accepted the old version and present them with the new one. This should be a planned capability before S1.B exit.

---

## 7. Beta Context — Disclosure Posture

The current user cohort is an invite-only beta (PH family + US Honorary Founders). The following is the honest disclosure posture for communications with that cohort:

**What they should know:**
- Their financial data is stored securely on operator-controlled VPS infrastructure (no third-party cloud SaaS data stores)
- No behavioral analytics or ad tracking is in place
- Diagnostic logs exist for debugging and are operator-only
- The app caches their data locally in the browser for offline use (Dexie/IndexedDB)
- They can export all their data at any time via Settings → Export
- The app is in beta — the operator (HitM) can access the database for support purposes

**What is still a gap:**
- Dexie opt-out not yet available (policy says it is)
- No in-app privacy dashboard or consent management UI
- No ToS re-consent flow on version update

---

## 8. Known Gaps Summary

| Gap | Severity | Status |
|---|---|---|
| Dexie opt-out mechanism not built | 🔴 High — policy non-compliance | Cursor P1 task |
| F-010 token revocation migration (`0018`) not applied | 🔴 High | Cursor P0 task |
| F-013 log PII boundary not formally reviewed | 🟡 Medium | Needs Cursor review pass before log tooling |
| No ToS re-consent flow on version update | 🟡 Medium | Needed before S1.B exit |
| Diagnostic log retention period undefined | 🟡 Medium | Define before scaling user base |
| Multi-user Dexie/PWA behavior uncharacterized | 🟡 Medium | Parked — investigate before multi-user features |
| No in-app privacy/consent management dashboard | 🟡 Medium | Future feature (post F-014) |

---

*This document is a point-in-time record. Update when F-014 ships, when Dexie opt-out is implemented, or when the Privacy Policy is materially revised.*
