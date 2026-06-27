# Legal Compliance Checklist — The Hive Financial Manager

> **Purpose:** Monthly automated compliance audit reference. Each check specifies what to verify, where to look, what policy claim it validates, and pass/fail criteria. The monthly automation reads this document and runs each check against the current codebase state.
>
> **Last updated:** 2026-06-27
> **Maintained by:** Claude Code (admin/governance)
> **Used by:** Antigravity monthly compliance automation (`strategy/automations/prompts/legal_compliance_monthly_prompt.md`)
>
> **Update protocol:** When any of the following change, update the relevant check(s) here BEFORE the next monthly run:
> - A new feature ships that touches data collection, storage, or processing
> - A policy document is updated (update the "Policy claim" lines)
> - A pending item (`[PENDING]`) is resolved (remove the pending flag; update the check)
> - A new third-party processor is added
>
> **Report output:** `strategy/legal/compliance_reports/YYYY-MM.md`

---

## Baseline state (updated 2026-06-27)

These are confirmed live as of this date. Checks below verify they remain true.

- **T05 deployed:** JWT access token in memory; refresh token in `HttpOnly; Secure; SameSite=Strict` cookie
- **T06 deployed:** Dexie.js encrypted at rest via `dexie-encrypted` (XSalsa20-Poly1305); key API-derived, in-memory only
- **Argon2 live:** Default password hasher confirmed (`settings.py:334`)
- **No Dexie auto-purge:** Policy correctly states no time-based purge (corrected 2026-06-27)
- **PII in logs (open):** `signals.py` still logs `user.username` in general Loguru sinks — known gap, pending scrub

> **⚠️ Immediate action (first run only):** The published policy files at `finance_manager_web/src/content/legal/` still contain "Until T05/T06 deploys, tokens are in localStorage / local copy not encrypted" language. These must be updated to reflect the NOW-DEPLOYED state before the next user sees the policies. See Check C3.3 and C3.4 below.

---

## Category 1 — Data Collection

**What we claim:** Privacy Policy §3.1–§3.4 — we collect only: username, email, hashed password (Argon2), financial transaction data. No real name, no phone, no payment card. Server-side (dual-write model).

### C1.1 — AppProfile / User model fields

**Where to look:** `finance_manager_api/finance/models.py` — all model classes  
**What to check:** List all CharField, EmailField, TextField, UUIDField on `AppProfile`, `Transaction`, `UpcomingExpense`, `Category`, `PaymentSource`, `Tag`, `SupportTicket`, and any new models  
**Policy claim:** Only disclosed fields exist (see §3.1 data table in privacy_policy_v1.md)  
**Pass:** Every field maps to a disclosed data category  
**Fail:** Any PII-capable field (name, phone, address, DOB, national ID, payment card) exists and is NOT in the policy

### C1.2 — New external HTTP calls

**Where to look:** `grep -rn "requests\.\|httpx\.\|urllib" finance_manager_api/finance/` (exclude tests/, .venv/)  
**What to check:** Any outbound HTTP call to a third-party service not in the processor table  
**Policy claim:** Only Namecheap VPS (internal) and Cloudflare (proxy-layer) receive data; no third-party analytics or error logging services  
**Pass:** No external HTTP calls to undisclosed third-party services  
**Fail:** Any external HTTP call to a new service not listed in Privacy Policy §5 processor table

### C1.3 — New installed packages that phone home

**Where to look:** `finance_manager_api/requirements.txt` or `pyproject.toml`; `finance_manager_web/package.json`  
**What to check:** Any new package containing keywords: analytics, tracking, sentry, datadog, segment, mixpanel, fullstory, hotjar, logrocket  
**Policy claim:** No third-party analytics, error logging, or tracking services deployed  
**Pass:** No such packages present  
**Fail:** Any matching package found — assess whether it constitutes a new processor; update §5 if so

---

## Category 2 — Data Retention

**What we claim:** Privacy Policy §7 retention table.

### C2.1 — F-013 diagnostic log retention (14-day, mtime)

**Where to look:** `finance_manager_api/finance/management/logging_config.py`  
**What to check:** Line with `stat().st_mtime` comparison; confirm `14 * 86400` window unchanged; confirm cleanup is probabilistic (~1%)  
**Policy claim:** "14 days, 10MB rotation" — probabilistic cleanup noted in legal_workflow_coordination.md  
**Pass:** `mtime` + `14 * 86400` present; cleanup probabilistic  
**Fail:** Retention window changed; or switched to ctime; or cleanup removed (logs never deleted)

### C2.2 — Dexie no auto-purge (policy says: no time-based purge)

**Where to look:** `finance_manager_web/src/offline/` — all files  
**What to check:** `grep -n "delete\|purge\|clear\|unlink" src/offline/` — look for any NEW date-based deletion logic  
**Policy claim:** "No automatic purge — persists until browser storage is cleared or account deleted" (corrected 2026-06-27)  
**Pass:** No date-sweep deletion found (drain-on-success clear is OK; that's not time-based)  
**Fail/Changed:** A date-based purge job was added — policy must be updated to reflect the new retention period

### C2.3 — Aggregate data (DailyUsageSnapshot, InviteChainEvent) — indefinite, no PII

**Where to look:** `finance_manager_api/finance/models.py` — `DailyUsageSnapshot`, `InviteChainEvent`  
**What to check:** Verify no new PII fields added to these models; verify no auto-delete logic added  
**Policy claim:** "Indefinite — aggregate/pseudonymous; no individual-level data"  
**Pass:** Models unchanged or only have aggregate fields; no individual user PII  
**Fail:** PII field (email, name, etc.) added to aggregate models; or an auto-delete was added without policy update

### C2.4 — SupportTicket retention

**Where to look:** `finance_manager_api/finance/models.py` — `SupportTicket` + any new signals/tasks that delete tickets  
**Policy claim:** Implied "until account deletion" (covered by `pre_delete` signal on User)  
**Pass:** No standalone ticket retention/deletion logic beyond account deletion  
**Fail:** Auto-delete by age added without policy update

---

## Category 3 — Security Posture

**What we claim:** Privacy Policy §9 security measures. Cookie Policy §3.1.

### C3.1 — JWT: access token NOT in localStorage (post-T05)

**Where to look:** `finance_manager_web/src/state/auth.ts` and any other auth-related files  
**What to check:** `grep -n "localStorage.*fm_access\|localStorage.*fm_refresh" src/state/auth.ts`  
**Policy claim (post-T05):** Access token in memory; refresh token in HttpOnly cookie; no tokens in localStorage  
**Pass:** 0 matches — tokens not in localStorage  
**Fail:** Matches found — T05 regression or partial deployment; policy "until T05" disclosure still showing

### C3.2 — Dexie encryption active (post-T06)

**Where to look:** `finance_manager_web/src/offline/db.ts`  
**What to check:** `grep -n "applyEncryptionMiddleware\|dexie-encrypted" src/offline/db.ts`  
**Policy claim (post-T06):** "Local Dexie copy encrypted at rest using XSalsa20-Poly1305; key in memory only"  
**Pass:** `applyEncryptionMiddleware` found in db.ts  
**Fail:** Not found — T06 regression; policy incorrectly claims encryption

### C3.3 — Published cookie policy: remove "Until T05" language

**Where to look:** `finance_manager_web/src/content/legal/cookies.md`  
**What to check:** `grep -n "Until T05\|localStorage.*interim\|Until T05 is deployed\|tokens are currently stored in localStorage"` in the published policy file  
**Policy claim target:** Policy should now state HttpOnly cookie is LIVE (T05 deployed)  
**Pass:** No "Until T05" language found in published file — it's been updated  
**Fail/Action:** Language found — the published policy has not been updated yet. Update `src/content/legal/cookies.md` §3.1 to remove the interim disclosure and state the current (deployed) state.

### C3.4 — Published privacy policy: remove "Until T06" language

**Where to look:** `finance_manager_web/src/content/legal/privacy_policy.md`  
**What to check:** `grep -n "Until T06\|not currently encrypted\|Until T06 is deployed"` in the published policy file  
**Policy claim target:** Policy should state Dexie encryption is LIVE (T06 deployed)  
**Pass:** No "Until T06" language found — policy updated  
**Fail/Action:** Language found — update `src/content/legal/privacy_policy.md` §9 and §3.2 to reflect T06 deployed state

### C3.5 — Argon2 remains default hasher

**Where to look:** `finance_manager_api/finance_api/settings.py`  
**What to check:** `grep -n "PASSWORD_HASHERS" settings.py` — confirm `Argon2PasswordHasher` is index 0  
**Policy claim:** "Password stored as one-way Argon2id hash"  
**Pass:** Argon2PasswordHasher first in list  
**Fail:** Different hasher moved to index 0; or Argon2 removed

---

## Category 4 — PII in Logs

**What we claim:** Privacy Policy §3.3 — "certain internal operational log entries currently include your username in plain text; known gap being resolved."

### C4.1 — signals.py username logging status

**Where to look:** `finance_manager_api/finance/api_tools/signals.py` — lines 55, 75, 84, 131 (as of last audit)  
**What to check:** `grep -n "user.username\|user\.email" finance_manager_api/finance/api_tools/signals.py`  
**Current state:** Username present — this is the KNOWN GAP disclosed in §3.3  
**Pass (gap closed):** 0 matches → remove §3.3 disclosure note from published privacy policy  
**Unchanged:** Matches present → keep §3.3 note; verify disclosure language is still accurate  
**Fail:** New PII fields (email, name, financial amounts) added to log calls — not currently disclosed

### C4.2 — No new PII log calls in other files

**Where to look:** `grep -rn "logger\.\|log\.info\|log\.debug\|log\.warning\|log\.error" finance_manager_api/finance/` (exclude tests/)  
**What to check:** Any new log call that includes `user.email`, `user.first_name`, or any financial amounts/transaction descriptions  
**Pass:** No new PII log calls beyond known signals.py gap  
**Fail:** New PII in logs — flag for scrub; update §3.3 if needed

---

## Category 5 — Third-Party Processors

**What we claim:** Privacy Policy §5 — only Namecheap (phoenixNAP VPS) and Cloudflare.

### C5.1 — Docker Compose: no new services

**Where to look:** `docker-compose.bluegreen.yml`  
**What to check:** List all service images — compare against known: `postgres`, `redis`, `web` (Nginx/Caddy), `api` (Django), `celery_worker`, `celery_beat`  
**Pass:** Only known services present  
**Fail/Changed:** New external service added (e.g., Sentry, external log shipper, new DB) — assess if it's a new processor; update §5

### C5.2 — Settings: INSTALLED_APPS and middleware

**Where to look:** `finance_manager_api/finance_api/settings.py` — `INSTALLED_APPS`, `MIDDLEWARE`  
**What to check:** Any new third-party app or middleware that sends data externally  
**Pass:** Only known apps (Django, axes, rest_framework, corsheaders, etc.)  
**Fail:** New external-data-sharing app installed without policy update

---

## Category 6 — Open Item Tracker

Track the status of known legal open items. Report current state.

| Item | Description | Check | Resolution trigger |
|---|---|---|---|
| N2 | Clickwrap ToS acceptance logged | `grep -n "tos_accepted_at\|tos_version" finance_manager_api/finance/models.py` and `SignupPage.tsx` for checkbox | Closed when field exists + UI shows checkbox |
| N4 | Dexie opt-out mechanism | `grep -rn "opt.*out\|dexie.*disable\|clear.*dexie\|IndexedDB" finance_manager_web/src/pages/settings/` | Closed when settings page has Dexie opt-out |
| N5 | Multi-user single PWA Dexie instance | Check if per-user Dexie DB naming exists in `src/offline/db.ts` | Closed when per-user namespace OR explicit disclosure added to cookie policy |
| Signals PII | username in general Loguru sinks | `grep -n "user.username" finance_manager_api/finance/api_tools/signals.py` | Closed when 0 matches; remove §3.3 disclosure note |
| N2 deploy | Published clickwrap ToS version to reflect | Check `AppProfile` model for tos fields | Closed when model has fields AND signup UI has checkbox |

---

## Category 7 — New Feature Legal Impact Detection

Run after checking git log for commits since last monthly run.

**Command:** `git log --since="30 days ago" --oneline -- finance_manager_api/finance/models.py finance_manager_web/src/`

For each commit touching models, check:
- **New model fields:** Does the field collect PII or financial data not already in the privacy policy data table?
- **New API endpoints:** Does the endpoint collect, process, or expose data not already disclosed?
- **New localStorage/cookie keys:** Does the web app write to any new key not in the cookie policy storage inventory?
- **New email sends:** Does any new email send expose data not covered by "communicating service changes"?

**If any new item found:** Flag for HitM review. New items need either (a) confirmation they're within scope of existing disclosures, or (b) a policy update before next monthly report.

---

## Legal framework references

| Document | Requirement | Applicability |
|---|---|---|
| RA 10173 (PH-DPA) | Lawful basis, DPO, NPC breach notification (72h) | Primary — PH users |
| NPC Circular 2023-04 | Layered notice at setup | Required |
| NPC Advisory 2024-01 | PH→USA cross-border transfer clause | Active (Namecheap VPS in Phoenix AZ) |
| PH SC Arbitration ruling (Apr 2025) | Mandatory arbitration language in ToS | In ToS §15 |
| CCPA/CalOPPA | "We do not sell" statement; Do-Not-Track disclosure | CYA — US incidental users |
| COPPA | "No under-13" statement | CYA — US incidental users |
| GDPR (EU) | Basic rights table in privacy policy | CYA — no EU targeting |
| RA 7394 (PH Consumer Act) | Liability cap enforceability | Attorney review required |
