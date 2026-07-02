# Runtime Handoff Template — Structured Format

*Locked 2026-05-04 — Emergency Orchestration Huddle (D5).*

Copy this template for every feature plan's `runtime_handoff.md`. The YAML frontmatter is machine-readable so agents and `scripts/sprint_status.sh` can parse current state without re-reading the entire plan.

---

```yaml
---
# Runtime Handoff — <Feature Name>
# Auto-parseable by sprint_status.sh

feature_id: F-XXX
plan_root: plans/S1/S1.B/<sub-plan>/
status: in_progress  # draft | in_progress | awaiting_review | awaiting_hitm | complete | blocked

# VPS deployment state
deployment:
  active_color: green        # which color is currently serving production
  inactive_color: blue       # which color has the feature branch deployed
  last_deploy_sha:
    api: null                # short SHA or null
    web: null                # short SHA or null
  last_deploy_time: null     # ISO 8601
  smoke_result: null         # PASS | FAIL | null (not yet run)

# Branch state
branches:
  feature_branch: cursor/s1b/feat/<feature-name>
  api_pr: null               # PR URL or null
  web_pr: null               # PR URL or null
  ecosystem_pr: null         # PR URL or null

# Slice progress (append rows as work progresses)
slices:
  - id: T01.SL1
    status: pending          # pending | in_progress | pass | fail | waived
    v_tier: V1
    executor: null           # agent identity
    reviewer: null           # agent identity
    evidence: []             # list of evidence file paths
    notes: ""

# Known issues (append-only, do not delete)
known_issues:
  - id: 1
    severity: P0             # P0 | P1 | P2
    summary: ""
    discovered_by: ""        # agent id or HitM
    discovered_date: null

# Blocked items (if status: blocked)
blockers: []
---
```

## Narrative Notes

Use this section for context that doesn't fit in YAML. Keep it brief — the YAML above is the source of truth for automated tools.

### Last Session Summary

<1-2 paragraphs: what was accomplished, what remains>

### HitM Manual Verification Notes

<HitM fills this in after V3 verification>

### Handoff Warnings

<Anything the next agent must know that isn't captured in slices/issues above>
