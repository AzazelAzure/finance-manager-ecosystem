# Agent Workspace Isolation — Layout and Rules

*Locked 2026-05-04 — Emergency Orchestration Huddle.*

> **Superseded 2026-07-01 by `governance/workspace_protocol.md`.** The paths below (`~/Documents/python/finance_manager`, `~/agent-workspaces/*`) and role names are pre-migration. Kept for history only — do not follow for current workspace setup.

## Directory Layout

```
~/Documents/python/finance_manager/              ← PRIMARY (HitM + planning)
  git identity: Patrick Proctor <etusnproctor@gmail.com>
  role: HitM work, orchestration, manual verification, production flips
  branch policy: any branch; main for governance/strategy edits

~/agent-workspaces/antigravity-executor/finance_manager/
  git identity: Proctor-Antigravity-Agents <antigravity-agent@hivemanager.com>
  GitHub account: Proctor-Antigravity-Agents (collaborator, push)
  role: EXECUTOR — writes production code on feature branches
  branch policy: feature branches only (`agy/s1b/feat/...` or `cur/s1b/feat/...` per agent)
  Visibility: Antigravity IDE subagents or Cursor native multitask — not `scripts/orchestrator.py` (archived)
```

## Isolation Rules

1. **No two agents share a working directory.** Each agent operates in its own clone.
2. **Slices must target non-overlapping files.** Orchestrator assigns file scope per slice.
3. **Agents pull before starting work.** Each clone must `git pull` the latest before beginning any task.
4. **Commits use the workspace's local git identity.** Each clone has `user.name` and `user.email` set locally (not global). This ensures commit attribution without changing the global gitconfig.
5. **SSH key is shared.** All clones use HitM's SSH key (`~/.ssh/id_ed25519`) for push access. Agent GitHub accounts are collaborators with `push` permission — they get write access, but pushes are SSH-authenticated as HitM. Commit authorship (via local git config) provides attribution.

## GitHub Accounts

| Account | GitHub Username | Role | Permission |
|---------|----------------|------|------------|
| HitM | AzazelAzure | Owner + Orchestrator | admin (owner) |
| Antigravity Agent | Proctor-Antigravity-Agents | Executor | push (collaborator) |

## Concurrency Safety

| Scenario | Safe? | Why |
|----------|-------|-----|
| Antigravity Grunt 1 writes to `finance_manager_web/src/pages/Foo.tsx` while Grunt 2 writes `finance_manager_api/` | ✅ | Different clones, different subrepos, different slices |
| Both executors work on different slices of the same feature | ✅ | Different clones, non-overlapping file scope enforced by Orchestrator |
| Reviewer reads a branch while Executor pushes to it | ✅ | Reviewer pulls a snapshot; no write conflict |
| All agents pull main at the same time | ✅ | Read-only, separate `.git` databases |
| All agents push different branches | ✅ | Non-overlapping branches |
| Two agents push to the SAME branch | ❌ | Force-push race. Prevented by governance: only one agent works on a feature branch at a time |
| Any agent builds docker on VPS while another deploys | ❌ | VPS is shared. Sequence manually: one agent at a time on VPS operations |

## Sync Script

After any branch merge or significant change, agents should sync:

```bash
# In any agent workspace:
cd ~/agent-workspaces/<agent>/finance_manager
git pull --recurse-submodules
git submodule update --init --recursive
```

## SSH Key Persistence

The systemd user service `ssh-agent.service` is active. If keys get unloaded (e.g. after reboot), reload:

```bash
ssh-add ~/.ssh/id_ed25519
```

This is already configured for HitM's key. Agent workspaces use the same key via the shared `SSH_AUTH_SOCK`.
