# Deployment Protocol — VPS Blue-Green CPPR+D Cycle

Defines how merged code reaches the running VPS. Extends the standard CPPR cycle with a fifth step: **Deploy**.

This protocol assumes the operating model in `governance/Server_Runtime_Agent_Operations_Contract.md`: cloud agents are the **control plane** (planning, PR review, deploy intent); the Orchestrator CLI is the **execution plane** (runs scripted deploy commands with SSH access). Cloud agents do not SSH directly to the VPS.

## 1) CPPR+D cycle


| Step  | Action                       | Where                     | Who                  | Manual gate                                      |
| ----- | ---------------------------- | ------------------------- | -------------------- | ----------------------------------------------- |
| C     | Commit                       | local feature branch      | author agent         | none                                            |
| P     | Push                         | origin remote             | author agent         | none                                            |
| PR    | Open PR                      | GitHub via `gh`           | author agent         | `pre_merge` (workspace rule)                    |
| M     | Merge                        | GitHub                    | author agent or HitM | reconciles IDE Chat + GitHub state              |
| **D** | Deploy to VPS inactive color | Orchestrator CLI          | execution plane      | `**pre_deploy`, `pre_cutover`** (this protocol) |


For docs-only or pure-governance plans: the D step is skipped. The plan's metadata `deployment.required: false` declares this.

## 2) Plan deployment metadata

Plans that result in code changes shipping to VPS must declare deployment metadata in the plan's YAML header:

```yaml
deployment:
  required: true                        # true | false
  target_services:                      # list of services this plan modifies
    - api
    - reflex                            # 'reflex' or 'js' depending on which frontend stack is current
  bundle_required: true                 # true if a runtime bundle must be re-built; false for proxy-only changes
  rollback_plan_id: null | <plan_id>    # optional explicit rollback plan
  smoke_targets:                        # paths/endpoints validated post-deploy
    - GET /api/health/
    - GET / (reflex/js root)
  notes: ""
```

If `deployment.required: false`: skip §3-§7 entirely. Close the plan via `plan_lifecycle.md` §E without a Deploy step.

## 3) Pre-deploy gate (`pre_deploy`)

Posted by the execution plane after PR merge, before any VPS-touching action.

Interface: IDE Chat or Terminal

```text
[GATE: pre_deploy]
Plan: {plan_id}
Merged PR: {pr_url}
Commit SHA: {short_sha}

Target services: {comma_separated}
Bundle required: {yes|no}
Active color (current): {blue|green}
Inactive color (deploy target): {green|blue}

Runtime owner: {current_owner_from_runtime_signup_sheet}

Reply: 👍 deploy  |  👎 hold  |  "rollback" if active color is currently broken
```

Wait condition: agent blocks until reply OR 24h timeout (timeout → status `paused`, paused_reason: `pre_deploy gate timeout`).

## 4) Deploy actions (after `pre_deploy` approved)

Execute in order. Each command is run via the Orchestrator CLI (host-local execution plane).

```
1. Confirm runtime owner per governance/Runtime_Signup_Sheet.md
2. Build runtime bundle (if deployment.bundle_required == true):
   ./scripts/ops/create_runtime_bundle.sh
3. Push and extract bundle to VPS inactive color:
   ./scripts/ops/push_runtime_bundle.sh \
     --host {vps_host} --user {ssh_user} \
     --remote-dir {inactive_color_path}
4. Verify release manifest on VPS (push script does this; confirm output):
   verifies bundle_name, commit SHA, dirty/clean flag, runtime_profile
5. Deploy to inactive color (first-time bring-up, or after `down`):
   ./scripts/ops/fm_server_beta.sh deploy {inactive_color}
   If you **rebuilt images** on the VPS for that color (Dockerfile / `git pull` + build), use instead:
   ./scripts/ops/fm_server_beta.sh rebuild-color {inactive_color}
   so Podman does not fail removing `api-*` / `web-*` while `proxy` still references them (`depends_on` → `--requires`). Expect a brief shared-proxy restart.
6. Run smoke against inactive color:
   ./scripts/ops/fm_server_beta.sh smoke --color {inactive_color}
```

If any step fails:

- Status: `in_progress → blocked`
- Post `[HANDOFF: failure]` per `execution_protocols.md` §2.3 with `failure_category: infra` or `runtime`
- Do not cutover

## 5) Pre-cutover gate (`pre_cutover`)

Posted after smoke passes on inactive color, before proxy switch.

Interface: IDE Chat or Terminal

```text
[GATE: pre_cutover]
Plan: {plan_id}
Inactive color smoke: {pass|partial}
Smoke evidence:
- {bullet_1}
- {bullet_2}

Active color (current): {blue|green}
Cutover target: {green|blue}

Manifest identity:
- bundle_name: {name}
- commit_short: {sha}
- worktree_dirty: {true|false}

Reply: 👍 cutover  |  👎 hold  |  "extend" for additional smoke
```

Wait condition: agent blocks until reply OR 24h timeout.

`hold` and `extend` keep the deploy in inactive-color state. Active color continues serving traffic. Plan stays `in_progress`.

## 6) Cutover actions (after `pre_cutover` approved)

```
1. Switch proxy:
   ./scripts/ops/fm_server_beta.sh switch --to {target_color}
   (script performs pre-cutover smoke and aborts on failure)
2. Post-cutover smoke against newly-active color:
   ./scripts/ops/fm_server_beta.sh smoke --color active
3. Tail logs briefly:
   ./scripts/ops/fm_server_beta.sh logs --color active --since 5m
4. Record evidence in plan task thread (IDE Chat or Terminal)
```

Cutover is proxy-only (rewrites `proxy/active_color.conf`, reloads nginx). No container restart on the previously-active color; it remains warm for fast rollback.

## 7) Post-cutover monitoring window

Plan does not transition `completed` immediately after cutover. Plan stays `in_progress` for a monitoring window:


| Plan priority | Monitoring window  |
| ------------- | ------------------ |
| P0            | 60 minutes minimum |
| P1            | 30 minutes minimum |
| P2            | 15 minutes minimum |


During the window, the execution plane:

```
- Monitors API /api/health/ and reflex/js root every 60s
- Watches log error rate via fm_server_beta.sh logs
- Watches canary metrics (transaction count, sync count)
- Reports any regression to plan task thread
```

Rollback is fired automatically if any of:

```
- API /api/health/ returns non-2xx for 3 consecutive checks
- Active color container exits or crash-loops
- Canary metric deviates >X% (X is plan-defined; default 50%)
```

If automatic rollback triggers: status `in_progress → blocked`, `[HANDOFF: failure]`, do not retry without HitM authorization.

## 8) Rollback protocol

Manual rollback (HitM-initiated) or automatic rollback (per §7).

```
1. Run: ./scripts/ops/fm_server_beta.sh rollback
   (proxy switches back to previous active color; previous color is still warm)
2. Post-rollback smoke:
   ./scripts/ops/fm_server_beta.sh smoke --color active
3. Record manifest identity, timestamp, failure category in plan body §10 Risks log
4. Status: in_progress → blocked (until root cause identified)
```

Rollback target is the previously-active color (the one we cutover *from*). Cutting back further requires manual intervention.

## 9) Pre-close deployment evidence (extends `plan_lifecycle.md` §E)

When `deployment.required: true` and the plan is reaching close, the `pre_close` gate (per `execution_protocols.md` §1.3) must include deployment evidence:

```
Strategic impact:
[...]

Deployment evidence:
- Active color now: {color}
- Cutover timestamp: {iso_8601}
- Post-cutover smoke: pass
- Monitoring window: {15|30|60} minutes complete
- Manifest identity: {bundle_name}, commit {sha}
- Rollback fired: {no|yes_at_<timestamp>}
```

If rollback fired and was not resolved: do not close. Plan stays `blocked`.

## 10) SSH and credential management

### 10.1 Canonical VPS connection target (current)

```
SSH target:    dev@dev@<VPS_HOST>
Auth:          SSH key (HitM's default ~/.ssh/id_* via ~/.ssh/config or default agent forwarding)
HitM action:   none required at deploy time — auto-login is configured on the bridge host
```

Use these values in deploy scripts:

```bash
./scripts/ops/push_runtime_bundle.sh \
  --host dev@<VPS_HOST> \
  --user dev \
  --remote-dir /opt/finance_manager
```

The `--identity` flag is **not required** — the bridge host's SSH config resolves the correct key automatically. Do not pass an explicit key path in deploy commands unless rotating or testing a new key.

If a future agent or runbook needs to know the canonical VPS target, **read this subsection** rather than asking HitM. This is the doc-of-record.

### 10.2 Where SSH credentials live

```
- VPS SSH private key: ONLY on the host running the Orchestrator CLI
- Stored at: ~/.ssh/<key_name> with restrictive permissions (0600)
- Resolved automatically via ~/.ssh/config Host entry; deploy scripts do not need --identity
- Never committed to any repo; gitignored at workspace level
- Never echoed to IDE Chat or any log
```

### 10.3 Who can SSH to VPS

```
Authorized identity: dev@dev@<VPS_HOST> (the configured deploy user; not root)
Cloud agents: never. Cloud agents dispatch deploy tasks to the Orchestrator and wait for execution-plane response.
HitM: directly, for emergency / out-of-band ops only
```

### 10.4 Key rotation cadence

```
Quarterly (every 90 days), or immediately if:
  - Key suspected compromised
  - Host running Orchestrator changes
  - Orchestrator role transferred to a different host
HitM-managed; not an agent task.
```

### 10.5 Deploy environment secrets

```
.secrets/server.env on the local orchestrator host: gitignored, contains:
  - VPS_HOST=dev@<VPS_HOST>
  - VPS_SSH_USER=dev
  - VPS_SSH_IDENTITY (optional; ~/.ssh/config usually resolves)
  - VPS_REMOTE_DIR=/opt/finance_manager
  - Any production env values needed at deploy time
On VPS: separate .secrets/server.env applies for runtime, not deploy.
```

## 11) Runtime ownership during deploy

Per workspace rule `container-testing-orchestration.mdc`: only one agent owns container uptime at a time.

During a deploy:

```
- The execution-plane agent (local Orchestrator) is the runtime owner for the deploy duration
- Other agents do not start/stop/rebuild containers on VPS during deploy
- Other agents may continue read-only ops (status checks, log reads) on the active color only
- After cutover + monitoring window: ownership returns to whoever was the prior steady-state owner
- Track in governance/Runtime_Signup_Sheet.md
```

## 12) Multi-service deploy ordering

When a plan targets both `api` and `reflex/js`:

```
Default order (most plans):
  1. Deploy API to inactive color
  2. Smoke API
  3. Deploy frontend to inactive color
  4. Smoke frontend (which exercises API)
  5. Cutover both via proxy switch (single command toggles both)
  6. Post-cutover smoke

If frontend depends on a new API contract:
  Same order (API first), and the API change MUST be backwards-compatible
  with the currently-active frontend, or the cutover must be coordinated
  (rare; usually merge into one plan).

If only one service is changed:
  - Deploy and smoke that one service's inactive color
  - Cutover toggles only that service (proxy config supports per-service color)
```

## 13) Reflex-to-JS pivot transition state

While the JS frontend is being built (S2), there will be a transition window where:

```
- 'reflex-blue' / 'reflex-green' are the production frontend pair
- 'js-blue' / 'js-green' are the staging frontend pair (may not exist yet)
- Plans may target either based on deployment.target_services
- Cutover from reflex-active to js-active is itself a strategic milestone
  (see strategic-roadmap-reframe-53be/phases/S2 §3)
```

Until JS pair is production-ready: `target_services: [reflex]` is the production target. `target_services: [js]` is staging-only.

## 14) Plans that change deployment infrastructure itself

Plans that modify `docker-compose.bluegreen.yml`, `proxy/`, `scripts/ops/fm_server_beta.sh`, `scripts/ops/*`, or any deploy scaffolding:

```
- domain: INFRA or OPS
- deployment.required: true
- deployment.bundle_required: true
- deployment.target_services: [infra]   ← special service token
- These plans require pre_deploy AND pre_cutover gates as `required`
- These plans cannot be approved at pre_execution if another infra plan is currently deployed
- Test on inactive color first; cutover only after extended smoke
```

## 15) References


| Need                                         | File                                                                               |
| -------------------------------------------- | ---------------------------------------------------------------------------------- |
| Operating model (control vs execution plane) | `governance/Server_Runtime_Agent_Operations_Contract.md`      |
| Server install runbook                       | `deploy/SERVER_BETA_INSTALL.md`                                                    |
| Blue-green commands                          | `scripts/ops/fm_server_beta.sh`                                                        |
| Runtime bundle build/push                    | `scripts/ops/create_runtime_bundle.sh`, `scripts/ops/push_runtime_bundle.sh` |
| Manifest verification                        | `scripts/ops/verify_release_manifest.sh`                                        |
| Compose layout                               | `docker-compose.bluegreen.yml`                                                     |
| Active color state                           | `proxy/active_color.conf`                                                          |
| Runtime ownership tracking                   | `governance/Runtime_Signup_Sheet.md`                                  |
| Manual gate templates                        | `execution_protocols.md` §1                                            |
| Status transitions                           | `plan_lifecycle.md`                                                    |


## 16) Quick reference — deploy decision tree

```
if plan.deployment.required == false:
    skip §3-§9; close per plan_lifecycle.md §E

elif plan reaches pre-merge state:
    1. Wait for pre_merge gate (workspace rule)
    2. Merge PR
    3. Post pre_deploy gate (§3)
    4. On 👍: execute deploy actions (§4)
    5. On smoke pass: post pre_cutover gate (§5)
    6. On 👍: execute cutover (§6)
    7. Begin monitoring window (§7)
    8. On window complete + no rollback: post pre_close gate with deploy evidence (§9)
    9. On 👍: status → completed
```

