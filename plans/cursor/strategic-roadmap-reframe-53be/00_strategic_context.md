# Strategic Context (Captured 2026-04-28)

## 1) The Wedge (Single Source of Brand Truth)

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

This sentence is the brand. It belongs on:

- The landing page hero, above the fold.
- The first KPI on every dashboard view, web and mobile.
- Every social post screenshot.
- Every PH community/Reddit/FB group thread description.
- The CLI/Reflex/Android app store descriptions.

If a feature does not directly serve "what's safe to spend right now," it is **not** a Phase S1–S2 feature. It can be queued for later, but it does not get scarce launch attention.

## 2) Primary Persona: The "Living Thin" Household

Not "Average Joe." Not "Finance Bro." The actual user is:

- Lives in PH (or US/EU expat with PH ties; OFW families).
- Income is real but variable (freelance, part-time, multi-source, GCash/Maya wallet first).
- Has multiple recurring obligations that compete for the same pesos.
- Practices "partial bill payment" survival math (pay 60% of electric to keep it on, 100% of rent, defer phone) on a regular basis.
- Has been burned by Western PFMs that assume surplus and zero-based budgeting.
- Mobile-first, often offline, low-RAM Android device, intermittent connectivity.

**Secondary persona ("whales"):** "Finance Bro" power users who want multi-currency, investment tracking, AI-assisted planning. They subsidize the primary persona via paid AI tier and Pro subscription. **They are not the marketing target.** They self-discover from the same channels.

## 3) Strategic Decisions Locked

These are **closed decisions**. Re-opening them requires a kill/commit gate review.

### 3.1 Reflex → JS Pivot
- Reflex was acceptable for Alpha/Beta MVP. It is a constraint at the polish bar set by Monarch/Copilot.
- Pivot target: TypeScript + React (Next.js) or SvelteKit. Decision deferred to start of S2.
- **Trigger:** S1 user feedback explicitly cites polish/responsiveness as friction → start pivot in S2.
- **Constraint:** API contract is the firewall. JS frontend re-implements against the same OpenAPI surface.

### 3.2 ZK Rust Middleware: Owner-Hands-On → AI-Orchestrated
- Original framing: owner-led, hands-on Rust learning, multi-quarter.
- Reframe: owner is `executive` for Rust track, not `senior dev`. AI agents implement; owner reviews architecture, security model, audit findings.
- **Cost paid:** loss of personal Rust mastery as a side-effect.
- **Cost avoided:** 12+ months of opportunity cost during baby's first year + S1/S2 distribution-critical window.
- **Trigger to start serious work:** S5 entry (PFM ≥100 paying users). Not before.

### 3.3 Android: Mandatory, Not Deferrable
- PH market is mobile-first; internet is intermittent. Browser-only fails the primary persona.
- Offline-first SQLite + delta sync is the architecture, not an add-on.
- **Trigger to start:** S3 entry (after S2 web retention validates the wedge).
- **Constraint:** sync architecture must be designed *before* S3 implementation; design happens during S2.

### 3.4 GCash/Maya Ingestion: Free Tier in PH
- Geographic gating (IP + user-declared region) qualifies users for free GCash/Maya ingestion.
- **Strategic reason:** US/EU users will not use this. Making it free for PH costs nothing in lost revenue and is the strongest hook for the primary persona.
- **The upsell is AI planning, not ingestion.** Resist any temptation to gate GCash/Maya behind paid.

### 3.5 AI Credits Model (Cursor-Pattern)
- Free tier: ~10 AI prompts/month using a small/cheap model (e.g. Haiku-tier or local Llama). Hard cost cap per user (see `01_unit_economics_and_costs.md`).
- Paid tier: monthly subscription includes baseline AI credits; PAYG top-ups available.
- "Smart predictions" rotate model tier by subscription level. Always cache, always batch where possible.
- **Trigger to launch:** S2 (after web retention proves wedge; before mobile build).

### 3.6 Sari-Sari B2B as Clout-Laddered Spinoff
- Sari-Sari is **not** a feature of the PFM. It is a separate product that reuses the PFM data layer + encryption infra.
- Adoption depends on PFM trust signal in personal/local network.
- **Trigger to start:** S6 entry. Pre-S6 work is at most informal interviews with sari-sari operators in personal network — no design, no implementation, no marketing.

### 3.7 Bounty Program / ZK Open-Source: Dev-Channel Marketing
- Open-source `django-zk` middleware is positioned as **career capital + dev-channel WoM**, not direct revenue.
- Indirect revenue via: PFM reputation lift, future Pro/Enterprise tier on PFM, future consulting if desired.
- **Trigger:** S4 (security baseline mature, PFM has users, audit-grade prep work done).

## 4) What Was Rejected and Why

| Rejected option | Why |
|---|---|
| "Premium-feeling general-purpose PFM with widgets" (original docs framing) | War with Monarch/Copilot is unwinnable for solo dev. Wedge replaces this. |
| Owner-led Rust learning during S1–S3 | Time/energy crowd-out during baby year + distribution-critical window. AI-orchestrated for now. |
| Plaid integration in S1–S2 | Per-MAU cost ($0.30–$1.00) breaks the unit economics for free PH tier. Defer until paid US/EU expansion considered (post-S5). |
| US market as primary in S1 | Crowded, high CAC, no unique distribution. Re-considered as secondary market post-S5 when reputation amplifies. |
| Mobile PWA as Android substitute | Insufficient for spotty PH connectivity + offline-first requirement. |
| ZK encryption as Beta launch blocker | Customer-shrug feature pre-PMF. Adds support burden (forgot password = data loss). Delayed to S5. |
| "Account Deletion = Full Wipe" as ZK justification | This is GDPR/CCPA hygiene, not a ZK requirement. Don't conflate them. |

## 5) Success Criteria (Owner-Stated, 2026-04-28)

- **Floor / break-even:** Cover ~$100/mo overhead (Cursor + VPS). ≈15–30 PH paying subs at PHP-anchored pricing.
- **Win:** $1k MRR within 3–5 years.
- **Bust gate:** 3–5 years sustained net negative → wind down formally (see `kill_commit_gates.md` §1).
- **Tax cliff:** Foreign Earned Income Exclusion (~$126–130k for 2026, indexed). Anything approaching this triggers entity restructuring (see `01_unit_economics_and_costs.md` §5).
- **Personal floor:** VA disability income covers baseline needs; project does not need to replace salary income to be viable. This changes the risk profile materially.

## 6) Owner Operating Model

- **Role:** Executive / orchestrator, not junior/mid dev. AI agents implement; owner reviews architecture, financial-math correctness, security posture, distribution strategy, brand consistency.
- **Inviolable human-review categories:**
  - Money math (any change to balance, transaction, snapshot, safe-to-spend, AI prediction logic).
  - Authentication and session handling.
  - Database migrations.
  - Cryptographic operations (when ZK exists).
  - Pricing and billing logic.
  - PII handling.
- **Always-allowed agent categories:**
  - UI polish, copy, layout (with screenshot review).
  - Test additions, refactors with no behavior change.
  - Documentation updates.
  - Build/CI/runtime ops automation.
  - Distribution content drafts (review before posting).

## 7) Distribution Theory

PFM does not grow from architecture. It grows from these channels, in order of priority:

1. **PH-local online communities (S1+):** r/phinvest, r/Philippines, OFW Facebook groups, Filipino freelancer Discord/FB groups, GCash subreddit, "barya" / "thrift living" content audiences.
2. **Founding-member program (S1):** 50–100 lifetime seats at PHP-anchored low price (e.g. ₱999–₱1,499 lifetime). Buys real beta users + cash + testimonials. Cap is hard.
3. **PH micro-influencer content (S2+):** Personal finance creators on TikTok/YouTube with PH audiences. Affiliate or co-marketing, not paid placement.
4. **Dev-channel (S4+):** Hacker News, r/Django, r/rust, security Twitter/Mastodon, infosec conferences. Anchored to `django-zk` middleware and bounty program.
5. **B2B referral (S6+):** Sari-Sari operators referring other operators. Only meaningful after personal-network beachhead.

**Out of scope (pre-S5):** Paid ads of any kind. SEO is a passive byproduct, not a strategy.
