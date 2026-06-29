# Cursor Execution List — 2026-06-29

Dispatch sheet for today's local Cursor work. Ordered by priority. All branches use the
`cur/s1b/...` prefix. **Credit-conscious:** Cursor cloud is exhausted (local coding only);
ration local credits — HitM calls the halt threshold.

**Cursor execution rules (AGENTS.md):** one PR per task (`gh pr create`, post URL); CPPR per
task; one agent per sub-repo at a time; ask before guessing underspecified scope; PWA/offline is
part of done for any web work.

---

## Order

### 1. Bill Recurrence Engine — P1 (blocks F-009) 🥇

- **Plan:** `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29`
- **Branch:** `cur/s1b/feat/bill-recurrence-engine`
- **Tasks:** `plans/S1/S1.B/feat-bill-recurrence-engine/tasks/` T01 → T02 → T03 → T04 (in order)
- **Repos:** API (T01–T03), Web (T04)
- **Why first:** HitM directive — must ship before anything depending on bill calculations (F-009). Replaces the start/due-delta inference stopgap with a first-class `cadence` field.
- **Gotchas:** T01 is a schema + data-backfill migration (check current migration head, last is `0016_savings_goal`); semimonthly is a named cadence, not a 15-day step (T02).
- **Closeout:** set anomaly `2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md` → `resolved`.

### 2. Local Security Audit Suite — P1 (replaces lost cloud vuln screens)

- **Plan:** `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29`
- **Branch:** `cur/s1b/chore/local-security-audit-suite`
- **Tasks:** `plans/S1/S1.B/local-security-audit-suite/tasks/` T01 → T02 → T03 → T04 (T01 must pass before T02 verifies)
- **Repos:** parent `scripts/` + local tooling (no submodule code)
- **Why:** restores security coverage lost with Cursor cloud credits. All-local, no cloud, private-repo safe.
- **HitM follow-up:** after T01–T02 land, add weekly cron (Sunday 02:00) — see T03.

### 3. D5 — vps_state.sh + gather_doc_context.sh refactor

- **Spec:** `strategy/automations/specs/vps_state_and_doc_context_spec_2026-06-29.md`
- **Branch:** `cur/s1b/chore/vps-state-live-query`
- **Why:** fixes the stale-state false-alarm root cause (the hardened daily-summary/doc-sweep prompts now depend on this live block existing). New `scripts/vps_state.sh`; `gather_doc_context.sh` calls it instead of reading the static Runtime Signup Sheet.
- **Note:** docs/scripts only; SSH config reuses what `fm_server_beta.sh` uses.

### 4. D3 — nginx check false-negative fix (small chore)

- **Anomaly:** `strategy/anomalies/2026-06-28_CI-CD_fm-server-beta-check-nginx-resolver.md` (status: dispatched)
- **Branch:** `cur/s1b/fix/fm-server-beta-nginx-check`
- **Fix:** mount `00-resolver.conf` into the throwaway check container, or `exec -T proxy nginx -t` on the live proxy. **First confirm** whether `00-resolver.conf` is committed or runtime-generated — that picks the path.
- **Closeout:** anomaly → `resolved`.

### 5. Dependabot queue — D7 option B

- **Branch:** `cur/s1b/chore/dependabot-batch-2026-06-29`
- **Scope:** review + merge the 14 open Dependabot PRs (7 API, 7 Web) in one local chore pass.
- **Hold:** eslint `8→9` (Web #77) — needs a build check; merge only if green, else leave for HitM.
- **Note:** Dependabot is GitHub-native (free); these are safe dependency bumps, mostly patch/minor.

### 6. Design-Docs Restructure — P2 (docs-only, do last)

- **Plan:** `PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29`
- **Branch:** `cur/s1b/chore/design-docs-restructure`
- **Tasks:** `plans/S1/S1.B/chore-design-docs-restructure/tasks/` T01 → T02 → T03
- **Repo:** `design_docs` **submodule** — commit on the submodule branch, then bump the parent pointer (CPPR, not CPPRD-deploy).
- **Why last:** intentionally low priority so it doesn't crowd feature work. Archive reflex/alpha docs, retire roadmap/versioning overlap (**keep `Runtime_Signup_Sheet.md`**), fix Dashboard + Sync Protocol.

---

## Not today (context)

- **F-009, F-006:** July Cursor work per `strategy/priority_matrix_2026-06-28.md`. F-009 is hard-blocked by item 1 above.
- **Design-doc sweep automation prompt:** downstream of item 6 (needs the settled boundary). Claude Code authors once restructure lands.

## Suggested stopping point

Items 1–2 (both P1) are the must-do. If credits allow, 3–5 are high-value and cheap. Item 6 is
deferrable. Halt wherever your local credit threshold says so.

**End-of-day snapshot (15:40 +08):** Original items 1–4 and 6 are **done on `main`**. Item 5 original
Dependabot batch is **done** (5 new API Dependabot PRs remain). Inactive-color polish batch (Themes
1–4) also **merged**. **Next gate:** redeploy inactive BLUE → jsdevtesting per parent #82 checklist →
VPS flip. Only open PR: parent **#82** (docs checklist).

---

## Execution status — 2026-06-29 (verified live ~15:40 +08:00)

> Live-verified via `git fetch` + `gh pr view` (per-PR base/merge state) + VPS SSH `fm_server_beta.sh status`.
> Times are +08:00. VPS state is point-in-time as of the 15:40 status read.
> All local repos fast-forwarded to `origin/main` @ end of session.

### Per-item status

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Bill Recurrence Engine | **merged — awaiting HitM verify + VPS flip** | API #63/#64/#65 + Web #91 on `main`. On inactive **BLUE** from morning deploy (api-blue/web-blue healthy, up ~7h @ 15:40). Migration `0017_upcomingexpense_bill_cadence` present. Active **GREEN** untouched (up ~23h). Anomaly `2026-06-28_PRODUCTION-UX-FIX_T02` → **resolved**. |
| 2 | Local Security Audit Suite | **complete** | T01 (#74) + T02 (#75) + corrective T04 (#77) merged to `main`. Wrong-base #76 superseded. **T03 weekly cron** = HitM follow-up (not blocking). |
| 3 | D5 vps_state.sh / gather_doc_context refactor | **complete** | Parent **#78** merged to `main`. `scripts/vps_state.sh` + `gather_doc_context.sh` live-query refactor landed. |
| 4 | D3 nginx check false-negative fix | **complete** | Parent **#79** merged to `main`. Anomaly `2026-06-28_CI-CD_fm-server-beta-check-nginx-resolver` → **resolved**. |
| 5 | Dependabot queue (D7 opt B) | **mostly complete — 5 API PRs remain** | Original batch merged: API **#44–#50** (7) + Web **#72–#78** (7, incl. eslint-plugin-react-refresh #77 — green). **Still open:** API #67–#71 (pytest, setuptools, coverage, cryptography, tzdata) — new Dependabot cycle post-merge. |
| 6 | Design-Docs Restructure | **complete** | Parent **#80** merged to `main` (submodule pointer bump for vault restructure). |

### Add-on batch — Inactive-Color UX/Security Polish (not in original order list)

Spawned from HitM jsdevtesting feedback after item 1 deploy. All feature PRs merged; checklist PR still open.

| Theme | Status | PRs |
|-------|--------|-----|
| 1 Security — share-link shutdown + RCA | **merged** | API **#66**, Web **#92**, parent **#81** |
| 2 Dashboard + nav polish | **merged** | Web **#93** |
| 3 Data Hub + Profile restructure | **merged** | Web **#94** |
| 4 Guide mode + walkthrough expansion | **merged** | Web **#95** |
| HitM jsdevtesting checklist | **open — mergeable** | Parent **#82** (`strategy/meetings/inactive-blue-polish-checklist_2026-06-29.md`) |

**VPS gap:** inactive BLUE last rebuilt ~08:40 +08 (7h uptime @ 15:40). Themes 1–4 merged to `main` **after** that (~15:28–15:40). **Redeploy inactive blue required** before jsdevtesting signoff (`sprint_verify.sh` + manual smoke — see #82 checklist; `sprint_verify --smoke` still a no-op per anomaly).

### PR inventory (all today-relevant PRs)

| Repo | PR | Title | State | VPS / notes |
|------|----|-------|-------|-------------|
| api | #63–#65 | Bill recurrence T01–T03 | MERGED → main | Migration 0017; on inactive BLUE (morning deploy). |
| api | **#66** | Share-link endpoint disable + migration 0018 | MERGED → main | **Not yet on inactive BLUE** — redeploy needed. |
| web | #91 | Bill recurrence T04 | MERGED → main | On inactive BLUE (morning deploy). |
| web | **#92–#95** | Share UI remove, dashboard/nav, Data Hub/Profile, guides | MERGED → main | **Not yet on inactive BLUE** — redeploy needed. |
| parent | #74–#75, **#77** | Security audit T01/T02/T04 | MERGED → main | No VPS. |
| parent | **#78** | D5 vps_state live query | MERGED → main | Scripts only. |
| parent | **#79** | D3 nginx check fix | MERGED → main | Deploy script fix. |
| parent | **#80** | Design-docs restructure pointer | MERGED → main | Submodule bump. |
| parent | **#81** | Share-link exposure RCA | MERGED → main | Docs only. |
| parent | **#82** | Inactive blue polish checklist | **OPEN → main** | MERGEABLE/CLEAN; merge when convenient (docs-only). |
| parent | #76 | Security audit T04 (wrong base) | MERGED → T02 branch | Superseded by #77; historical only. |

Open Dependabot (Item 5 remainder): API **#67,#68,#69,#70,#71** only. Web queue clear.

### HitM testing checklist

**Bill recurrence (item 1 — may already be testable on current inactive BLUE):**

- [ ] **jsdevtesting cadence UI** — cadence field renders + saves: weekly, biweekly, semimonthly (named cadence, **not** 15-day step), monthly; i18n present.
- [ ] **Cadence API** — create/update `UpcomingExpense` per cadence; recurrence advances by cadence.
- [ ] **Overdue catch-up** — catch-up advances by cadence.

**Inactive-color polish (Themes 1–4 — after redeploy to BLUE):**

- [ ] **Redeploy inactive blue** from current `main` (API #66 + Web #92–#95); confirm migration `0018_revoke_export_share_tokens`.
- [ ] **Security** — no Share Data card; share endpoints 404; export only on Profile → Data tab.
- [ ] **Dashboard/nav** — Goals nav; mobile home link; widget spacing; balance chart hides `unknown` source.
- [ ] **Data Hub** — tabbed layout (Overview/Sources/Categories/Tags); KPIs on Overview; compact list buttons.
- [ ] **Guides/tours** — Calendar, Data Hub, dashboard widgets, Profile, Goals; form walkthroughs on major modals.

**Production cutover (last):**

- [ ] **VPS color flip** — only after all above pass: `fm_server_beta.sh switch` GREEN→BLUE.

**Admin (non-blocking):**

- [ ] **PR #82 merge** — land jsdevtesting checklist doc on `main`.
- [ ] **Security audit T03 cron** — weekly Sunday 02:00 (HitM follow-up).
- [ ] **API Dependabot #67–#71** — review/merge when convenient.

### Rolling vs blocked

- **Complete (code on `main`):** Items 1–4, 6; Dependabot original batch; inactive-color Themes 1–4.
- **Rolling:** Item 1 recurrence on inactive BLUE (morning build); inactive-color batch merged but **not redeployed**.
- **Blocked on HitM:** inactive BLUE redeploy + jsdevtesting signoff for full day's deliverables; then VPS color flip.
- **Open / low urgency:** Parent #82 (docs checklist); API Dependabot #67–#71; security audit T03 cron.

### Known anomalies logged today

| Anomaly | Status | Notes |
|---------|--------|-------|
| `2026-06-29_SECURITY-AUDIT_T04-merged-to-wrong-base` | unreviewed | Closeout candidate — fixed by #77 merge. |
| `2026-06-29_BILL-RECURRENCE_sprint-verify-skips-smoke` | unreviewed | Still applies; manual `fm_server_beta.sh smoke --color blue` required. |
| `2026-06-29_BILL-RECURRENCE_support-tests-require-live-redis` | unreviewed | Local dev only; CI unaffected. |
