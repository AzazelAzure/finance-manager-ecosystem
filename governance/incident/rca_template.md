---
logged: YYYY-MM-DD
agent: <who wrote this — cursor / claude-code / antigravity / hitm>
plan_context: <plan id or branch the incident relates to>
status: draft        # draft → final
severity: <S0 | S1 | S2 | S3>   # see glossary §4; RCA required for S0/S1
related_prs:
  land: <org/repo#NN>      # PR(s) that introduced it
  fix: <org/repo#NN>       # PR(s) that remediated it
originating_anomaly: <strategy/anomalies/...md or "—">
---

# Root-Cause Analysis: <short incident title>

**Report date:** YYYY-MM-DD
**Reporter context:** <how it was discovered — who flagged what, where>
**Disposition:** <current state — fixed / mitigated / open; one line>

> **How to use this template** (delete in the final): an RCA traces *how* the issue reached its
> state — origin → code → timeline-with-evidence → why controls missed it → remediation → durable
> controls. Make every claim *evidenced* (SHA, PR, file:line, timestamp). Don't soften; don't
> over-claim. Canonical worked example: `strategy/audits/2026-06-29_share-link-exposure_rca.md`.

---

## 1. Executive summary

2–4 sentences: what the issue is, its true classification (and what it is *not* — head off
mislabels), the failure mode in one phrase, and the exposure/impact window.

## 2. What the issue is (exact flow / reproduction)

The precise mechanism — request flow, repro steps, or failing path. Include the literal calls /
inputs / outputs. State explicitly **what is and is NOT affected** (scope boundaries) so severity
isn't over- or under-stated.

## 3. Where it lives (code map)

| Layer | Path | Notes |
|-------|------|-------|
| Plan | | |
| Spec / task | | |
| Model / migration | | |
| Views / routes | | |
| UI / client | | |
| Tests | | what they *did* and *didn't* cover |

## 4. Why it was built this way (intent vs. outcome)

The intended behavior (quote the concept/spec) vs. what shipped. This is where **drift** surfaces —
where safe-but-vague intent became unsafe-and-concrete, and which layer made the call. Quote the
exact spec lines that produced the outcome. Note any mitigations that *were* specified (and what
they missed).

## 5. How it reached its current state (timeline with evidence)

| When (TZ) | Repo | SHA / PR | Event |
|-----------|------|----------|-------|
| | | | |

Cite the evidence chain (CHANGELOG entries, runtime handoff, signup sheet, deploy logs). Compute and
state the **exposure / impact window** explicitly.

## 6. Why controls missed it

Walk each control that *should* have caught it and why it didn't:
- Specification / scope review
- Definition of Done gates
- Agent / peer review scope
- Pre-merge gate (was it enforced?)
- Verification / smoke (did it test the right risk, or the wrong success?)

## 7. Remediation taken

| Action | Owner | PR | Status |
|--------|-------|-----|--------|
| | | | |

State what is unchanged / still safe, too.

## 8. Control recommendations (durable)

Numbered, concrete, and assignable. Aim at *preventing the class*, not just this instance (e.g. a
DoD gate, a review-checklist line, a retired stale doc) — not self-blame.

## 9. Follow-up

- Linked follow-up plan / hardening stub / parking-lot items
- Verification owed after remediation deploys
- Forward features or re-scopes that fell out of the analysis

## 10. References

- Originating anomaly: `strategy/anomalies/...`
- PRs, plan path, related docs, links.
