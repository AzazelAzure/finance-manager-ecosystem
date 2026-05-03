# Execution Protocols — HitM Messages and Parallelism Rules

All HitM-facing output uses these exact templates. Variables in `{curly_braces}` are substituted; everything else is verbatim.

## 1) Slack gate templates

### 1.1 `pre_execution` gate

Channel: `#cli-interface` (in plan task thread, or new thread if none).

```text
[GATE: pre_execution]
Plan: {plan_id}
Phase: {strategic_phase}
Branch: {intended_branch}
Repos: {comma_separated_target_repos}

Scope: {one_line_scope_summary_max_140_chars}

Strategic check:
- Wedge respected: {yes|no|n/a}
- Locked decisions touched: {none|comma_list}
- Cost cap impact: {none|short_description}

Dependencies:
- depends_on satisfied: {yes|no}
- conflicts_with active: {none|comma_list_of_plan_ids}

Reply: 👍 approve  |  👎 reject  |  hold for desktop review
```

Wait condition: agent blocks until reply OR 24h timeout.

### 1.2 `pre_merge` gate

Channel: `#pull-requests` (new top-level message).

```text
[PR] {plan_id}
Repo: {repo_name}
Branch: {intended_branch}
URL: {pr_url}
Strategic phase: {strategic_phase}
Validation: {one_line_validation_summary}
```

Wait condition: agent reads `#pull-requests` for automation final state. Agent reads GitHub state via `gh pr view {pr_number}`. Both must align before merge per workspace rule.

If GitHub state is `CONFLICTING` or `DIRTY`: do not merge. Set plan status: `blocked`. Notify HitM via plan thread reply.

### 1.3 `pre_close` gate

Channel: `#cli-interface` (in plan task thread).

```text
[GATE: pre_close]
Plan: {plan_id}
Status: ready to mark complete
PR: {merged_pr_url}

Verification evidence:
- {bullet_1}
- {bullet_2}
- {bullet_3}

Strategic impact:
- Phase: {strategic_phase}
- Triggers met: {none|specific_validation_gates_md_entries}
- Kill/commit gates evaluated: {none|gate_id_and_outcome}
- Design docs to sync: {none|file_list}

Reply: 👍 confirm close  |  👎 evidence insufficient  |  defer
```

Wait condition: agent blocks until reply OR 24h timeout.

## 2) Handoff templates

### 2.1 `in_plan` handoff (mid-plan, between agents on same plan)

Channel: plan task thread.

```text
[HANDOFF: in_plan]
Plan: {plan_id}
From: {from_agent_id}
To: {to_agent_id|next_available}

Last completed: T{n} - {short_title}
Next: T{m} - {short_title}
Branch state: {clean|uncommitted|pushed|wip_committed}

Context:
- {bullet_1}
- {bullet_2}
- {bullet_3}

Outstanding HitM questions: {none|list}
Status: in_progress
```

### 2.2 `cross_plan` handoff (one plan reveals work belonging to another)

Channel: source plan task thread.

```text
[HANDOFF: cross_plan]
Source plan: {source_plan_id} (current)
Target plan: {target_plan_id|new}

Issue discovered:
{one_paragraph}

Recommended target plan_id (if new): PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>
Recommended dependency: target depends_on source | source depends_on target | parallel_safe

Source plan action: {continue|pause}
```

If `target_plan_id == new`: the agent (or HitM) opens a Birth flow per `plan_lifecycle.md` §A.

### 2.3 `failure` handoff (agent cannot resolve)

Channel: plan task thread.

```text
[HANDOFF: failure]
Plan: {plan_id}
From: {from_agent_id}
Failure category: implementation|runtime|contract|infra|unknown

What failed:
{one_paragraph}

What was tried:
- {attempt_1}
- {attempt_2}

Best-guess next step:
{one_paragraph}

Branch state: {clean|uncommitted|pushed|wip_committed}
Status: in_progress → blocked
```

### 2.4 `close_summary` (informational, after `pre_close` approved)

Channel: plan task thread + cross-post to `#cli-interface` if plan is P0.

```text
[CLOSE: {plan_id}]
Status: completed
PR: {merged_pr_url}
Phase: {strategic_phase}

Strategic impact:
- {validation_gates_updates}
- {kill_commit_gates_outcomes}
- {design_docs_sync_summary}

Follow-ups: {none|list_of_new_plan_ids_or_open_questions}
```

## 3) HitM reply parsing

The agent must accept all of these reply forms.

### 3.1 Approval (proceed)

Match any of: `👍`, `approve`, `approved`, `go`, `yes`, `y`, `ok`, `proceed`, `lgtm`.

Action: continue per gate-specific transition.

### 3.2 Rejection (do not proceed)

Match any of: `👎`, `reject`, `rejected`, `no`, `n`, `stop`, `cancel`.

Action: do not transition. Post next-step reply asking what to fix.

### 3.3 Hold for desktop review (`pre_execution` only)

Match any of: `hold`, `wait`, `pause`, `desktop`.

Action: status `ready → paused`. `paused_reason: awaiting desktop review`.

### 3.4 Defer (`pre_close` only)

Match any of: `defer`, `not yet`, `more work`.

Action: stay `in_progress`. Post next-step reply asking what's needed.

### 3.5 Free-form clarification

Any reply that does not match §3.1-§3.4.

Action: parse the message. If actionable, treat as conditional approval ("👍 with constraint X") or rejection-with-reason. If unclear, post a clarification reply with the original gate restated.

### 3.6 Approval with constraint

Pattern: approval keyword followed by qualification.

Example: `👍 but skip the API changelog this round`.

Action: log the constraint in plan body §10 Risks/notes. Comply during execution.

## 4) Channel routing


| Message type                | Channel                                       | Thread?                                         |
| --------------------------- | --------------------------------------------- | ----------------------------------------------- |
| `pre_execution` gate        | `#cli-interface`                              | new thread or existing plan thread              |
| `pre_merge` PR announcement | `#pull-requests`                              | new top-level                                   |
| `pre_merge` reconciliation  | `#pull-requests`                              | thread reply on PR announcement                 |
| `pre_close` gate            | `#cli-interface`                              | plan task thread                                |
| `in_plan` handoff           | `#cli-interface`                              | plan task thread                                |
| `cross_plan` handoff        | `#cli-interface`                              | source plan task thread                         |
| `failure` handoff           | `#cli-interface`                              | plan task thread                                |
| `close_summary`             | `#cli-interface` (+ thread); cross-post if P0 | plan task thread + new top-level for cross-post |


## 5) Slack message length

Max chunk: 2400 chars (per bridge default). If template exceeds, split:

- Chunk 1: header + scope + strategic check.
- Chunk 2: dependencies + reply line.

HitM replies on chunk 1 (the message starting with `[GATE: ...]` or `[PR]` or `[HANDOFF: ...]`).

## 6) Wait + timeout policy


| Gate                     | Wait? | Timeout                     | On timeout                          |
| ------------------------ | ----- | --------------------------- | ----------------------------------- |
| `pre_execution` required | yes   | 24h                         | status: `paused`, paused_reason set |
| `pre_execution` optional | no    | —                           | proceed after posting               |
| `pre_merge` required     | yes   | indefinite (workspace rule) | stay `in_progress`; do not merge    |
| `pre_close` required     | yes   | 24h                         | status stays `in_progress`          |
| `pre_close` optional     | no    | —                           | proceed after posting               |


## 7) Parallel execution rules

Two plans P_A and P_B may both have `status: in_progress` if and only if **at least one** of these conditions is true:

```
P_A.parallel_safe_with contains P_B.plan_id  AND
P_B.parallel_safe_with contains P_A.plan_id

OR

target_repos(P_A) ∩ target_repos(P_B) == ∅  AND
no API contract change in either plan

OR

P_A is read-only (DOMAIN: DOCS only)  AND
P_B is implementation

OR

target_repos(P_A) and target_repos(P_B) include the same repo
BUT modify disjoint Django apps with no shared models
```

If conditions fail: the second plan to attempt `ready → in_progress` blocks until the first reaches `completed`.

## 8) Conflict signatures (auto-detect)

Two plans **conflict** if any apply:

```
Files modified intersect (any path)
Same Django migration sequence (numeric prefix overlaps)
Both modify: docker-compose.yml | proxy/ | .secrets/ | scripts/ at root | settings.py
Either plan changes API contract that the other consumes
```

Resolution options:

```
sequence  : earlier plan blocks later; later plan depends_on earlier
merge     : combine both into one plan with one branch
coordinate: rare; usually leads to merge
```

## 9) Branch hygiene under parallel execution

```
- Each plan: own feature branch.
- No shared branches.
- Two parallel plans may both branch from main but never push to each other's branch.
- Merge order: depends_on chain first; otherwise merge timestamp.
- If conflict emerges mid-flight: later-started plan transitions in_progress → paused until earlier merges.
```

## 10) Runtime ownership under parallel execution

Per workspace rule `container-testing-orchestration.mdc`:

```
- Only one agent owns container uptime at a time.
- Non-owner parallel plans:
  - read-only runtime ops (status checks, log reads), OR
  - wait for owner handoff, OR
  - work in code paths not requiring runtime.
```

## 11) Slack unavailable fallback

```
If Slack down or HitM unreachable:
  pre_execution required → do not proceed; status stays ready or paused
  pre_close required     → do not close; status stays in_progress
  pre_merge required     → workspace rule absolute; do not merge

Hotfix override:
  HitM may post desktop authorization (commit message in feature branch,
  gh pr review --approve, or in-person verbal).
  Hotfix is the only category permitted to bypass Slack pre_merge gate.
```

## 12) Reply latency expectations

Agent should not poll faster than:

```
pre_execution: every 60s for first 10min, every 5min thereafter
pre_merge:     every 120s indefinitely (workspace rule allows long waits)
pre_close:     every 60s for first 10min, every 10min thereafter
```

Bridge agent (`scripts/cursor_headless_slack_agent.py`) provides polling; do not implement custom poll loops.