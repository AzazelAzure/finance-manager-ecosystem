# Midday Touch-Up — 2026-06-29

**Format:** Topic-tracking working doc (same as the morning meeting). Comment inline.
**Trigger:** HitM flagged significant snags during inactive-blue polish — chiefly the F-010 share-link exposure.
**Governed by:** `governance/meeting_artifact_protocol.md`.

> **Edit-sync note:** writes land on disk; if you keep this open in an editor, reload from disk
> before adding comments so saves don't clobber each other.

---

## 🔴 Topic 1 — F-010 share-link privacy exposure

### 1.0 Status + decision

The public share endpoint (`api.thehivemanager.com/finance/export/share/<uuid>/`) is **still live on
active GREEN** — the disable (API #66 + migration `0018`; Web #92) is merged to `main` but blue isn't
redeployed/flipped yet.

**✅ DECISION (HitM):** leave open; close it on **today's normal flip**, not as a standalone hotfix.
Acceptable *only because* userbase ≈2 and public visibility ≈0. It closes automatically: the disable
is **Theme 1 of the polish batch**, so redeploy-blue → flip takes it down (Topic 3).

> HitM: We will live this open for now.  Currently security issue in practice, and worth being cautious around, but we are safe currently only because our current userbase is basically 2, and public visability is essentially 0.  This will be fixed today, and taken down, but for now it's okay, once everythign is flipped.  

### 1.1 The RCA (Cursor — excellent; see Topic 5)

`strategy/audits/2026-06-29_share-link-exposure_rca.md`. Confirmed facts:
- **Not an IDOR** — cross-user isolation worked (tests enforced it).
- **Exposure by design:** `ShareTokenAccessView` = `AllowAny` + `authentication_classes = []`, returns the owner's **entire transaction history** as raw JSON, no date filter, no viewer, no consent, no rate limit.
- A UUID bearer URL anyone can open.

### 1.2 Severity — you are NOT overreacting

"Not IDOR" is right only on that one label and undersells it: an unauthenticated public URL returning
a **complete financial ledger**, with the token leaking via clipboard / history / Referer, live ~24h+
and advertised in marketing, **is** a serious privacy/security exposure. Your "security-bypass vector"
instinct is sound. Not a multi-tenant bypass; still serious.

### 1.3 What went wrong — shared blame (per your §1.5)

The honest split:

- **Claude Code (me):** resolved a stale/ambiguous spec into the *least safe* concrete option (public,
  no-JWT, full-history, raw JSON; viewer + rate-limit deferred) and **never flagged the privacy
  tradeoff for signoff.** "I built what the files said" is true but insufficient — a public full-ledger
  dump is unsafe regardless of what a stale file implied; catching that is the planner's job.
- **HitM:** feature/concept mixup (what was *meant* for F-010 ≠ what got attached), and the source
  `FEATURE_IDEAS.md` is **extremely outdated and should've been swept** before being mined as a spec.
- **Deeper cause = drift.** Stale concept doc → confident-but-wrong spec → unsafe build. The same
  design/doc drift we formally took on today (D6). Durable fixes: the **DoD privacy gate** *and*
  **retiring/refreshing stale concept docs** so they can't be used as specs.

| Layer | What it said | Verdict |
|---|---|---|
| Concept — `FEATURE_IDEAS.md` §F-010 | "read-only link or export…, **scope TBD**"; "show **a month** without full account access"; F-012 cross-refs "**never auto-attach full ledger**" | Stale + loose; safety intent present but never locked |
| Plan README (May 5) | "time-limited share links… 'send this month to spouse'" | Implied bounded |
| Task files T04/T05 (this chat) | scope-TBD → public/no-JWT; "a month" → full history; "summary/viewer" → raw JSON URL; rate-limit/viewer deferred; risk register missed "full ledger exposed to holder" | Where it became unsafe-and-concrete |
| Handoff | privacy tradeoff lived in task ACs; never surfaced for signoff | Missing escalation |
| DoD / gates | no privacy gate for `AllowAny` + financial data; pre_merge not enforced; review checked IDOR not "should this be public"; marketing front-ran review | Process gaps (RCA §6) |

### 1.4 What F-010 "share" was actually meant to be (your §1.5)

Neither my read nor the RCA had this right. The original intent was **direct data transfer /
portability**: let a user **transfer all their data to another service** by temporarily linking that
service to our servers (account-takeout / migration). **Not** a public viewer link, **not** an invite
link. Two distinct, still-unbuilt features fall out, both for later:

1. **Data portability / direct transfer** — the real F-010 "share" intent; needs a real auth model (user authorizes the transfer), never a public bearer URL.
2. **Invite / referral link** — separate, tied to the pseudo-open-beta organic-invite growth strategy.

### 1.5 Forward items

- [x] ~~Expedite the disable flip~~ — resolved (§1.0): close on today's normal flip.
- [ ] **DoD privacy gate** — RCA rec #1: any `AllowAny` endpoint returning user financial data needs explicit HitM risk-acceptance in-plan + audit entry before merge. *(Primary durable control — Claude Code governance edit.)*
- [ ] **Sweep `FEATURE_IDEAS.md`** — outdated, mined as a spec source. Extend the doc-drift cleanup into `plans/` concept docs, not just `design_docs/`.
- [ ] **Data portability / direct-transfer feature** — re-scope properly later (real auth model). Future plan / parking-lot.
- [ ] **Invite / referral link** — future plan / parking-lot; beta growth.
- [ ] **Hardening stub** for viewer-style sharing if ever revived: `plans/S1/S1.B/feat-f010-export-sharing/HARDENING_FOLLOWUP_STUB.md`.
- [ ] **Process discussion:** "merged → prod in ~1hr, no privacy signoff" + "marketing before review" (overlaps morning-meeting governance + DoD gate).

> HitM: So this is a issue between both of us.  You *technically* did what you were supposed to do, based on files and what was attached, while there are issues for there.  This is an issue on me for mixing up what we were attaching to which feature, design/doc drift which we addressed today.  That feature idea file is extremely outdated, and should have been swept up before hand.  Part of the drift issue we have been combatting over the past few sessions.    The share link in that context was an idea of *direct transferal of data* not an actual link.  The idea was basically the ability for allowing a user to direct transfer all of their data to another service if they wanted, by linking their new service temporarily to our servers to extract their data.  So we need to come back to this later for the actual user share link in invite link method.  We both share blame on this.  

---

## Topic 2 — Cursor execution status (read)

`strategy/meetings/cursor_execution_2026-06-29.md`, Cursor live-verified ~15:40 +08. **Day's dispatch
essentially complete — no reordering needed.**

- **Done on `main`:** Bill Recurrence (API #63–65 / Web #91), Security Audit Suite (#74/#75/#77), D5 vps_state (#78), D3 nginx (#79), Design-docs restructure (#80). Dependabot original batch (API #44–50, Web #72–78).
- **Polish batch merged:** Theme 1 share shutdown (API #66 / Web #92 / parent #81), Theme 2 dashboard+nav (#93), Theme 3 Data Hub+Profile (#94), Theme 4 guides (#95).
- **Parent #82** (the Topic-3 checklist doc) — ✅ **now merged** (HitM).
- **Still open / low-urgency:** API Dependabot **#67–#71**; security-audit **T03 weekly cron** (HitM).
- **The real gap → Topic 3:** inactive **BLUE** is behind `main` (rebuilt ~08:40, before Themes 1–4 merged). Needs **redeploy**, then flip.

---

## Topic 3 — Inactive-blue polish + flip (read)

`strategy/meetings/inactive-blue-polish-checklist_2026-06-29.md` — your jsdevtesting gate for the flip,
and the mechanism that takes F-010 down.

- All listed PRs merged (#66 → #92 → #81 → #93 → #94 → #95; #82 now merged too).
- **Redeploy:** `sprint_verify.sh --color blue --branch main --repos api,web` **+ manual smoke**
  (`fm_server_beta.sh smoke --color blue`, because `--smoke` is a no-op — anomaly). Confirm migration
  `0018_revoke_export_share_tokens` on blue.
- **Verify before flip:** Theme 1 Security (no Share card; export only on Profile→Data; `share/{uuid}` → **404** = the F-010 takedown check) + bill cadence + dashboard/nav + Data Hub/Profile + guides + PWA offline.
- **Flip gate:** `fm_server_beta.sh switch` (GREEN→BLUE) only after all pass; then update `Runtime_Signup_Sheet.md`.

---

## Topic 4 — Reorientation: what's left, who does what

The thing you asked for — clean split of remaining work to close out today and flip.

### ✅ What's genuinely DONE (on `main`)
All of today's feature/chore/polish work is merged: bill recurrence, security suite, D5 vps_state, D3
nginx, D6 restructure, polish Themes 1–4, F-010 disable, checklist #82. Nothing left to *write* for today.

### 🟦 The ONE critical path to "today done"
**Redeploy inactive blue → run jsdevtesting checklist → flip GREEN→BLUE.** That single path closes
F-010 and ships everything. Everything below is either part of this path or genuinely deferrable.

### 👤 HitM (you) — the gating actions
1. **Redeploy inactive blue** from `main` (`sprint_verify.sh` + the **manual** smoke).
2. **jsdevtesting signoff** — walk the Topic-3 checklist on `jsdevtesting.thehivemanager.com`. *You are the only blocker.*
3. **Flip** `fm_server_beta.sh switch` once it passes → **F-010 closed.** Update `Runtime_Signup_Sheet.md`.
4. **Security-audit T03 cron** — add the weekly Sunday 02:00 entry (still pending; not blocking the flip).

### 🤖 Cursor — genuinely-left handover (all post-flip, low urgency)
1. **Fix `sprint_verify --smoke` no-op** (anomaly) — so future redeploys don't need a manual smoke. Small chore.
2. **API Dependabot #67–#71** — review/merge per D7-B.
3. **Triage/close the 3 anomalies** (incl. `T04-merged-to-wrong-base` → close, fixed by #77).
4. *(Already queued, not today):* F-009 + F-006 task files are authored and **Ready**; F-002/F-003 wait on the rust-tools session (Topic 6).

> HitM:

---

## Topic 5 — Adopt the RCA format as a standard (HitM endorsed)

You want Cursor's RCA promoted to a reusable standard. Status:

1. ✅ **Glossary:** **RCA (Root-Cause Analysis)** + **Incident** added to `governance/glossary.md` §13 (Incident & RCA vocabulary), with the when-required rule (S0/S1 → full RCA) and storage convention.
2. ✅ **Template:** `governance/rca_template.md` created, modeled on Cursor's file (exec summary → exact flow → code map → intent-vs-outcome/drift → timeline w/ evidence → why controls missed → remediation → durable controls → follow-up → references). Cursor's file is cited as the canonical worked example.
3. ✅ **Applies to bug reports + anomalies:** glossary §13 makes a full RCA the resolution artifact for S0/S1 anomalies / confirmed incidents; lighter ones stay normal logs.
4. ⏳ **Anomaly-sweep integration ("perhaps") — your call:** wire the daily/anomaly sweep to flag any S0/S1 anomaly as "RCA required" + link the template, or keep RCA manual-trigger only? *(Not done — awaiting your confirm.)*

> HitM:

---

## Topic 6 — Next up (after the flip): rust tools planning

You want to scope **the rust tools to create across everything** before building the features that
depend on them (F-002 smart-tag estimation, F-003 predictive budgeting — both flagged
`finance_manager_rust_tools`; plus the WASM/frontend-port direction raised in D2). That's the **next
planning session**, after today's flip. Not started here.

> HitM:

---

## Open snags needing your call

1. **`sprint_verify --smoke` no-op** — manual smoke each redeploy until fixed (Cursor chore — Topic 4). Fix now or live with it short-term?
2. **3 untriaged anomalies** (`T04-wrong-base` = closeout candidate; `sprint-verify-skips-smoke`; `support-tests-require-live-redis` = local-dev only). Triage now or next sweep?

> HitM:

---

## Carried context

- Everything is merged to `main`; inactive **BLUE** is behind `main` (needs **redeploy**, not just a flip).
- Active **GREEN** is current production; F-010 lives there until the flip.
- Single critical path to done: **redeploy blue → checklist → flip.** Blocker = HitM signoff.
