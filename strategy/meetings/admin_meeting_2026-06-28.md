# Admin Meeting — 2026-06-28

**Format:** Daily morning admin — current status, parked items, next priorities
**Reference:** `strategy/audit_improvement_tracker_2026-06-27.md`, `strategy/quarterly_reviews/2026-Q2.md`

---

## Carry-in from 2026-06-27 session

Today's session closed the main audit action items:
- ✅ Quarterly review template created (`strategy/quarterly_reviews/2026-Q2.md`) — **HitM fills in by June 30**
- ✅ CI/CD plan created (`PLAN_CROSS_CI_CD_2026-06-27`) — ready for Cursor
- ✅ DR plan created (`governance/disaster_recovery.md`)
- ✅ Incident response plan created (`governance/incident_response.md`)
- ✅ Backup approach decided — local cron pulling pg_dump over SSH; script queued

---

## Discussion Points

### 0. ⚠️ Cursor credit efficiency — HIGH PRIORITY
**Context:** 30% of monthly Cursor credits consumed as of 2026-06-27. At this burn rate, the cap could be hit before month-end. This is a `§7 Cost Discipline Auto-Trigger` watch item.
**Discussion questions:**
- What is the current monthly reset date? How many days remain in the cycle?
- Which agent tasks are burning the most credits? (Large context loads, repeated re-reads, long code generation passes?)
- Can any recurring agent tasks be replaced with bash scripts in `scripts/`?
- Should we reduce active parallel Cursor agents until the reset?
- Is there a "low-credit mode" — lighter tasks only, no large refactors — that preserves runway for must-ship work?
**Goal:** Exit this discussion with a concrete credit rationing plan for the rest of the billing cycle.

---

### 1. Backup script + cron setup
**Context:** Decided to use local dev machine cron (daily `pg_dump` over SSH to local disk). Script not yet written.
**Today's action:**
- Create `scripts/server/pull_backup.sh` — SSH into VPS, `pg_dump | gzip`, save to `~/fm_backups/` with date stamp, prune backups older than 30 days
- Create `scripts/local/setup_backup_cron.sh` — helper that prints the exact `crontab -e` entry to add (do not auto-edit crontab; let HitM review and add manually)
- Update `governance/disaster_recovery.md` §9 with script path once created

### 2. Bash scripts for repeated operations — minimize credit usage
**Context:** Claude/Cursor agents are used for many tasks that could be scripted once and run directly, reducing token spend and session overhead.
**Discussion questions:**
- What operations do we currently invoke via agent that are deterministic and repeatable? (e.g., plan status checks, PR summaries, branch cleanup, submodule sync)
- Which of these could be a bash script in `scripts/` instead of a prompt?
- Are there agent prompts that could be replaced with a `scripts/` wrapper that calls `gh` or `git` directly?
**Goal:** Identify 3–5 candidate scripts. Create them as Cursor tasks or write them inline.
**Examples to consider:**
  - `scripts/dev/plan_status.sh` — grep plan_registry for in_progress/blocked plans; print summary
  - `scripts/dev/open_prs.sh` — `gh pr list --state open` across all three repos in one call
  - `scripts/dev/submodule_status.sh` — show each submodule's current commit vs parent pinned commit
  - `scripts/dev/vps_freshness.sh` — compare VPS deployed SHA against current `main` HEAD

### 3. GitHub Actions orientation
**Context:** CI/CD plan (`PLAN_CROSS_CI_CD_2026-06-27`) is ready for Cursor. HitM has not used GitHub Actions before.
**Discussion:** Walk through what the plan asks Cursor to do before handing it off. No surprises for HitM reviewing the resulting PRs.
**Key things to understand before Cursor runs:**
- Workflows are YAML files in `.github/workflows/` — they run on GitHub's servers on each push
- First run will likely need one round of fixing (secrets, path issues, test DB config) — normal, not a failure
- Branch protection (T04) must wait until T01+T02 have at least one green run
- The health check (T03) goes in the parent repo, not a submodule

### 4. Quarterly self-review — due June 30
**Context:** `strategy/quarterly_reviews/2026-Q2.md` is the template. HitM writes the answers.
**Reminder:** Part 1 (family/health §6 gate) is mandatory and time-sensitive. The gate outcomes log block needs to be copied to `kill_commit_gates.md` after completion.
**Time budget:** ≤30 minutes per the gate spec.

---

## Active Cursor agents (status check)

| Plan | PRs | Status |
|---|---|---|
| feat-legal-pages | Web #66 | In flight |
| feat-signup-clickwrap | API #42, Web #67 | In flight |
| feat-email-comms | TBD | In flight |
| feat-ui-ux-test-seed | API #40 | In flight |
| API security hardening | In progress | T05/T06 deployed to VPS |

---

## Parked (not today)
- Plans archival system + admin artifacts restructure
- Honorary Founders definition in PH context
- Cost monitoring automation
- Repo hygiene cleanup (scratch.py, test_db.py etc.)
