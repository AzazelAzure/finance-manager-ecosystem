# Git Workflow Scripts

These scripts help manage Git operations across workspace repos listed in:

- `scripts/repos.txt`

By default, the file includes:

- `finance_manager_api`
- `finance_manager_cli`
- `finance_manager_reflex`

To add a new repo (for example Rust later), add one directory name per line in `scripts/repos.txt`.
Blank lines and `# comments` are ignored.

All scripts continue safely when a directory is missing or not initialized as a Git repository.

## Scripts

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
