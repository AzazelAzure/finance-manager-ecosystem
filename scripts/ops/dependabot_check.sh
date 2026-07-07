#!/usr/bin/env bash
# dependabot_check.sh — Tier-1 lightweight Dependabot PR triage (T5-DEPENDABOT)
#
# Usage:
#   ./scripts/ops/dependabot_check.sh --repo api|web --pr <N>
#   ./scripts/ops/dependabot_check.sh --repo api --pr 87 --dry-run
#
# Exit codes: 0 = APPROVE, 1 = ESCALATE_CODEX, 2 = NEEDS_HITM
# Prints: VERDICT: APPROVE|ESCALATE_CODEX|NEEDS_HITM
#         REASON: <one line>
#
# Tier 2 escalation: codex_review.sh --mode dependabot
# Tier 3: NEEDS_HITM when critical/high CVE advisory detected in PR body.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

declare -A GH_REPOS=(
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

REPO_SLUG=""
PR_NUM=""
DRY_RUN=0

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 3
}

parse_args() {
  if [[ $# -eq 0 ]]; then
    usage
    exit 0
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo)
        [[ $# -ge 2 ]] || die "--repo requires a value"
        REPO_SLUG="$2"
        shift 2
        ;;
      --pr)
        [[ $# -ge 2 ]] || die "--pr requires a value"
        PR_NUM="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done

  [[ -n "$REPO_SLUG" ]] || die "--repo is required (api|web)"
  [[ -n "$PR_NUM" ]] || die "--pr is required"
  [[ -n "${GH_REPOS[$REPO_SLUG]:-}" ]] || die "Invalid --repo: $REPO_SLUG (use api|web)"
}

emit_verdict() {
  local verdict="$1"
  local reason="$2"
  local code=0
  case "$verdict" in
    APPROVE) code=0 ;;
    ESCALATE_CODEX) code=1 ;;
    NEEDS_HITM) code=2 ;;
    *) die "internal: unknown verdict $verdict" ;;
  esac

  printf 'VERDICT: %s\n' "$verdict"
  printf 'REASON: %s\n' "$reason"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'DRY-RUN: no PR action taken\n'
  fi
  exit "$code"
}

classify_dependabot_pr() {
  local gh_repo="$1"
  local pr_num="$2"
  python3 - "$gh_repo" "$pr_num" <<'PY'
import json
import re
import subprocess
import sys

gh_repo, pr_num = sys.argv[1], sys.argv[2]

raw = subprocess.check_output(
    [
        "gh", "pr", "view", pr_num,
        "--repo", gh_repo,
        "--json", "title,body,headRefName,author",
    ],
    text=True,
)
meta = json.loads(raw)

head = meta.get("headRefName") or ""
if not head.startswith("dependabot/"):
    print(json.dumps({"verdict": "ESCALATE_CODEX", "reason": "not a dependabot head branch — use standard review"}))
    raise SystemExit(0)

title = meta.get("title") or ""
body = meta.get("body") or ""
combined = f"{title}\n{body}".lower()

# Critical/high security advisory in Dependabot security PR body.
if re.search(r"\b(critical|high)\s+severity\b", combined, re.I):
    print(json.dumps({"verdict": "NEEDS_HITM", "reason": "critical/high severity advisory in PR body"}))
    raise SystemExit(0)
if re.search(r"GHSA-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}", body, re.I) and re.search(
    r"severity:\s*(critical|high)\b", combined, re.I
):
    print(json.dumps({"verdict": "NEEDS_HITM", "reason": "GHSA advisory with critical/high severity"}))
    raise SystemExit(0)

SECURITY_PKG = re.compile(
    r"(auth|oauth|jwt|allauth|crypto|cryptography|bcrypt|passlib|secret|"
    r"psycopg|postgres|sqlalchemy|mysqlclient|redis|"
    r"httpx|requests|urllib3|idna|aiohttp|werkzeug|django\b)",
    re.I,
)

# Package name from dependabot branch: dependabot/uv/psycopg-3.3.4
pkg = ""
branch_tail = head.split("/", 2)[-1] if "/" in head else head
pkg_match = re.match(r"([a-z0-9_.-]+?)(?:-\d|$)", branch_tail, re.I)
if pkg_match:
    pkg = pkg_match.group(1).replace("_", "-")

# Title fallback: "bump setuptools from ..."
title_pkg = re.search(r"bump\s+([^\s]+)\s+from\s+", title, re.I)
if title_pkg:
    pkg = title_pkg.group(1)

major_bump = False
ver_match = re.search(
    r"from\s+([0-9][0-9A-Za-z._-]*)\s+to\s+([0-9][0-9A-Za-z._-]*)",
    title,
    re.I,
)
if ver_match:
    old_v, new_v = ver_match.group(1), ver_match.group(2)

    def major_part(v: str) -> str:
        return re.split(r"[.\-]", v, maxsplit=1)[0]

    if major_part(old_v) != major_part(new_v):
        major_bump = True

if major_bump:
    print(json.dumps({
        "verdict": "ESCALATE_CODEX",
        "reason": f"major version bump for {pkg or 'dependency'} ({ver_match.group(1)} → {ver_match.group(2)})",
    }))
    raise SystemExit(0)

if pkg and SECURITY_PKG.search(pkg):
    print(json.dumps({
        "verdict": "ESCALATE_CODEX",
        "reason": f"security-sensitive package: {pkg}",
    }))
    raise SystemExit(0)

print(json.dumps({
    "verdict": "APPROVE",
    "reason": f"routine patch/minor bump for {pkg or 'dependency'} — no security flags",
}))
PY
}

main() {
  parse_args "$@"

  if ! command -v gh >/dev/null 2>&1; then
    die "gh CLI is required"
  fi

  local gh_repo result verdict reason
  gh_repo="${GH_REPOS[$REPO_SLUG]}"
  result="$(classify_dependabot_pr "$gh_repo" "$PR_NUM")"
  verdict="$(python3 -c 'import json,sys; print(json.loads(sys.argv[1])["verdict"])' "$result")"
  reason="$(python3 -c 'import json,sys; print(json.loads(sys.argv[1])["reason"])' "$result")"

  emit_verdict "$verdict" "$reason"
}

main "$@"
