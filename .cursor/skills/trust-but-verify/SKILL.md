---
name: trust-but-verify
description: Re-check tool and script output before treating it as clean at a gate — especially merge and deploy gates. Use when a status claim or "0 findings" result gates a real decision. Cursor's instance of the cross-cutting TBV doctrine skill.
---

# Trust But Verify (Cursor instance)

Operationalizes Golden Rule #18 (`design_docs/00_Coding_Guidelines.md`) / #16 (`GEMINI.md`) for
Cursor's execution lane. Distinct from Claude's `status-verification-spotcheck` (admin/dispatch
focus) — this skill targets tool/script output at implementation and merge gates.

## Doctrine

- Golden Rule #18 / #16 — full text lives in cited docs; this is the operational form.

## Loads

None — loaded imperatively by `pr-review-and-merge` and other high-stakes gates.

## Tools

Whatever tool produced the claim — re-run live or read underlying output directly. No fixed list.

## Scope

Applies when a tool/script claim **gates a decision** (merge, deploy readiness, "audit clean").
Do not re-verify every incidental command output — that defeats tooling.

## Procedure

1. Identify what the "clean" or "passed" claim is based on (exit code, summary line, registry field).
2. Re-run the underlying check or read raw output — not a cached summary.
3. Confirm the tool actually executed its checks (precedent: `run_audit.sh` crashing while reporting 0 findings).
4. If confirmed: proceed and note TBV pass in handoff.
5. If contradicted: stop, log anomaly per `anomaly-log.mdc`, do not proceed on the original claim.

## Handoff

When loaded by another skill, report `Skill(s) used: trust-but-verify` plus pass/fail and what was re-checked.
