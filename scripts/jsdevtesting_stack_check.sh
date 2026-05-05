#!/usr/bin/env bash
# jsdevtesting_stack_check.sh — quick HTTPS probes for staging web + staging API hostnames.
# Guardrail only; does not SSH. Use after deploy or from CI with network access.
#
# Environment (optional overrides):
#   FM_JS_WEB_URL    default https://jsdevtesting.thehivemanager.com:8443/
#   FM_JS_API_URL    default https://api-jsdevtesting.thehivemanager.com/api/health/
#
# Exit 0 if both curls succeed (HTTP 2xx). -k skips TLS verify for broken-lab certs only;
# production should validate certs; override URLs if you use valid public TLS.
#
set -euo pipefail

FM_JS_WEB_URL="${FM_JS_WEB_URL:-https://jsdevtesting.thehivemanager.com:8443/}"
FM_JS_API_URL="${FM_JS_API_URL:-https://api-jsdevtesting.thehivemanager.com/api/health/}"

code() {
  curl -sS -o /dev/null -w '%{http_code}' -k --max-time 25 "$1"
}

log() { printf '%s\n' "$*"; }

w="$(code "$FM_JS_WEB_URL")"
a="$(code "$FM_JS_API_URL")"

log "WEB  $FM_JS_WEB_URL -> HTTP $w"
log "API  $FM_JS_API_URL -> HTTP $a"

[[ "$w" =~ ^2 ]] || { log "ERROR: web probe not 2xx"; exit 1; }
[[ "$a" =~ ^2 ]] || { log "ERROR: api probe not 2xx"; exit 1; }
log "jsdevtesting stack check: OK"
