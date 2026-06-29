# Admin Meeting Seed — 2026-06-30 (carry-forward from 2026-06-29)

**Seeded:** 2026-06-29 ~19:00 +08 (EOD) — captured before sign-off so nothing is lost overnight.
**Status:** SEED. Convert to the morning consolidated note tomorrow. Comment inline as usual.
**Format:** morning-meeting structure (per D8). Governed by `governance/meeting_artifact_protocol.md`.

> Yesterday (2026-06-29) was a very full day — not intended to be. Today's session can be lighter.

---

## 0. Where we ended yesterday (production state)

**Everything is merged, deployed, and flipped.** Active production color flipped GREEN→BLUE; the
full day's work is live. **F-010 share-link exposure is closed** (disable + migration `0018` revoking
tokens shipped on the flip).

Shipped + live yesterday: bill recurrence engine (cadence), security audit suite, D5 vps_state +
gather_doc_context refactor, D3 nginx check fix, D6 design-docs restructure, inactive-color polish
Themes 1–4, F-010 takedown. Parent #82 merged.

### 0a. First-thing verification (trust-but-verify tenet — do before trusting the above)

- [ ] Confirm active color post-flip + both colors healthy (`vps_state.sh` / `fm_server_beta.sh status`).
- [ ] **F-010 closed on production:** `GET https://api.thehivemanager.com/finance/export/share/<any-uuid>/` → **404**; no Share Data card in UI.
- [ ] Migration `0018_revoke_export_share_tokens` applied on the now-active color.
- [ ] `design_docs/30_Releases/Runtime_Signup_Sheet.md` updated on the flip.

---

## 1. Primary topic — Rust tools planning session 🦀

The main event for today (HitM-flagged). **Scope the rust tools to create across the whole product
before building the features that depend on them.**

- **Gates:** F-002 (smart-tag estimation) and F-003 (predictive budgeting) — both flagged
  `finance_manager_rust_tools` in their plans; do **not** start them until the tooling is scoped.
- **Also in scope (D2 direction):** as bill/budget math grows, port numerics to Rust and **compile to
  WASM for the frontend/PWA** to keep client and server calculations consistent.
- **Deliverable for the session:** a rust-tools plan (what crates/functions, which features consume
  them, API↔WASM boundary, build/CI story). Likely a planning doc HitM marks up, then task files.
- `finance_manager_rust_tools` is `rust_tools:Tight Beta`; `finance_manager_rust_middleware` is
  S5 / Scaffold (separate — ZK middleware, not this).

> HitM:

---

## 2. Ready-to-dispatch feature work (Cursor)

Both authored yesterday, `status: ready`, task files complete. F-009's blocker (bill recurrence)
shipped + flipped, so it's clear.

| Feature | Plan | Branch | Notes |
|---|---|---|---|
| **F-009 Recurring Auto-Deduct** | `PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009` | `cur/s1b/feat/f009-recurring-auto-deduct` | T01–T04: `auto_deduct` flag + idempotency, Celery-beat due-date eval, web toggle, edge cases. Cadence dependency satisfied. |
| **F-006 Dashboard Widgets** | `PLAN_CROSS_DASHBOARD_WIDGETS_F006` | `cur/s1b/feat/f006-dashboard-widgets-custom` | T01–T04: layout persistence, widget catalog/render, DnD reorder/resize, device variants. |

**Sequencing question for today:** rust-tools planning vs. dispatching F-009/F-006 — which first?
(They don't depend on rust tools, so they can run in parallel with the planning session.)

> HitM:

---

## 3. F-010 RCA forward items (from midday §1.5)

Carried from yesterday's midday touch-up. These are the durable fixes + the two real features the
exposure surfaced.

| Item | Type | Owner | Notes |
|---|---|---|---|
| **DoD privacy gate** | Governance | Claude Code | *Primary durable control.* Any `AllowAny` endpoint returning user financial data needs explicit HitM risk-acceptance in-plan + audit entry before merge. Edit `governance/definition_of_done.md`. |
| **Sweep `FEATURE_IDEAS.md`** | Doc-drift | Claude Code | Stale concept doc was mined as a spec → drift. Refresh/retire; extends D6 cleanup into `plans/` concept docs. |
| **Data portability / direct transfer** | New feature | future plan | The *real* F-010 "share" intent: user-authorized data egress to another service. Needs a proper auth model — never a public bearer URL. |
| **Invite / referral link** | New feature | future plan | Separate; ties to pseudo-open-beta organic-invite growth strategy. |
| **Process discussion** | Governance | HitM + Claude | "merged → prod in ~1hr, no privacy signoff" + "marketing advertised before review." Overlaps the DoD gate. |

> HitM:

---

## 4. Open governance / decisions

- [ ] **Anomaly-sweep RCA integration** (midday Topic 5 #4 — your "perhaps"): wire the sweep to flag S0/S1 anomalies as "RCA required" + link `governance/rca_template.md`, or keep RCA manual-trigger? *(Glossary §13 + template already landed.)*
- [ ] **AGENTS.md documentation-notes seated discussion** (deferred from morning D5): the broader doc-maintenance notes (beyond the trust-but-verify tenet already added). HitM wanted a seated pass.

> HitM:

---

## 5. Cursor cleanup backlog (low urgency, post-flip)

- [ ] Fix `sprint_verify --smoke` no-op so redeploys don't need a manual smoke (anomaly `2026-06-29_BILL-RECURRENCE_sprint-verify-skips-smoke`).
- [ ] API Dependabot **#67–#71** (pytest, setuptools, coverage, cryptography, tzdata) — merge per D7-B.
- [ ] Triage/close the 3 anomalies logged yesterday (`T04-merged-to-wrong-base` → close, fixed by #77; `sprint-verify-skips-smoke`; `support-tests-require-live-redis` = local-dev only).

---

## 6. HitM personal actions (carried)

- [ ] **Security-audit T03 weekly cron** — `crontab -e`, Sunday 02:00 `run_audit.sh` (still pending from yesterday).

---

## 7. Parked (own sessions — not today unless you want them)

- Morning-meeting template formalization (D8 — after D5/D6; D6 now largely done).
- Design-doc **sweep automation prompt** — now unblocked (D6 boundary settled + restructure shipped); Claude Code authors when ready.
- "Trust but verify" is in AGENTS.md; the fuller core-tenets/doc-notes pass is §4 above.

---

## 8. Carry-forward index (so nothing's lost)

Everything above traces to: yesterday's morning meeting (`admin_meeting_notes_2026-06-29.md`), the
midday touch-up (`midday_touchup_2026-06-29.md`), the F-010 RCA
(`strategy/audits/2026-06-29_share-link-exposure_rca.md`), and the new RCA standard
(`governance/glossary.md` §13 + `governance/rca_template.md`).
