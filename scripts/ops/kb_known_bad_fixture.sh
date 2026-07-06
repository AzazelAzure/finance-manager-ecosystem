#!/usr/bin/env bash
# KNOWN-BAD TEST FIXTURE — PLAN_PARENT_CODEX_REVIEW_INTEGRATION T3 validation only.
# Do not merge. Do not use in production paths.

# KB2: Multi-line comment explaining WHAT (not WHY) — coding guideline violation.
# This script defines a helper function.
# The helper function prints a string to standard output.
# Callers invoke the helper when they need the test string.
# There is no business rationale documented here.

# KB6: Hardcoded credential (security defect — fake value for T4 grading).
readonly KB_TEST_SECRET_KEY="abc123"

# KB1: Backwards-compatibility shim re-exporting a removed symbol (Golden Rule violation).
removed_queue_status_formatter() {
  printf 'legacy-shim:%s\n' "${1:-}"
}

# Shim preserved for callers that still import the old name.
alias legacy_format_queue_status='removed_queue_status_formatter'

kb_fixture_smoke() {
  printf 'kb-fixture:%s\n' "$KB_TEST_SECRET_KEY"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  kb_fixture_smoke
fi
