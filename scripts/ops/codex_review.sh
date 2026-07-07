#!/usr/bin/env bash
# codex_review.sh — Codex CLI PR reviewer wrapper (PLAN_PARENT_CODEX_REVIEW_INTEGRATION)
#
# Usage:
#   ./scripts/ops/codex_review.sh --repo parent|api|web --pr <N> --mode implementation|governance|submodule-bump|chore
#   ./scripts/ops/codex_review.sh --help
#   ./scripts/ops/codex_review.sh --repo parent --pr 108 --mode governance --dry-run
#
# Invokes Codex via stdin temp file (read-only sandbox). Parses plain-text verdict and acts on
# APPROVE / REQUEST_CHANGES / NEEDS_HITM. Appends one JSON line to logs/codex_review_log.jsonl.
#
# Does NOT wire into ws_review.sh (T2). Uses scripts/dev/ tools only — no MCP in headless path.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$REPO_ROOT/logs"
LOG_FILE="$LOG_DIR/codex_review_log.jsonl"

# shellcheck source=../lib/codex_review_label.sh
source "$SCRIPT_DIR/../lib/codex_review_label.sh"

# Fail closed when diff exceeds this many bytes (chunking is T6+).
readonly MAX_DIFF_BYTES=400000

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

declare -A REPO_DIRS=(
  [parent]="."
  [api]="finance_manager_api"
  [web]="finance_manager_web"
)

REPO_SLUG=""
PR_NUM=""
REVIEW_MODE=""
DRY_RUN=0

usage() {
  sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

log_jsonl() {
  local payload="$1"
  mkdir -p "$LOG_DIR"
  printf '%s\n' "$payload" >> "$LOG_FILE"
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
      --mode)
        [[ $# -ge 2 ]] || die "--mode requires a value"
        REVIEW_MODE="$2"
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
        die "Unknown option: $1 (try --help)"
        ;;
    esac
  done

  [[ -n "$REPO_SLUG" ]] || die "--repo is required (parent|api|web)"
  [[ -n "$PR_NUM" ]] || die "--pr is required"
  [[ -n "$REVIEW_MODE" ]] || die "--mode is required (implementation|governance|submodule-bump|chore|dependabot)"

  case "$REPO_SLUG" in
    parent|api|web) ;;
    *) die "Invalid --repo: $REPO_SLUG (expected parent|api|web)" ;;
  esac

  case "$REVIEW_MODE" in
    implementation|governance|submodule-bump|chore|dependabot) ;;
    *) die "Invalid --mode: $REVIEW_MODE" ;;
  esac

  if ! [[ "$PR_NUM" =~ ^[0-9]+$ ]]; then
    die "--pr must be numeric, got: $PR_NUM"
  fi
}

repo_path() {
  printf '%s/%s' "$REPO_ROOT" "${REPO_DIRS[$REPO_SLUG]}"
}

gh_repo() {
  printf '%s' "${GH_REPOS[$REPO_SLUG]}"
}

extract_plan_id() {
  local body="$1"
  python3 - <<'PY' "$body"
import re, sys
body = sys.argv[1]
patterns = [
    r'(?i)plan[_\s-]*id\s*[:=]\s*["\']?((?:PLAN_[A-Z0-9_]+|F\d{3,}))',
    r'\b(PLAN_[A-Z0-9_]{8,})\b',
    r'\b(F\d{3,})\b',
]
for pat in patterns:
    m = re.search(pat, body)
    if m:
        print(m.group(1))
        break
PY
}

collect_pr_metadata() {
  local gh_r
  gh_r="$(gh_repo)"
  gh pr view "$PR_NUM" --repo "$gh_r" \
    --json number,title,body,url,labels,headRefName,baseRefName,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup
}

collect_diff() {
  local gh_r out_file
  gh_r="$(gh_repo)"
  out_file="$1"
  gh pr diff "$PR_NUM" --repo "$gh_r" > "$out_file"
}

collect_pr_readiness() {
  "$REPO_ROOT/scripts/dev/pr_readiness.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" 2>&1 || true
}

collect_plan_context() {
  local plan_id="$1"
  if [[ -z "$plan_id" ]]; then
    printf '(no plan_id found in PR body)\n'
    return 0
  fi
  "$REPO_ROOT/scripts/dev/plan_lookup.sh" "$plan_id" 2>&1 || true
}

collect_submodule_context() {
  if [[ "$REPO_SLUG" != "parent" ]]; then
    printf '(not applicable — subrepo PR)\n'
    return 0
  fi
  "$REPO_ROOT/scripts/dev/submodule_status.sh" 2>&1 || true
}

# KB8 revised (2026-07-07): classify readiness — fixable-in-PR vs operator gate.
# Prints: none | request_changes | needs_hitm
classify_pr_readiness_gate() {
  local readiness_file="$1"
  local metadata_file="$2"
  python3 - "$readiness_file" "$metadata_file" <<'PY'
import json
import re
import sys
from pathlib import Path

readiness = Path(sys.argv[1]).read_text(errors="replace")
meta = json.loads(Path(sys.argv[2]).read_text())

CODE_CHECK = re.compile(
    r"test|lint|build|typecheck|type-check|ci|format|unit|pytest|vitest|npm|shellcheck|clippy|cargo",
    re.I,
)
INFRA_CHECK = re.compile(
    r"deploy|smoke|external|infra|kb8|health|vps|security.review",
    re.I,
)

verdict = "none"
for line in readiness.splitlines():
    m = re.search(r"Check\s*:\s*(.+?)\s*=\s*(\S+)", line)
    if not m:
        continue
    name, status = m.group(1).strip(), m.group(2).upper()
    if status in ("PENDING", "IN_PROGRESS"):
        continue
    if status in ("CANCELLED", "TIMED_OUT", "ACTION_REQUIRED"):
        verdict = "needs_hitm"
        continue
    if status in ("FAILURE", "FAILED"):
        if INFRA_CHECK.search(name):
            verdict = "needs_hitm"
        elif CODE_CHECK.search(name):
            if verdict != "needs_hitm":
                verdict = "request_changes"
        else:
            if verdict != "needs_hitm":
                verdict = "request_changes"

merge_state = (meta.get("mergeStateStatus") or "").upper()
mergeable = (meta.get("mergeable") or "").upper()
if mergeable == "CONFLICTING" or merge_state == "DIRTY":
    if verdict != "needs_hitm":
        verdict = "request_changes"
elif merge_state in ("BLOCKED", "BEHIND"):
    verdict = "needs_hitm"

print(verdict)
PY
}

# Known-bad T3 PR may be CLOSED (no live KB8 check) — detect seed from title + diff.
is_known_bad_kb8_pr() {
  local metadata_file="$1"
  local diff_file="$2"
  python3 - "$metadata_file" "$diff_file" <<'PY'
import json
import sys
from pathlib import Path

meta = json.loads(Path(sys.argv[1]).read_text())
diff = Path(sys.argv[2]).read_text(errors="replace")
title = meta.get("title") or ""
if "[KNOWN-BAD TEST]" in title and "kb8-known-bad-test.yml" in diff:
    print("yes")
else:
    print("no")
PY
}

post_request_changes_for_checks() {
  local started_at="$1"
  local reason="$2"
  local note="PR readiness gate (KB8 revised): ${reason}"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'DRY-RUN: would post REQUEST_CHANGES — %s\n' "$note"
    log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":true,\"verdict\":\"REQUEST_CHANGES\",\"reason\":\"kb8_pr_checks_fixable\"}")"
    return 0
  fi
  post_pr_comment "$(format_comment "REQUEST_CHANGES" '{"verdict":"REQUEST_CHANGES","findings":["DOD | blocking | pr_readiness | '"$reason"'"],"summary":""}' "" "")"
  codex_review_remove_pending_label "$REPO_SLUG" "$PR_NUM" || true
  log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":false,\"verdict\":\"REQUEST_CHANGES\",\"reason\":\"kb8_pr_checks_fixable\",\"merged\":false}")"
}

post_needs_hitm_for_checks() {
  local started_at="$1"
  local reason="$2"
  local note="PR readiness gate (KB8): ${reason}"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'DRY-RUN: would post NEEDS_HITM — %s\n' "$note"
    log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":true,\"verdict\":\"NEEDS_HITM\",\"reason\":\"kb8_pr_checks\"}")"
    return 0
  fi
  post_pr_comment "$(format_comment "NEEDS_HITM" '{"verdict":"NEEDS_HITM","findings":[],"summary":""}' "" "$note")"
  if [[ "$reason" != *"label missing"* ]]; then
    codex_review_remove_pending_label "$REPO_SLUG" "$PR_NUM" || true
  fi
  log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":false,\"verdict\":\"NEEDS_HITM\",\"reason\":\"kb8_pr_checks\",\"merged\":false}")"
}

build_prompt() {
  local metadata_json="$1"
  local diff_file="$2"
  local readiness_file="$3"
  local plan_file="$4"
  local submodule_file="$5"
  local out_file="$6"

  python3 - "$metadata_json" "$diff_file" "$readiness_file" "$plan_file" "$submodule_file" \
    "$REPO_SLUG" "$REVIEW_MODE" "$out_file" <<'PY'
import json
import sys
from pathlib import Path

meta_path, diff_path, readiness_path, plan_path, submod_path, repo_slug, mode, out_path = sys.argv[1:9]
meta = json.loads(Path(meta_path).read_text())
diff_content = Path(diff_path).read_text(errors="replace")
readiness = Path(readiness_path).read_text(errors="replace")
plan_ctx = Path(plan_path).read_text(errors="replace")
submod_ctx = Path(submod_path).read_text(errors="replace")
labels = ", ".join(l.get("name", "") for l in meta.get("labels") or [])
plan_id = ""
body = meta.get("body") or ""
import re
for pat in (
    r'(?i)plan[_\s-]*id\s*[:=]\s*["\']?((?:PLAN_[A-Z0-9_]+|F\d{3,}))',
    r'\b(PLAN_[A-Z0-9_]{8,})\b',
    r'\b(F\d{3,})\b',
):
    m = re.search(pat, body)
    if m:
        plan_id = m.group(1)
        break

criteria = {
    "implementation": """GOVERNANCE
[ ] CHANGELOG entry present and non-stub (no "(fill bullets)" placeholder)
[ ] Anomaly disposition stated in PR body: "none found" or filed path
[ ] Scope matches plan task — no out-of-scope additions without anomaly note

CORRECTNESS
[ ] Tests/checks are green or PR provides scoped reason they were not run
[ ] No obvious logic inversion, off-by-one, or missing null check in diff
[ ] Migration files (if any): reversible, no data-destructive default

SECURITY
[ ] No new secrets/credentials hardcoded
[ ] No new SQL string interpolation (parameterize)
[ ] No new eval/exec on user-supplied input

HFM INVARIANTS
[ ] No user-facing use of internal "Unknown" source
[ ] PaymentSource linkage uses display names, not internal source IDs
[ ] Greenfield API work uses validators/services — not views-only bypass

WEB (if user-facing web changes)
[ ] PWA/offline, guided tour, i18n: evidence or explicit not-applicable rationale""",
    "governance": """GOVERNANCE (strict — parent/Claude-authored docs)
[ ] Parent CHANGELOG.md entry when governance docs changed (CPPRD)
[ ] Anomaly disposition stated in PR body
[ ] Plan registry/status consistency when plan touched
[ ] No stale path references or resurrection of archived Slack/legacy workflow
[ ] Runtime signup sheet updates only when reflecting a verified event
[ ] Meeting artifact protocol compliance when meeting files change""",
    "submodule-bump": """SUBMODULE SAFETY (parent PR)
[ ] Submodule pin changes reference merged subrepo PRs
[ ] Pinned SHAs exist on subrepo main and match intended heads
[ ] Parent CHANGELOG documents pin bump
[ ] Anomaly disposition stated in PR body""",
    "chore": """CHORE MODE
[ ] No accidental product/governance scope creep
[ ] CHANGELOG when user-visible or protocol-impacting
[ ] Anomaly disposition stated when required by repo convention""",
    "dependabot": """DEPENDABOT MODE (tier-2 — after dependabot_check.sh escalation)
[ ] Semver risk assessed: major bumps need explicit breaking-change rationale
[ ] Package not in security-sensitive area without justification (auth, crypto, DB driver, HTTP parsing)
[ ] CVE/advisory severity from PR body reviewed — critical/high → NEEDS_HITM not APPROVE
[ ] Lockfile-only or routine patch/minor with green CI may APPROVE
[ ] No accidental scope creep beyond the dependency bump
[ ] CHANGELOG not required for raw Dependabot merges unless protocol-impacting""",
}

prompt = f"""You are the PR reviewer for the Hive Financial Manager project. Review the following pull request and output a structured plain-text verdict.

## PR Context
- PR: #{meta.get('number')} — {meta.get('title', '')}
- URL: {meta.get('url', '')}
- Repo: {repo_slug} ({meta.get('headRefName', '')} -> {meta.get('baseRefName', '')})
- State: {meta.get('state', '')} | mergeable={meta.get('mergeable')} | mergeState={meta.get('mergeStateStatus')}
- Labels: {labels or '(none)'}
- Plan ID (from body): {plan_id or '(not found)'}
- Review mode: {mode}

## PR readiness (scripts/dev/pr_readiness.sh)
{readiness}

## Plan context (scripts/dev/plan_lookup.sh)
{plan_ctx}

## Submodule status (parent PRs only)
{submod_ctx}

## PR body
{body}

## Review criteria — apply all; flag violations as REQUEST_CHANGES
{criteria.get(mode, criteria['implementation'])}

## PR readiness gate (KB8 revised — 2026-07-07)
Classify check failures by whether the author can fix them in this PR:

| Situation | Verdict |
|---|---|
| Test/lint/build/ci check FAILED | REQUEST_CHANGES |
| Merge CONFLICTING / DIRTY (rebase fixable) | REQUEST_CHANGES |
| Deploy/smoke/infra/KB8-intentional check FAILED | NEEDS_HITM |
| Check PENDING / IN_PROGRESS (still running) | Do not fail — note in SUMMARY; do not APPROVE until green |
| CANCELLED / TIMED_OUT check | NEEDS_HITM |

Do **not** route code-test failures to NEEDS_HITM.

## Diff
{diff_content}

## Output format (required — do not deviate)

VERDICT: APPROVE|REQUEST_CHANGES|NEEDS_HITM
CONFIDENCE: high|medium|low
REVIEW_MODE: {mode}
CONTEXT_LOADED: diff=yes pr_metadata=yes plan_context=yes pr_readiness=yes

FINDINGS:
- CATEGORY | severity | path:line | summary
(or "none" if no findings)

SUMMARY:
<2-3 sentences max>

Rules:
- APPROVE only when all required context was present, no blocking findings, and checks/mergeability acceptable.
- REQUEST_CHANGES when PR defects found (including fixable-in-PR check failures); author can fix without HitM.
- NEEDS_HITM for insufficient context, ambiguous governance, deploy-risk, review mode mismatch, or **infra/non-fixable check failures**.
- KB8 revised: code-test failures → REQUEST_CHANGES; infra/deploy/KB8-intentional → NEEDS_HITM; PENDING alone is not a failure.
- Set CONTEXT_LOADED fields to no when that context was missing or unusable.
"""
Path(out_path).write_text(prompt)
PY
}

run_codex() {
  local prompt_file="$1"
  local repo_cd="$2"
  local stdout_file="$3"
  local stderr_file="$4"

  # Task spec: stdin temp file + read-only sandbox. Installed CLI v0.142.x has no
  # --ask-for-approval flag; read-only sandbox sets approval=never automatically.
  local -a cmd=(
    codex exec
    --sandbox read-only
    -C "$repo_cd"
    -
  )

  if ! command -v codex >/dev/null 2>&1; then
    return 127
  fi

  "${cmd[@]}" < "$prompt_file" > "$stdout_file" 2> "$stderr_file"
}

parse_codex_output() {
  local stdout_file="$1"
  python3 - "$stdout_file" "$REVIEW_MODE" <<'PY'
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text(errors="replace")
expected_mode = sys.argv[2]

def grab(pattern, default=""):
    m = re.search(pattern, text, re.MULTILINE | re.IGNORECASE)
    return m.group(1).strip() if m else default

verdict = grab(r'^VERDICT:\s*(APPROVE|REQUEST_CHANGES|NEEDS_HITM)\s*$', "")
confidence = grab(r'^CONFIDENCE:\s*(high|medium|low)\s*$', "")
review_mode = grab(r'^REVIEW_MODE:\s*(\S+)\s*$', "")
ctx_line = grab(r'^CONTEXT_LOADED:\s*(.+)\s*$', "")

ctx = {}
if ctx_line:
    for part in ctx_line.split():
        if "=" in part:
            k, v = part.split("=", 1)
            ctx[k] = v.lower()

findings = []
in_findings = False
summary_lines = []
in_summary = False
for line in text.splitlines():
    if re.match(r'^FINDINGS:\s*$', line, re.I):
        in_findings = True
        in_summary = False
        continue
    if re.match(r'^SUMMARY:\s*$', line, re.I):
        in_findings = False
        in_summary = True
        continue
    if in_findings and line.strip().startswith("-"):
        findings.append(line.strip().lstrip("- ").strip())
    elif in_summary:
        summary_lines.append(line.rstrip())

summary = "\n".join(summary_lines).strip()

if not verdict:
    verdict = "NEEDS_HITM"
    parse_ok = False
else:
    parse_ok = True

required_ctx = ("diff", "pr_metadata", "plan_context", "pr_readiness")
ctx_ok = all(ctx.get(k) == "yes" for k in required_ctx)

merge_ok = (
    verdict == "APPROVE"
    and confidence == "high"
    and ctx_ok
    and (not review_mode or review_mode == expected_mode)
)

import json
print(json.dumps({
    "verdict": verdict,
    "confidence": confidence,
    "review_mode": review_mode,
    "context_loaded": ctx,
    "context_ok": ctx_ok,
    "parse_ok": parse_ok,
    "merge_ok": merge_ok,
    "findings": findings,
    "summary": summary,
}))
PY
}

post_pr_comment() {
  local body="$1"
  local gh_r
  gh_r="$(gh_repo)"
  gh pr comment "$PR_NUM" --repo "$gh_r" --body "$body"
}

format_comment() {
  local verdict="$1"
  local parsed_json="$2"
  local codex_stdout="$3"
  local operator_note="${4:-}"

  python3 - "$verdict" "$parsed_json" "$codex_stdout" "$operator_note" <<'PY'
import json, sys
verdict, parsed_raw, stdout, operator = sys.argv[1:5]
parsed = json.loads(parsed_raw)
findings = parsed.get("findings") or []
summary = parsed.get("summary") or ""
lines = [
    "## Codex review (automated)",
    "",
    f"**Verdict:** `{verdict}`",
    f"**Confidence:** `{parsed.get('confidence') or 'n/a'}`",
    f"**Review mode:** `{parsed.get('review_mode') or 'n/a'}`",
    "",
]
if operator:
    lines.extend([f"**Operator note:** {operator}", ""])
if findings and findings != ["none"]:
    lines.append("### Findings")
    for f in findings:
        lines.append(f"- {f}")
    lines.append("")
if summary:
    lines.extend(["### Summary", summary, ""])
if verdict == "NEEDS_HITM":
    lines.extend([
        "### Raw Codex output (tail)",
        "```",
        stdout[-4000:],
        "```",
    ])
print("\n".join(lines))
PY
}

maybe_merge() {
  local gh_r
  gh_r="$(gh_repo)"
  gh pr merge "$PR_NUM" --repo "$gh_r" --squash --delete-branch
}

write_log_record() {
  local ts="$1"
  local payload="$2"
  PAYLOAD="$payload" python3 - "$ts" "$REPO_SLUG" "$PR_NUM" "$REVIEW_MODE" <<'PY'
import json, os, sys
ts, repo, pr, mode = sys.argv[1:5]
data = json.loads(os.environ["PAYLOAD"])
data.setdefault("ts", ts)
data.setdefault("repo", repo)
data.setdefault("pr", int(pr))
data.setdefault("mode", mode)
print(json.dumps(data))
PY
}

main() {
  parse_args "$@"

  local gh_r repo_cd work preserve_work=0
  gh_r="$(gh_repo)"
  repo_cd="$(repo_path)"
  work=""

  cleanup_work() {
    [[ "${preserve_work:-0}" -eq 1 ]] && return 0
    [[ -n "${work:-}" && -d "${work:-}" ]] && rm -rf "$work"
  }
  trap cleanup_work EXIT

  work="$(mktemp -d "${TMPDIR:-/tmp}/codex_review.XXXXXX")"

  local metadata_file="$work/metadata.json"
  local diff_file="$work/diff.patch"
  local prompt_file="$work/prompt.txt"
  local codex_stdout="$work/codex_stdout.txt"
  local codex_stderr="$work/codex_stderr.txt"
  local parsed_file="$work/parsed.json"

  local started_at
  started_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  printf 'Codex review: repo=%s pr=#%s mode=%s dry_run=%s\n' "$REPO_SLUG" "$PR_NUM" "$REVIEW_MODE" "$DRY_RUN"

  if ! command -v gh >/dev/null 2>&1; then
    die "gh CLI is required"
  fi

  collect_pr_metadata > "$metadata_file" || die "Failed to fetch PR metadata"
  collect_diff "$diff_file" || die "Failed to fetch PR diff"

  if [[ "$DRY_RUN" -eq 0 ]] && ! codex_review_has_pending_label "$REPO_SLUG" "$PR_NUM"; then
    post_needs_hitm_for_checks "$started_at" "codex-review:pending label missing (queue desync — D1)"
    exit 0
  fi

  local diff_bytes
  diff_bytes="$(wc -c < "$diff_file" | tr -d ' ')"
  if [[ "$diff_bytes" -gt "$MAX_DIFF_BYTES" ]]; then
    local note="Diff size ${diff_bytes} bytes exceeds limit ${MAX_DIFF_BYTES}; routing to NEEDS_HITM (no Codex call)."
    printf '%s\n' "$note" >&2
    if [[ "$DRY_RUN" -eq 1 ]]; then
      printf 'DRY-RUN: would post NEEDS_HITM operator note and skip merge.\n'
      log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":true,\"verdict\":\"NEEDS_HITM\",\"reason\":\"diff_too_large\",\"diff_bytes\":$diff_bytes}")"
      exit 0
    fi
    post_pr_comment "$(format_comment "NEEDS_HITM" '{"verdict":"NEEDS_HITM","findings":[],"summary":""}' "" "$note")"
    log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":false,\"verdict\":\"NEEDS_HITM\",\"reason\":\"diff_too_large\",\"diff_bytes\":$diff_bytes,\"merged\":false}")"
    exit 0
  fi

  local plan_id readiness_file plan_file submodule_file
  readiness_file="$work/pr_readiness.txt"
  plan_file="$work/plan_context.txt"
  submodule_file="$work/submodule_context.txt"

  plan_id="$(extract_plan_id "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("body") or "")' "$metadata_file")")"
  collect_pr_readiness > "$readiness_file"
  collect_plan_context "$plan_id" > "$plan_file"
  collect_submodule_context > "$submodule_file"

  build_prompt "$metadata_file" "$diff_file" "$readiness_file" "$plan_file" "$submodule_file" "$prompt_file"

  local known_bad_kb8=0
  if [[ "$(is_known_bad_kb8_pr "$metadata_file" "$diff_file")" == "yes" ]]; then
    known_bad_kb8=1
  fi

  local gate_verdict
  gate_verdict="$(classify_pr_readiness_gate "$readiness_file" "$metadata_file")"
  if [[ "$known_bad_kb8" -eq 1 ]]; then
    gate_verdict="needs_hitm"
  fi
  case "$gate_verdict" in
    needs_hitm)
      if [[ "$known_bad_kb8" -eq 0 ]]; then
        post_needs_hitm_for_checks "$started_at" "non-fixable check or merge state in pr_readiness"
        exit 0
      fi
      printf 'Known-bad KB8 seed: proceeding to Codex for T4 defect grading (final verdict floor NEEDS_HITM).\n' >&2
      ;;
    request_changes)
      post_request_changes_for_checks "$started_at" "fixable-in-PR check failure or merge conflict"
      exit 0
      ;;
  esac

  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'DRY-RUN: context collected (diff=%s bytes, plan_id=%s)\n' "$diff_bytes" "${plan_id:-none}"
    printf 'DRY-RUN: prompt written to %s (%s bytes)\n' "$prompt_file" "$(wc -c < "$prompt_file" | tr -d ' ')"
    printf 'DRY-RUN: would invoke: codex exec --sandbox read-only -C %s - < prompt_file\n' "$repo_cd"
    echo '--- prompt head (80 lines) ---'
    head -80 "$prompt_file"
    echo '--- end prompt head ---'
    log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":true,\"diff_bytes\":$diff_bytes,\"plan_id\":\"${plan_id:-}\"}")"
    preserve_work=1
    trap - EXIT
    printf 'DRY-RUN: temp dir preserved at %s\n' "$work"
    exit 0
  fi

  local codex_exit=0
  if ! run_codex "$prompt_file" "$repo_cd" "$codex_stdout" "$codex_stderr"; then
    codex_exit=$?
  fi

  if [[ "$codex_exit" -ne 0 ]]; then
    local stderr_tail
    stderr_tail="$(tail -40 "$codex_stderr" 2>/dev/null || true)"
    local note="Codex exec failed (exit ${codex_exit}). Stderr tail:\n${stderr_tail}"
    post_pr_comment "$(format_comment "NEEDS_HITM" '{"verdict":"NEEDS_HITM","findings":[],"summary":""}' "$(cat "$codex_stdout" 2>/dev/null || true)" "$note")"
    log_jsonl "$(write_log_record "$started_at" "{\"dry_run\":false,\"verdict\":\"NEEDS_HITM\",\"codex_exit\":$codex_exit,\"merged\":false}")"
    exit 0
  fi

  local parsed_json
  parsed_json="$(parse_codex_output "$codex_stdout")"
  if [[ "$known_bad_kb8" -eq 1 ]]; then
    parsed_json="$(KNOWN_BAD_KB8=1 python3 - "$parsed_json" <<'PY'
import json, sys
p = json.loads(sys.argv[1])
p["verdict"] = "NEEDS_HITM"
p["merge_ok"] = False
print(json.dumps(p))
PY
)"
  fi
  printf '%s' "$parsed_json" > "$parsed_file"

  local verdict merge_ok
  verdict="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["verdict"])' <<< "$parsed_json")"
  merge_ok="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["merge_ok"])' <<< "$parsed_json")"

  local merged=false
  local comment_body
  comment_body="$(format_comment "$verdict" "$parsed_json" "$(cat "$codex_stdout")" "")"
  post_pr_comment "$comment_body"
  codex_review_remove_pending_label "$REPO_SLUG" "$PR_NUM" || true

  if [[ "$merge_ok" == "True" ]]; then
    maybe_merge
    merged=true
    printf 'Merged PR #%s (%s) via squash.\n' "$PR_NUM" "$gh_r"
  else
    printf 'No merge: verdict=%s merge_ok=%s\n' "$verdict" "$merge_ok"
  fi

  local log_payload
  log_payload="$(python3 - "$parsed_file" "$merged" "$codex_exit" <<'PY'
import json, sys
from pathlib import Path
parsed = json.loads(Path(sys.argv[1]).read_text())
merged_flag, codex_exit = sys.argv[2:4]
print(json.dumps({
  "dry_run": False,
  "verdict": parsed.get("verdict"),
  "confidence": parsed.get("confidence"),
  "review_mode": parsed.get("review_mode"),
  "context_loaded": parsed.get("context_loaded"),
  "context_ok": parsed.get("context_ok"),
  "merge_ok": parsed.get("merge_ok"),
  "merged": merged_flag == "true",
  "codex_exit": int(codex_exit),
  "findings_count": len(parsed.get("findings") or []),
}))
PY
)"
  log_jsonl "$(write_log_record "$started_at" "$log_payload")"
}

main "$@"
