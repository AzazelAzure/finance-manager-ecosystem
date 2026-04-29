# Phase S3: Mobile Offline-First (PH Critical)

## Objective

Deliver an Android app that **works offline** and syncs reliably when connectivity is intermittent. PH market is mobile-first with patchy internet; without this, the wedge cannot reach the persona at scale.

This is also the phase that breaks the "web-only" perception of the product and sets up the architecture that the future Sari-Sari B2B vertical will reuse.

## Entry Criteria

- S2 exit met (per `validation_gates.md` S2 exit triggers).
- Sync architecture design from S2 §7 reviewed and approved by owner.
- Android dev environment + AI agent capable of producing buildable artifacts validated.
- Feature parity ceiling for Android beta is documented (deliberately less than web).

## Exit Criteria (all required)

- Android beta in PH Play Store OR sideload distribution if Play Store gating delayed.
- ≥20% of total active users on Android within 60 days of beta launch.
- Sync failure rate <0.5% of operations.

## Workstreams

### 1. Sync Architecture Implementation (P0)

- [ ] Local SQLite schema implemented per S2 design.
- [ ] Delta sync protocol implemented: client sends pending operations log, server returns merged state.
- [ ] Conflict resolution rules implemented: last-write-wins for soft data, CRDT-style merge for additive transactions, manual conflict UI for hard conflicts.
- [ ] Idempotency keys for all mutating operations.
- [ ] Sync state visible to user: "last synced X minutes ago," "N operations pending."

### 2. Android App MVP (P0)

- [ ] Native Android (Kotlin, Jetpack Compose) — not Flutter, not React Native. Reasoning: AI agents are strongest at Kotlin+Compose for Android-specific concerns; battery/data efficiency is critical in PH.
- [ ] Minimum-viable feature set for Android beta:
  - Authentication (mirror web).
  - Manual transaction entry with offline queue.
  - Safe-to-spend dashboard (read from local SQLite, refresh on sync).
  - Account/wallet list view.
  - GCash/Maya SMS parsing (S3-specific feature; web does CSV import).
  - Sync status visibility.
- [ ] Out of S3 mobile scope: AI features (S4), advanced charts, multi-user family-share UI.

### 3. SMS Parsing for GCash/Maya (P0)

- [ ] Permissions handling: minimal SMS read permission scoped to known sender IDs only.
- [ ] Parsing rules per sender (GCash, Maya, BPI, BDO, etc.) — versioned, server-pushed updates.
- [ ] Privacy guardrails: parsed transaction data lives locally first, syncs only on user opt-in.
- [ ] User control: explicit opt-in per sender, easy disable.

### 4. Battery & Data Discipline (P0)

- [ ] Background sync uses WorkManager with battery-aware constraints.
- [ ] Data budget: full sync of typical user state ≤500KB; delta sync ≤50KB typical.
- [ ] No always-on websocket; pull on schedule + on user-action.
- [ ] Battery impact tested on low-end PH-popular devices (e.g. Redmi 9, Realme C-series).

### 5. Play Store Distribution (P0)

- [ ] Play Console developer account active.
- [ ] App listing: PH-localized description, screenshots, wedge sentence as first line.
- [ ] Internal/Closed testing track first; promote to Open Beta when stable.
- [ ] Sideload APK distribution as fallback during Play Store review delays.

### 6. PH Distribution Push (P1)

- [ ] Tap PH local creator network from S2 with "now on Android" angle.
- [ ] PH-Reddit/FB community announcements: re-engage existing channels with mobile-first message.
- [ ] Targeted post: "GCash/Maya users — auto-imported transactions, offline-first, free."
- [ ] Track Android-specific cohorts separately for retention/conversion analysis.

### 7. Web Maintenance Cadence (P1)

- [ ] Web continues per existing JS-pivot trajectory (or Reflex if pivot deferred).
- [ ] Web feature freeze during S3 main implementation; only bug fixes and security patches.
- [ ] When S3 exit reached, web resumes feature work.

### 8. Documentation Sync (P1, at exit)

- [ ] Update or create `design_docs/android_docs/` with sync architecture and SMS parsing.
- [ ] Update `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` (already exists per file glob).
- [ ] Update `design_docs/03_Localization_Strategy.md` to reflect actual PH-mobile execution.

## Constraints

- **Web feature work freezes during S3 main implementation.** Only bug fixes / security patches.
- **No iOS in S3.** PH market is overwhelmingly Android. iOS is a post-S5 consideration tied to US/EU expansion.
- **AI features deferred to S4 on mobile.** Mobile S3 is sync, parse, display — not AI.
- **Owner-baby calendar:** at S3 entry, child is likely 6–12 months old. Velocity may be improved vs S1/S2 but still planned conservatively.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Sync protocol has subtle data-loss bug | Delta sync with idempotency + audit log; periodic full-sync reconciliation; canary metric on operation count. |
| SMS parsing breaks when banks update message format | Server-pushed parsing rules; user-reported parse errors trigger rule update. |
| Android battery impact tanks rating | Test on real low-end PH devices; budget validation pre-launch. |
| Play Store rejection (financial app categories are scrutinized) | Compliance prep: privacy policy, data deletion flow, financial disclaimer, no money-services positioning. |
| Web users feel abandoned during freeze | Communicate freeze explicitly; promise of feature resumption post-S3. |

## Verification Gate

Per `validation_gates.md` Phase S3 exit triggers.

## Definition of Done for Phase S3

- All exit triggers met.
- Sync failure rate documented and within tolerance.
- Android beta has measurable PH user adoption.
- Web feature freeze formally lifted.
- S4 entry gate evaluated.
