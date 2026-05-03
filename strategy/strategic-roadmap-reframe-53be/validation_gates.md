# Validation Gates (Per-Phase Triggers)

**Originally captured:** 2026-04-28. **Major revision:** 2026-04-30 post-beta huddle (Stage-level triggers added for S1; PH-first market focus; mobile-wallet payment requirement; "worth paying for" S1.C trigger).

Each Phase / Stage has explicit *quantitative* triggers for entry, mid-Stage health, and exit. Where a metric is unmeasurable yet (e.g. before any users exist), the gate is qualitative and explicit about that fact.

### Indexing paying-user gates to affordability (policy)

Pure **paying-user headcounts** below assume a **healthy mix** including Pro PH at roughly **mid-band affordability**, not maximal list price—see `01_unit_economics_and_costs.md` §2 (affordability vs margin) and **§4.1 sensitivity table**.

- **Gate anchor ASP (until S1.B lock):** assume **₱199/mo Pro list** (and the same ~0.85 illustrative net shortcut as §4.1) when interpreting headcount thresholds. This is **not** a promise to charge ₱199; it is the **economics normalization** for “how many users is this gate worth.” **List lock 2026-05-01:** Pro **₱249/mo** — when reconciling headcount-only gates to **revenue**, scale per the formula below or prefer an explicit **minimum net ₱ MRR** criterion at next registry pass.
- **If HitM locks Pro lower** for conversion (still **≤₱250** positioning cap), **revenue-equivalent scaling** for headcount-only gates:

`N_adjusted = ceil(N_document × (gate_anchor_price / locked_Pro_list))` using **gate_anchor_price = ₱199** until updated.

Examples (illustrative, **₱149** Pro lock vs **₱199** anchor; always `ceil`): **S1.C exit ≥30 → ≥41**; **S2 exit ≥100 → ≥134**; **S4 entry ≥50 → ≥67**; **S5 entry ≥100 → ≥134**. **Round up**; recompute when anchor or locked price changes.

- **Obligation:** at **S1.B pricing + payment provider decision**, HitM reconciles documented gate numbers—either revise counts in this file or add parallel **minimum net ₱ MRR** exit criteria so traction cannot satisfy a headcount bar with unsustainable ASP.
- Mixed cohorts (Founding lifetime treated separately from MRR, Pro+ AI uplift) refine but do not eliminate this check; prefer a **spreadsheet snapshot** tied to launch pricing.

---

## Phase S1: Public Beta Launch + Position Lock-in

### S1.A — Tight Invite Beta

**Status:** **completed 2026-04-30** (live on VPS since 2026-04-29).

**Entry triggers (all required):**
- VPS baseline runtime stable (per pre-governance plan validation gates).
- API + frontend passing smoke (web is flagship; Reflex archived).
- HitM has explicitly committed to wedge sentence in `00_strategic_context.md` §1.

**Exit triggers (any one of):**
- ✅ Tight Beta cohort accessing live VPS (currently active testers; founding interest seed of 3 PH family members + grandfathered US testers).
- Initial smoke evidence captured (BP7 snapshot per `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md` §H).

### S1.B — Distribution Readiness

**Status:** **active 2026-04-30 →** (entering at huddle close).

**Entry triggers (all required, all met):**
- S1.A exit met.
- Strategic Plan revision complete (this huddle output).
- Topic 8 velocity controls operational (10/55 ceiling, time-clock agent setup queued).

**Mid-Stage health checks (monthly):**
- Cursor monthly cap stays under 100% (no overages purchased).
- Free-tier LLM spend on track (currently de minimis pre-S1.C).
- Family/health quarterly self-review fires per `kill_commit_gates.md` §6 on calendar.

**Exit triggers (all required):**
- Email uniqueness S0 fix shipped (per `KNOWN_ISSUES.md` Issue 5; before any new invitee).
- `+Bill` hotfix retroactively committed to git.
- Reflex archival complete (per Topic 2 detailed scope).
- Pre-governance plans formally closed in registry.
- Bug fixes for Issues #1, #4, #7 shipped (per Topic 1 triage).
- AI Economics Deep-Dive complete with 16 decisions resolved.
- Entity formation decision made (US LLC vs OPC).
- Payment provider decision made (with mobile-wallet primary path defined).
- Distribution channel research complete; founder content cadence defined.
- Wedge consistency audit complete; landing-page polish landed (per Topic 7).
- Founding member program backend ready (seat cap + lifetime SKU + badge system).
- "Worth paying for" feature work complete (Pro tier demonstrably worth ₱200/mo vs notebook substitute).
- ToS + Privacy + Refund policies drafted and live.
- Flagship **`web` PWA “install as app”** meets the production checklist in `plans/S1/S1.B/pwa-install-offline-sync-research/README.md` **§6** (manifest, HTTPS, install + standalone launch, service worker + update strategy, tier-appropriate offline behavior — **Advanced** per that file **§1.1**). Sub-plan `pwa-install-offline-sync-research` **completed** with **D0–D4** decision log and **D4-exec** smoke pass on deployed `:8443` per **§1.6 / §6** of that README. **Rationale + cross-links for implementation:** same README **§1.1–§1.7** (browser matrix **D0**, API/outbox **D2**, auth/offline **D3**, smoke/ADR **D4**, **3-month seed + offline window UX + atomicity**), plus artifact index `plans/S1/S1.B/pwa-install-offline-sync-research/RESEARCH_ARTIFACTS.md` and S1.B sprint index `plans/S1/S1.B/README.md` section **“Sprint activation index — PWA (install, offline, resync)”**. **Progress to S1.C is blocked until this bullet is satisfied** (it is part of S1.B exit, which S1.C entry already requires).

### S1.C — Founding Beta

**Entry triggers (all required):**
- S1.B exit met (includes flagship PWA install bar above).
- Pricing live with PHP-anchored Pro tier and Founding Lifetime SKU.
- Mobile wallet payment (GCash/Maya) functional as primary payment method.
- AI tier (Pro+ AI) launches — final commitment per AI Economics Deep-Dive outcome.

**Mid-Stage health checks (monthly):**
- Founding seat take-up (target: meaningful uptake within 3 months of opening).
- Day-30 retention ≥30% on cohorts that signed up.
- AI per-user cost within tier cap for ≥95% of users.

**Exit triggers (all required):**
- ≥30 paying users total (Founding members + Pro PH), **unless re-indexed per "Indexing paying-user gates" above** when Pro list is locked below the ₱199 gate anchor (e.g. **≥41** at **₱149** Pro lock, illustrative).
- Founding seat cap reached OR 6-month founding window elapsed.
- Retention day-60 ≥25% on Founding cohort.

### S1.D — Soft Public Open (PH-only)

**Entry triggers (all required):**
- S1.C exit met.
- Public landing page polish complete with wedge as hero.
- Bug count from Founding Beta cohort resolved or triaged.

**Exit triggers (any one of):**
- ≥10 paying PH users active in the prior 30 days (Pro tier, post-Founding).
- ≥50 active free PH users with retention day-30 ≥30%.

### S1 → S2 transition

S2 entry = S1.D exit met. **PH-only market focus continues into S2.** US re-engagement deferred behind P-6 trigger.

---

## Phase S2: PH Public Launch + Scaling

### Entry triggers (all required)
- S1.D exit met.
- S2-specific feature roadmap drafted (per Topic 11 deliverables).
- Owner velocity ceiling functioning correctly through S1.

### Mid-phase health checks (monthly)
- Day-60 retention ≥25% on cohorts that signed up during S1.
- AI tier paid conversion ≥5% of free users by month 3 of S2.
- AI per-user cost is within tier cap for ≥95% of users.
- PH-local distribution showing organic growth (≥20% of new users from non-direct channels).

### Exit triggers (all required)
- GCash/Maya direct integration live and accurate (≥95% test transactions correctly parsed).
- AI tier mature with ≥10 paid Pro+ AI subscribers.
- ≥100 paying users total (**re-index per "Indexing paying-user gates"** when Pro ASP is locked below gate anchor—e.g. **≥134** at **₱149** vs **₱199** anchor, illustrative).
- Active PH content cadence sustained for ≥3 months.

---

## Phase S3: Mobile Offline-First (Android Scaling)

**Re-scoped 2026-04-30:** original "Android initial build" is now S1.B/C work; S3 focuses on scaling.

### Entry triggers (all required)
- S2 exit met.
- Android pulled forward in S1.B/C to `android:Tight Beta` or beyond.
- Sync architecture validated against scripted scenarios.
- Battery impact within bounds (≤2% per hour active sync).

### Mid-phase health checks (monthly)
- Android crash-free rate ≥99% on test devices.
- Sync conflict resolution validated against expanded scenarios.

### Exit triggers (all required)
- Android in PH Play Store (or sideload distribution if Play Store gating delayed).
- ≥30% of total active users on Android within 60 days of broader public availability.
- Sync failure rate <0.5% of operations.

---

## Phase S4: Trust & Reputation Building

### Entry triggers (any one of)
- PFM ≥50 paying users (**re-index per "Indexing paying-user gates"** when Pro ASP is below anchor—e.g. **≥67** at **₱149** vs **₱199**, illustrative).
- HitM has authored security disclosure policy and `SECURITY.md` for PFM repos.
- Bounty program scope drafted and reviewed.

### Mid-phase health checks (quarterly)
- ≥1 disclosed security finding handled per published policy timeline.
- Dev-channel touchpoints (Hacker News post, blog post, talk submission) ≥1 per quarter.
- ZK middleware spec / RFC drafted in public.

### Exit triggers (all required)
- Bounty program live with ≥3 reported findings handled.
- ZK middleware spec public and reviewed by ≥1 external security-aware reviewer.
- HitM has dev-channel presence with measurable inbound interest.

---

## Phase S5: ZK Middleware Magnum Opus + US Re-Engagement Alignment

**Elevated 2026-04-30** from "magnum opus / clout" to "structural revenue defense." Without ads or user-data revenue, ZK is the differentiator that justifies premium subscription pricing.

### Entry triggers (all required)
- S4 exit met.
- PFM ≥100 paying users (**re-index per "Indexing paying-user gates"** when Pro ASP is below anchor—e.g. **≥134** at **₱149** vs **₱199**, illustrative).
- Audit-grade prep: threat model published, dependency hygiene score acceptable, no open P0 security findings.

### Mid-phase health checks (quarterly)
- Audit/review milestones met: design review → code review → external audit → adoption announcement.
- PFM revenue does not regress during S5 build.

### Exit triggers (all required)
- `django-zk` Rust middleware publicly released under chosen license.
- External audit completed and findings published.
- PFM in production using the middleware (live reference).
- Public announcement on Hacker News, r/django, security channels with measurable adoption signal.
- **US re-engagement decision made** per P-6 trigger (Phase placement / trigger condition / specific marketing motion).

---

## Phase S6: Sari-Sari B2B Vertical

### Entry triggers (all required)
- S5 exit met (or S5 explicitly abandoned with documented reason).
- PFM ≥$1k MRR sustained for ≥6 months.
- ≥3 sari-sari operators in HitM's personal network expressed unprompted interest. (Founding interest seed from S1 includes 1 sari-sari owner — early viewport.)

### Mid-phase health checks (quarterly)
- Discovery interviews completed before any code (≥10 operators interviewed).
- B2B sales motion validated: at least one operator paying without family-discount.
- Reuse of PFM data layer / encryption confirmed; no fork divergence.

### Exit triggers (all required)
- ≥10 paying sari-sari operators.
- Supplier-integration prototype operational.
- B2B churn <10%/quarter.

---

## Cross-Phase: Always-On Validation

These gates run **regardless of active Phase/Stage** and override Phase-specific gates if violated.

### Cost discipline gate
- Free-tier LLM monthly cost ≤30% of paid MRR.
- Total infrastructure (VPS+domain+TLS) stays within **`01_unit_economics_and_costs.md` §1** buffered planning range unless paid users justify overshoot (HitM personal **₱100/mo** cap is separate; see strategic context §7).
- Cursor Pro+ usage stays under 100% of monthly cap (no overages).
- Cursor cap re-evaluated at every Phase transition.

### Family / health gate
- Quarterly self-review per `kill_commit_gates.md` §6 (first execution 2026-06-30).
- Triggers reduced-scope mode or master kill gate evaluation as defined.

### Velocity gate
- Daily 10hr / weekly 55hr ceiling enforced by local time-clock agent.
- Decompression weeks: 6hr/day, 30hr/week ceiling.
- Sprint duration minimums: 1 week production, 3 days maintenance, 1 week research.

### Security gate
- Any S0/P0 security incident pauses feature work until resolved.
- Any PII/auth/money-math change goes through human review per `00_strategic_context.md` §8.

### Brand consistency gate
- Every public-facing surface (landing page, app store description, social posts) leads with the wedge sentence (`00_strategic_context.md` §1).
- Wedge consistency audit at every Phase transition (and weekly during S1.C+ once landing live).

---

## Status snapshot (2026-04-30)

- **Active Phase:** S1.
- **Active Stage:** S1.A (just exited) → S1.B (entering).
- **Flagship product:** `web` (`finance_manager_web`).
- **Active market:** PH-only primary; US passive (Honorary Founders only).
- **Next major gate:** S1.B exit (research workstreams + drift cleanup + "worth paying for" feature work + founding member program backend).
- **Anticipated S1.B duration:** May 2026 → July 2026 (~3 months).
- **Anticipated S1.B → S1.C transition:** August 2026 (subject to research outcomes and AI Economics Deep-Dive).
