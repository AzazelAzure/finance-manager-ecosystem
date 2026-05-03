# T02 Secret Hygiene

## Objective
Remove tracked secret material and prevent similar backup/env files from entering the API repo again.

## Scope Boundary
- Repo: `finance_manager_api/`
- Branch: create `cursor/api-secret-hygiene-53be` or combine with `T01` only if the API owner intentionally keeps one security PR.
- Do not publish real secret values in PR bodies, Slack, or logs.

## Evidence
- `finance_manager_api/.env.bak` is tracked.
- It contains `SECRET_KEY` and database credential-like values.
- `finance_manager_api/.gitignore` ignores `.env` but not `.env.bak` or broader `.env*` patterns.

## Implementation Notes
- Remove `.env.bak` from tracked files.
- Add ignore coverage for:
  - `.env`
  - `.env.*`
  - `.env*`
  - `*.bak` if this matches repo practice
- Add or update `.env.example` if developers still need a template.
- Recommend rotation of any exposed credentials out-of-band.
- If history rewriting is desired, make it a human-owned follow-up; this task should not rewrite public/shared history without explicit instruction.

## Acceptance Criteria
- No tracked `.env.bak` or secret-bearing backup file remains.
- Git ignore rules prevent future accidental env backup commits.
- PR notes mention rotation required without printing secret values.

## Verification Commands
Run from `finance_manager_api/`:

```bash
git ls-files | rg '(^|/)\\.env|\\.bak$|secret|credential|key' || true
rg -n 'SECRET_KEY=|DB_PASSWORD=|SLACK_BOT_TOKEN|CURSOR_API_KEY' . --glob '!uv.lock' --glob '!*.md'
```

Review matches manually to distinguish legitimate code references from secret values.

## Required Handoff
- Files changed.
- Secret-bearing files removed.
- Rotation recommendation.
- Verification output summary.
- Branch/PR status.
