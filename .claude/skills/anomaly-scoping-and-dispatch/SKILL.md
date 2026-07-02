---
name: anomaly-scoping-and-dispatch
description: Use when an anomaly is suspected during admin work. Verifies it's real, writes the anomaly file, classifies RCA depth (shallow vs deep), and writes the RCA directly only for shallow cases — deep cases route to Cursor rather than Claude attempting multi-file code tracing.
---

# Anomaly Scoping and Dispatch

Narrowed 2026-07-02 after HitM flagged that writing full RCAs is borderline-out-of-scope for
Claude in the general case — it worked twice this session only because both cases were shallow
enough to reason about from already-gathered session context (direct tool execution, not
multi-file tracing).

## Doctrine

- `strategy/anomalies/anomaly_template.md` — anomaly file frontmatter/body shape.
- `governance/plans/plan_template.md` — for anomalies tied to a specific plan/task.
- `governance/incident/rca_template.md` — RCA shape, used only for the shallow case here; deep cases are
  Cursor's to write, following the same template on its side.

## Loads

- `status-verification-spotcheck` (imperative) — verify the anomaly is real before logging it,
  not just plausible.

## Tools

- `anomaly_new` — file the anomaly.
- `queue_push` / `queue_status` — dispatch fix tasks once an anomaly has a clear remediation.

## Procedure

1. Load `status-verification-spotcheck` first — confirm the anomaly is real (reproduce or
   directly observe it), not just suspected from a stale report.
2. File the anomaly via `anomaly_new`, following `anomaly_template.md`'s frontmatter
   (`logged`, `agent`, `plan_context`, `status`, `severity_guess`).
3. **Classify RCA depth:**
   - **Shallow** — the root cause is already known from session context (a tool was run
     directly, output observed, cause is a single clear fact). Write the RCA now.
     `governance/incident/rca_template.md`.
   - **Deep** — requires real multi-file code investigation to establish root cause. Do not
     attempt it. Route to Cursor. (Dispatch mechanism not yet built as of 2026-07-02 — proposed:
     a script wrapping `cursor agent --print --workspace <dir> --trust --force`, same pattern as
     `scripts/workspace/ws_dispatch.sh`, scoped to investigation/report output rather than the
     queue→branch→PR flow. Check whether this exists before assuming it needs to be built fresh.)
4. If a clear fix is identifiable, queue it via `queue_push` — writing the anomaly/RCA doesn't
   have to wait for the fix to be scoped, but don't invent a fix task without a clear
   remediation path.

## Note — don't duplicate HitM's standing practice

HitM runs a pre-meeting routine: tasking Cursor to investigate all active/unresolved anomalies
before each admin session. `strategy/anomalies/` and a fresh RCA matrix are often already
populated at session start because of this — check there before assuming an anomaly needs fresh
investigation from this skill at all.

## Handoff

`Skill(s) used: anomaly-scoping-and-dispatch, status-verification-spotcheck` on every anomaly
filed. If dispatched to Cursor for a deep RCA, the dispatch packet includes `Skill(s) to load`
naming whatever Cursor-side investigation skill applies (`functional-investigation-report` or
the relevant Phase-3 triage skill).
