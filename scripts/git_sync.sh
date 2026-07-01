#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib/lib_repos.sh
source "$SCRIPT_DIR/lib/lib_repos.sh"

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
    echo "[WARN] Detached HEAD in $repo; skipping pull"
    echo
    continue
  fi

  echo "Fetching origin..."
  git -C "$repo_path" fetch origin

  echo "Pulling origin/$branch..."
  git -C "$repo_path" pull origin "$branch"
  echo

done
