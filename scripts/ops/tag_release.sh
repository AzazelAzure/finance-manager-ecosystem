#!/usr/bin/env bash
set -u

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "Usage: ./scripts/tag_release.sh <tag_name>"
  exit 1
fi

tag_name="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/lib_repos.sh
source "$SCRIPT_DIR/../lib/lib_repos.sh"

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

  if git -C "$repo_path" rev-parse "$tag_name" >/dev/null 2>&1; then
    echo "[WARN] Tag already exists in $repo: $tag_name"
  else
    echo "Creating tag: $tag_name"
    git -C "$repo_path" tag "$tag_name"
  fi
  echo

done
