# Deployment Script Audit — Phase 2a

*Date: 2026-05-04 — Emergency Orchestration Huddle action item #3.*

## Current VPS Container State

```
Project: fm-beta
Active color: green
Inactive color: blue

CONTAINER                       STATUS              PORTS
finance-manager-db              Created             0.0.0.0:5432->5432/tcp    ← ORPHAN (old project)
finance-manager-proxy           Created             0.0.0.0:8080->80/tcp, 0.0.0.0:8443->443/tcp  ← ORPHAN
fm-beta_db_1                    Up 27 hours         0.0.0.0:5432->5432/tcp    ← ACTIVE
fm-beta_redis_1                 Up 23 hours
fm-beta_web-green_1             Up 20 hours         ← ACTIVE PRODUCTION
fm-beta_api-green_1             Up 20 hours         ← ACTIVE PRODUCTION
finance_manager_db_1            Created             0.0.0.0:5432->5432/tcp    ← ORPHAN (legacy project)
finance_manager_redis_1         Up 8 hours          ← ORPHAN (legacy project)
finance_manager_web-blue_1      Up 8 hours          ← ORPHAN from wrong project name
finance_manager_api-blue_1      Created             ← ORPHAN from wrong project name
fm-beta_web-blue_1              Up 4 hours          ← CORRECT inactive
fm-beta_api-blue_1              Up 4 hours          ← CORRECT inactive
fm-beta_proxy_1                 Up 4 hours          ← ACTIVE proxy
```

## Issues Found

### Issue 1: CRITICAL — Multiple orphan containers from inconsistent project names

Three different project name prefixes exist:
- `finance-manager-*` (old, orphaned)
- `finance_manager_*` (legacy, orphaned, some still running)
- `fm-beta_*` (current correct project)

**Impact:** Port collisions (three containers all claim `0.0.0.0:5432->5432/tcp`), wasted resources, agent confusion (agents see wrong containers in `docker ps` and target them).

**Root cause:** Agents ran `podman-compose` or `docker-compose` without `--project` flag, or used the wrong compose file, creating containers under the default project name derived from the directory.

**Fix:** Clean up orphan containers on VPS. Ensure all scripts enforce `FM_BLUEGREEN_PROJECT=fm-beta`.

### Issue 2: MODERATE — `fm_server_beta.sh` lacks `--no-cache` flag on `rebuild-color`

The `rebuild_color_cmd` function calls `compose_cmd build` but doesn't expose `--no-cache`. This is exactly the problem from F-007: Podman's build cache served stale images while the agent thought it had rebuilt.

**Fix:** Add `--no-cache` flag to `rebuild-color` command.

### Issue 3: MODERATE — `fm_docker.sh` and `fm_server_beta.sh` share no code

Both scripts independently detect compose provider, handle env files, and manage containers. But `fm_docker.sh` operates on `docker-compose.yml` (single-stack) while `fm_server_beta.sh` operates on `docker-compose.bluegreen.yml`. Agents have used the wrong one.

**Fix:** Document clearly which script is authoritative for blue-green ops. `fm_docker.sh` is for local dev only; `fm_server_beta.sh` is for VPS blue-green.

### Issue 4: LOW — `smoke_cmd` doesn't verify the deployed SHA

Smoke checks confirm services are responding, but don't verify they're running the *expected* code. This is the exact failure mode from F-007: old image served, smoke passed.

**Fix:** Add a version/SHA check endpoint (or check container image ID against expected build).

### Issue 5: LOW — `fm_services.sh` has no blue-green awareness

It runs `manage.py runserver` directly, which is only for Lane A local dev. No issue per se, but agents confuse it with deployment commands.

**Fix:** Add a comment header clarifying scope.

## Recommended Fixes (Priority Order)

1. **VPS cleanup** — Remove orphan containers (`finance-manager-*`, `finance_manager_*`)
2. **Add `--no-cache` to `rebuild-color`** — Prevent stale image builds
3. **Add SHA verification to `smoke_cmd`** — Check deployed code matches expected commit
4. **Script scope documentation** — Header comments on each script's intended use
5. **Shared `lib_compose.sh`** — Extract common compose detection (future, not critical now)

## Action Items

- [ ] VPS orphan cleanup (requires SSH, potentially disruptive — coordinate with HitM)
- [x] Add `--no-cache` flag to `rebuild-color` (landed 2026-05-04 per `ACTIONS.md`)
- [ ] Add version endpoint to API (`/api/version/`) returning git SHA
- [ ] Update script header comments

## 2026-05-05 — Automation follow-up

- [`scripts/sprint_verify.sh`](../../../scripts/sprint_verify.sh) — SSH + remote `scripts/fm_server_beta.sh` rebuild + optional smoke; write logs under `--evidence` for V2 slice proof.
- [`scripts/jsdevtesting_stack_check.sh`](../../../scripts/jsdevtesting_stack_check.sh) — optional HTTPS probes for `jsdevtesting` / `api-jsdevtesting` (does not replace VPS orphan inventory above).
