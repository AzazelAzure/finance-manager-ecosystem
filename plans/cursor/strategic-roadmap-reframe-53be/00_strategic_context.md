# Strategic Context

**Originally captured:** 2026-04-28. **Major revision:** 2026-04-30 post-beta huddle.

## 1) The Wedge (Single Source of Brand Truth)

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

This sentence is the brand. It belongs on:

- The landing page hero, above the fold.
- The first KPI on every dashboard view, web and mobile.
- Every social post screenshot.
- Every PH community / FB group / OFW community thread description.
- App store / Play Store descriptions when published.

If a feature does not directly serve "what's safe to spend right now," it is **not** a Phase S1–S2 feature. It can be queued for later, but it does not get scarce launch attention.

**Wedge consistency audit** is queued for S1.B per `validation_gates.md` and `_governance/branching_guidelines.md`.

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

### 3.1 Frontend: JS pivot complete; Reflex archived

- **Reflex archived 2026-04-30.** Repo retained as historical evidence; removed from production architecture. Per Topic 2 lock.
- **Flagship product is `web`** (`finance_manager_web`, React + TypeScript + Vite).
- JS pivot completed during S1.A launch sprint (3-day execution, BP1–BP7).
- API contract was the firewall during pivot; remained stable.
- **Implication:** original "S2 will include JS pivot" framing is obsolete. S2 content updated accordingly.

### 3.2 ZK Rust Middleware: AI-Orchestrated, S5 Conditional

- Owner is `executive` for Rust track, not `senior dev`. AI agents implement; owner reviews architecture, security model, audit findings.
- **Cost paid:** loss of personal Rust mastery as a side-effect.
- **Cost avoided:** 12+ months of opportunity cost during baby's first year + S1/S2 distribution-critical window.
- **Trigger to start serious work:** S5 entry (PFM ≥100 paying users, S4 exit met).
- **2026-04-30 elevation:** ZK is no longer just "magnum opus / clout" — it is **structural revenue defense**. With ads rejected (§4) and user-data monetization rejected, ZK middleware is what makes "we genuinely cannot read your data" a defensible brand claim. It is the differentiation that justifies premium subscription pricing without alternative revenue paths.

### 3.3 Android: Mandatory, Pull-Forward to S1.B/C

- PH market is mobile-first; internet is intermittent. Browser-only fails the primary persona.
- Offline-first SQLite + delta sync is the architecture, not an add-on.
- **Pull-forward (2026-04-30):** `android:Scaffold → android:Alpha` during S1.B; `android:Tight Beta` during S1.C. Original S3 timing was "after S2 web retention validates wedge"; reality is mobile cannot wait that long for the PH wedge.
- **Implication:** S3 re-scoped from "Android initial build" to "Android scaling and feature parity."

### 3.4 GCash/Maya Ingestion: Free Tier in PH

- Geographic gating (IP + user-declared region) qualifies users for free GCash/Maya ingestion.
- **Strategic reason:** US/EU users will not use this. Making it free for PH costs nothing in lost revenue and is the strongest hook for the primary persona.
- **The upsell is AI planning, not ingestion.** Resist any temptation to gate GCash/Maya behind paid.

### 3.5 AI Credits Model (Cursor-Pattern); Tier Ships at S1.C

- Free tier: ~10 AI prompts/month using a small/cheap model. Hard cost cap per user (see `01_unit_economics_and_costs.md`).
- Paid tier: monthly subscription includes baseline AI credits; PAYG top-ups available.
- "Smart predictions" rotate model tier by subscription level. Always cache, always batch where possible.
- **2026-04-30 timing update:** Pro+ AI tier pulls forward from S2 to **S1.C** (Founding Beta entry), tentative pending the AI Economics Deep-Dive resolution within S1.B.

### 3.6 Sari-Sari B2B as Clout-Laddered Spinoff

- Sari-Sari is **not** a feature of the PFM. It is a separate product that reuses the PFM data layer + encryption infra.
- Adoption depends on PFM trust signal in personal/local network.
- **Trigger to start:** S6 entry. Pre-S6 work is at most informal interviews with sari-sari operators in personal network.

### 3.7 Bounty Program / ZK Open-Source: Dev-Channel Marketing

- Open-source `django-zk` middleware is positioned as **career capital + dev-channel WoM**, plus structural brand defense for ZK story.
- Indirect revenue via: PFM reputation lift, future Pro/Enterprise tier on PFM, future consulting.
- **Trigger:** S4 (security baseline mature, PFM has users, audit-grade prep work done).

### 3.8 PH-First Market Focus (locked 2026-04-30)

- All marketing, distribution, content, and product decisions optimize for PH first.
- US presence continues passively — webapp accessible globally, existing testers grandfathered as Honorary Founders — but no US-targeted acquisition until specific trigger conditions (per `PARKING_LOT.md` P-6, deferred to S1.B → S1.C transition).
- US re-engagement Phase placement (S5.A vs separate Phase) deferred to S1.B → S1.C transition.
- **Asymmetric pricing for US users:** continued free Pro tier (Honorary Founders); AI tier in S1.C is PH-only initially; AI for US opens (post-PH-validation, USD-equivalent prices).

### 3.9 Mobile Wallet Payment as Hard Constraint (locked 2026-04-30)

- "Forcing PH users to have a credit card is a financial death sentence."
- S1.B billing infra must support direct GCash/Maya as a primary payment method, not a fallback.
- This is the core constraint shaping S1.B research workstream (entity formation + payment provider selection).

### 3.10 "Worth Paying For" Requirement (locked 2026-04-30)

- ₱200/mo is a significant decision in PH. The product must be demonstrably worth more than a notebook before founding beta opens.
- **S1.C entry trigger** (additive, locked): "Product is demonstrably worth ₱200/mo paid tier vs free tier vs notebook substitute." On top of the original S1.C entry triggers (S1.B exit met, AI economics deep-dive complete, billing infra live).
- Implication: S1.B includes feature work, not just research.

### 3.11 Lifetime Founding Beta Definition (locked 2026-04-30, deep-dive pending)

- HitM intent: "lifetime access to all future features" with AI features specifically gated and potentially tiered for founders (with discounts on credit packs).
- Industry-comparable framing offered as alternative: "lifetime Pro tier + lifetime access to Pro+ AI features with PAYG consumption at 50% discount; new product streams negotiated at launch."
- **Final commitment pending AI Economics Deep-Dive** (16 questions per `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` S1.B workstream).

## 4) What Was Rejected and Why


| Rejected option                                                            | Why                                                                                                                                                                                                            |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "Premium-feeling general-purpose PFM with widgets" (original docs framing) | War with Monarch/Copilot is unwinnable for solo dev. Wedge replaces this.                                                                                                                                      |
| Owner-led Rust learning during S1–S3                                       | Time/energy crowd-out during baby year + distribution-critical window. AI-orchestrated for now.                                                                                                                |
| Plaid integration in S1–S2                                                 | Per-MAU cost ($0.30–$1.00) breaks the unit economics for free PH tier. Defer until paid US/EU expansion considered (post-S5).                                                                                  |
| US market as primary in S1                                                 | Crowded, high CAC, no unique distribution. Reframed as PH-first per §3.8; US re-engagement deferred behind P-6 trigger.                                                                                        |
| Mobile PWA as Android substitute                                           | Insufficient for spotty PH connectivity + offline-first requirement.                                                                                                                                           |
| ZK encryption as Beta launch blocker                                       | Customer-shrug feature pre-PMF. Adds support burden (forgot password = data loss). Delayed to S5.                                                                                                              |
| "Account Deletion = Full Wipe" as ZK justification                         | This is GDPR/CCPA hygiene, not a ZK requirement. Don't conflate them.                                                                                                                                          |
| **Ads as revenue vector** (locked 2026-04-30)                              | Trust erosion in thin-margin persona is severe; PH ad networks lean predatory; untargeted CPM too low without financial-data targeting which ZK position rejects; brand consistency. See `PARKING_LOT.md` P-3. |
| **User-data monetization** (locked 2026-04-30)                             | "Relatively deplorable" per HitM. Brand inconsistent with ZK position. ZK middleware (S5) becomes structural revenue defense.                                                                                  |
| **Desktop standalone product (now `desktop:Concept`)** (locked 2026-04-30) | Tracked as future product stream; no scheduled work; revisit at S5+ or specific user demand. Original Track E.                                                                                                 |
| **Reflex frontend** (archived 2026-04-30)                                  | JS pivot completed; Reflex no longer carries polish bar; maintaining two frontends doubles cost without revenue offset. Repo retained as historical artifact.                                                  |


## 5) Success Criteria

- **Floor / break-even:** Cover ~$100/mo overhead (Cursor + VPS). ≈45 PH paying subs at PHP-anchored pricing OR mix.
- **Personal success target:** ₱100k/mo in business take-home (matches HitM's current personal income).
- **Win:** $1k MRR within 3–5 years.
- **Bust gate:** 3–5 years sustained net negative → wind down formally (see `kill_commit_gates.md` §1).
- **Tax cliff:** Foreign Earned Income Exclusion (~$126–130k for 2026, indexed). Anything approaching this triggers entity restructuring (see `01_unit_economics_and_costs.md` §5).
- **Personal floor:** VA disability income covers baseline needs; project does not need to replace salary income to be viable.

## 6) Lessons Learned

Captured at huddle 2026-04-30 from JS pivot retro (Topic 3).

### 6.1 AI-orchestrated frontend development is feasible at velocity

3-day Reflex→React+Vite pivot from foundations to BP7 polish + production beta validated the model. Tech moves fast with AI orchestration; *humans* (distribution) are the bottleneck. **Implication:** technical timeline projections weight toward "fast" defaults; distribution timelines weight toward "slow."

### 6.2 API-first discipline pays off

Frontend framework swap was clean because API contract was the firewall. JS frontend re-implemented against the same OpenAPI surface; no API revision required. **Implication:** maintain strict API-first discipline; it's structurally protective, not procedural.

### 6.3 Multi-agent parallel coordination works at execution level, but handoff mechanics need work

`web-beta-rollout` + `vps-reflex-bluegreen-recovery` ran in parallel without deadlocks via `CROSS_AGENT_COORDINATION.md` files and Runtime Signup Sheet. But in practice, sprint became "build everything at once and rebuild," not disciplined per-plan handoffs. **Implication:** Topic 11 deliverables include orchestration realignment around new S1.B goals.

### 6.4 Conscious owner-approved deviations need automatic follow-up tracking

The `+Bill` hotfix wasn't an AI failure or process violation — it was a deliberate owner tradeoff during launch. Drift came from forgetting to schedule the cleanup. **Implication:** approved deviations should automatically open a "retro-commit this" task. Workflow formalized in `_governance/branching_guidelines.md` §4.

### 6.5 Sprint compression risk is real

3-day pivot velocity is exactly the work-pattern that breaks sustainability. One-time success doesn't make it a habit. **Mitigation:** Topic 8 mechanisms — Cursor cap as forcing function; Sprint duration minimums (1 week production, 3 days maintenance, 1 week research); daily 10hr / weekly 55hr ceiling.

### 6.6 Agent identity separation: deferred research

Separate GitHub/Slack identities for agents would improve traceability but operational benefit is small for solo HitM. Deferred research item; revisit when adding second human collaborator OR considering automated PR auto-merge.

### 6.7 Automation is not always desirable

Manual merge-after-confirmation is a verification gate, not bureaucracy. For solo HitM with multiple agents, manual merge is one of the few places "is this actually working?" gets externally validated. **Default:** agents prepare automation-ready outputs (drafted PRs, ready-to-merge state, smoke evidence captured); humans commit irreversible actions (merge, deploy authorization, cutover). Codified in design doc 15 and `_governance/branching_guidelines.md`.

## 7) Personal Operating Constraints

Captured at huddle 2026-04-30. These are inputs to plan decisions, not separate plan items. Future agents inherit these so proposals that conflict with them get caught early.


| Constraint                   | Status                                                               | Effect                                                                                                                       |
| ---------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Baby due 2026-06-15          | Pre-baby through ~mid-June; full velocity available                  | Front-load deep-focus research workstreams (entity, payments, AI economics) into May–early June pre-baby window              |
| Velocity post-baby           | 30–50% loss assumption                                               | Implementation work and feature additions are interruption-tolerant; can land post-baby                                      |
| HitM overwork pattern        | ADHD-driven hyper-fixation tendency                                  | Cursor cap + daily 10hr / weekly 55hr ceiling enforced via local time-clock agent                                            |
| First quarterly self-review  | 2026-06-30 (calendar quarter aligned)                                | Per `kill_commit_gates.md` §6 — three written questions; triggers continued / reduced / kill-gate evaluation                 |
| Visa trip                    | Date TBD (one day)                                                   | Calendar block when scheduled                                                                                                |
| Wedding day                  | Legal marriage in process; date TBD                                  | Calendar block when scheduled                                                                                                |
| ₱100/mo runtime cost cap     | Hard ceiling                                                         | New infrastructure proposals must fit; otherwise blocked                                                                     |
| Monthly savings target cycle | Pay arrives end-of-month; constrained spending applies to NEXT month | May 2026 is currently constrained; June onward TBD per actual needs                                                          |
| Exercise routine / gym       | Cost-blocked currently                                               | Future concern; not infrastructure-blocking                                                                                  |
| Solo HitM, AI workforce      | Sole human in the org                                                | Governance designed for single-human + many-agents; no team/handoff structure assumed unless HitM explicitly tells otherwise |


## 8) Owner Operating Model

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

## 9) Distribution Theory

PFM does not grow from architecture. It grows from these channels, in order of priority:

1. **PH-local family/friend WOM seed (S1.A active, S1.C formal):** founding interest seed of 3 PH family members (incl. 1 Sari-Sari owner — S6 viewport bonus). Engaged formally at S1.C founding beta launch.
2. **Facebook business page (S1.B+):** primary PH digital vector. AI video stories using HitM's personal Gemini Pro asset (separate from project overhead) leveraging PH cultural preference for AI-drama formats.
3. **PH-local online communities (S1.C+):** specific channels deferred to S1.B marketing research workstream — AI's PH market knowledge has Western bias and is unreliable for channel selection.
4. **Founding-member program (S1.C):** 50–100 lifetime seats at PHP-anchored low price (e.g. ₱999–₱1,499 lifetime). Buys real beta users + cash + testimonials. Cap is hard.
5. **PH micro-influencer content (S2+):** Personal finance creators on TikTok/YouTube/FB with PH audiences. Affiliate or co-marketing, not paid placement.
6. **Dev-channel (S4+):** Hacker News, r/Django, r/rust, security Twitter/Mastodon, infosec conferences. Anchored to `django-zk` middleware and bounty program.
7. **B2B referral (S6+):** Sari-Sari operators referring other operators. Only meaningful after personal-network beachhead.

**Default starting cadence (subject to S1.B marketing research):** monthly AI video story (high-effort) + weekly educational post (mid-effort) + ad-hoc personal narrative posts (low-effort). Anchored on Facebook initially.

**Out of scope:** paid ads pre-S5. SEO is a passive byproduct, not a strategy.

## 10) References

- Phase docs: `phases/S1_public_beta_position.md` through `phases/S6_sari_sari_b2b_vertical.md`.
- Validation gates: `validation_gates.md`.
- Kill/commit gates: `kill_commit_gates.md`.
- Unit economics: `01_unit_economics_and_costs.md`.
- Parking lot (deferred decisions): `PARKING_LOT.md`.
- Vocabulary: `_governance/glossary.md`.
- Branching workflow: `_governance/branching_guidelines.md`.
- Deployment workflow: `_governance/deployment_protocol.md`.
- Plan template: `_governance/plan_template.md`.
- Plan registry: `_governance/plan_registry.md`.