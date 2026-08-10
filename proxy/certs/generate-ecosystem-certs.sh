#!/usr/bin/env bash
# Generate self-signed origin certs for ecosystem hostnames (smoke / staging).
# Replace with Cloudflare origin certs before production Zero Trust cutover.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gen_cert() {
  local name="$1"
  shift
  local sans=("$@")
  local cfg
  cfg="$(mktemp)"
  cat >"$cfg" <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = ${name}

[v3_req]
subjectAltName = @alt_names

[alt_names]
EOF
  local i=1
  for san in "${sans[@]}"; do
    echo "DNS.${i} = ${san}" >>"$cfg"
    i=$((i + 1))
  done
  openssl req -x509 -nodes -days 825 -newkey rsa:2048 \
    -keyout "${DIR}/${name}-key.pem" \
    -out "${DIR}/${name}.pem" \
    -config "$cfg" -extensions v3_req
  rm -f "$cfg"
  chmod 600 "${DIR}/${name}-key.pem"
  echo "wrote ${DIR}/${name}.pem"
}

gen_cert thedirectorate.app api.thedirectorate.app www.thedirectorate.app
gen_cert pproctor.com pproctor.com www.pproctor.com preview.pproctor.com

echo "Done. Mount proxy/certs into the proxy container and reload nginx."
