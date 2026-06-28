# Legal Frameworks — thehivemanager.com

> **Landing zone for legal research artifacts.** Drop Claude Web-generated legal framework documents here. These are research inputs and requirement frameworks — not the final published documents (those live in the web app itself).

**Created:** 2026-06-26  
**Status:** Awaiting artifact drop from Claude Web research session  
**S1.B gate link:** ToS + Privacy + Refund policies must be drafted and live before S1.B exit

---

## Artifacts

| File | Contents | Status |
|---|---|---|
| `scope_analysis.md` | In-scope vs out-of-scope analysis against actual implementation; 5 critical gaps; implementation priority table | ✅ Complete 2026-06-26 |
| `cookie_consent_requirements.md` | Cookie/Auth/Consent — PH-DPA baseline, JWT audit requirement, Dexie.js disclosure, CYA EU/CCPA coverage, OAuth placeholder | ✅ Complete 2026-06-26 |
| `tos_requirements.md` | Terms of Service — financial disclaimer, PH governing law, arbitration (mandatory language required), age gate, CYA EU/US clauses, OAuth/payment/subscription placeholders | ✅ Complete 2026-06-26 |
| `privacy_policy_requirements.md` | Privacy Policy — PH-DPA NPC Circular 2023-04 notice, DPO designation (Gap #3), Cloudflare as processor, hashed-IP disclosure, CYA GDPR/CCPA, all feature placeholders | ✅ Complete 2026-06-26 |
| `compass_artifact_wf-9ec4d26f-...md` | Source artifact from Claude Web — three frameworks combined; preserved for reference | Archive |

---

## Context for the legal researcher

### What data this app currently collects (from observability plan §10)

| Data | Purpose | Retention |
|---|---|---|
| Hashed IP (salted SHA256, not recoverable) | Security event correlation | 90 days |
| User UUID (pseudonymous, no name/email link in logs) | Feature usage analytics | 90 days |
| User agent class (bot/crawler/user — classified, raw string not stored) | Traffic composition | 90 days |
| API endpoint + method + response code | Usage analytics + security | 90 days |
| DAU/MAU aggregate counts (no individual tracking) | Growth monitoring | Indefinite |
| Invite chain (UUID pairs only) | Growth monitoring | Indefinite |

### Auth mechanism
JWT tokens — confirm storage location (localStorage vs cookies) before finalizing cookie consent requirements. If localStorage only: cookie consent banner obligation is reduced (functional cookies only for CSRF). If HttpOnly cookies: full cookie consent required.

### Market
- **Primary:** Philippines (PH Data Privacy Act RA 10173, NPC regulations)
- **Passive/Honorary:** US users (CCPA applicability — low at current scale but flag)
- **No EU presence** — GDPR not primary obligation, but GDPR-adjacent practices are the design default (privacy brand position)

### Pricing model (for ToS)
- Pro ₱249/mo subscription
- Pro+ AI ₱349/mo subscription
- PAYG ₱99/100 credits
- Founding lifetime ₱999–₱1,499 one-time
- Refund policy needed for subscription + one-time tiers

### Relevant existing docs
- `strategy/projections/success_projection_2026-06.md` — business context
- `plans/S1/S1.B/feat-celery-observability/README.md` §10 — full data disclosure spec
- `strategy/strategic-roadmap-reframe-53be/validation_gates.md` — S1.B exit gate: "ToS + Privacy + Refund policies drafted and live"
