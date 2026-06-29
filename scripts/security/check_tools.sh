#!/usr/bin/env bash
# check_tools.sh — verify (and optionally install) prerequisites for scripts/security/run_audit.sh
#
# Run from parent repo root:
#   ./scripts/security/check_tools.sh
#
# Manual install notes (not auto-installed):
#   gitleaks — Go binary; on Linux download from:
#     https://github.com/gitleaks/gitleaks/releases
#     Place the binary on PATH (e.g. /usr/local/bin/gitleaks).
#   npm/node — required for npm audit on finance_manager_web; install Node 22+ if missing.
#
# Pip tools (bandit, pip-audit, semgrep) auto-install into finance_manager_api/.venv
# via `uv pip` when absent, using versions from scripts/security/TOOL_VERSIONS.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
API_DIR="$REPO_ROOT/finance_manager_api"
VENV_PYTHON="$API_DIR/.venv/bin/python"
TOOL_VERSIONS="$SCRIPT_DIR/TOOL_VERSIONS"

MISSING=()
AUTO_INSTALLED=()

read_pinned_version() {
  local package=$1
  if [[ ! -f "$TOOL_VERSIONS" ]]; then
    echo ""
    return
  fi
  grep -E "^${package}==" "$TOOL_VERSIONS" | head -1 | cut -d= -f3-
}

version_line() {
  local cmd=$1
  shift
  # tail -1: semgrep prints an upgrade notice before the version line
  "$cmd" "$@" 2>&1 | tail -1
}

ensure_api_venv() {
  if [[ ! -x "$VENV_PYTHON" ]]; then
    echo "[ERROR] API virtualenv not found at $API_DIR/.venv"
    echo "        Run: cd finance_manager_api && uv sync --frozen"
    exit 1
  fi
  if ! command -v uv &>/dev/null; then
    echo "[ERROR] uv is required to install Python audit tools into the API venv"
    exit 1
  fi
}

install_pip_tool() {
  local display_name=$1
  local package=$2

  ensure_api_venv
  local spec="$package"
  local pinned
  pinned="$(read_pinned_version "$package")"
  if [[ -n "$pinned" ]]; then
    spec="${package}==${pinned}"
  fi

  echo "[INSTALL] $display_name -> $spec (into finance_manager_api/.venv)"
  (cd "$API_DIR" && uv pip install --python .venv/bin/python -q "$spec")
  AUTO_INSTALLED+=("$display_name")
}

tool_bin() {
  echo "$API_DIR/.venv/bin/$1"
}

check_pip_tool() {
  local display_name=$1
  local package=$2
  local bin_name=$3
  local version_args=("${@:4}")

  ensure_api_venv
  local bin_path
  bin_path="$(tool_bin "$bin_name")"
  if [[ ! -x "$bin_path" ]]; then
    install_pip_tool "$display_name" "$package"
  fi

  if [[ -x "$bin_path" ]] && "$bin_path" "${version_args[@]}" &>/dev/null; then
    echo "[OK] $display_name: $(version_line "$bin_path" "${version_args[@]}")"
    return 0
  fi

  # Binary missing or broken — try install once more
  install_pip_tool "$display_name" "$package"
  if [[ -x "$bin_path" ]] && "$bin_path" "${version_args[@]}" &>/dev/null; then
    echo "[OK] $display_name: $(version_line "$bin_path" "${version_args[@]}")"
    return 0
  fi

  echo "[MISSING] $display_name — failed to install $package into API venv"
  MISSING+=("$display_name")
  return 1
}

echo "Security audit tool check"
echo "Repo root: $REPO_ROOT"
echo ""

# bandit, pip-audit, semgrep — API venv pip tools
check_pip_tool "bandit" "bandit" "bandit" --version || true
check_pip_tool "pip-audit" "pip-audit" "pip-audit" --version || true
check_pip_tool "semgrep" "semgrep" "semgrep" --version || true

# npm (npm audit is built-in)
if command -v npm &>/dev/null; then
  echo "[OK] npm: $(version_line npm --version) (npm audit available)"
else
  echo "[MISSING] npm — install Node.js (https://nodejs.org/) for Web dependency audits"
  MISSING+=("npm")
fi

# gitleaks — binary only, no auto-install
if command -v gitleaks &>/dev/null; then
  echo "[OK] gitleaks: $(version_line gitleaks version)"
else
  pinned="$(read_pinned_version gitleaks)"
  hint="download gitleaks"
  if [[ -n "$pinned" ]]; then
    hint="${hint} v${pinned} from https://github.com/gitleaks/gitleaks/releases and place on PATH"
  else
    hint="${hint} from https://github.com/gitleaks/gitleaks/releases and place on PATH"
  fi
  echo "[MISSING] gitleaks — $hint"
  MISSING+=("gitleaks")
fi

echo ""
if [[ ${#AUTO_INSTALLED[@]} -gt 0 ]]; then
  echo "Auto-installed: ${AUTO_INSTALLED[*]}"
  echo ""
fi

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "ERROR: ${#MISSING[@]} tool(s) missing: ${MISSING[*]}"
  echo "Install them and re-run ./scripts/security/check_tools.sh"
  exit 1
fi

echo "All tools present. Ready to run audit."
