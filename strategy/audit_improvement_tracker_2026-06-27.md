# Audit Improvement Tracker — 2026-06-27

**Source:** Antigravity operational audit (`strategy/operational_audit_report.md`)
**Session:** Admin meeting 2026-06-27
**Purpose:** Persistent reference so context isn't lost as each item is executed. Check items off as they close.

---

## Context: What the audit got wrong

Before diving into action items, record what was snapshot-stale so we don't chase false problems:

| Audit finding | Reality |
|---|---|
| "secrets in git — critical" | FALSE. `.env` has zero git history. `smtp.secret` properly gitignored. Not an issue. |
| "automation reliability unknown" | FALSE. Screenshots confirm 5 active automations, 4 scheduled tasks, 88.1% success rate last 7d. |
| "all legal docs are draft" | STALE. Legal pages deploying today (PRs #42, #66, #67). Policies corrected 2026-06-27. |
| "security: T05/T06 pending" | STALE. T05/T06 deployed and on VPS as of 2026-06-27. |
| "automation = cron jobs" | INCORRECT ASSUMPTION. All AI automations are cloud/IDE agent prompts, not cron. Scheduled tasks run in Antigravity's native scheduler. |

---

## Tier 1 — Critical

### ✅ 1A. Secret Exposure — CLEARED
**Audit finding:** `.env` possibly in git history; `smtp.secret` at repo root.
**Resolution:** Verified — `.env` not in API git history. `smtp.secret` is gitignored and never committed. No action needed.
**Closed:** 2026-06-27

---

### 🔄 1B. CI/CD — Minimum Viable Pipeline
**Audit finding:** Zero GitHub Actions workflows. Tests exist but never run automatically. PR template references CI that doesn't exist (creates false process compliance).
**Why this matters:** Any PR can merge regardless of test status. Regressions caught manually, if at all.
**Plan needed:** Yes — Cursor implementation territory.
**Scope:**
- API: pytest + basic migration check on push/PR
- Web: vitest + tsc type check on push/PR
- Branch protection on `main` in both repos: require passing CI before merge
- Health check cron (T03) — GitHub Actions every 10 min, emails on failure (self-hosted uptime monitor)
- Dependabot (T04) — automated dependency CVE scanning
**Effort:** ~3-4 hours Cursor execution
**Owner:** Claude creates plan artifact → Cursor executes
**Status:** **EXECUTING** — `PLAN_CROSS_CI_CD_2026-06-27` handed to Cursor 2026-06-28. T01–T04 task files written. Cursor actively building workflows. T04 (branch protection) must be last.

---

### ✅ 1C. Quarterly Self-Review — COMPLETED
**Due:** 2026-06-30
**Document:** `strategy/quarterly_reviews/2026-Q2.md`
**Completed:** 2026-06-28 (2 days early)
**Gate outcome:** 0/3 yes — continue, no mode change. Sleep regression attributed to newborn + Fajr prayer, not work.
**S1.B status:** 7/14 criteria done (updated). Q3 commits: #10 wedge audit, #12 feature work, #9 distribution research, #13 (done).
**Remaining action:** Copy gate log entry to `kill_commit_gates.md` (HitM).
**Status:** Template ready. Awaiting HitM written answers.

---

## Tier 2 — High Priority

### 🔲 2A. Uptime Monitoring
**Audit finding:** No external alerting. Site can be down for hours without anyone knowing.
**Discussion from session:**
- **Cloudflare (what you have):** Request analytics, error rates visible in dashboard — but no proactive alerting on free tier. Cloudflare Health Checks (active origin probe) is a paid feature (Business/Enterprise). Free Notifications can alert on some events but not pure downtime.
- **VPS metrics (what you have):** Shows server resource health (CPU/RAM/disk). A crashed nginx process still shows the server as "up." Not service-level monitoring.
- **External monitor (Uptime Robot / Healthchecks.io):** Checks from outside your entire stack whether a real HTTP request gets a valid response. NOT redundant — it's a different layer. Cloudflare + VPS metrics cannot catch: nginx crashed but server running, Django app error loop, port not listening.

**Recommendation:** First, check Cloudflare Notifications (free) for error rate spike alerts — log into Cloudflare → Notifications → create alert for "Error rate" on the finance manager zone. If that catches 5xx spikes reliably, it may be sufficient for now. If not, Uptime Robot free tier (50 monitors, 5-minute checks, email alerts) is 10 minutes to set up and genuinely additive.

**Action:** HitM checks Cloudflare Notification config. If error rate alerting is available and configured → sufficient for now. Otherwise, set up Uptime Robot.
**Effort:** 15–30 minutes
**Owner:** HitM (external service account, no code)
**Status:** Pending HitM evaluation

---

### ✅ 2B. Backup Automation — DONE
**Audit finding:** `backup_db.sh` exists but no evidence of automated schedule, verification, or offsite storage.
**Resolution (2026-06-28):**
- `scripts/server/pull_backup.sh` — SSH to VPS, `pg_dump | gzip`, stream to `~/fm_backups/fm_db_DATE.sql.gz`. Includes `gzip -t` integrity check. 30-day local retention with auto-prune.
- `scripts/local/setup_backup_cron.sh` — prints crontab entries; does not auto-edit crontab.
- `governance/disaster_recovery.md` §9 updated with confirmed paths.
- gh auth token stored at `~/.config/fm_gh_token` for cron use.
**Remaining action:** HitM adds crontab entry (`crontab -e`) — line printed by `setup_backup_cron.sh`.

---

### 🔲 2C. VPS Deploy Cadence
**Audit finding:** VPS 12+ days stale vs `main`. Deploy infrastructure is sophisticated; discipline of actually deploying hasn't kept pace.
**Current blue/green status:** Blue inactive, blue smoke status documented as "inactive — no changes deployed" per recent commits.
**Action:** This is part of the blue-smoke VPS sync work already in progress on current branch. Active Cursor agents handling legal/security PRs need to merge and stabilize before next blue deployment.
**Status:** In progress (blocked on open PRs closing)

---

## Tier 3 — Important This Quarter

### ✅ 3A. Disaster Recovery Plan
**Audit finding:** No documented answer to "VPS dies → what happens?"
**Resolution:** `governance/disaster_recovery.md` created 2026-06-27. Covers S1–S5 severity levels, container restart, color switch, full VPS rebuild, DB restore from backup, DNS failover, SSL re-issue, beta tester communication template, open questions on backup storage.
**Status:** Done. Open item flagged: offsite backup storage gap — if backups only live on VPS disk, they die with the VPS in an S4 scenario.

---

### ✅ 3B. Incident Response Plan
**Audit finding:** No documented answer to "data breach → who gets notified, in what order?"
**Why it matters:** PH Data Privacy Act (RA 10173) requires breach notification. Not optional once real user data is in the system.
**Resolution:** `governance/incident_response.md` created 2026-06-27. Covers P0–P3 severity classification, containment steps, full credential rotation checklist, NPC 72-hour notification requirement and template, user notification email template, post-mortem requirement.
**Status:** Done. Attorney review flagged before treating NPC section as authoritative.

---

### 🔄 3C. Dependabot Configuration
**Audit finding:** No automated dependency scanning. CVEs discovered manually, if at all.
**Scope:** Add `.github/dependabot.yml` to API repo and Web repo.
**Owner:** Cursor
**Status:** Folded into CI/CD plan T04. Will be created as part of current Cursor execution. pip + npm + github-actions, weekly Monday schedule.

---

### 🔲 3D. Governance Complexity Audit
**Audit finding:** Plan template at 18.9KB may create overhead exceeding its value at current scale.
**Discussion from session:** Admin rework is already a parked discussion item (`admin_overhaul_proposal_2026-06-26.md`). This includes: plan archival system, decision matrix, lighter plan templates for smaller tasks.
**Status:** Parked — scheduled for future admin discussion session. Not blocking execution.

---

## Tier 4 — Nice to Have

### 🔲 4A. Cost Monitoring Automation
**Audit finding:** Cost tracking is point-in-time, not ongoing. No alert when approaching ₱100/mo cap.
**Current state:** `$102/mo overhead baseline` documented but not verified as current.
**Action:** Add a monthly cost check to an Antigravity scheduled task. Simple: check VPS invoice + Cloudflare + domain + tool spend; compare against cap; flag if >80%.
**Status:** Low priority — quarterly manual check is sufficient for now

---

### 🔲 4B. Repo Hygiene Cleanup
**Audit finding:** Stale files in API submodule root (`scratch.py`, `test_db.py`, `db.sqlite3`, `Untitled`, `get_users.py`, `print_tx.py`). GitHub repo name typos.
**Status:** Low priority. Queued for next Cursor cleanup pass.

---

### 🔲 4C. Structured Business Notes
**Audit finding:** `business_notes.txt` (15KB) is a flat scratch file at repo root. Should be structured into strategy docs.
**Status:** Low priority. Content is context, not lost — just messy.

---

## Automation Scoring Correction (for the record)

The audit scored Automation at 6/10 with "unknown reliability." The screenshots provided (2026-06-27) clarify:

**Antigravity Automations (event-triggered):**
- Stale PR Check ✅
- Assign PR Reviewers ✅
- Scan frontend for vulnerabilities ✅
- Find vulnerabilities in API ✅
- New Automation (just created) ✅

**Antigravity Scheduled Tasks:**
- `daily summary` — Daily at 5:00 AM ✅ enabled
- `documentation-updates` — Weekly Wednesday 9:00 AM ✅ enabled
- `seo-check` — Weekly Tuesday 6:00 AM ✅ enabled
- `project pacing investigator` — Daily 9:00 AM ⚠️ **disabled**

**7-day reliability:** 52 successful / 7 failed = 88.1%

**Actual score: ~7-8/10.** The 11.9% failure rate warrants a check on what's failing — but this is materially better than the audit's "unknown."

**Note on automation architecture:** All AI automations are cloud/IDE agent prompts run in Antigravity's native scheduler. They are NOT cron jobs and should not be evaluated as such. The daily summary and monthly legal compliance prompts created 2026-06-27 follow this same pattern.

---

## Open Questions From Session

| Question | Answer |
|---|---|
| Are automations reliably running? | Yes — 88.1% success rate, confirmed by screenshots |
| Is .env in git history? | No — confirmed clean |
| Is smtp.secret committed? | No — gitignored, never committed |
| Are Cloudflare/VPS metrics redundant with Uptime Robot? | Partially overlapping, not fully redundant — GitHub Actions health check (T03) covers the gap |
| Is backup_db.sh automated? | **Resolved 2026-06-28** — pull_backup.sh created; cron entry ready |
| What's pacing investigator disabled for? | Unknown — HitM to check |

---

## Session 2026-06-28 — Remediation Progress

### What was executed this session (beyond 2026-06-27 plan)

| Item | Audit category | What was done |
|---|---|---|
| VPS state verified via SSH | §3 Deployment, §11 Risk | cagent confirmed: blue active, Celery running, SHAs current. Stale current_status.md was doc drift, not real drift. |
| PR review automation disabled | §7 Automation / credit efficiency | Antigravity PR review auto-comments turned off — high token cost, zero signal for solo operator |
| Daily doc sweep automation | §7 Automation, §8 Documentation | `strategy/automations/prompts/daily_doc_sweep_prompt.md` created. Handles plan reconciliation + stale ref fixes daily. |
| `gather_doc_context.sh` cron script | §7 Automation | Bash data-gather script runs at 4:45 AM before Antigravity sweep. Zero LLM cost for fact collection. |
| `scripts/dev/` utility scripts (4x) | §7 Automation / credit efficiency | `open_prs.sh`, `plan_status.sh`, `submodule_status.sh`, `vps_freshness.sh` — replace agent prompts with zero-cost shell calls |
| Plan registry catch-up | §12 Operational Execution | 9 plans reconciled from Draft → Recently Completed via cagent sweep. Duplicate removed. |
| `pull_backup.sh` | §11 Risk Management | SSH pull of pg_dump with gzip integrity check + 30-day retention. Cron entry ready. |
| `setup_backup_cron.sh` | §11 Risk Management | Helper that prints both cron entries (backup + doc context) for manual review. |
| Quarterly review completed | §12 Operational Execution | 2026-Q2.md completed 2 days early. Gate: 0/3 yes. Q3 commitments locked. |
| Doc sync protocol updated | §8 Documentation | `02_Documentation_Sync_Protocol.md` — removed Reflex/CLI trigger conditions; updated example to current-era feature. |
| Runtime Signup Sheet wired to daily summary | §7 Automation, §8 Documentation | Antigravity daily summary prompt updated to read Runtime_Signup_Sheet.md for VPS state (not validation_gates.md). |

### Estimated score movement

| Category | Original | Estimated now | Driver |
|---|---|---|---|
| CI/CD | 1/10 | 4/10 | Plan executing; workflows being created |
| Risk Management | 3/10 | 6/10 | DR plan, incident response plan, backup script, uptime monitoring (T03) |
| Legal/Compliance | 4/10 | 7/10 | ToS/Privacy/Cookie live; clickwrap live; monthly audit automation running |
| Automation | 6/10 | 8/10 | Doc sweep added; bash scripts replace LLM calls; context gatherer |
| Documentation | 8/10 | 8/10 | Doc sweep helps freshness; plan registry reconciled |
| Operational Execution | 3/10 | 5/10 | 9 plans closed; quarterly review done; VPS confirmed current |
| **Overall** | **5.2/10** | **~6.5/10** | |

### Remaining open items (not yet executed)

| Item | Priority | Owner | Blocker |
|---|---|---|---|
| Copy gate log to `kill_commit_gates.md` | High | HitM | Manual step |
| Add crontab entries (backup + doc context) | High | HitM | Needs `crontab -e` |
| CI/CD T01–T04 complete | High | Cursor | In execution |
| Uptime monitoring (T03 health check) | High | Cursor | In CI/CD plan |
| Email delivery E2E test | Medium | HitM | Submit test bug report via app |
| Entity formation | Deferred | HitM | Marriage processing Jun–Dec 2026 |
| Repo hygiene (scratch.py etc.) | Low | Cursor | Next cleanup pass |
| business_notes.txt restructure | Low | — | Parked |
