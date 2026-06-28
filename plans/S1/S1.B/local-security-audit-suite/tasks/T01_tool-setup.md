# T01 — Tool Installation + Verification Script

## End State

A script `scripts/security/check_tools.sh` verifies that all 5 audit tools are installed and reachable. Missing tools are installed automatically where possible, with clear instructions for anything requiring manual steps (e.g. gitleaks on Linux). The script exits 0 only when all tools are confirmed available.

## Acceptance Criteria

1. [V1] `./scripts/security/check_tools.sh` exits 0 on a machine with all tools present
2. [V1] Script exits 1 and prints which tool is missing if any tool is absent
3. [V1] `bandit --version`, `pip-audit --version`, `npm audit --version`, `gitleaks version`, `semgrep --version` all resolve correctly after running the script
4. [V1] Script is idempotent — running it twice does not error or duplicate installs
5. [V1] Script works from the parent repo root (where `finance_manager_api/` and `finance_manager_web/` are submodules)

## Scope Lock

### Files to create
- `scripts/security/check_tools.sh`

### Files NOT to touch
- Any existing script in `scripts/`
- Submodule contents

## Slices

### T01.SL1 — Tool installation logic

`scripts/security/check_tools.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

MISSING=()

check() {
  local name=$1 cmd=$2 install_hint=$3
  if command -v "$cmd" &>/dev/null; then
    echo "[OK] $name: $($cmd --version 2>&1 | head -1)"
  else
    echo "[MISSING] $name — $install_hint"
    MISSING+=("$name")
  fi
}
```

Tool checks and install hints:
- `bandit` — `pip install bandit` (or `uv pip install bandit` if uv is the venv manager in the API submodule)
- `pip-audit` — `pip install pip-audit`
- `npm` (for `npm audit`) — should already be present; hint to install Node if missing
- `gitleaks` — binary install: check GitHub releases or `brew install gitleaks` on Mac; on Linux, download the binary from `https://github.com/gitleaks/gitleaks/releases` (no API, no package manager required)
- `semgrep` — `pip install semgrep` (community edition, no login required)

At the end:
```bash
if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo ""
  echo "ERROR: ${#MISSING[@]} tool(s) missing. Install them and re-run."
  exit 1
fi
echo ""
echo "All tools present. Ready to run audit."
```

### T01.SL2 — Auto-install for pip tools

For `bandit`, `pip-audit`, `semgrep`: attempt auto-install into the API virtualenv if missing (the venv is at `finance_manager_api/.venv`). Use `finance_manager_api/.venv/bin/pip install <tool>` rather than system pip. If venv doesn't exist, print a clear message and exit.

gitleaks is a Go binary — do not attempt auto-install. Print the download URL and exit if missing.

### T01.SL3 — chmod and test

```bash
chmod +x scripts/security/check_tools.sh
./scripts/security/check_tools.sh
```

Confirm all 5 tools resolve. Document any that required manual install in a comment block at the top of `check_tools.sh`.

## Notes

- `npm audit` is built into npm — no separate install. The check is just `command -v npm`.
- `semgrep` community edition does not require a Semgrep account or login. `semgrep --version` works immediately after pip install.
- gitleaks binary should be placed in `/usr/local/bin/gitleaks` or anywhere on `$PATH`; the script checks `command -v gitleaks` only, not a specific path.
- Pin tool versions in a `scripts/security/TOOL_VERSIONS` file so audits are reproducible: `bandit==1.x.x`, `pip-audit==x.x.x`, `semgrep==x.x.x`, `gitleaks==vx.x.x`
