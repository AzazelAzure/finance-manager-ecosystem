#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_FILE="$SCRIPT_DIR/../repos.txt"

read_repos() {
  if [[ ! -f "$REPO_FILE" ]]; then
    echo "[ERROR] Missing repo list: $REPO_FILE" >&2
    return 1
  fi

  local line
  local cleaned
  REPOS=()

  while IFS= read -r line; do
    cleaned="${line%%#*}"
    cleaned="${cleaned%${cleaned##*[![:space:]]}}"
    cleaned="${cleaned#${cleaned%%[![:space:]]*}}"
    [[ -z "$cleaned" ]] && continue
    REPOS+=("$cleaned")
  done < "$REPO_FILE"

  if [[ ${#REPOS[@]} -eq 0 ]]; then
    echo "[ERROR] No repositories configured in $REPO_FILE" >&2
    return 1
  fi

  return 0
}
