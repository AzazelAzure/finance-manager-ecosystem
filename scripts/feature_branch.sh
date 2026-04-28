#!/usr/bin/env bash
set -u

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "Usage: ./scripts/feature_branch.sh <branch_name>"
  exit 1
fi

branch_name="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib_repos.sh
source "$SCRIPT_DIR/lib_repos.sh"

if ! read_repos; then
  exit 1
fi

for repo in "${REPOS[@]}"; do
  echo "=================================================="
  echo "Repo: ${repo}"
  echo "=================================================="

  repo_path="$WORKSPACE_ROOT/$repo"

  if [[ ! -d "$repo_path" ]]; then
    echo "[WARN] Directory not found: $repo_path"
    echo
    continue
  fi

  if ! git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "[WARN] Not a git repository: $repo_path"
    echo
    continue
  fi

  if git -C "$repo_path" show-ref --verify --quiet "refs/heads/$branch_name"; then
    echo "Branch exists; checking out: $branch_name"
    git -C "$repo_path" checkout "$branch_name"
  else
    echo "Creating and checking out branch: $branch_name"
    git -C "$repo_path" checkout -b "$branch_name"
  fi
  echo

done
