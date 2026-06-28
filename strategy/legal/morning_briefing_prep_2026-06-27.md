# Morning Briefing Prep — Legal Sweep 2026-06-27

> **For use at:** morning admin meeting, after daily summary is created  
> **Session scope:** Legal document sweep — absorbing HitM comments, correcting scope analysis, identifying today's execution targets

---

## 1. What Moved Since Last Session

- **Gap #3 CLOSED:** `privacy@thehivemanager.com` created; HitM formally designated DPO
- **Three legal requirement docs created and annotated:** `tos_requirements.md`, `privacy_policy_requirements.md`, `cookie_consent_requirements.md`
- **HitM comments absorbed** from ToS and Privacy Policy docs — 12 new open items identified
- **Critical architecture correction applied** to privacy policy docs and scope analysis (see §2 below)
- **VPS confirmed:** Namecheap Magnetar, phoenixNAP Phoenix AZ USA — now in processor table

---

## 2. Critical Correction (must carry into all drafting)

**Original claim (wrong):** "Financial data never leaves the device."  
**Actual model:** Dual-write — user-entered data is written to the server API AND Dexie simultaneously. The Dexie copy is an offline mirror, not the primary store. The operator DOES receive and store financial transaction data.

**What this changes:**
- Privacy policy §3.2 data table — corrected; financial transaction data now listed as server-side
- §3.3 PLACEHOLDERs — account data and financial data reclassified as LIVE NOW
- Privacy story reframe: strong position is now "minimal PII + no data sold + no third-party analytics," not "local-only"
- PH → USA data transfer is ACTIVE (VPS in Phoenix AZ) — disclosure required

**What stays accurate:**
- No real name or additional PII stored (username + email only)
- Account deletion is fully functional server-side; deletes all user data except UUID-keyed error logs
- No third-party analytics whatsoever

---

## 3. Active Parked Items

| Item | Status | Trigger |
|---|---|---|
| Attorney review (liability cap, arbitration, NPC profiling Q for F-003) | Parked — attorney contact known | Before F-003 launch or entity creation, whichever is first |
| ToS + Privacy Policy + Cookie Policy publication | Parked — Cursor audits (#1, #5) + attorney must happen first | P1 (S1.B exit gate) |
| Facebook OAuth research | Parked — HitM to research | Before OAuth sprint |

---

## 4. Today's Execution Targets (legal sweep)

These are the items that can move today without attorney input:

### 4a. Cursor execution items (can brief cagent / Cursor now)
| # | Item | Plan artifact |
|---|---|---|
| Gap #1 | JWT storage audit — grep `finance_manager_web` for token storage location | None — ad hoc Cursor task |
| Gap #5 | Dexie encryption key location — verify not in localStorage | None — ad hoc Cursor task |
| N6 | F-013 Loguru retention policy — confirm current setting | None — ad hoc Cursor task |

> **Suggested cagent prompt:** "Audit three things in finance_manager_web and finance_manager_api: (1) Where are JWT tokens stored — specifically the access token and refresh token storage mechanism in the web app; (2) Where does Dexie.js store its encryption key — is it derived from a user secret, stored in localStorage, or fetched from backend; (3) What is the F-013 Loguru retention/rotation config on the API side — how long are per-UUID log files kept. Report findings per item."

### 4b. Governance items (Claude Code, this session)
| # | Item | Output |
|---|---|---|
| N7 | Data retention compliance tier 0-5 briefing | New doc: `data_retention_compliance_tier.md` |
| N2 | Add clickwrap + ToS link to Cursor's implementation checklist | Update to API security hardening plan or new task |
| N4 | Document Dexie opt-out requirement as a legal-required feature | PLACEHOLDER task note in `feat-celery-observability` or new plan |
| N5 | Document multi-user single PWA Dexie instance gap | Add to `scope_analysis.md` N5 as a tracked open gap |
| N8 | Document age gate as front-end self-declaration (not verified) | Update §3.11 in privacy policy doc |

### 4c. Discussion items (HitM to resolve, no agent needed)
| # | Item | What's needed |
|---|---|---|
| N1 | Financial advice definition — what will literacy content look like? | HitM describes scope so it can be noted in §2.3 |
| N9 | Facebook OAuth research | HitM researches or defers |

---

## 5. §3.8 Data Retention Compliance Tier (N7 — draft)

> **Requested by HitM:** Tier each data point 0-5; 0=not operational, 5=fully operational AND compliant.

| Data Point | Tier | Notes / Gap to Compliance |
|---|---|---|
| Financial transaction data (server-side) | 3 | Live and operational; retention policy not yet formally defined; deletion on account delete is confirmed; no policy stated for inactive accounts |
| Username + email (account record) | 3 | Live; deletion on account delete confirmed; no automatic inactive-account expiry policy |
| Hashed password | 4 | Live; hash only (no raw password); deletion on account delete; minor: algorithm not confirmed in docs |
| Dexie.js local data | 3 | Live; 3-month auto-purge exists; opt-out mechanism not yet built (N4); multi-user gap (N5) |
| Pseudonymous hashed IP (Redis/flat files) | 2 | Observability plan written; not yet deployed; 90-day retention spec exists in plan but not implemented |
| User UUID in logs (F-014) | 2 | F-014 deployed; DAU/MAU models live; retention policy for raw InviteChainEvent and DailyUsageSnapshot records not defined |
| User agent class (Redis) | 2 | Observability plan written; not yet deployed |
| API endpoint / method / response code (Redis) | 2 | Observability plan written; not yet deployed |
| F-013 Loguru per-UUID diagnostic logs | 1 | Live; retention duration UNKNOWN — Gap N6 (Cursor audit needed); not in any published retention policy |
| Invite chain (F-014 InviteChainEvent) | 2 | F-014 deployed; records stored indefinitely currently; no expiry policy defined |
| DAU/MAU aggregate counts | 4 | F-014 deployed; aggregate only; no PII; indefinite retention acceptable |

**Tier definitions:**
- **0** — Feature/data not operational
- **1** — Operational but no retention policy defined
- **2** — Plan written; not yet deployed or policy draft only
- **3** — Operational + partially compliant; known gaps remain
- **4** — Operational + substantially compliant; minor documentation gap only
- **5** — Fully operational AND compliant; retention stated, enforced, and disclosed

**Items needing immediate attention to reach Tier 3+:**
- F-013 Loguru: audit retention config (Gap N6)
- Hashed IP / API analytics: deploy observability plan (currently Tier 2 — plan exists, Cursor execution pending)
- Account data: define inactive-account expiry policy (or state none exists and justify under PH-DPA purpose limitation)

---

## 6. Remaining Gaps Summary

| Gap | Description | Owner | Blocked? |
|---|---|---|---|
| #1 | JWT storage location | Cursor | No |
| #2 | Liability cap PH enforceability | Attorney | Yes — needs attorney |
| #4 | Hashed IP disclosure language | Governance | No — use "pseudonymous security identifier" |
| #5 | Dexie encryption key location | Cursor | No |
| N1 | Financial advice definition | HitM + Attorney | Partial — HitM can describe scope now |
| N2 | Clickwrap + ToS link in cookie banner | Cursor | No |
| N4 | Dexie opt-out mechanism | Cursor | No — but needs design first |
| N5 | Multi-user single Dexie instance | Cursor + Attorney | Partially blocked — design + legal |
| N6 | F-013 retention policy | Cursor | No |

---

## 7. What's NOT On Today's List

- Publishing any policy documents (blocked on attorney + Gap #1/#5)
- F-003 profiling/NPC question (attorney)
- Facebook OAuth research (HitM)
- Account creation wizard revamp (S1.C, not current)
- Subscription billing clauses (P2)
