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
