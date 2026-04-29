# Kill / Commit Gates (Pre-Decided Decision Points)

This file exists so that **tired-future-you, baby-fog-future-you, and discouraged-future-you** do not have to invent these decisions on a hard day. Decisions are made now, while rested and clear.

If the trigger conditions below are met, the action fires. No further deliberation required. Re-deliberation is *itself* a forbidden action under fatigue.

## 1) Master Kill Gate (Project Wind-Down)

**Trigger:** Any one of:

- **Time:** 5 years post-S1 launch with sustained net negative cash flow (revenue does not cover overhead for 12+ consecutive months).
- **Family:** Owner determines project time meaningfully harms family/parenting commitments and self-correction has failed twice (formal review, see §6).
- **Health:** Sustained chronic stress or health deterioration attributable to project; documented by self-reflection or clinical advice.

**Action when fired:**

1. Public communication: 90-day wind-down notice to all paying users.
2. Refund the most recent 1 month for monthly subs and pro-rata for annual subs.
3. Open-source the PFM under a permissive license (or AGPL, owner's call at the time).
4. Open-source `django-zk` middleware unconditionally (even if S5 not reached).
5. Archive `design_docs/` and `plans/` as a public learning artifact.
6. Owner takes a 90-day complete break before deciding next steps.

This gate is the **safety net** that makes the rest of the roadmap possible. Knowing the off-ramp exists is what allows wholehearted commitment.

## 2) Phase S1 → S2 Decision Gate

**Trigger evaluation:** 9 months after public Beta landing page goes live.

**Possible outcomes:**

- **Commit (S2 entry):** ≥10 paying PH users OR ≥50 active free users (logged in within 30 days). Retention day-30 ≥ 30%. → Enter S2.
- **Extend S1:** Between 5–10 paying users; retention day-30 between 15–30%. → Add 6 months; reassess. **Hard cap on extensions: 2.**
- **Reposition:** <5 paying users after 9 months OR retention day-30 <15%. → Pause feature work; spend 30 days on customer interviews; re-author wedge in `00_strategic_context.md`; restart S1.
- **Kill:** Reposition has been triggered twice and third evaluation still fails → fire master kill gate (§1).

## 3) Phase S2 → S3 Decision Gate

**Trigger evaluation:** When S2 exit criteria appear plausibly close (≥25 paying users, AI tier live for 90 days, GCash/Maya ingestion live).

**Possible outcomes:**

- **Commit (S3 entry):** S2 exit met AND PH-local distribution shows organic growth (≥20% of new users from non-direct channels). → Begin Android offline-first build.
- **Defer S3:** Distribution still requires constant manual posting from owner. → Stay in S2 for 3 months focused on distribution automation/content cadence; reassess.
- **Reposition:** Growth has stalled; user feedback indicates wedge mismatch. → Same protocol as S1 reposition.

## 4) ZK Middleware Commitment Gate (S5 entry)

**Trigger evaluation:** PFM ≥100 paying users AND security baseline mature (passed bounty program scarred-and-healed cycle in S4).

**Possible outcomes:**

- **Commit (S5 entry):** Triggers met. → AI-orchestrated Rust dev begins; owner reviews architecture/security model only.
- **Defer:** Triggers not met but PFM is healthy. → Stay focused on PFM revenue growth. Re-evaluate at next 50-user milestone.
- **Reframe:** PFM is healthy but ZK is no longer interesting (market moved, tech changed, competitor open-sourced first). → Owner formal write-up: pivot or abandon. Either way, commit to the decision in this file via update commit.

## 5) Sari-Sari Vertical Commitment Gate (S6 entry)

**Trigger evaluation:** PFM ≥$1k MRR AND ≥3 sari-sari operators in personal network expressed unprompted interest.

**Possible outcomes:**

- **Commit (S6 entry):** Both conditions met. → 30-day customer-discovery interviews with 10+ operators before any code. → Then build.
- **Defer:** PFM revenue met but no organic sari-sari pull. → Do not push it. Stay PFM-focused. Re-evaluate annually.
- **Abandon:** 5 years post-PFM-MRR threshold and still no organic pull. → Officially close S6 in this file. Owner is free to use the encryption/sync infra for other purposes.

## 6) Family / Health Self-Review Gate (Quarterly, Always)

**Trigger:** End of each calendar quarter.

**Process (≤30 minutes):**

1. Owner answers, in writing, three questions:
   - *Did I miss anything important with my child or partner this quarter because of the project?*
   - *Was my sleep, exercise, or mood meaningfully worse this quarter than last?*
   - *Would I be embarrassed to tell my child, in 10 years, how I spent my time this quarter?*
2. If "yes" to two or more: trigger 2-week reduced-scope mode (passive maintenance only).
3. If "yes" to all three twice in a row: trigger §1 master kill gate evaluation.

This is **not** optional. It belongs in calendar. The roadmap is downstream of family health, not the reverse.

## 7) Cost Discipline Auto-Triggers (Always-On)

These fire automatically based on metrics, not deliberation:

- **AI free tier overrun:** if free-tier LLM cost > 30% of paid-tier MRR for 2 consecutive months → free tier prompts halved.
- **Infrastructure overrun:** if VPS+domain+TLS > $50/mo for 2 consecutive months without proportional MRR growth → downgrade tier or migrate to cheaper provider.
- **Cursor evaluation:** at S3 entry, evaluate Cursor Pro vs pay-per-use. If owner velocity is bottlenecked elsewhere, downgrade.

## 8) When This File Is Updated

- After every kill/commit gate fires (record the outcome in a new dated section below the rules).
- When a new strategic decision is locked in `00_strategic_context.md`.
- Never to "loosen" a gate without an honest write-up of why the original gate was wrong.

---

## Gate Outcomes Log

(Append below; do not modify entries above.)

- *No gates fired yet. First entry will appear at S1 → S2 evaluation, ~2026-12 to 2027-03.*
