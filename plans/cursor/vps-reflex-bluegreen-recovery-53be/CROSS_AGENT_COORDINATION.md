# Cross-agent coordination — Reflex / blue-green plan

This plan runs in parallel with **[finance-manager-web-beta-rollout-53be](../finance-manager-web-beta-rollout-53be/README.md)** (JS frontend rollout). Both agents use the same VPS account **`dev@159.198.75.194`** (SSH sessions and file edits can overlap). **Container lifecycle** (start/stop/rebuild/deploy) must still follow a single **runtime owner** on the [Runtime Signup Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md) so two agents do not issue conflicting `fm_docker.sh` / `fm_server_beta.sh` commands at once.

## Single runtime owner (mandatory)

Before any `fm_docker.sh` / `fm_server_beta.sh` start, stop, rebuild, or deploy:

1. Read and update **[design_docs/30_Releases/Runtime_Signup_Sheet.md](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md)** — claim owner or request sublet; **script-only** lifecycle per workspace rules.
2. Use **[design_docs/30_Releases/Runtime_Owner_Handoff_Template.md](../../../../design_docs/30_Releases/Runtime_Owner_Handoff_Template.md)** when handing off or pausing.

If the JS agent needs API-only local changes (CORS, env) and you own VPS runtime, either sequence work or split: Reflex agent owns VPS container restarts unless orchestrator assigns API sublet with written scope.

## Check status of the sibling (JS) plan

| What | Where |
|------|--------|
| JS plan root | [../finance-manager-web-beta-rollout-53be/README.md](../finance-manager-web-beta-rollout-53be/README.md) |
| JS validation gates | [../finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) |
| JS agent launch prompt | [../finance-manager-web-beta-rollout-53be/AGENT_LAUNCH_PROMPT.md](../finance-manager-web-beta-rollout-53be/AGENT_LAUNCH_PROMPT.md) |

**Before proxy or compose changes on VPS:** skim JS `validation_gates.md` for “blocked on API” or “blocked on proxy DNS” — avoid shipping proxy rules that break `jsdevtesting` hostnames if that phase is active.

## Handoff to JS agent (when Reflex/proxy work affects API or CORS)

Post a short block in the JS plan folder’s coordination file (or Slack thread per org practice) with:

- What changed (files, PR URL)
- Public hostnames / ports affected
- Whether API container was restarted and when

## Handoff from JS agent (when you need to know)

JS work may add `CORS_ALLOWED_ORIGINS`, new server names in nginx, or Cloudflare hostnames. Reflex agent should read [../finance-manager-web-beta-rollout-53be/CROSS_AGENT_COORDINATION.md](../finance-manager-web-beta-rollout-53be/CROSS_AGENT_COORDINATION.md) for “last known API/proxy state” if present.

## CPPR+D reminder for this track

VPS deploys follow **[governance/deployment_protocol.md](../../../governance/deployment_protocol.md)** — cloud agents plan/review; **execution plane** runs SSH/bundle/deploy per contract. Do not SSH from cloud agent unless that contract is explicitly waived for your session.
