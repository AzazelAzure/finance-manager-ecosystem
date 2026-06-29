#!/usr/bin/env bash
# lib_anomaly_write.sh — write MEDIUM/HIGH security findings to strategy/anomalies/

ANOMALY_WRITTEN=0

make_anomaly_slug() {
  local raw="$1"
  echo "$raw" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-\+//;s/-\+$//' | cut -c1-40
}

find_existing_security_anomaly() {
  local tool="$1"
  local short_slug="$2"
  local repo_root="$3"
  local match
  shopt -s nullglob
  local candidates=("$repo_root/strategy/anomalies/"*_security-audit_"${tool}"_"${short_slug}".md)
  shopt -u nullglob
  if [[ ${#candidates[@]} -gt 0 ]]; then
    echo "${candidates[0]}"
  fi
}

# write_security_anomaly <tool> <severity> <short_slug> <finding_text> <repo_root>
# Writes to strategy/anomalies/ if severity is MEDIUM or HIGH.
# Skips LOW and INFO.
write_security_anomaly() {
  local tool="$1"
  local severity="$2"
  local short_slug="$3"
  local finding_text="$4"
  local repo_root="$5"

  case "${severity,,}" in
    high|medium) ;;
    *) return 0 ;;
  esac

  local date_str
  date_str=$(date +%Y-%m-%d)
  local filename="${date_str}_security-audit_${tool}_${short_slug}.md"
  local filepath="$repo_root/strategy/anomalies/$filename"

  local existing
  existing="$(find_existing_security_anomaly "$tool" "$short_slug" "$repo_root")"
  if [[ -n "$existing" ]]; then
    sed -i "s/^logged: .*/logged: $date_str/" "$existing"
    echo "[anomaly] Updated existing: $(basename "$existing")"
    return 0
  fi

  mkdir -p "$repo_root/strategy/anomalies"

  _ANOMALY_TOOL="$tool" _ANOMALY_SEVERITY="${severity,,}" _ANOMALY_FINDING="$finding_text" \
    python3 - "$filepath" "$date_str" <<'PY'
import os
import sys
from pathlib import Path

filepath, date_str = sys.argv[1], sys.argv[2]
tool = os.environ["_ANOMALY_TOOL"]
severity = os.environ["_ANOMALY_SEVERITY"]
finding_text = os.environ["_ANOMALY_FINDING"]
content = f"""---
logged: {date_str}
agent: run_audit.sh
plan_context: PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29
status: unreviewed
severity_guess: {severity}
---

## What was found

```
{finding_text}
```

## Where

Detected by `{tool}` during automated security audit. See full report:
`strategy/security/audit_{date_str}.md`

## What agent was doing

Running weekly automated security audit via `scripts/security/run_audit.sh`.

## Why outside scope

Security audit is read-only. Remediation belongs to Cursor or HitM.

## Possible owner

Cursor — review finding and determine if fix is needed.

## Notes

Severity reported by {tool}: {severity.upper()}. Verify before acting — static analysis can produce false positives.
"""
Path(filepath).write_text(content)
PY

  ANOMALY_WRITTEN=$((ANOMALY_WRITTEN + 1))
  echo "[anomaly] Filed: $filename"
}

parse_bandit_anomalies() {
  local bandit_out="$1"
  [[ -z "$bandit_out" ]] && return 0
  export _AUDIT_PARSE_INPUT="$bandit_out"
  while IFS=$'\t' read -r severity slug finding_b64; do
    [[ -z "$severity" ]] && continue
    finding=$(printf '%s' "$finding_b64" | base64 -d 2>/dev/null || true)
    write_security_anomaly "bandit" "$severity" "$slug" "$finding" "$REPO_ROOT"
  done < <(python3 <<'PY'
import os, re, base64
text = os.environ.get("_AUDIT_PARSE_INPUT", "")
blocks = re.split(r"(?=>> Issue:)", text)
for block in blocks:
    if not block.strip():
        continue
    if "Severity: High" in block:
        sev = "high"
    elif "Severity: Medium" in block:
        sev = "medium"
    else:
        continue
    loc = re.search(r"Location:\s+(\S+)", block)
    title = re.search(r">> Issue:\s*(.+)", block)
    loc_s = loc.group(1) if loc else "unknown"
    title_s = title.group(1).strip() if title else "bandit-finding"
    slug = re.sub(r"[^a-z0-9]+", "-", f"{loc_s}-{title_s}".lower()).strip("-")[:40]
    finding = base64.b64encode(block.strip().encode()).decode()
    print(f"{sev}\t{slug}\t{finding}")
PY
  )
}

parse_pipaudit_anomalies() {
  local json_in="$1"
  [[ -z "$json_in" ]] && return 0
  export _AUDIT_PARSE_INPUT="$json_in"
  while IFS=$'\t' read -r severity slug finding; do
    [[ -z "$severity" ]] && continue
    write_security_anomaly "pip-audit" "$severity" "$slug" "$finding" "$REPO_ROOT"
  done < <(python3 <<'PY'
import json, os, re
try:
    data = json.loads(os.environ.get("_AUDIT_PARSE_INPUT", ""))
except json.JSONDecodeError:
    raise SystemExit(0)
for dep in data.get("dependencies", []):
    name = dep.get("name", "unknown")
    version = dep.get("version", "")
    for vuln in dep.get("vulns", []):
        vid = vuln.get("id", "cve")
        aliases = vuln.get("aliases", [])
        desc = vuln.get("description", "")[:200]
        sev = "high" if any("CVE" in str(a) for a in aliases) else "medium"
        slug = re.sub(r"[^a-z0-9]+", "-", f"{name}-{vid}".lower()).strip("-")[:40]
        finding = f"{name}=={version}: {vid} {aliases} — {desc}"
        print(f"{sev}\t{slug}\t{finding}")
PY
  )
}

parse_npm_anomalies() {
  local json_in="$1"
  [[ -z "$json_in" ]] && return 0
  export _AUDIT_PARSE_INPUT="$json_in"
  while IFS=$'\t' read -r severity slug finding; do
    [[ -z "$severity" ]] && continue
    write_security_anomaly "npm-audit" "$severity" "$slug" "$finding" "$REPO_ROOT"
  done < <(python3 <<'PY'
import json, os, re
try:
    data = json.loads(os.environ.get("_AUDIT_PARSE_INPUT", ""))
except json.JSONDecodeError:
    raise SystemExit(0)
vulns = data.get("vulnerabilities", {})
if not vulns and "advisories" in data:
    vulns = {str(k): {"name": v.get("module_name"), "severity": v.get("severity"), "title": v.get("title"), "url": v.get("url")} for k,v in data["advisories"].items()}
for key, v in vulns.items():
    sev_raw = (v.get("severity") or "").lower()
    if sev_raw in ("high", "critical"):
        sev = "high"
    elif sev_raw in ("moderate", "medium"):
        sev = "medium"
    else:
        continue
    name = v.get("name") or key
    title = v.get("title", "")
    slug = re.sub(r"[^a-z0-9]+", "-", f"{name}-{key}".lower()).strip("-")[:40]
    finding = f"{name}: {title} ({sev_raw})"
    print(f"{sev}\t{slug}\t{finding}")
PY
  )
}

parse_gitleaks_sarif_anomalies() {
  local sarif_path="$1"
  local repo_name="$2"
  [[ ! -f "$sarif_path" ]] && return 0
  while IFS=$'\t' read -r severity slug finding; do
    [[ -z "$severity" ]] && continue
    write_security_anomaly "gitleaks" "$severity" "$slug" "$finding" "$REPO_ROOT"
  done < <(python3 - "$sarif_path" "$repo_name" <<'PY'
import json, re, sys
path, repo_name = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
for r in data.get("runs", [{}])[0].get("results", []):
    loc = r.get("locations", [{}])[0].get("physicalLocation", {}).get("artifactLocation", {}).get("uri", "unknown")
    msg = r.get("message", {}).get("text", "secret detected")
    rule = r.get("ruleId", "gitleaks")
    slug = re.sub(r"[^a-z0-9]+", "-", f"{repo_name}-{loc}-{rule}".lower()).strip("-")[:40]
    finding = f"[{repo_name}] {loc}: {msg} (rule: {rule})"
    print(f"high\t{slug}\t{finding}")
PY
  )
}

parse_semgrep_anomalies() {
  local json_in="$1"
  [[ -z "$json_in" ]] && return 0
  export _AUDIT_PARSE_INPUT="$json_in"
  while IFS=$'\t' read -r severity slug finding; do
    [[ -z "$severity" ]] && continue
    write_security_anomaly "semgrep" "$severity" "$slug" "$finding" "$REPO_ROOT"
  done < <(python3 <<'PY'
import json, os, re
try:
    data = json.loads(os.environ.get("_AUDIT_PARSE_INPUT", ""))
except json.JSONDecodeError:
    raise SystemExit(0)
for r in data.get("results", []):
    sev_raw = (r.get("extra", {}).get("severity") or r.get("check_id", "")).upper()
    if sev_raw == "ERROR":
        sev = "high"
    elif sev_raw == "WARNING":
        sev = "medium"
    else:
        extra = r.get("extra", {})
        meta = extra.get("metadata", {})
        impact = (meta.get("impact") or "").upper()
        if impact in ("HIGH", "CRITICAL"):
            sev = "high"
        elif impact in ("MEDIUM", "MODERATE"):
            sev = "medium"
        else:
            continue
    path = r.get("path", "unknown")
    line = r.get("start", {}).get("line", 0)
    check = r.get("check_id", "semgrep")
    msg = r.get("extra", {}).get("message", "")
    slug = re.sub(r"[^a-z0-9]+", "-", f"{path}-{line}-{check}".lower()).strip("-")[:40]
    finding = f"{path}:{line} [{check}] {msg}"
    print(f"{sev}\t{slug}\t{finding}")
PY
  )
}
