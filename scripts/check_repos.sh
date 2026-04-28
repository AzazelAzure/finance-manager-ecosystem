#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib_repos.sh
source "$SCRIPT_DIR/lib_repos.sh"

if ! read_repos; then
  exit 1
fi

missing=0
git_repos=0
non_git=0

for repo in "${REPOS[@]}"; do
  echo "=================================================="
  echo "Repo: ${repo}"
  echo "=================================================="

  repo_path="$WORKSPACE_ROOT/$repo"

  if [[ ! -d "$repo_path" ]]; then
    echo "[MISSING] Directory not found: $repo_path"
    missing=$((missing + 1))
    echo
    continue
  fi

  if git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git -C "$repo_path" branch --show-current 2>/dev/null || true)"
    if [[ -z "$branch" ]]; then
      branch="(detached HEAD)"
    fi
    echo "[OK] Git repository"
    echo "Branch: $branch"
    git_repos=$((git_repos + 1))
  else
    echo "[WARN] Directory exists but is not a git repository"
    non_git=$((non_git + 1))
  fi
  echo

done

echo "==================== Summary ===================="
echo "Configured entries : ${#REPOS[@]}"
echo "Git repositories   : $git_repos"
echo "Non-git directories: $non_git"
echo "Missing directories: $missing"

if [[ $missing -gt 0 ]]; then
  exit 2
fi

exit 0
