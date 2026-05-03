# T02 Installation Package Layout

## Objective
Create a reproducible server install package that can bootstrap the Finance Manager stack from a clean Linux host with minimal manual steps.

## Scope Boundary
- Primary repo: parent `finance-manager-ecosystem`
- Candidate paths:
  - `scripts/server/`
  - `deploy/`
  - `.env.example` / server env templates
  - deployment README/runbook
- Do not commit real secrets, server IPs, private keys, or production certificates.

## Requested Deliverables
- Scripted install entrypoint, for example:
  - `scripts/server/install_prereqs.sh`
  - `scripts/server/bootstrap_env.sh`
  - `scripts/server/render_env_template.sh`
  - `scripts/server/verify_install.sh`
- A server `.env.example` covering:
  - Django `SECRET_KEY`
  - database credentials
  - allowed hosts / CSRF origins
  - Reflex/API URLs
  - Redis URL if used
  - blue/green active color
  - image/tag/version inputs
- A runbook explaining:
  - required OS packages
  - Podman/Docker compatibility
  - how to run first install
  - how to verify health
  - how to avoid committing secrets

## Acceptance Criteria
- Scripts are idempotent or fail safely with clear messages.
- Scripts support dry-run or verification mode where practical.
- Scripts detect missing dependencies before modifying runtime.
- `.env.example` is complete enough for server migration.
- No script assumes `/home/pproctor/...`; paths are parameterized.

## Verification
```bash
bash -n scripts/server/*.sh
shellcheck scripts/server/*.sh || true
```

If shellcheck is unavailable, record that and perform manual review.

## Required Handoff
- Files created.
- Required manual server inputs.
- Verification output.
- Remaining blockers.
