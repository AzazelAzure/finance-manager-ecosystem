# Branching Guidelines — Per-Feature Color-Cycle Workflow

**Locked:** 2026-04-30, Topic 11 close-out (huddle). Extends `deployment_protocol.md`.

This file codifies the actual branching + deployment workflow for shipping features on the blue-green VPS runtime. It supersedes any informal patterns from prior sprints.

---

## 1) Core principle

**One feature at a time on inactive color.** Each fully-implemented feature triggers a color flip. Atomic feature shipping; clean rollback; no "partial feature in production."

This is more disciplined than parallel feature flow but matches the solo-HitM operator constraint and prioritizes rollback safety over throughput.

---

## 2) Branch hierarchy

```
main (production HEAD; matches active color)
  └── cursor/<phase-stage>/feat/<feature-name>      ← FEATURE BRANCH (inactive color staging)
        ├── cursor/<phase-stage>/feat/<feature-name>/t01-<slug>   ← TASK BRANCH
        ├── cursor/<phase-stage>/feat/<feature-name>/t02-<slug>
        ├── cursor/<phase-stage>/feat/<feature-name>/t03-<slug>
        └── ...
```

Examples:

```
cursor/s1b/feat/email-uniqueness-fix
cursor/s1b/feat/email-uniqueness-fix/t01-add-unique-constraint
cursor/s1b/feat/email-uniqueness-fix/t02-add-validation
cursor/s1b/feat/email-uniqueness-fix/t03-update-tests
```

```
cursor/s1b/feat/quick-pay-bill
cursor/s1b/feat/quick-pay-bill/t01-define-form-spec
cursor/s1b/feat/quick-pay-bill/t02-implement-form
cursor/s1b/feat/quick-pay-bill/t03-wire-transaction-seed
```

### 2.1 Task slices (`T##.SL#`) — documentation vs branches

Per `governance/plan_template.md` §1a, plans decompose work into **tasks** (`T##`) and **slices** (`T##.SL#`). `**SL`** avoids ambiguity with **Phase/Stage `S`** notation (`S1`, `S1.B`).

- **Branches stay at the task level by default:** one branch `…/t##-<slug>` per task; multiple slices merge as **sequential commits or PRs** to that same task branch. Name the active slice in commit messages or PR descriptions (`T03.SL2: transactions offline read`).
- **Optional finer isolation:** HitM may open a short-lived branch such as `…/t03-sl2-<slug>` if two slices must not share a branch; still document parent task `T03` and slice IDs in the plan README.
- Orchestrators and executors treat **slice** as the smallest delegated scope unless HitM explicitly widens it.

---

## 3) Per-feature lifecycle

### 3.1 Feature open (one feature at a time)

1. Identify next feature from active Execution Plan.
2. Confirm inactive color is clean (no stale commits, no parallel feature in flight).
3. Create feature branch from `main`: `git checkout -b cursor/<phase-stage>/feat/<feature-name>`.
4. Push branch (no PR yet).
5. Update `plan_registry.md` with the feature branch as `in_progress`.

### 3.2 Per-task work

For each task within the feature:

1. Branch from feature branch: `git checkout -b cursor/<phase-stage>/feat/<feature-name>/t<NN>-<slug>`.
2. Implement task.
3. Run task-level verification (tests, lint, manual smoke).
4. Open PR from task branch → feature branch (NOT to main).
5. PR review: same severity as standard but limited scope (one task).
6. Merge PR into feature branch.
7. Delete task branch (or let it auto-prune after merge).

**Important:** task PRs **do not deploy**. They merge into the feature branch and accumulate. Inactive color is rebuilt to reflect feature-branch HEAD as tasks land (or at feature completion — see §3.3).

### 3.3 Inactive-color rebuild cadence

Two valid patterns; choose per feature:

- **Continuous:** rebuild inactive color after every task merge. Surfaces integration issues early. Higher VPS rebuild count but cleaner staging.
- **Batch:** rebuild inactive color only at feature completion. Fewer rebuilds; risk of integration surprises at the end.

Default: **continuous** if inactive color is reachable (e.g. `jsdevtesting.thehivemanager.com`); **batch** otherwise.

### 3.4 Feature completion → ship

When all tasks for the feature are merged into the feature branch:

1. Final feature-branch verification:
  - All tests pass on the feature branch.
  - Inactive color smoke per `deployment_protocol.md` §6.
  - Feature behaves end-to-end (manual review on inactive color).
2. Open PR: feature branch → `main`.
3. Apply `pre_deploy` Slack gate (HitM authorization to deploy).
4. On approval: merge PR.
5. Trigger color flip (deploy via `scripts/fm_server_beta.sh switch --to <inactive-color>`).
6. Apply `pre_cutover` Slack gate (HitM authorization for the flip itself).
7. Post-cutover smoke per `deployment_protocol.md` §6.
8. Update `plan_registry.md`: feature as `completed`.

The feature branch is now merged into main; inactive color (the previously-inactive one) is now active. The newly-inactive color (the previously-active one) holds the prior state, ready for rollback.

### 3.5 Next feature

Once the color flip is complete and stable:

1. Confirm new active color is healthy (post-cutover smoke + monitoring window).
2. New inactive color is "previous state" — ready for next feature staging.
3. Open the next feature branch from `main` (now reflecting new active color).
4. Repeat from §3.1.

---

## 4) Bug-fix path (per Q11.2.b)

Bug severity determines the path.

### 4.1 Minor bugs (S2 / S3, non-UX-destroying)

**Bundle into the next color flip with the active feature.**

- Add the fix as a task within the currently-active feature branch.
- Branch: `cursor/<phase-stage>/feat/<feature-name>/t<NN>-fix-<slug>`
- Merges into the feature branch alongside other tasks.
- Ships as part of the feature's color flip.

If no feature is currently active: open a "maintenance feature branch" (`cursor/<phase-stage>/feat/maintenance-batch-<date>`) to accumulate small fixes; ship when batch reaches a reasonable size.

### 4.2 Major bugs (S0 / S1, blocking or UX-destroying)

**Hotfix path with re-roll into next batch.**

1. **Pause active feature** if one is in flight.
2. Create hotfix branch from `main`: `git checkout -b cursor/<phase-stage>/hotfix/<slug>`.
3. Implement minimum viable fix (no scope creep).
4. PR hotfix branch → `main` directly (skip feature branch).
5. Apply hotfix-specific Slack gates (`pre_deploy` required; `pre_cutover` required; per `deployment_protocol.md`).
6. On approval: merge + color flip.
7. **After hotfix lands:** the previously-paused feature branch needs the hotfix re-rolled into it before resumption:
  - Either rebase the feature branch on the new main (clean), or
  - Cherry-pick the hotfix commit into the feature branch (also fine).
8. Resume feature work from §3.2.

**Hotfix Sprint duration override:** can be shorter than the standard 1-week minimum (per `glossary.md` §6) because hotfixes are reactive, not planned.

### 4.3 What about S0 production incidents (data corruption, auth breach)?

These follow the incident triage flow per `design_docs/40_System_Design/15_Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md`. Branching follows §4.2 (hotfix path) but with shortened Slack gate cadence allowed at HitM discretion.

---

## 5) Concurrency rules

### 5.1 Feature concurrency

**One feature in flight at a time per inactive color.** Multiple features cannot accumulate on the same inactive color.

If an agent attempts to start a new feature while one is in flight:

- Block the start.
- Notify HitM: "Feature X is in flight on inactive color; new feature deferred until X ships."

### 5.2 Task concurrency within a feature

**Multiple tasks within the same feature CAN be in flight in parallel** if and only if they don't conflict on files. Apply the conflict-detection heuristics from `plan_template.md` §7.

### 5.3 Hotfix during active feature

Hotfix interrupts the active feature (per §4.2). Only one hotfix at a time.

---

## 6) Color flip authorization (Slack gate cadence)


| Event                            | `pre_deploy` gate             | `pre_cutover` gate |
| -------------------------------- | ----------------------------- | ------------------ |
| Feature complete → ship          | Required                      | Required           |
| Hotfix → ship                    | Required                      | Required           |
| Maintenance batch → ship         | Required                      | Required           |
| Inactive-color rebuild (no flip) | Optional (informational only) | N/A                |


Per `deployment_protocol.md` §3 and §5; this section reinforces that the cadence applies per feature flip, not per Sprint.

---

## 7) Rollback protocol

If a feature flip causes regression:

1. Run `scripts/fm_server_beta.sh rollback` (proxy switches back to previous active color).
2. Previous color is still warm (containers running) — fast rollback within seconds.
3. Status: feature plan transitions `in_progress → blocked` with documented failure category.
4. Investigate; fix on the feature branch (or new branch if needed); re-deploy when fixed.

The previously-shipped feature stays in main commit history; rolling back the proxy doesn't roll back git. If the feature needs full removal: `git revert` the merge commit and ship a hotfix-style flip.

Per `deployment_protocol.md` §8.

---

## 8) Edge cases

### 8.1 Feature requires a migration

DB migrations are special — they're not easily rollback-able by color flip alone. Rules:

- Migrations are **never** included in feature branches by default.
- A migration ships as its own micro-feature with stricter gates: HitM personal review, dry-run on inactive color, manual rollback verification.
- Color flip after migration is more cautious: monitoring window doubled (per `deployment_protocol.md` §7).

### 8.2 Feature spans multiple repos (e.g. API + web)

If a feature requires changes in both `finance_manager_api` and `finance_manager_web`:

- Branch in BOTH repos using the same feature name: `cursor/s1b/feat/<feature-name>`.
- Coordinate task merges so the API contract is finalized before web consumes it.
- API ships first (deploy + color flip); web ships second (deploy + color flip).
- Treat as two sequential feature flips, not one.
- Log the multi-repo coordination in a shared `CROSS_REPO_COORDINATION.md` file in one of the plan directories.

### 8.3 Feature branch becomes stale (>1 week without progress)

If a feature branch has had no commits for >1 week:

- Pause status in registry.
- Notify HitM: "Feature X stale; resume or abandon?"
- On HitM decision, either resume (rebuild against fresh main) or abandon (delete branch, document reason).

---

## 9) Anti-patterns (do not do)

- ❌ Multiple feature branches accumulated on inactive color simultaneously.
- ❌ Task PRs going directly to main (always go to feature branch first).
- ❌ Color flip without `pre_cutover` Slack gate authorization.
- ❌ Skipping the inactive-color smoke before flip.
- ❌ Squashing task branch history when merging task PR (preserve task-level history within feature branch).
- ❌ Force-pushing to feature branch after task PRs have landed.
- ❌ Merging a feature branch to main without all task PRs first merging into it.

---

## 10) Cross-references


| Concept                                            | File                                                                                            |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Slack gate templates (`pre_deploy`, `pre_cutover`) | `execution_protocols.md` §1                                                                     |
| VPS deployment commands                            | `deployment_protocol.md` §4-§6                                                                  |
| Plan template metadata                             | `plan_template.md`                                                                              |
| Status transitions                                 | `plan_lifecycle.md`                                                                             |
| Vocabulary (Sprint types, etc.)                    | `glossary.md`                                                                                   |
| Incident triage                                    | `design_docs/40_System_Design/15_Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md` |


