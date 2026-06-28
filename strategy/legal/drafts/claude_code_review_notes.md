# Claude Code Review Notes — Legal Drafts v1.0

> **From:** Claude Web (claude.ai)  
> **Date:** 2026-06-27  
> **Files reviewed against:** `legal_workflow_coordination.md`, `scope_analysis.md`, `privacy_policy_requirements.md`, `tos_requirements.md`, `cookie_consent_requirements.md`, README for F-003  
> **Drafts produced:** `privacy_policy_v1.md`, `tos_v1.md`, `cookie_policy_v1.md`

---

## Scope Decisions Made

These were judgment calls in the drafts. Claude Code should verify each against codebase state.

### 1. Dual-write model — fully reflected in all three documents
Privacy Policy §3.2 explicitly describes the dual-write model and corrects the "data doesn't leave the device" error. ToS §10 (Offline Data Storage) is rewritten from the original erroneous framing. Cookie Policy §4.1 correctly states Dexie is a mirror, not a primary store.

### 2. T05 / T06 markers — placed in every affected claim
- `[PENDING T05]`: Auth token section (cookie policy §3.1), CSRF token (cookie policy §3.2), security measures (privacy policy §9)
- `[PENDING T06]`: Dexie encryption-at-rest (privacy policy §3.2, cookie policy §4.1, ToS §10)
- Until T05 deploys: cookie policy §3.1 accurately states tokens are currently in localStorage
- Until T06 deploys: cookie policy §4.1 accurately states local copy is not encrypted at rest

**Cagent verify needed:** Confirm localStorage is still the current JWT storage mechanism — if T05 has already deployed, these markers need to be removed and claims updated.

### 3. Known PII gap in logs — disclosed in privacy policy §3.3
The username-in-plain-text issue in signals.py:55,75,84,131 is disclosed under §3.3 as a known gap being resolved. This is the most accurate position — better to disclose a known gap than to claim "no PII in logs" that isn't yet true. When the signals PII issue is resolved in T05/T06, remove this note.

### 4. F-003 and NPC automated profiling — attorney checkpoint maintained, no position taken
Privacy Policy §4.1 and §14 both flag the F-003 attorney review checkpoint. The draft does NOT claim F-003 is or isn't "automated decision-making/profiling" — that's the attorney's call. The description of what F-003 does is accurate per the README: statistical projection of historical spending patterns; no decisions with legal effect.

### 5. Argon2id / PBKDF2 migration — flagged in privacy policy §9
Privacy policy §9 notes `[PENDING T01/T02: migration from PBKDF2 to Argon2id]`. Coordination doc showed hashed password listed as "Argon2 (pending T01/T02 migration from PBKDF2)." **Cagent verify:** which is the current live state — PBKDF2 or Argon2? The draft currently states Argon2id in §3.1 (as target) and PBKDF2 in §9 (as current). If PBKDF2 is still live, the §3.1 data table should say PBKDF2, not Argon2id.

### 6. Dexie purge job — open cagent item not yet verified
The 3-month auto-purge is stated throughout all three documents as confirmed. The scope_analysis listed this as an unverified cagent item. **Cagent verify:** is the 3-month Dexie purge job actually implemented? If not, the retention disclosures are inaccurate and must be changed to "planned" or "not yet implemented."

### 7. Error log retention — 14 days from coordination doc
Privacy policy §7 and appendix table state 14-day retention for F-013 diagnostic logs, per the coordination doc (14 days, 10MB rotation). Open item N6 flags this as needing Cursor audit confirmation. **Cagent verify:** confirm `logs/diagnostic/{uuid}.log` retention policy — if the 14-day figure isn't confirmed by implementation, flag for update.

### 8. Redis / flat-file analytics — marked pending
All references to hashed IP retention (90-day rolling), flat-file analytics, and Redis counters are marked `[PENDING: Redis + flat-file analytics deploy]` since coordination doc shows these are not yet deployed on VPS. Once deployed, remove the pending markers.

---

## Attorney Review Items — Summary

These cannot be finalized without a qualified PH attorney. Collected here for easy handoff:

| # | Document | Section | Issue |
|---|---|---|---|
| A1 | ToS §8–9 | Warranty disclaimer + liability cap | PH Consumer Act (RA 7394) enforceability; US boilerplate is not transferable |
| A2 | ToS §15 | Arbitration clause final wording | Mandatory language confirmed in draft; attorney to write final clause |
| A3 | ToS §15 | Consumer carve-out (EU/CA) | Class-action waiver enforceability for non-PH users |
| A4 | ToS §2 / Privacy §11 | Age-gating implementation | Self-declaration adequacy under PH law for financial app |
| A5 | Privacy §4.1, §14 | F-003 automated profiling trigger | Does predictive budgeting require NPC registration regardless of user count? |
| A6 | Privacy §6 | NPC Advisory 2024-01 cross-border clause | Contractual clause with Namecheap/Cloudflare to be drafted |
| A7 | Cookie §4.1 | Dexie "functional" classification | Defensibility of functional classification under PH-DPA |
| A8 | ToS §3 | Financial advice line-drawing | What constitutes "advice" in PH law context re: financial literacy content (open item N1) |

---

## Open Items Not Resolved in Drafts (require code or design action)

| Item | Owner | Document affected | What's needed |
|---|---|---|---|
| N2 | Cursor | ToS + Privacy | Clickwrap logging (timestamp + ToS version) in account creation flow |
| N4 | Cursor + design | Cookie policy §7.2 | Dexie opt-out mechanism accessible from app settings |
| N5 | Cursor + attorney | Privacy §3.2 | Multi-user single PWA Dexie instance gap — needs either per-user namespacing or explicit disclosure |
| N6 | Cursor | Privacy §7 | F-013 Loguru retention period — confirm 14-day figure is implemented |
| N8 | Cursor | ToS §2, Privacy §11 | Front-end age gate — add to account creation; policy correctly states self-declared and unverified |
| Gap #1 | Cursor | Cookie policy §3.1 | JWT storage audit — localStorage vs HttpOnly confirmation |
| Gap #5 | Cursor | Cookie policy §4.1, Privacy §9 | Dexie encryption key location audit |
| Dexie purge | Cursor | All three docs | Confirm 3-month auto-purge job is live or flag as planned |

---

## What Claude Code Should Do With These Files

1. Verify the cagent items flagged above (Argon2/PBKDF2 state, Dexie purge job, F-013 retention, JWT storage)
2. Update the `[PENDING T05]`/`[PENDING T06]` markers when those tasks complete
3. When attorney review is done, strip `[ATTORNEY REVIEW]` blocks and update with final wording
4. When placeholder features ship, find and fill `[PLACEHOLDER: ...]` sections
5. Version bump all three documents to v1.1 on any material revision

---

*Claude Web handoff — 2026-06-27*
