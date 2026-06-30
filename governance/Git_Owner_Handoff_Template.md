# Git Owner Handoff Template

## Purpose
Use this template whenever branch ownership moves between agents during active implementation so the final owner is accountable for git closeout.

## Copy/Paste Handoff

```markdown
## Git Owner Handoff
- Previous owner:
- New owner:
- Timestamp:

### Branch State
- Repo:
- Branch:
- Head commit (before transfer):
- Working tree summary (`git status --short`):

### Work Completed
- Implemented tasks:
- Files touched:
- Validation run:

### Pending Work
- Remaining tasks:
- Required checks before commit:
- Known blockers:

### Final Owner Responsibility
- Is new owner final closeout owner? yes/no
- If yes, required actions:
  1. Run `git status --short`
  2. Run `git diff` (staged + unstaged)
  3. Run `git log --oneline -n 10` for style
  4. Create repo-scoped commit(s)
  5. Push branch
  6. Confirm post-push status

### Constraints
- Cross-repo commits allowed? no (default)
- Main branch active conflict warning:
- Forbidden actions for non-owner agents:
```

## Minimum Handoff Rules

1. Always include branch + head commit context.
2. Always include `git status --short` summary before transfer.
3. Always state whether new owner is the final closeout owner.
4. If final owner is set, include explicit commit/push checklist.
