# Agent launch prompt — VPS Reflex + blue-green recovery

Copy everything inside the fence into a new agent task (no placeholders to fill).

```text
You are the Reflex / server-runtime agent for plan:
  plans/cursor/vps-reflex-bluegreen-recovery-53be/

VPS SSH (same Linux user as the parallel JS plan agent — both may use this simultaneously for SSH/editing; still coordinate container lifecycle via Runtime Signup Sheet so only one owner runs start/stop/rebuild/deploy):
  dev@159.198.75.194
  Typical repo path on VPS: /home/dev/finance_manager (confirm on host if different)

Read first (order matters):
1. plans/cursor/vps-reflex-bluegreen-recovery-53be/README.md
2. plans/cursor/vps-reflex-bluegreen-recovery-53be/validation_gates.md
3. plans/cursor/vps-reflex-bluegreen-recovery-53be/CROSS_AGENT_COORDINATION.md
4. design_docs/30_Releases/Runtime_Signup_Sheet.md — claim runtime owner OR sublet before any container lifecycle
5. deploy/SERVER_BETA_INSTALL.md (blue-green commands)
6. scripts/fm_server_beta.sh -- help via `scripts/fm_server_beta.sh` with no args if needed
7. plans/cursor/server-beta-install-bluegreen-53be/known_good_beta_state_apr28.md (baseline context; Namecheap VPS is dev@159.198.75.194)

Parallel work: finance-manager-web-beta-rollout-53be (JS). Do not restart/rebuild VPS without runtime sheet coordination.

Repository boundaries:
- Reflex code + changelog: finance_manager_reflex/ (submodule repo)
- Parent compose/proxy/scripts: workspace root — commit per git-repo-workflow

Intended git branch (parent or ops repo): cursor/vps-reflex-bluegreen-recovery-53be

Success criteria (full run):
- Phase A: Written inventory — single-stack vs blue-green on VPS dev@159.198.75.194; tunnel → port → compose map
- Phase B: Reflex stable on chosen stack (login, dashboard, hard refresh, websocket not persistently 502)
- Phase C: scripts/fm_server_beta.sh check passes on VPS with FM_PUBLIC_* overrides for production hostnames if needed; inactive color deploy + smoke WITHOUT public cutover unless separate human gate; optional cutover + rollback drill with evidence
- Close: Update validation_gates.md breakpoint statuses; fill runtime_handoff.md; handoff block per CROSS_AGENT_COORDINATION.md if API/proxy changed

CPPR+D: Any VPS deploy of merged code uses governance/deployment_protocol.md (pre_deploy, deploy inactive, smoke, pre_cutover, cutover). Slack gates in #cli-interface as specified there.

Start at README Phase A. Report blockers with reproduction + last 30 lines of relevant container logs.
```
