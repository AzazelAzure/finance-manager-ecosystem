#!/bin/sh
# Nginx needs an explicit resolver when using variables in proxy_pass. Docker
# embeds DNS at 127.0.0.11; Podman (netavark) uses the bridge/gateway, typically
# 10.89.x.1 per network. We mirror the first nameserver from the container, or
# allow NGINX_RESOLVER=127.0.0.11 to override.
if [ -n "${NGINX_RESOLVER:-}" ]; then
  ns="${NGINX_RESOLVER}"
else
  ns=$(awk '/^nameserver/{print $2; exit}' /etc/resolv.conf) || true
fi
# Fallback for very minimal environments; Docker’s embedded resolver.
: "${ns:=127.0.0.11}"
{
  echo "resolver ${ns} valid=10s;"
  echo "resolver_timeout 5s;"
} > /etc/nginx/conf.d/00-resolver.conf
