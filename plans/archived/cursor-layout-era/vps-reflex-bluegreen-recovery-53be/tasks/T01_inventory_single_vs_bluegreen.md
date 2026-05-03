# T01 — Inventory: single-stack vs blue-green on VPS

**Status (2026-04-29):** **Done** — results in [`T01_inventory_results.md`](./T01_inventory_results.md). Current execution pointer: [`../PASSDOWN.md`](../PASSDOWN.md).

## Objective

Produce a factual map of what is running **now** on the VPS (not what docs say should run).

## Steps

1. SSH to VPS; `cd` to finance_manager checkout (e.g. `/home/dev/finance_manager`).
2. Run `./scripts/fm_docker.sh status` and capture output.
3. If `docker-compose.bluegreen.yml` / `fm_server_beta` is in use, run `./scripts/fm_server_beta.sh status` and capture.
4. Record Cloudflare tunnel public hostname → local `https://127.0.0.1:PORT` mapping (from `cloudflared` config or operator doc).
5. `curl -kI` with `Host: thehivemanager.com` and `Host: reflex-api.thehivemanager.com` against local proxy port (8443 typical).

## Handoff output

- Stack type: single | blue-green
- Container names + health
- Tunnel → proxy port
- Domains tested + HTTP codes
- Drift vs `known_good_beta_state_apr28.md`

## Sibling check

Skim [../../finance-manager-web-beta-rollout-53be/validation_gates.md](../../finance-manager-web-beta-rollout-53be/validation_gates.md) for proxy/DNS blockers.
