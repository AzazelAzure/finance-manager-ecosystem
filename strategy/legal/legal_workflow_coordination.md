# Legal Document Workflow — Multi-Agent Coordination

> **Purpose:** Coordination document for the multi-agent legal workflow. Claude Web handles research and document drafting. Claude Code (this file's home) handles governance and scope review. cagent handles codebase lookups. Cursor/IDE agents handle all code implementation.
>
> **cagent role:** Information gathering ONLY — no coding. Use to pull specific file contents, grep for implementations, or verify current state.
>
> **Workflow:** Claude Web draft → drop to `strategy/legal/drafts/` → Claude Code reviews scope accuracy → cagent verifies any code details → Claude Code annotates → iterate.

---

## Current Implementation State (as of 2026-06-27 audit)

This is the authoritative codebase state for legal document drafting. Claude Web should reference this when writing policy text.

### Authentication

| Item | Current state | Target state | Plan |
|---|---|---|---|
| Access token storage | `localStorage['fm_access_token']` | In-memory JS variable | T05 in `feat-api-security-hardening` |
| Refresh token storage | `localStorage['fm_refresh_token']` | `HttpOnly; Secure; SameSite=Strict` cookie | T05 in `feat-api-security-hardening` |
| Token PII | No PII in JWT payload — confirmed | — | OK now |
| CSRF protection | Unknown — Cursor to verify when running T05 | Required on state-changing routes | T05 scope |

> **Policy implication:** Until T05 is deployed, §3.12 and cookie policy §1.4 CANNOT claim HttpOnly refresh cookie or in-memory access token. Draft with `[PENDING T05]` markers.

### Local Data Storage (Dexie.js)

| Item | Current state | Target state | Plan |
|---|---|---|---|
| Dexie encryption | None — plain Dexie, no plugin | `dexie-encrypted` (XSalsa20-Poly1305) | T06 in `feat-api-security-hardening` |
| Encryption key storage | N/A (no encryption) | API-derived, in-memory only | T06 |
| IndexedDB stores | `outbox` (pending mutations), `caches` (API response mirror), `meta` | Same + encrypted non-indexed fields | T06 |
| Data retention | **No auto-purge exists** (cagent verified 2026-06-27 — `src/offline/seed.ts:31-48` seeds a 92-day window but never deletes; no date-sweep deletion anywhere in `src/offline/`) | Rows persist until overwritten by server sync or browser storage cleared | All three legal docs corrected — "3-month auto-purge" removed |
| Offline model | Dual-write — financial data written to both API and Dexie simultaneously | Same | Already live |

> **Policy implication:** Until T06 is deployed, §3.12 CANNOT claim encryption-at-rest for Dexie. Draft with `[PENDING T06]` markers.

### Server-Side Data

| Data | Status | Retention | Notes |
|---|---|---|---|
| Username | Live — stored in `auth_user.username` | Until account deletion | Only identifier stored |
| Email | Live — stored in `auth_user.email` | Until account deletion | Used for auth + operator contact |
| Hashed password | Live — **Argon2 confirmed as live default** (cagent verified 2026-06-27; PBKDF2 is fallback-verify only for legacy hashes, transparent re-hash on next login) | Until account deletion | Raw password never stored |
| Financial transactions | Live — dual-write with Dexie | Until account deletion | Server is primary store |
| Upcoming expenses | Live | Until account deletion | |
| Categories, tags, payment sources | Live | Until account deletion | |
| Account deletion | Functional — deletes all above via `pre_delete` signal | N/A | `signals.py:89-113` confirmed |
| Error logs (F-013 diagnostic) | Live — `logs/diagnostic/{uuid}.log` | 14 days, 10MB rotation | UUID-keyed, no PII in log records |
| DAU/MAU (F-014) | Live — `DailyUsageSnapshot` model | Indefinite (aggregate, no individual) | |
| Invite chain (F-014) | Live — `InviteChainEvent` model (UUID pairs) | Indefinite | No names/emails |
| Operator alert state (F-014) | Live — `OperatorAlertState` | Indefinite | Internal only |
| Redis usage counters | Planned (observability plan) — NOT YET DEPLOYED | 48h TTL in Redis, then flat-file | Pending VPS deploy |
| Flat-file analytics | Planned — NOT YET DEPLOYED | 90-day rolling | Pending VPS deploy |
| Hashed IP (security) | Planned — NOT YET DEPLOYED | 90-day rolling | Pending VPS deploy |

### Third-Party Processors (confirmed)

| Processor | Role | Data received | Location |
|---|---|---|---|
| Namecheap (Magnetar VPS) | App hosting | All server-side data | phoenixNAP, Phoenix AZ, USA |
| Cloudflare | CDN, DDoS, routing | Raw client IPs, request metadata, CF-Ray | Singapore PoP (confirmed) |

No other third-party processors. No third-party analytics. No advertising.

### Known PII Issues in Codebase (not yet fixed)

- `finance/api_tools/signals.py:55,75,84,131` — Loguru log calls include `user.username` in plain text. These appear in general INFO/DEBUG/CRITICAL logs (NOT in the UUID-keyed F-013 diagnostic logs). Operator-access only, but inconsistent with "no PII in logs" position. Flag for security hardening sprint (add to T05 or T06 scope).

---

## Legal Document Status

| Document | File | Status | Blocked on |
|---|---|---|---|
| Scope analysis | `scope_analysis.md` | ✅ Current | — |
| Cookie/consent requirements | `cookie_consent_requirements.md` | ✅ Draft framework | T05 audit results incorporated |
| ToS requirements | `tos_requirements.md` | ✅ Draft framework | Attorney review (liability cap, arbitration) |
| Privacy policy requirements | `privacy_policy_requirements.md` | ✅ Draft framework | T05, T06 deploy; attorney review |
| **Cookie policy (actual text)** | `drafts/cookie_policy_v1.md` | ✅ v1 draft complete (Claude Web 2026-06-27); Claude Code corrections applied 2026-06-27 | T05/T06 markers in place; attorney review; Dexie purge claim corrected |
| **Terms of Service (actual text)** | `drafts/tos_v1.md` | ✅ v1 draft complete (Claude Web 2026-06-27) | Attorney review (A1–A8); `[ATTORNEY REVIEW]` markers in place |
| **Privacy policy (actual text)** | `drafts/privacy_policy_v1.md` | ✅ v1 draft complete (Claude Web 2026-06-27); Claude Code corrections applied 2026-06-27 | T05/T06 markers; Argon2 confirmed; Dexie purge corrected; attorney review |

---

## Workflow for Claude Web

### What Claude Web should do
1. Read the three requirements documents (`cookie_consent_requirements.md`, `tos_requirements.md`, `privacy_policy_requirements.md`) and this coordination file
2. Draft the actual policy TEXT in `strategy/legal/drafts/` — one file per document
3. Mark items that depend on pending code changes with `[PENDING T05]` or `[PENDING T06]`
4. Mark items requiring attorney review with `[ATTORNEY REVIEW]`
5. Drop draft files here; Claude Code will review for scope accuracy

### What Claude Web should NOT do
- Assume financial data is local-only (it is server-side — dual-write model)
- Claim HttpOnly cookies or Dexie encryption are in place (they are NOT yet — T05/T06 pending)
- Reference any third-party processors other than Namecheap VPS and Cloudflare
- Assume there is a native mobile app (there is a PWA; Android scaffold exists but is not live)

### Codebase questions — use cagent to verify

If Claude Web needs to verify a specific implementation detail before drafting, ask cagent with this format:
```
[LEGAL-QUERY] Verify: [specific question about the codebase]
Example: [LEGAL-QUERY] Verify: Is there a 3-month auto-purge job for Dexie data, and if so, where is it implemented?
```

cagent will grep the codebase and return the file path and relevant code. Results feed back into this file or directly into the draft.

### PH-specific requirements to apply (always)
- Governing law: Republic of the Philippines
- NPC Circular 2023-04 layered notice format
- DPO: Patrick Proctor, `privacy@thehivemanager.com`
- No NPC registration yet (below threshold); DPO designation done
- PH → USA data transfer active (Namecheap VPS in Phoenix AZ); NPC Advisory 2024-01 applies
- Mandatory arbitration language (PH SC April 2025 ruling — "shall be resolved through," not "shall have the right to")
- Financial disclaimer must be prominent: NOT a licensed financial advisor

---

## Items Requiring Attorney Input Before Publication

These sections cannot be finalized without a qualified PH attorney:

| Item | Document | Notes |
|---|---|---|
| Liability cap wording | ToS §2.8 | PH Consumer Act (RA 7394) limits boilerplate disclaimers |
| Arbitration clause final wording | ToS §2.14 | Mandatory language confirmed; attorney to draft actual clause |
| Consumer carve-out (EU/CA) | ToS §2.14 | Class-action waiver enforceability |
| Age-gating implementation specifics | ToS §2.2 | Attorney to confirm self-declaration approach is adequate |
| Does F-003 trigger NPC automated-profiling registration? | Privacy §3.14 | Attorney to assess |
| NPC Advisory 2024-01 cross-border clause | Privacy §3.10 | Attorney to draft contractual clause for Namecheap/Cloudflare |

**Attorney contact:** known to HitM; engagement planned before F-003 launch or entity creation.

---

## Cagent Verification Results (2026-06-27)

| Question | Finding | Documents corrected |
|---|---|---|
| Argon2 or PBKDF2 live? | **Argon2 is live default** — `settings.py:334-340` confirms `Argon2PasswordHasher` at index 0; PBKDF2 is verify-only fallback | `legal_workflow_coordination.md` (this file); removed T01/T02 pending marker from `privacy_policy_v1.md §9` |
| Dexie 3-month auto-purge implemented? | **NOT implemented.** `seed.ts:31-48` seeds a 92-day cache window (writes, never deletes). No date-sweep deletion anywhere in `src/offline/`. Rows persist until overwritten or browser storage cleared. | `privacy_policy_v1.md §3.2, §7`; `cookie_policy_v1.md §4.1` — all "3-month auto-purge" language removed |
| F-013 retention mtime or ctime? | **mtime confirmed** — `logging_config.py:169` compares `stat().st_mtime` (last write); 14-day window resets on each log append; ~1% probabilistic cleanup | No change needed — already stated correctly |

---

## US Market Position

**US is NOT a primary market and NOT fully shut down.** Correct framing (confirmed 2026-06-27):

- US users receive baseline free access to the app — no paid systems built or planned for them
- CYA legal coverage for US (CCPA/CalOPPA in policies) is maintained for the same reason EU coverage exists: to cover incidental users, not because we target either market
- No systems will be built specifically to serve US users; paid features are PH-only
- Honorary Founders concept shifts from US friends → **PH beta testers** (concept stays; audience changes)
- If PH success scales, US market will be revisited — not before

**Policy implication:** CCPA/CalOPPA sections in all three documents stay as-is (CYA coverage). No change needed to any legal text from this clarification.

---

## Open Codebase Gaps (must be resolved before policy text is accurate)

| Gap | Description | Plan | ETA |
|---|---|---|---|
| T05 | JWT storage migration | `feat-api-security-hardening` T05 | Next security sprint |
| T06 | Dexie encryption | `feat-api-security-hardening` T06 | Next security sprint |
| Signals PII | Username in general Loguru sinks | Add to T05/T06 scope or new slice | Next security sprint |
| Dexie 3-month purge | Confirm purge job is actually implemented | cagent verify | ASAP |
| CSRF protection | Confirm state-changing routes have CSRF tokens (required with T05 cookie auth) | T05 scope | Next security sprint |

---

## Draft Directory

Place all draft policy documents in: `strategy/legal/drafts/`

Naming convention:
- `cookie_policy_v1.md` — Cookie & Storage Policy (actual published text)
- `tos_v1.md` — Terms of Service (actual published text)
- `privacy_policy_v1.md` — Privacy Policy (actual published text)

Version bump on each material revision (`v1 → v2`). Archive prior versions.
