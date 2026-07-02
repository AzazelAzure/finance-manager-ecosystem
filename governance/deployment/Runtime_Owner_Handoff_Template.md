# Runtime Owner Handoff Template

## Purpose
Use this template whenever container/runtime control is transferred between agents during active implementation/testing windows.

## Copy/Paste Handoff

```markdown
## Runtime Owner Handoff
- Previous owner:
- New owner:
- Timestamp:

### Runtime State
- Active mode: containerized | local-services
- Last lifecycle command:
- Current status command output summary:
  - `scripts/ops/fm_server_beta.sh status`: (updated 2026-06-29)
  - `scripts/local-stack/fm_services.sh status`:

### Active Testing Breakpoint
- Breakpoint: A (baseline) | B (batch validation) | C (regression sanity)
- Current objective:
- Validation completed:
- Validation pending:

### Known Issues / Blockers
- Critical:
- High:
- Notes:

### Safety Constraints
- Mixed runtime allowed? yes/no
- If yes, explicit reason:
- Forbidden actions for non-owner agents:

### Next Expected Actions
1.
2.
3.
```

## Minimum Handoff Rules

1. Always include status from both script checks.
2. Explicitly name current breakpoint (A/B/C).
3. State whether mixed runtime is allowed; default is no.
4. List blockers before transferring ownership.
