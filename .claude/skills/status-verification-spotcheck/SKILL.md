---
name: status-verification-spotcheck
description: Use before any dispatch, close-out, or "report complete" decision that rests on a status claim — a registry status field, an anomaly status field, or a tool's self-reported clean result. Re-verify live rather than trusting the claim at face value. This is Claude's instance of the cross-cutting Trust-But-Verify doctrine skill (Golden Rule #18/#16).
---

# Status Verification Spotcheck

Operationalizes Golden Rule #18 (`design_docs/00_Coding_Guidelines.md`) / #16 (`GEMINI.md`),
"Trust But Verify." Landed 2026-07-02 after two real incidents this session: a security-audit
cron job reporting "0 findings" while its underlying tool was silently crashing (bandit ↔
env-poisoning cascade), and a plan registry marking `ready` for a design that was actually
incomplete.

## Doctrine

- Golden Rule #18 (`design_docs/00_Coding_Guidelines.md`) / #16 (`GEMINI.md`) — full text and
  scope live there; this skill is the operational form of that rule.
- Scheduled review: 2026-10-01 (start of Q4) — confirm the rule has been worth the friction.

## Scope (deliberately narrow — read this before applying broadly)

**This is not a mandate to re-verify everything a tool does.** That would defeat the point of
using tools at all (credit/time optimization). It applies specifically to:

- A status claim (registry `status:`, anomaly `status:`, a script's "clean"/"0 findings" output)
- That gates a real decision (dispatch, plan close-out, reporting something complete)

If a claim isn't about to gate a decision, don't spend a spotcheck on it. This is primarily an
**admin-layer** discipline (Claude Code / HitM) — it is not meant to slow down Cursor's execution
loop; Cursor's own instance of this doctrine skill is scoped separately.

## Tools

Whatever tool actually produced the claim being checked — re-run it live, or read its underlying
output directly, rather than trusting a summary of it. No fixed tool list; this is a discipline,
not a script.

## Procedure

1. Before acting on a status claim that gates dispatch/close-out/completion-reporting: identify
   what the claim is actually based on (a registry row, an automated report, a tool's exit code).
2. Re-run or directly re-read the underlying source, not the summary of it.
3. If it confirms the claim: proceed, note in the decision log that it was spot-checked (this is
   what makes the discipline auditable, not just aspirational).
4. If it contradicts the claim: stop, file an anomaly (`anomaly-scoping-and-dispatch`), and do
   not proceed on the original claim until the discrepancy is resolved.

## Handoff

Skills that load this one imperatively (per `skill_architecture.md`'s taxonomy) include:
`design-first-gate`, `daily-sweep-verification`, `anomaly-scoping-and-dispatch`. When loaded by
another skill, report back `Skill(s) used: status-verification-spotcheck` plus pass/fail.
