# Plan Lifecycle — State Machine

## State machine

```
(none) ──birth──> draft ──validate──> ready ──pickup──> in_progress
                                                            │
                                                            ├──pause──> paused ──resume──> in_progress
                                                            ├──block──> blocked ──unblock──> in_progress
                                                            ├──merge──> completed ──30d──> archived
                                                            └──abandon──> abandoned ──30d──> archived

hotfix: (none) ──birth──> in_progress  (skips draft, ready)
```

## Transition table


| From          | To            | Trigger                                                            | Required actions                   | Slack gate                                                                             |
| ------------- | ------------- | ------------------------------------------------------------------ | ---------------------------------- | -------------------------------------------------------------------------------------- |
| `(none)`      | `draft`       | New work identified                                                | §A Birth actions                   | none                                                                                   |
| `(none)`      | `in_progress` | Hotfix only                                                        | §A Birth + §A.HF hotfix variant    | none for pre_execution                                                                 |
| `draft`       | `ready`       | Validation passes                                                  | §B Validation actions              | none                                                                                   |
| `ready`       | `in_progress` | Agent picks up                                                     | §C Pre-execution actions           | `pre_execution` if required                                                            |
| `in_progress` | `paused`      | Voluntary hold                                                     | §D.P Pause actions                 | none                                                                                   |
| `in_progress` | `blocked`     | External blocker                                                   | §D.B Block actions                 | none                                                                                   |
| `paused`      | `in_progress` | Resume condition met                                               | Update registry, update `updated:` | none                                                                                   |
| `blocked`     | `in_progress` | Blocker resolved                                                   | Update registry, update `updated:` | none                                                                                   |
| `in_progress` | `completed`   | PR merged + verification (+ deploy if `deployment.required: true`) | §E Close actions                   | `pre_close` if required; `pre_deploy` and `pre_cutover` if `deployment.required: true` |
| `in_progress` | `abandoned`   | Decision to stop                                                   | §F Abandon actions                 | none                                                                                   |
| `completed`   | `archived`    | ≥30 days idle, not referenced                                      | §G Archive actions                 | none                                                                                   |
| `abandoned`   | `archived`    | ≥30 days idle                                                      | §G Archive actions                 | none                                                                                   |


## Forbidden transitions

```
draft        → in_progress        ❌  (must validate first; exception: hotfix per §A.HF)
draft        → completed          ❌
ready        → completed          ❌  (must execute first)
in_progress  → ready              ❌  (use paused or blocked instead)
completed    → in_progress        ❌  (open new plan if work resumes)
archived     → *                  ❌  (open new plan; don't unarchive)
```

## §A Birth actions (`(none) → draft`)

```
1. Identify trigger: phase work | bug | ops | doc sync | hotfix
2. Decide strategic_phase (S1..S6 | cross-phase | hotfix)
3. Generate plan_id: PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>
4. Create plan_root: plans/<Phase>/<Stage>/<sub-plan>/ (match `intended_branch` per `branching_guidelines.md`)
5. Create README.md from plan_template.md
6. Fill metadata header (status: draft)
7. Fill required body sections per template §4
8. If the plan touches multiple web routes or API surfaces: enumerate **tasks and slices** `T##.SL#` per `plan_template.md` §1a before heavy execution
9. Append row to plan_registry.md "Draft / Planning"
```

## §A.HF Hotfix variant deltas

Hotfix overrides §A and §B:

```
status: in_progress (from creation)
priority: P0
strategic_phase: hotfix
slack_gates: pre_execution=none, pre_merge=required, pre_close=none
Body sections: may be filled retroactively within 24h
Registry: append row directly to "In Progress" section
```

## §B Validation actions (`draft → ready`)

```
1. Run plan_template.md §6 validator (binary checklist)
2. If any check fails: stay draft, fix, re-run
3. If all pass:
   a. Set status: ready
   b. Update metadata: updated: <today>
   c. Move registry row from "Draft / Planning" to "Ready for Execution"
```

## §C Pre-execution actions (`ready → in_progress`)

```
1. Re-check plan_registry.md:
   - All depends_on plans status: completed
   - No conflicts_with plans currently in_progress
2. If slack_gates.pre_execution == required:
   a. Post Slack gate per execution_protocols.md §1.1
   b. Wait for HitM reply
   c. On 👍 / approve / yes → continue
   d. On 👎 / reject / no  → stay ready, post reason as next-step
   e. On hold / wait / pause → status: paused, paused_reason set
   f. On 24h no-reply → status: paused, paused_reason: pre_execution gate timeout
3. Set status: in_progress
4. Update metadata: updated: <today>
5. Move registry row from "Ready" to "In Progress"
6. Create feature branch in target sub-repo: git checkout -b <intended_branch>
```

## §D.P Pause actions (`in_progress → paused`)

```
1. Set status: paused
2. Update metadata: updated, paused_reason, resume_trigger
3. Move registry row from "In Progress" to "Paused"
4. If branch has uncommitted work: stash or commit WIP with prefix "wip(paused):"
```

## §D.B Block actions (`in_progress → blocked`)

```
1. Set status: blocked
2. Update metadata: updated, blocker, resolution_owner
3. Move registry row from "In Progress" to "Blocked"
4. Notify HitM via Slack thread reply (no gate prompt; informational)
```

## §E Close actions (`in_progress → completed`)

Pre-conditions:

```
[ ] All exit criteria in plan body §6 met
[ ] All verification commands pass
[ ] PR opened, posted to #pull-requests
[ ] Slack #pull-requests automation reconciled with GitHub state
[ ] PR merged
[ ] If deployment.required == true:
      [ ] pre_deploy gate authorized (deployment_protocol.md §3)
      [ ] Inactive-color smoke passed (deployment_protocol.md §4)
      [ ] pre_cutover gate authorized (deployment_protocol.md §5)
      [ ] Cutover executed and post-cutover smoke passed (deployment_protocol.md §6)
      [ ] Monitoring window complete with no rollback (deployment_protocol.md §7)
[ ] If slack_gates.pre_close == required: HitM 👍 received
      (pre_close gate must include deployment evidence per deployment_protocol.md §9 when deployment.required == true)
```

Then:

```
1. Set status: completed
2. Update metadata: updated: <today>
3. Move registry row from "In Progress" to "Recently Completed"
   - Include: completion_date, strategic_impact_summary, pr_url(s)
4. Strategic impact updates (mandatory):
   - Read plan body §8
   - For each checked item:
     a. If validation_gates.md trigger met: edit strategic-roadmap/validation_gates.md inline
     b. If kill_commit_gates.md gate evaluated: append outcome to outcomes log
   - Update plan_registry.md "Last updated" header
5. Documentation sync (if §7 lists files):
   - Invoke design-docs-sync skill
   - Stage and commit doc changes if needed (separate commit from code)
6. Slack handoff (informational, no gate):
   - Post completion to plan thread or #cli-interface
   - Format: see execution_protocols.md §2.1 with type=close_summary
```

## §F Abandon actions (`* → abandoned`)

```
1. Document abandonment reason in plan body (new §11 Abandonment Reason)
2. Set status: abandoned
3. Update metadata: updated, abandoned_reason
4. Move registry row to "Abandoned"
5. Branch handling: do NOT auto-delete; HitM decides at archive time
```

## §G Archive actions (`completed/abandoned → archived`)

Pre-conditions:

```
[ ] Status is completed or abandoned
[ ] Days since completion/abandonment >= 30
[ ] No active plan lists this plan_id in depends_on
[ ] HitM authorized OR auto-archive enabled (current default: auto-archive on)
```

Then:

```
1. Move plan_root contents: plans/<Phase>/<Stage>/<sub-plan>/ → plans/archived/<plan_id>/
2. Optional: leave stub at original path:
   plans/<Phase>/<Stage>/<sub-plan>/ARCHIVED.md → "Moved to plans/archived/<plan_id>/"
3. Set status: archived
4. Move registry row to "Archived (Index Only)"
5. Update metadata one last time: updated: <today>
```

## Status invariants (validator may check)

```
- A plan_id is unique across all sections of plan_registry.md.
- A plan in "In Progress" must have status: in_progress in its metadata header (and vice versa).
- A plan listed in any depends_on must exist somewhere in the registry.
- No plan can list itself in depends_on, blocks, parallel_safe_with, or conflicts_with.
- depends_on graph must be acyclic (transitively).
- A plan in "Recently Completed" or "Abandoned" >30 days should be moved to "Archived".
```

## Quick reference — what to do at each transition


| If status is  | And event is                 | Do                                                       |
| ------------- | ---------------------------- | -------------------------------------------------------- |
| `(none)`      | New work                     | Run §A Birth                                             |
| `draft`       | Authoring complete           | Run §B Validation                                        |
| `ready`       | Picked up                    | Run §C Pre-execution                                     |
| `in_progress` | Tasks complete + tests pass  | Open PR, run §E Close pre-conditions                     |
| `in_progress` | HitM unavailable >24h        | Stay in_progress unless work cannot proceed → §D.P Pause |
| `in_progress` | External blocker             | Run §D.B Block                                           |
| `paused`      | Resume condition true        | Set in_progress, update registry                         |
| `blocked`     | Blocker resolved             | Set in_progress, update registry                         |
| `completed`   | 30+ days idle                | Run §G Archive                                           |
| `abandoned`   | 30+ days idle                | Run §G Archive                                           |
| any           | Conflict detected mid-flight | Pause this plan; resolve via plan_template.md §7         |


