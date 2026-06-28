# Admin Meeting Notes — 2026-06-29

**Generated:** 2026-06-29 morning  
**Source:** daily_summary_2026-06-29.md + doc_sweep_2026-06-29.md + anomaly queue  
**Purpose:** Standing sync — orient, surface blockers, decide today's work order

---

## 1. Overnight Wins (what actually shipped)

This was a very large execution day. Everything queued is now merged to `main`.


| Feature                                       | PRs                      | State          |
| --------------------------------------------- | ------------------------ | -------------- |
| F-004 STS Pay Cycles + Bill Realism           | API #52–#55, Web #81–#83 | Merged         |
| F-001 Balance History + Chart                 | API #56, Web #84         | Merged         |
| F-010 Export & Sharing                        | API #57–#60, Web #85–#87 | Merged         |
| F-005 Savings Goals                           | API #61–#62, Web #88–#89 | Merged         |
| F-011 Landing Page T02 (feature showcase)     | Web #90                  | Merged         |
| Production UX batch (nav/labels/wizard/legal) | API #51, Web #80         | Merged (prior) |


---

## 2. Operational Issues — Requires Discussion

### 2A. ~~HIGH — Active stack API/Web mismatch~~ ✅ CONFIRMED RESOLVED (cagent 2026-06-29)

**What the summary said:** Active green API on old SHA (`defd844`), F-005 endpoints missing.

**Actual state:** cagent confirmed active green API is on `42bfd0e` (latest main), migration `0016_savings_goal` applied, `GET /finance/savings-goals/` returns 401 (auth-gated, not 404). Daily summary had a stale SHA captured before the VPS rebuild completed. No action needed.

---

### 2B. ~~HIGH — Celery not running on VPS~~ ✅ CONFIRMED RESOLVED (cagent 2026-06-29)

**What the summary said:** Celery worker + beat not deployed.

**Actual state:** cagent confirmed both containers running — `fm-beta_celery-worker_1` and `fm-beta_celery-beat_1` both up 12 hours. All 9 containers healthy (db, redis, web-green, api-green, web-blue, api-blue, proxy, worker, beat). No action needed.

---

### 2C. MEDIUM — Anomaly: Bill recurrence engine is a stopgap

**File:** `strategy/anomalies/2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md`

**What:** The overdue bill catch-up in `finance/logic/updaters.py:267-268` still uses `relativedelta(months=1)`. The T02 fix chose interval-based advance (HitM chose option B), but the API has no first-class cadence field on `UpcomingExpense` — it's inferred from `start_date`/`due_date` deltas. Weekly/biweekly/pay-cycle-aligned bills will behave incorrectly.

**Dispatch:** Cursor — follow-up plan or F-009 slice. Not production-critical right now (no users on weekly bills yet), but needs a plan before F-009 ships recurring auto-deduct.

**Decision needed:** Do we track this as a standalone fix plan, or absorb it into F-009 scope? Recommend: absorb into F-009 T01 (schema) since that's when cadence becomes first-class.



[1] This is something I had it flag personally during operations while a different feature was being created.  This is going to require it's own action item because it will require significant API reworks on how upcoming expenses are handled and calculated, and that will carry forward to the front end for how they're displayed.  

---

### 2D. LOW — Anomaly: `fm_server_beta.sh check` nginx validation always fails

**File:** `strategy/anomalies/2026-06-28_CI-CD_fm-server-beta-check-nginx-resolver.md`

**What:** `check_cmd` in `fm_server_beta.sh` spins up a throwaway `nginx:alpine` container that doesn't mount `proxy/00-resolver.conf`, so the test always exits 1 even when the live proxy is healthy.

**Dispatch:** Cursor — small chore on `fm_server_beta.sh`. Likely fix: add the resolver conf to the mount list, or switch to `exec -T proxy nginx -t` on the live container.

**Decision needed:** Is `00-resolver.conf` committed to the repo or generated at runtime? That determines the fix path. Worth a quick check during today's VPS work.



[2] Full discloser, I actually do not know what any of this does or means personally, as this is outside my scope of knowledge.  I would need to be educated on what it is actually doing and the effects of the different options before I make a decision on this.

---

### 2E. LOW — Stale containers on VPS

Old `finance-manager-db` and `finance-manager-proxy` containers are exited and unused. Safe to prune during the blue-green rebuild today (`podman container prune` or manual removal).



[3] This *should* have been taken care of already.  I had an agent rework the server script to auto-prune old containers.  If there are still old containers, they need to be pruned, and our vps automation scripts need to be adjusted to check for/prune old containers automatically.  This has been a continued issue that has cause significant build and deploy issues historically.  

---

## 3. Doc Sweep Findings (informational)

The automated sweep ran overnight and fixed the following:

- `scripts/fm_docker.sh` → `scripts/fm_server_beta.sh` in 3 design docs
- Stale Cursor PA / old runner references updated to three-tool model in Inter-Agent doc
- Old `cursor/s1b/`* branch prefix → `agy/s1b/*` in inter-agent doc
- "Reflex" references in historical checkpoint/roadmap files left intact (per scope rules)

**Flagged for HitM review:** 5 old draft plans (F-002, F-003, F-006, F-008, F-009) are 55+ days old with no merged PRs. No action needed now — consistent with priority matrix. Just acknowledging the flag.



[4] We need to adjust this sweep, and ad another sweep that specifically writes the tech docs in design docs.  

---

## 4. Dependabot Queue

14 open Dependabot PRs (7 API, 7 Web) opened after CI/CD went live. None are blocking. Discuss: batch-merge strategy? Options:

- A) Let Cursor review + merge in a single chore pass today (uses ~5-10% credits)
- B) Review manually and merge from GitHub UI (zero credit cost)
- C) Defer to weekly cadence (set expectation now)

Recommend: B for the straightforward ones (patch bumps); A for anything that needs a test run (eslint major version bump `8→9` on Web #77 — that one needs a build check).



[5] This may be an API credits issue, depending on how who runs the dependabot.  I am out of cursor API credits (thus the massive usage percentage).  We will need to discuss this for what is actually necessary, along with some other work arounds for no API credits and what it means for production. 

---

## 5. Discussion Points — Decisions & Open Questions

*Working section. HitM comments welcome inline below each point.*

---

### D1 — Cursor API Credits Exhausted

**Context:** HitM confirmed Cursor API credits are exhausted (comment [5] on §4). This is the highest-priority operational constraint for today — it gates everything that would normally go to Cursor.

**Impact:**
- No Cursor for code, tests, or multi-file changes until billing resets
- Dependabot queue cannot go to Cursor
- VPS script fixes (nginx check, stale container prune) wait for reset
- Claude Code fully available: plan authoring, governance, task files, content — zero Cursor cost
- Antigravity fully available: single-file content changes with exact specs
- cagent available: read-only VPS verification and shell-only operations

**Decisions needed:**
- When does Cursor billing reset?
- Which work streams can run Claude Code + Antigravity + cagent only?
- Any production-critical code fixes that can't wait for reset?

> HitM:

---

### D2 — Bill Recurrence Engine: Standalone Plan Required

**Context:** HitM confirmed in comment [1] this requires its own plan. The current implementation infers bill cadence from `start_date`/`due_date` deltas in `finance/logic/updaters.py`. When F-009 ships recurring auto-deduct, bills with non-monthly cycles will miscalculate. Needs a first-class `cadence` field on `UpcomingExpense` plus API and frontend ripple.

**What Claude Code can do today:** Author the plan README + task files at zero Cursor cost. Cursor executes when credits reset.

**Decisions needed:**
- Suggested plan ID: `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` — confirm or rename
- Does recurrence engine need to land *before* F-009 executes, or can F-009 ship and recurrence follow?
- Priority relative to F-006 / F-009?

> HitM:

---

### D3 — nginx Check False Negative: Plain-Language Explanation + Decision

**Context:** HitM noted in comment [2] this is outside their scope of knowledge.

**Plain-language explanation:** `fm_server_beta.sh check` is a pre-deploy safety test that confirms the nginx proxy config has no syntax errors. It works by spinning up a throwaway nginx container and running `nginx -t` (nginx's own self-check command). The problem: the throwaway container is missing one config file (`00-resolver.conf`) that only exists inside the real running proxy. So the test always fails — not because nginx is broken, but because the test environment is missing a file. The live proxy is healthy; only the *test* is broken.

**Options:**
- **A) Fix the test** — mount `00-resolver.conf` into the throwaway container, or point the test at the live proxy container instead. Correct long-term. ~30 min Cursor chore when credits reset.
- **B) Skip the nginx test in `check` for now** — unblocks the script but removes a safety check.

Recommend A. No HitM technical action required — just confirm "fix it properly when credits reset."

> HitM:

---

### D4 — Stale Container Auto-Prune: Verify Then Fix

**Context:** HitM noted in comment [3] that an agent already added auto-prune to `fm_server_beta.sh`. If old containers are still present, the logic isn't firing. If they're already gone, the daily summary was simply stale (same SHA issue as 2A/2B). cagent can confirm at zero cost.

**Proposed action:** Send cagent to check `podman ps -a` for any exited containers. If old ones are still present, file a Cursor chore for billing reset. If gone, close this item.

**Decisions needed:**
- Approve cagent verification check?

> HitM:

---

### D5 — Documentation Accuracy Gap (Root Cause Discussion)

**Context:** HitM manually ran doc sweeps after all deploys completed, then Antigravity swept again this morning — yet the daily summary still showed wrong VPS SHAs and wrong Celery state. Both were confirmed as false alarms by cagent. This is a systemic issue.

**Likely root cause:** The automation reads from `daily_context.md` (a cached context file generated at sweep start), not from live VPS state at summary-write time. If that file was generated before the VPS rebuild completed, all downstream output inherits the stale data — even after a manual re-sweep, because the sweep re-reads the same cached file rather than re-querying the VPS.

**What needs to change:**
- Option A: `gather_doc_context.sh` SSHes the VPS on every run and writes live container + SHA state into context. Correct long-term.
- Option B: Daily summary template explicitly flags VPS state as point-in-time with timestamp, so stale reads are visible rather than hidden.

Recommend A. Claude Code writes the fix spec; Cursor implements when credits reset.

**Secondary question:** Should `gather_doc_context.sh` be the canonical live-state source, or should a separate `vps_state.sh` snapshot run independently and feed into it?

> HitM:

---

### D6 — Design Doc Sweep: New Automation Scope

**Context:** HitM noted in comment [4] a new automation is needed that actively writes/updates `design_docs/`. Current sweep corrects stale references but doesn't proactively generate or update docs to reflect shipped state.

**Proposed scope:**
- Target: `design_docs/10_Current_State/` first (highest drift risk)
- Trigger: weekly or after feature plan closes
- Output: updated runtime checklist, architecture current-state, shipped feature list
- Separate prompt file from `daily_doc_sweep_prompt.md` to keep concerns isolated

**Decisions needed:**
- Which `design_docs/` sections have drifted most — confirm `10_Current_State/` as first target?
- Weekly cadence or tied to plan completion?
- Should Claude Code draft the prompt file today?

> HitM:

---

### D7 — Dependabot Queue (Revised for No-Credits Constraint)

**Context:** 14 open Dependabot PRs (7 API, 7 Web). With Cursor credits out, the original recommendation (Cursor pass) is off the table.

**Revised options:**
- **A) HitM merges patch bumps manually from GitHub UI** — most are trivial (patch version deps, GitHub Actions bumps). Defer eslint `8→9` (Web #77) until Cursor resets for a proper build check. ~10 min.
- **B) Defer all 14 until Cursor credits reset** — clean single-agent pass, zero manual effort.
- **C) cagent checks CI status on each branch** — HitM decides per-PR based on pass/fail. Middle ground.

> HitM:

---

### D8 — Morning Meeting Format: Formalize Structure

**Context:** HitM requested formalizing how morning sessions are structured so future sessions are consistent and don't require re-derivation.

**Proposed standard sections:**
1. Overnight wins (merged/deployed — from git, not cached context)
2. Operational status (VPS live state — SSH-verified, not cached)
3. Open anomalies (dispatch or dismiss each)
4. Doc sweep findings
5. Discussion points (HitM decisions needed)
6. Work order (by agent + Cursor cost estimate)
7. S1.B exit progress (updated only after feature pushes)

**What needs to be built:** A meeting template file + a generation prompt that queries live state. Connects directly to D5 (documentation accuracy gap).

**Decisions needed:**
- Confirm this section structure, or adjust?
- Should the morning meeting be generated by Antigravity (automated) or seeded by Claude Code (manual trigger at session start)?

> HitM:

---

## 6. Work Order (provisional — pending D1–D8 responses)

**Claude Code (available now, zero Cursor cost):**
- [ ] Bill recurrence engine plan README + task files (D2 — pending name confirm)
- [ ] Update plan registry: F-005 + F-010 → Recently Completed
- [ ] Fix spec for `gather_doc_context.sh` live VPS query (D5)
- [ ] Design doc sweep prompt draft (D6 — pending scope confirm)
- [ ] Morning meeting template file (D8)

**cagent (available now, read-only):**
- [ ] Verify stale containers actually pruned (D4 — pending approve)

**HitM manual (GitHub UI, ~10 min if approved):**
- [ ] Merge patch-level Dependabot PRs; defer eslint `8→9` (D7)

**Cursor (defer to billing reset):**
- [ ] nginx check fix (D3)
- [ ] `fm_server_beta.sh` prune logic fix if needed (D4)
- [ ] `gather_doc_context.sh` VPS live-query implementation (D5)
- [ ] eslint `8→9` Dependabot review (D7)

---

## 7. S1.B Exit Progress Update

After yesterday's feature push:

| Gate | Before yesterday | After yesterday |
|---|---|---|
| Core ledger (F-001 balance, F-004 STS, F-005 goals, F-010 export) | Partial | **Closed** |
| Legal + compliance | ✅ Done | — |
| CI/CD | ✅ Done | — |
| Security | ✅ Done | — |
| Onboarding / UX polish | Partial | Wizard live, labels fixed |
| Distribution | Not started | Research queued Q3 |
| Android | Not started | Planning Q3 |

Re-assess S1.B exit timeline end of July after F-009 + F-006 ship and first tester feedback.
