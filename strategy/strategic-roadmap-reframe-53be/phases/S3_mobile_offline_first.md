# Phase S3: Android Scaling and Feature Parity

**Re-scoped 2026-04-30 post-beta huddle.** Original framing was "Mobile Offline-First (PH critical)" with assumption that Android initial build happens in S3. Reality: Android pull-forward to S1.B/C means by S3 entry, Android is already at `Tight Beta` or beyond. S3 is now about **scaling Android to feature parity with web and into Play Store / broader distribution**.

## Objective

Take the Android product from `Tight Beta` (S1.B/C output) to **production scale in PH**: Play Store presence, ≥30% of users on Android, sync reliability validated at scale, feature parity with web.

This is the phase where Android stops being a parallel test product and becomes the primary surface for the PH-mobile-first persona.

## Entry Criteria

- S2 exit met (≥100 paying users; PH content cadence sustained; GCash/Maya direct integration mature).
- Android already at `android:Tight Beta` or beyond (from S1.B/C pull-forward).
- Sync architecture validated against scripted scenarios.
- Battery impact within bounds (≤2% per hour active sync).

## Exit Criteria (all required)

- Android in PH Play Store (or sideload distribution if Play Store gating delayed).
- ≥30% of total active users on Android within 60 days of broader public availability.
- Sync failure rate <0.5% of operations.

## Workstreams

### W1 — Sync Architecture Hardening at Scale (P0)

Sync was implemented in S1.B/C for low user count. S2 onward stresses it.

- [ ] Delta sync protocol holds at higher concurrency (server-side stress).
- [ ] Conflict resolution rules validated against real user behavior data.
- [ ] Idempotency keys verified across all mutating operations.
- [ ] Sync failure rate measured and tracked; <0.5% target.
- [ ] Audit log + periodic full-sync reconciliation working.

### W2 — Feature Parity with Web (P0)

Android shipped with minimum viable feature set in S1.B/C. S3 closes the gap.

- [ ] All web features available on Android (or explicitly deferred with rationale).
- [ ] Mobile-specific UX (top-of-page quick add per Issue #6) refined.
- [ ] AI tier features available on Android (via API).
- [ ] Multi-account / family ledger features.

### W3 — Play Store Distribution (P0)

- [ ] Play Console developer account active.
- [ ] App listing: PH-localized description, screenshots, wedge sentence as first line.
- [ ] Internal/Closed testing track first; promote to Open Beta when stable.
- [ ] Sideload APK distribution as fallback during Play Store review delays.
- [ ] Compliance prep: privacy policy, data deletion flow, financial disclaimer, no money-services positioning.

### W4 — SMS Parsing Maturation (P0)

GCash/Maya SMS parsing landed in S2. S3 broadens.

- [ ] SMS parser per sender (BPI, BDO, UnionBank, Metrobank, etc.) — beyond GCash/Maya.
- [ ] Server-pushed parsing rules updates (banks change message formats).
- [ ] User-reported parse errors trigger rule updates.

### W5 — Battery + Data Discipline (P0)

PH wedge requires this.

- [ ] Background sync uses WorkManager with battery-aware constraints.
- [ ] Data budget: full sync of typical user state ≤500KB; delta sync ≤50KB typical.
- [ ] No always-on websocket; pull on schedule + on user-action.
- [ ] Battery impact tested on low-end PH-popular devices (Redmi 9, Realme C-series).

### W6 — PH Distribution Push (P1)

Tap PH local creator network from S2 with "now on Android with full features" angle.

- [ ] PH-Reddit/FB community announcements: re-engage existing channels.
- [ ] Targeted post: "GCash/Maya users — auto-imported transactions, offline-first, free tier."
- [ ] Track Android-specific cohorts separately for retention/conversion analysis.
- [ ] Founder content cadence includes Android-specific touchpoints.

### W7 — Web Maintenance Cadence (P1)

Web is no longer flagship-by-default during S3 main implementation, but it doesn't get abandoned.

- [ ] Web continues per existing trajectory; no feature freeze.
- [ ] Bug fixes ship per per-feature color cycle.
- [ ] If trade-off needed (Android feature vs web feature), Android wins per S3 priority.

### W8 — Documentation Sync (P1, at exit)

- [ ] Create `design_docs/android_docs/` with sync architecture, SMS parsing, Play Store learnings.
- [ ] Update `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` (already exists; reflect actual execution).
- [ ] Update `design_docs/03_Localization_Strategy.md` to reflect actual PH-mobile execution.

## Constraints

- **PH-only market focus continues** through S3.
- **Single runtime owner during deploy** per workspace rule.
- **One feature at a time on inactive color.**
- **Velocity ceiling holds.**

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Sync protocol has subtle data-loss bug | Delta sync with idempotency + audit log; periodic full-sync reconciliation; canary metric on operation count. |
| SMS parsing breaks when banks update message format | Server-pushed parsing rules; user-reported parse errors trigger rule update. |
| Android battery impact tanks Play Store rating | Test on real low-end PH devices; budget validation pre-launch. |
| Play Store rejection (financial app categories scrutinized) | Compliance prep: privacy policy, data deletion flow, financial disclaimer, no money-services positioning. |
| Web feels abandoned | Communicate maintenance cadence explicitly; document fix queue. |

## Verification Gate

Per `validation_gates.md` Phase S3 exit triggers.

## Definition of Done for Phase S3

- All exit triggers met.
- Sync failure rate documented and within tolerance.
- Android beta has measurable PH user adoption (≥30% of total active users).
- S4 entry gate evaluated.
