# P1: Agent Context Delivery Protocol

**Status:** `normative` (governance). **Locked:** 2026-05-21 — Admin Huddle Session 5 deliverable.  
**Related:** [`runtime_handoff_template.md`](./runtime_handoff_template.md), [`plan_template.md`](./plan_template.md)

---

## Problem

Agents start sessions with insufficient context, requiring 2–5 correction cycles before productive work begins. This costs HitM 5–12 hours/day of manual correction (the "babysitting" problem from Session 5 T-D01).

## Solution

Three mandatory artifacts that every agent session must consume before writing code:

1. **READ FIRST block** — in every task spec and plan README
2. **Condensed runtime handoff** — <200 lines, YAML-heavy, machine-parseable
3. **Append-only decision log** — immutable record of what's been decided

---

## 1) READ FIRST Block (mandatory in every task)

Every task spec and every plan `README.md` must include a `READ FIRST:` section listing the **exact files** the agent must read before doing anything.

### Format (task spec)

```text
READ FIRST:
- ~/finance_manager/governance/glossary.md (terms)
- ~/finance_manager/plans/S1/S1.B/<sub-plan>/README.md (plan scope)
- ~/finance_manager/plans/S1/S1.B/<sub-plan>/runtime_handoff.md (current state)
- ~/finance_manager/plans/S1/S1.B/<sub-plan>/DECISION_LOG.md (locked decisions)
- ~/finance_manager/<subrepo>/CHANGELOG.md (recent changes)
```

### Format (plan README)

Add after the YAML metadata header:

```markdown
## READ FIRST (agent session start)

Before writing any code or making any changes, read these files in order:

1. [`governance/glossary.md`](../../governance/glossary.md) — canonical vocabulary
2. [`DECISION_LOG.md`](./DECISION_LOG.md) — locked decisions for this plan (append-only)
3. [`runtime_handoff.md`](./runtime_handoff.md) — current deployment and slice state
4. [Subrepo `CHANGELOG.md`] — what shipped recently in the target repo
5. [`governance/definition_of_done.md`](../../governance/definition_of_done.md) — completion bars
```

### Rules

- **No agent may skip READ FIRST.** If an agent starts coding without reading the listed files, the orchestrator or reviewer must reject the work.
- **Maximum 7 files** in READ FIRST. If more context is needed, consolidate into the runtime handoff or decision log.

---

## 2) Condensed Runtime Handoff (<200 lines)

The existing `runtime_handoff_template.md` is the base. This protocol adds **hard constraints**:

### Size limit: 200 lines maximum

If a handoff exceeds 200 lines, it must be split:
- YAML frontmatter (machine state) stays in `runtime_handoff.md`
- Narrative overflow goes to `runtime_handoff_narrative.md` (optional, linked from YAML `notes:` field)

### Update discipline

| When | Who updates | What changes |
|------|------------|-------------|
| Slice starts | Executor | `slices.[id].status: in_progress`, `slices.[id].executor: <agent-id>` |
| Slice passes V1+ | Executor | `slices.[id].status: pass`, `slices.[id].evidence: [<paths>]` |
| Slice fails review | Reviewer | `slices.[id].status: fail`, `known_issues:` append |
| Deploy to staging | Executor/HitM | `deployment.last_deploy_sha`, `deployment.smoke_result` |
| Session ends (any reason) | Current agent | `Last Session Summary` updated, `Handoff Warnings` refreshed |

### Handoff Warnings section (mandatory)

Every handoff must include at minimum:

```yaml
handoff_warnings:
  - "Do NOT modify <file> — it was manually verified by HitM on <date>"
  - "Branch is rebased on main as of <sha>; do not force-push"
  - "<specific gotcha from last session>"
```

If there are no warnings, explicitly state: `handoff_warnings: []`

---

## 3) Append-Only Decision Log

Every plan directory must contain a `DECISION_LOG.md`. This is **append-only** — decisions are never edited or deleted, only superseded.

### Template

```markdown
# Decision Log — <Plan Name>

Append-only. Never edit or delete entries. Supersede by adding a new entry with `supersedes: D##`.

| ID | Date | Decision | Rationale | Supersedes |
|----|------|----------|-----------|------------|
| D01 | 2026-05-21 | Use Joyride v3 for guided tours | Lighter than Shepherd.js, better React integration | — |
| D02 | 2026-05-22 | Target DOM IDs not CSS classes for tour anchors | Classes change with CSS modules; IDs are stable | — |
| D03 | 2026-05-23 | Switch to data-tour attributes instead of IDs | IDs conflicted with form accessibility attrs | D02 |
```

### Rules

- **One row per decision.** Keep it concise — rationale is one sentence, not a paragraph.
- **Superseding:** When a decision changes, add a new row with `Supersedes: D##`. The old row stays visible.
- **Agent behavior:** Before making any design choice, agents must check the decision log. If a relevant decision exists, follow it. If not, add one with rationale.
- **HitM can pre-populate:** During sprint planning, HitM seeds decisions for architectural choices, library picks, and approach constraints.

---

## 4) Session-Start Enforcement (Orchestrator Responsibility)

When the orchestrator script (or HitM manually) dispatches a task:

### Pre-flight checklist (automated)

```
1. Verify READ FIRST files exist at specified paths
2. Verify runtime_handoff.md is <200 lines
3. Verify DECISION_LOG.md exists in plan root
4. Verify branch state matches handoff YAML
5. Verify no conflicting plans are in_progress (check plan_registry.md)
```

### Agent session start protocol

The executor agent must, as its first actions:

```
1. Read all READ FIRST files (in order listed)
2. Parse runtime_handoff.md YAML — confirm slice status matches expected
3. Scan DECISION_LOG.md — acknowledge locked decisions
4. Report readiness: "Context loaded. Starting T##.SL# — <slice title>"
5. THEN begin work
```

If any READ FIRST file is missing or handoff is stale, the agent must report the gap instead of guessing.

---

## Adoption

- **Existing plans:** Add `DECISION_LOG.md` and update `runtime_handoff.md` to conform before next execution.
- **New plans:** `DECISION_LOG.md` is mandatory at plan creation (even if empty table).
- **Task Specs:** All new specs must include `READ FIRST:` block per §1.
- **Orchestrator:** Implements pre-flight checklist per §4 when script is built.
