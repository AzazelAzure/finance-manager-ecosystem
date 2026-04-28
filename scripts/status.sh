#!/usr/bin/env bash
set -u

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

  branch="$(git -C "$repo_path" branch --show-current 2>/dev/null || true)"
  if [[ -z "$branch" ]]; then
    branch="(detached HEAD)"
  fi

  echo "Branch: $branch"
  echo "Status:"
  status_out="$(git -C "$repo_path" status -s 2>&1 || true)"
  if [[ -z "$status_out" ]]; then
    echo "  clean"
  else
    echo "$status_out"
  fi
  echo

done
