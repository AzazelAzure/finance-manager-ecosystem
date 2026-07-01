# Git Workflow Scripts

These scripts help manage Git operations across workspace repos listed in:

- `scripts/repos.txt`

By default, the file includes:

- `finance_manager_api`
- `finance_manager_cli`
- `finance_manager_web`
- `finance_manager_android`
- `finance_manager_rust_tools`
- `finance_manager_rust_middleware`
- `finance_manager_reflex` (archived; optional if present)

To add a new repo (for example more Rust tooling), add one directory name per line in `scripts/repos.txt`.
Blank lines and `# comments` are ignored.

All scripts continue safely when a directory is missing or not initialized as a Git repository.

## Archived

- **`archived/root_one_off_python/`** — former repo-root Python scratches (Reflex / httpx smokes); not maintained. See that folder’s `README.md`.

## Scripts

### `./scripts/schedule_agent_sync.sh`

Writes **`governance/HITM_SCHEDULE_SNAPSHOT.md`** (gitignored) with:

- `khal list` for the next **90** days (override with `SCHEDULE_DAYS`)
- `todo list` (todoman) across configured task lists

Requires **khal**, **todoman** (`todo` on `PATH`), and **python3**. See **`governance/HITM_SCHEDULE_AND_TASKS.md`** for disk paths (`~/.local/share/calendars/work/`, tasks glob) and agent reading order.

```bash
./scripts/schedule_agent_sync.sh
SCHEDULE_DAYS=120 ./scripts/schedule_agent_sync.sh
```

### `./scripts/status.sh`
Shows branch and `git status -s` output for each repo in `repos.txt`.

### `./scripts/git_sync.sh`
Fetches and pulls the current branch from `origin` for each repo.

Notes:
- If a repo is in detached HEAD state, pull is skipped for that repo.

### `./scripts/feature_branch.sh <branch_name>`
Creates and checks out a branch in each repo.

Behavior:
- If the branch already exists, it checks out the existing branch.
- If not, it creates and checks it out.

### `./scripts/tag_release.sh <tag_name>`
Creates a lightweight tag on the current commit in each repo.

Behavior:
- If the tag already exists in a repo, the script prints a warning and continues.

### `./scripts/check_repos.sh`
Validates `scripts/repos.txt` entries and reports whether each repo is:

- missing,
- present but not git,
- valid git repository (including current branch).

Exit codes:
- `0`: all configured directories exist
- `2`: one or more configured directories are missing

## Usage examples

```bash
./scripts/check_repos.sh
./scripts/status.sh
./scripts/git_sync.sh
./scripts/feature_branch.sh feature/my-work
./scripts/tag_release.sh v1.0.0
```
