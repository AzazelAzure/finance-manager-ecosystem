# Admin Meeting Notes — 2026-06-29

**Generated:** 2026-06-29 morning · **Rebuilt:** 2026-06-29 (post-discussion consolidation)
**Source:** daily_summary + doc_sweep + anomaly queue + live cagent verification
**Discussion archive:** `admin_meeting_notes_2026-06-29_discussion.md` (HitM's full inline D1–D8 responses preserved verbatim there)

> This is the **consolidated** record: decisions locked, work dispatched, open items surfaced.
> The blow-by-blow proposal/response thread lives in the archive file. Comment on **open items
> in §4** directly here.

---

## 1. Overnight Wins — shipped & live

Large execution day; everything queued merged to `main` and verified live on VPS.


| Feature                             | PRs                      | State            |
| ----------------------------------- | ------------------------ | ---------------- |
| F-004 STS Pay Cycles + Bill Realism | API #52–#55, Web #81–#83 | ✅ Merged + live  |
| F-001 Balance History + Chart       | API #56, Web #84         | ✅ Merged + live  |
| F-010 Export & Sharing              | API #57–#60, Web #85–#87 | ✅ Merged + live  |
| F-005 Savings Goals                 | API #61–#62, Web #88–#89 | ✅ Merged + live  |
| F-011 Landing Page T02              | Web #90                  | ✅ Merged + live  |
| Production UX batch                 | API #51, Web #80         | ✅ Merged (prior) |


Registry: all four core features (F-001/F-004/F-005/F-010) confirmed in **Recently Completed**.

---

## 2. Live VPS State — cagent-verified (not cached)

Both "HIGH" alerts in the daily summary were **stale-data false alarms**, disproved by cagent
against the live VPS. This is the trigger for D5 (documentation accuracy gap).


| Item                    | Daily summary said                   | Live truth (cagent)                                                                    |
| ----------------------- | ------------------------------------ | -------------------------------------------------------------------------------------- |
| Active API SHA          | old `defd844`, F-005 missing         | `42bfd0e` (latest main), migration `0016` applied, savings-goals endpoint auth-gated ✅ |
| Celery                  | worker + beat not running            | both up 12h; all 9 `fm-beta_`* containers healthy ✅                                    |
| Stale legacy containers | 4 exited `finance-manager-*` present | **pruned this session** via cagent ✅                                                   |


**Root cause of the false alarms → D5.** The "Current VPS State" the summary read is a static
markdown file (`Runtime_Signup_Sheet.md`), not a live query. Spec written — see §3.

---

## 3. Decisions Locked (D1–D5, D8) + what shipped this session


| #      | Decision (HitM)                                                                                                                                                                                                                                                                                                                | Action taken this session                                                                                                                                                                                                                                    |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **D1** | Cursor **cloud** credits exhausted = no cloud automations (vuln screens, PR reviewer). **Cursor still codes locally.** Constraint is automation coverage, not coding. Work around lost screens with local tooling — **not Antigravity** (hard-refuses all security prompts).                                                   | Local security audit suite authored to replace cloud vuln screens (`PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29`, T01–T04 ready).                                                                                                                             |
| **D2** | Bill recurrence engine = **standalone plan**, name confirmed, **ships before anything depending on those calculations** (F-009). Rust/WASM port flagged as likely *future* direction as math grows.                                                                                                                            | Plan authored: `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29`, README + T01–T04, status ready. First-class `cadence` field replaces the start/due-delta inference. Rust/WASM explicitly out-of-scope-future. Blocks F-009 in registry.                       |
| **D3** | nginx check false-negative: **fix it properly** (option A).                                                                                                                                                                                                                                                                    | Anomaly dispatched → Cursor chore. Fix path: mount `00-resolver.conf` into the check container or `exec -T proxy nginx -t`; first confirm whether the conf is committed or runtime-generated.                                                                |
| **D4** | Stale-container prune: approved.                                                                                                                                                                                                                                                                                               | 4 legacy containers pruned via cagent. Script auto-prune not patched (server renames out of beta eventually — not worth it).                                                                                                                                 |
| **D5** | Keep tools **separate by concern**; `gather_doc_context.sh` may *call* a separate `vps_state.sh` at runtime and compile. Automations must take a **deeper, verifying pass** ("trust but verify" — Antigravity has SSH too) and write their own findings file with links. Add "trust but verify" to **core tenants** (ref [1]). | Spec written: `strategy/automations/specs/vps_state_and_doc_context_spec_2026-06-29.md`. Confirmed root cause is the static-file read. Cursor implements the scripts; Claude Code updates the two prompt files. Core-tenant doc edit still pending (see §4). |
| **D8** | Meeting format: agree on templates; the inline-comment file format works well; revisit after D5/D6 formalize.                                                                                                                                                                                                                  | Section structure adopted for this rebuild. Template file deferred to D8 own session (parked).                                                                                                                                                               |


---

## 4. Open — needs your comment

Comment inline under each. These are the only items still genuinely undecided.

---

### D6 — Where 10/20/30/40 design docs should live (structural)

**Locked already:** design docs **must** be kept accurate to a worst-case "HitM continues
everything manually" standard — detailed walkthroughs of how each system actually works, for
later troubleshooting/manual implementation. This is a hard requirement, not cosmetic. A new
design-doc sweep automation is wanted.

**Still open — the structural question you raised:** the `design_docs/` 10/20/30/40 tiers
overlap with `plans/` and `strategy/` and "step on each other and cause drift by design." Before
building the design-doc sweep automation, we need to decide the **boundary**: what canonically
lives in `design_docs/` vs `plans/` vs `strategy/`, and which 10/20/30/40 sections are
redundant or deprecated and should be retired.

This is parked for its **own planning session** (doc-based, not terminal). I have *not* authored
the design-doc sweep prompt yet — it depends on this boundary call.

> **Q for you:** Do you want to (a) book that consolidation session next, or (b) let me draft a
> first-pass boundary proposal (a doc you mark up) to seed it?

> HitM: Let's hit that neext, since that will affect how plans and cursor documents what it does.  Plus we will need files and structure for not just daily meetings, but long term projection discussions, things that are posttponed, upcoming issues, audit issues, etc.  

---

### D7 — Dependabot + lost Cursor cloud automations

**Fact-checked this session (you asked "are these automations or something we built"):**

- **Dependabot is GitHub-native.** `.github/dependabot.yml` is present in **both** submodules
(API + Web). It keeps opening dependency PRs on GitHub's infra **for free**, regardless of
Cursor credits. The 14 open PRs cost nothing to exist.
- **What's actually down** with cloud credits = the Cursor **cloud PR-reviewer + vulnerability
scanner** (the bugbot-style automations). The **scanner half is already replaced** by the
local security audit suite (D1). The **PR-review half** is the only real loss.

So your stated path holds: *"work around them, continue production until I hit a local credit
usage threshold I deem halt-worthy."* Dependabot needs no workaround — only a merge owner.

**Remaining choice — who clears the 14 PRs:**

- **A)** You merge patch/minor bumps from GitHub UI (~10 min, zero credit); defer eslint `8→9`
(Web #77, needs a build check).
- **B)** Cursor reviews + merges locally in one chore pass (uses local credits you're rationing).
- **C)** Defer all 14 to a weekly batch.

Recommend **A** for the trivial bumps now, hold eslint `8→9` for a Cursor build check later.

> HitM: Just B, it doesn't take much for them to do it, and I'm not particularly worried about it right now.  

---

### Tenant doc — "trust but verify" (from D5 ref [1])

Small, ready to write once you confirm placement: add a **"Trust but verify"** core tenant
(automations with live-access capability must verify flagged state against ground truth before
escalating; never trust cached context as current). Where does this belong — `AGENTS.md` core
tenets section, or a dedicated `governance/core_tenets.md`?

> HitM: This should be in Agents.  Along with documentation notes, such as maintaining vps checkout sheet, since I noticed that was a previous issue.  We will need to touch on this later, but that can be handled another day, seated discussion.  

---

## 5. Work Order — 2026-06-29

**✅ Completed this session**

- [x] Stale legacy containers pruned (cagent)
- [x] Local security audit suite authored (T01–T04, registry ready)
- [x] Bill recurrence engine plan authored (README + T01–T04, registry ready, blocks F-009)
- [x] `vps_state.sh` / `gather_doc_context.sh` refactor **spec** written (D5)
- [x] Both open anomalies dispatched (bill-interval → recurrence plan; nginx-check → Cursor chore)
- [x] Registry header + bill-recurrence row updated
- [x] **D6 resolved + executed (Claude Code side):** `strategy/` homes created (`projections/`, `parking_lot/`, `audits/`, `risk_register.md`); `strategy/README.md` rebuilt as the living-state index; `governance/meeting_artifact_protocol.md` written; AGENTS.md §1 gained trust-but-verify + documentation-maintenance tenets; design-docs restructure chore plan authored for Cursor (`PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29`); proposal marked resolved

**Claude Code — remaining**

- [ ] Daily summary + doc sweep prompt hardening per D5 spec Deliverable 3 (can do now)
- [ ] Design-doc sweep automation prompt (now unblocked — boundary settled; downstream of the restructure)

**Cursor — local execution (credits available for coding)**

- [ ] `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29` T01–T04
- [ ] `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` T01–T04 (must land before F-009)
- [ ] `PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29` T01–T03 (submodule docs-only, CPPR)
- [ ] `vps_state.sh` + `gather_doc_context.sh` refactor (per D5 spec)
- [ ] nginx check fix (D3)
- [ ] **Dependabot: review + merge the 14 PRs in one local chore pass (D7 → option B)**

**HitM manual**

- [ ] Weekly security-audit cron entry (Sunday 02:00) after Cursor delivers T01–T02

**Resolved this turn**

- D6 → **resolved and executed** (Claude Code side done; Cursor restructure plan ready) — see proposal Resolution block
- D7 → **option B** (Cursor merges Dependabot locally)
- Trust-but-verify tenant → **added to AGENTS.md §1 this session** (with documentation-maintenance note), per your Q5

**Parked (own sessions)**

- Morning-meeting template formalization (D8 — after D5/D6) → tracked at `strategy/parking_lot/morning-meeting-template.md`
- White-hat AI for live security hardening → `strategy/parking_lot/white-hat-ai-security.md`
- Versioning system rework → `strategy/parking_lot/versioning-system-rework.md`

> *Dropped per HitM: the `context_handoff` file update — unnecessary, we're continuing in-thread.*

---

## 6. S1.B Exit Progress

After the 2026-06-28 feature push:


| Gate                                        | Status                                                |
| ------------------------------------------- | ----------------------------------------------------- |
| Core ledger (F-001, F-004, F-005, F-010)    | ✅ Closed                                              |
| Legal + compliance                          | ✅ Done                                                |
| CI/CD                                       | ✅ Done                                                |
| Security (local audit suite)                | 🔄 Plan ready — Cursor executes                       |
| Bill recurrence engine (F-009 prerequisite) | 🔄 Plan ready — Cursor executes                       |
| Onboarding / UX polish                      | Partial — wizard live, labels fixed, tour gaps remain |
| Distribution                                | Not started — Q3                                      |
| Android                                     | Not started — Q3                                      |


Re-assess S1.B exit timeline end of July after F-009 + F-006 ship and first tester feedback.