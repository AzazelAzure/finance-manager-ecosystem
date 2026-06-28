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
- Old `cursor/s1b/`* branch prefix → `agy/s1b/`* in inter-agent doc
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

> HitM: Cursor API credit hit means no cloud automations, not that we cannot code with Cursor.   Means no current API vulnerability screens, frontend vulnerability screens, etc.  We are entirely reliant on github actions as it stands.  
>
> Dependabot seriously depends on what it needs, we will need to address this.  
>
> this leaves further discussion on what to do about what we are losing in those fields.  We can potentially create work around automations, scripts, etc, that can run locally that won't hit api credits, but these cannot be done via Antigravity as it is hard coded (trained? not sure the correct word for this) to refuse *any* security related prompts.  Regardless of context.  

---

### D2 — Bill Recurrence Engine: Standalone Plan Required

**Context:** HitM confirmed in comment [1] this requires its own plan. The current implementation infers bill cadence from `start_date`/`due_date` deltas in `finance/logic/updaters.py`. When F-009 ships recurring auto-deduct, bills with non-monthly cycles will miscalculate. Needs a first-class `cadence` field on `UpcomingExpense` plus API and frontend ripple.

**What Claude Code can do today:** Author the plan README + task files at zero Cursor cost. Cursor executes when credits reset.

**Decisions needed:**

- Suggested plan ID: `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` — confirm or rename
- Does recurrence engine need to land *before* F-009 executes, or can F-009 ship and recurrence follow?
- Priority relative to F-006 / F-009?

> HitM: Name is fine, and this should likely ship before we do anything else that relies on those calculations.  That said, we may need to address some rust toools and implementations for api calculations as this gets more complicated, so that we can port these tools in WASMs to the frontend and PWA to minimize issues.  

---

### D3 — nginx Check False Negative: Plain-Language Explanation + Decision

**Context:** HitM noted in comment [2] this is outside their scope of knowledge.

**Plain-language explanation:** `fm_server_beta.sh check` is a pre-deploy safety test that confirms the nginx proxy config has no syntax errors. It works by spinning up a throwaway nginx container and running `nginx -t` (nginx's own self-check command). The problem: the throwaway container is missing one config file (`00-resolver.conf`) that only exists inside the real running proxy. So the test always fails — not because nginx is broken, but because the test environment is missing a file. The live proxy is healthy; only the *test* is broken.

**Options:**

- **A) Fix the test** — mount `00-resolver.conf` into the throwaway container, or point the test at the live proxy container instead. Correct long-term. ~30 min Cursor chore when credits reset.
- **B) Skip the nginx test in `check` for now** — unblocks the script but removes a safety check.

Recommend A. No HitM technical action required — just confirm "fix it properly when credits reset."

> HitM: We should fix this.  See D1 for further details on cursor credits.  

---

### D4 — Stale Container Auto-Prune: Verify Then Fix

**Context:** HitM noted in comment [3] that an agent already added auto-prune to `fm_server_beta.sh`. If old containers are still present, the logic isn't firing. If they're already gone, the daily summary was simply stale (same SHA issue as 2A/2B). cagent can confirm at zero cost.

**Proposed action:** Send cagent to check `podman ps -a` for any exited containers. If old ones are still present, file a Cursor chore for billing reset. If gone, close this item.

**Decisions needed:**

- Approve cagent verification check?

> HitM: Approved for decision

---

### D5 — Documentation Accuracy Gap (Root Cause Discussion)

**Context:** HitM manually ran doc sweeps after all deploys completed, then Antigravity swept again this morning — yet the daily summary still showed wrong VPS SHAs and wrong Celery state. Both were confirmed as false alarms by cagent. This is a systemic issue.

**Likely root cause:** The automation reads from `daily_context.md` (a cached context file generated at sweep start), not from live VPS state at summary-write time. If that file was generated before the VPS rebuild completed, all downstream output inherits the stale data — even after a manual re-sweep, because the sweep re-reads the same cached file rather than re-querying the VPS.

**What needs to change:**

- Option A: `gather_doc_context.sh` SSHes the VPS on every run and writes live container + SHA state into context. Correct long-term.
- Option B: Daily summary template explicitly flags VPS state as point-in-time with timestamp, so stale reads are visible rather than hidden.

Recommend A. Claude Code writes the fix spec; Cursor implements when credits reset.

**Secondary question:** Should `gather_doc_context.sh` be the canonical live-state source, or should a separate `vps_state.sh` snapshot run independently and feed into it?

> HitM: We should keep tools separate for scope, with the potential of writing other tools that call them.  for sake of example, doc_context could check all relevant docs for last edit date, and call vps_state.sh in its run time, and compile them together, but separation of concerns should be maintained for this.  
>
> Further, we will need to decide and fix how governance and documentation is handled during produciton cycles, and automation prompts to be more probing.     I'm thinking both is a good option, with the automation told to generate it's own file with links to what it noted, but to take a deeper, more meaningful pass instead of surface level to confirm.  Antigravity has the same SSH capabilities and scripts, so it "trust but verify" should still be in account here.  
>
> We should also include that in our core tenants.  noting this as reference [1] for later cross reference.

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

> HitM: See reference [1] for partial thoughts on this.  
>
> all of the design docs *should* be fixed.  though some of these are redundant or depreciated.  We will need to decide on where tings where 10/20/30/40 *should* live for admin clarity against things like plans and strategy, since these step on each other and cause drift by design.  
>
> the other major issue is, should absolute worst case scenario come through an I have to go in manually and continue all work by myself, design docs **NEED** to be up to date with detailed work throughs of how everything we have actually works so I can understand the, decisions, and functions for later troubleshooting/manual implementations.  This is a worst case scenario, but one that needs to be accounted for, especially over such a massive project.  

---

### D7 — Dependabot Queue (Revised for No-Credits Constraint)

**Context:** 14 open Dependabot PRs (7 API, 7 Web). With Cursor credits out, the original recommendation (Cursor pass) is off the table.

**Revised options:**

- **A) HitM merges patch bumps manually from GitHub UI** — most are trivial (patch version deps, GitHub Actions bumps). Defer eslint `8→9` (Web #77) until Cursor resets for a proper build check. ~10 min.
- **B) Defer all 14 until Cursor credits reset** — clean single-agent pass, zero manual effort.
- **C) cagent checks CI status on each branch** — HitM decides per-PR based on pass/fail. Middle ground.

> HitM: Again, this depends on how this is handled.  Are dependabot automations, or are they something we created.  If they are automations, i.e. the PR reviewer and security vulnerability scanner (see D1 comment) then we will work around them, and continue production until I hit a credit usage threshold locally into which I deem further work halted.  

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

> HitM: Agreed on the templates.  this comment section makes things easier for me to express thoughts so things don't get lost, and this is a lot to discuss at once, so it's easy for things to get lost.  I like this for context.  See D6 for other issues with this, as that will tie into this as well.   We will likely need to revamp a lot of things on the admin side as I develop as an engineer/executive.   We will come back to this after D5/D6 resolutions get more formalized. 

---

## 6. Work Order — 2026-06-29 (updated after D1–D8 discussion)

**Clarification from D1:** Cursor API cloud credits are exhausted — this kills cloud automations (vulnerability screens, etc.) but Cursor itself can still code locally. Constraint is cloud automation coverage only.

---

**✅ Completed this session:**

- [x] Stale legacy containers pruned from VPS (finance-manager-db/web/api/proxy removed via cagent)
- [x] Local security audit suite plan authored: T01–T04 task files, registry entry added (`PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29`)
- [x] Plan registry updated: F-005 + F-010 confirmed in Recently Completed (already moved by doc sweep)
- [x] `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` stub added to registry as Ready

---

**Claude Code — remaining this session:**

- [ ] Bill recurrence engine plan README + task files (D2 — name confirmed, priority: before F-009)
- [ ] `vps_state.sh` standalone script spec (D5 — separate from gather_doc_context.sh)
- [ ] Update `context_handoff_2026-06-29.md` with session progress (This is unnececssary, and should be noted here in the admin notes, that file was only to try to move this to the browser claude, it's no longer needed)

---

**Cursor (local, credits available for coding):**

- [ ] Execute `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29` T01–T04
- [ ] nginx check false-negative fix (D3 — option A confirmed)
- [ ] Dependabot queue: Cursor reviews and merges patch bumps; defer eslint 8→9 (D7)

---

**HitM manual:**

- [ ] Set up weekly cron for security audit (T03.SL2 — after Cursor delivers T01–T02)
- [ ] Add crontab entry: Sunday 02:00 `run_audit.sh`

---

**Parked (own planning sessions — not this session):**

- Design doc 10/20/30/40 structure consolidation (D6 — doc-based discussion)
- Morning meeting template formalization (D8 — after D5/D6 resolve)
- "Trust but verify" doctrine + core tenants doc (D5 reference [1])
- White hat AI planning (future session — distinct from preventive local tooling)

---

## 7. S1.B Exit Progress Update

After 2026-06-28 feature push:


| Gate                                     | Status                                                |
| ---------------------------------------- | ----------------------------------------------------- |
| Core ledger (F-001, F-004, F-005, F-010) | ✅ Closed                                              |
| Legal + compliance                       | ✅ Done                                                |
| CI/CD                                    | ✅ Done                                                |
| Security (local audit suite)             | 🔄 In progress (plan ready, Cursor executes)          |
| Onboarding / UX polish                   | Partial — wizard live, labels fixed, tour gaps remain |
| Distribution                             | Not started — Q3                                      |
| Android                                  | Not started — Q3                                      |


Re-assess S1.B exit timeline end of July after F-009 + F-006 ship and first tester feedback.