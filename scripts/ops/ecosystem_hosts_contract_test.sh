#!/usr/bin/env bash
# Contract test for ecosystem-hosts Portfolio three-host edge (Slice 6-B).
# Static assertions only — no proxy reload, deploy, or live upstream required.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

CANONICAL="$REPO_ROOT/proxy/conf.d/ecosystem-hosts.conf"
TEMPLATE="$REPO_ROOT/proxy/conf.d/ecosystem-hosts.conf.template"
CERT_SCRIPT="$REPO_ROOT/proxy/certs/generate-ecosystem-certs.sh"
DOCS="$REPO_ROOT/proxy/ECOSYSTEM_HOSTS.md"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }
assert_contains() {
  local file="$1" needle="$2" label="$3"
  grep -Fq "$needle" "$file" || fail "$label: missing '$needle' in $file"
}
assert_not_contains() {
  local file="$1" needle="$2" label="$3"
  if grep -Fq "$needle" "$file"; then
    fail "$label: unexpected '$needle' in $file"
  fi
}

for f in "$CANONICAL" "$TEMPLATE" "$CERT_SCRIPT" "$DOCS"; do
  [[ -f "$f" ]] || fail "missing required file: $f"
done

# --- Orchestrator hosts preserved ---
for host in api.thedirectorate.app www.thedirectorate.app; do
  assert_contains "$CANONICAL" "server_name $host;" "canonical orchestrator $host"
  assert_contains "$TEMPLATE" "server_name $host;" "template orchestrator $host"
done
assert_contains "$CANONICAL" "map \$orch_active_color \$orch_api_loopback" "canonical orch api map"
assert_contains "$TEMPLATE" "map \$orch_active_color \$orch_api_upstream" "template orch api map"
assert_contains "$CANONICAL" "map \$orch_active_color \$orch_console_loopback" "canonical orch console map"
assert_contains "$TEMPLATE" "map \$orch_active_color \$orch_console_upstream" "template orch console map"

# --- Portfolio three-host contract ---
for host in pproctor.com preview.pproctor.com www.pproctor.com; do
  assert_contains "$CANONICAL" "server_name $host;" "canonical portfolio $host"
  assert_contains "$TEMPLATE" "server_name $host;" "template portfolio $host"
done

# Apex + preview proxy same upstream; www must not proxy application traffic.
assert_contains "$CANONICAL" "upstream external_adapter_upstream" "canonical upstream block"
assert_contains "$TEMPLATE" "upstream external_adapter_upstream" "template upstream block"
assert_contains "$CANONICAL" "server host.containers.internal:3000;" "canonical upstream target"
assert_contains "$TEMPLATE" "server host.containers.internal:3000;" "template upstream target"

extract_www_server() {
  awk '
    /server_name www\.pproctor\.com;/ { in_block=1 }
    in_block && /^[[:space:]]*server[[:space:]]*\{/ { depth++ }
    in_block { print }
    in_block && /\}/ { depth--; if (depth <= 0) { exit } }
  ' "$1"
}

canonical_www="$(extract_www_server "$CANONICAL")"
template_www="$(extract_www_server "$TEMPLATE")"

echo "$canonical_www" | grep -Fq 'return 301 https://pproctor.com$request_uri;' \
  || fail "canonical www.pproctor.com must permanently redirect to apex with path/query"
echo "$template_www" | grep -Fq 'return 301 https://pproctor.com$request_uri;' \
  || fail "template www.pproctor.com must permanently redirect to apex with path/query"
assert_not_contains <(printf '%s\n' "$canonical_www") "proxy_pass" "canonical www redirect"
assert_not_contains <(printf '%s\n' "$template_www") "proxy_pass" "template www redirect"

assert_contains "$CANONICAL" $'server_name www.pproctor.com;\n        return 301 https://pproctor.com$request_uri;' "canonical www :80 redirect"
assert_contains "$TEMPLATE" $'server_name www.pproctor.com;\n        return 301 https://pproctor.com$request_uri;' "template www :80 redirect"

# Apex and preview proxy blocks
assert_contains "$CANONICAL" $'server_name pproctor.com;\n\n        ssl_certificate' "canonical apex tls"
assert_contains "$TEMPLATE" $'server_name pproctor.com;\n\n        ssl_certificate' "template apex tls"
assert_contains "$CANONICAL" $'server_name preview.pproctor.com;\n\n        ssl_certificate' "canonical preview tls"
assert_contains "$TEMPLATE" $'server_name preview.pproctor.com;\n\n        ssl_certificate' "template preview tls"
assert_contains "$CANONICAL" 'proxy_pass http://external_adapter_upstream;' "canonical portfolio proxy"
assert_contains "$TEMPLATE" 'proxy_pass http://external_adapter_upstream;' "template portfolio proxy"

# Preview defensive noindex
assert_contains "$CANONICAL" 'add_header X-Robots-Tag "noindex, nofollow" always;' "canonical preview noindex"
assert_contains "$TEMPLATE" 'add_header X-Robots-Tag "noindex, nofollow" always;' "template preview noindex"

# HTTP redirect server names include portfolio apex + preview (not www — separate block)
assert_contains "$CANONICAL" "server_name api.thedirectorate.app www.thedirectorate.app pproctor.com preview.pproctor.com;" "canonical :80 hosts"
assert_contains "$TEMPLATE" "server_name api.thedirectorate.app www.thedirectorate.app pproctor.com preview.pproctor.com;" "template :80 hosts"

# --- Certificate SAN inputs ---
assert_contains "$CERT_SCRIPT" "gen_cert thedirectorate.app api.thedirectorate.app www.thedirectorate.app" "thedirectorate SANs preserved"
assert_contains "$CERT_SCRIPT" "gen_cert pproctor.com pproctor.com www.pproctor.com preview.pproctor.com" "pproctor SANs include apex/www/preview"

# Idempotent overwrite behavior (script regenerates in place)
grep -Eq 'openssl req -x509' "$CERT_SCRIPT" || fail "cert script must use openssl req -x509"
grep -Fq 'set -euo pipefail' "$CERT_SCRIPT" || fail "cert script must fail closed"

# --- Operator docs ---
assert_contains "$DOCS" "pproctor.com" "docs apex host"
assert_contains "$DOCS" "www.pproctor.com" "docs www host"
assert_contains "$DOCS" "preview.pproctor.com" "docs preview host"
assert_contains "$DOCS" "host.containers.internal:3000" "docs upstream"
assert_contains "$DOCS" "Cloudflare Access" "docs access precondition"
assert_contains "$DOCS" "noindex" "docs noindex"
assert_contains "$DOCS" "does **not** deploy" "docs no-deployment status"

# --- Render script still copies template unchanged ---
RENDER="$REPO_ROOT/scripts/ops/render_ecosystem_hosts.sh"
[[ -x "$RENDER" ]] || [[ -f "$RENDER" ]] || fail "missing render_ecosystem_hosts.sh"
tmp_out="$(mktemp)"
trap 'rm -f "$tmp_out"' EXIT
/bin/bash "$RENDER" "$tmp_out" >/dev/null
diff -q "$TEMPLATE" "$tmp_out" >/dev/null || fail "render_ecosystem_hosts.sh output must match template byte-for-byte"

pass "ecosystem hosts contract (Portfolio Slice 6-B)"
echo "All ecosystem hosts contract checks passed."
