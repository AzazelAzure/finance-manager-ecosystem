# Spec — `vps_state.sh` + live-state refactor of `gather_doc_context.sh`

**Author:** Claude Code (admin) · **Owner of execution:** Cursor · **Date:** 2026-06-29
**Origin:** D5 in `strategy/meetings/admin_meeting_notes_2026-06-29.md`
**Related:** D6 (design-doc accuracy), "trust but verify" core tenant (D5 ref [1])

---

## Problem

The daily summary produced false HIGH alerts on 2026-06-29 (active-stack SHA mismatch, "Celery
not running") that cagent disproved against the live VPS. Root cause is in
`scripts/gather_doc_context.sh`:

```sh
echo "## Runtime Signup Sheet — Current VPS State"
head -60 "$REPO_ROOT/design_docs/30_Releases/Runtime_Signup_Sheet.md"
```

The "Current VPS State" section is **not** a live query — it reprints the top of a **static
markdown file** that a human (or agent) last edited. If that file was written before a deploy
finished, every downstream automation (doc sweep, daily summary, morning meeting) inherits the
stale state and presents it as current. Re-running the sweep does not help, because it re-reads
the same stale file.

## Decision (from D5)

- **Separation of concerns is maintained.** One new single-purpose script, `vps_state.sh`,
  owns *only* live VPS state. `gather_doc_context.sh` keeps its concern (gathering doc/context
  signals) and **calls** `vps_state.sh` at runtime, compiling the live result in.
- **Trust but verify.** The state must be SSH-verified at gather time, with an explicit
  timestamp, not trusted from a cached doc. Antigravity has the same SSH capability and must be
  told (in its prompt) to verify, not assume.

## Deliverable 1 — `scripts/vps_state.sh` (new)

**Single concern:** SSH the VPS, capture live runtime facts, print a timestamped markdown
block to stdout. No doc reading, no GitHub calls, no side effects beyond the SSH.

### Output (stdout, markdown)

```markdown
## Live VPS State (SSH-verified)

**Captured:** <ISO-8601 timestamp> · **Host:** <vps host> · **Query latency:** <ms>

| Field | Value |
|---|---|
| Active color | green / blue |
| Active API SHA | <short sha> |
| Active Web SHA | <short sha> |
| Containers running | <n>/<expected> |
| Celery worker | up <uptime> / DOWN |
| Celery beat | up <uptime> / DOWN |
| Last migration applied | <name> |
| API health | 200 / <code> |

### Container detail
<raw `podman ps --format` table for fm-beta_* containers>

### Drift check
<if any container expected-but-missing, or active SHA != latest main, list here>
```

### Behavior

1. SSH once, run a single remote command bundle (minimize round-trips): `podman ps`, the
   active-color marker, the deployed SHAs, `migrate --check`/last migration, and a localhost
   `curl` of the API health endpoint on the active color.
2. Always print the **capture timestamp** and host. The timestamp is the anti-stale guarantee.
3. If SSH fails or times out (set a hard timeout, e.g. 20s), print a clearly-marked
   `## Live VPS State (UNAVAILABLE — SSH failed at <ts>)` block and exit non-zero. Callers must
   surface "state unavailable," never silently fall back to a cached file.
4. Reuse the SSH host/key config the existing VPS scripts already use (`fm_server_beta.sh` /
   cagent path) — do not hardcode new credentials. Read host from the same source those use.
5. Drift check: compare active SHA against `git ls-remote`/latest `main` and expected container
   count; emit a `### Drift check` list only when something is off (empty section otherwise).

## Deliverable 2 — refactor `scripts/gather_doc_context.sh`

Replace the static `head -60 Runtime_Signup_Sheet.md` block with a call to `vps_state.sh`:

```sh
echo "## Runtime State"
if VPS_OUT="$("$SCRIPT_DIR/vps_state.sh" 2>&1)"; then
  printf '%s\n' "$VPS_OUT"
else
  printf '%s\n' "$VPS_OUT"
  echo ""
  echo "> ⚠️ Live VPS state unavailable this run — downstream automations must NOT"
  echo "> treat the Runtime Signup Sheet as current. Flag VPS state as UNKNOWN."
fi
echo ""
```

- Keep the static `Runtime_Signup_Sheet.md` as the **human-authored intent / changelog**, but
  it is no longer the source of "current state." Optionally still print it under a clearly
  different heading like `## Runtime Signup Sheet (human log — not live state)` so the two are
  never conflated.
- `gather_doc_context.sh` keeps everything else it does (registry, anomalies, stale-pattern
  scan). It gains a runtime dependency on `vps_state.sh` but not its logic.

## Deliverable 3 — prompt hardening (ties to D6)

Update `strategy/automations/prompts/daily_summary_prompt.md` and `daily_doc_sweep_prompt.md`:

- State explicitly: "VPS state comes from the `## Live VPS State (SSH-verified)` block and its
  timestamp. If that block says UNAVAILABLE, report VPS state as UNKNOWN — never infer it from
  the Runtime Signup Sheet or prior context."
- Add the **trust-but-verify** instruction: where the automation has SSH capability
  (Antigravity does), it should spot-verify a flagged HIGH against live state before escalating,
  and take a deeper pass rather than a surface read. The automation should write its own
  findings file with links to what it checked.

## Acceptance Criteria

1. `vps_state.sh` prints SSH-verified live state with a capture timestamp, or a clearly-marked
   UNAVAILABLE block on SSH failure (exit non-zero).
2. `gather_doc_context.sh` calls `vps_state.sh` and no longer presents `Runtime_Signup_Sheet.md`
   as current state.
3. A simulated stale `Runtime_Signup_Sheet.md` no longer poisons the output — live state wins.
4. On a deliberate SSH-block test, the output says UNKNOWN/UNAVAILABLE, not a stale-but-confident
   value.
5. Daily summary + doc sweep prompts instruct agents to treat VPS state as point-in-time and to
   verify before escalating.

## Out of scope

- The broader governance/design-doc consolidation (D6) — separate planning session.
- Changing cron cadence — same schedule; only the data source changes.
- The morning-meeting template (D8) — parked.

## Owner split

- **Cursor** implements `vps_state.sh` + the `gather_doc_context.sh` refactor (shell + SSH).
- **Claude Code** updates the two automation prompt files (content-only) — can be done now or
  bundled with the design-doc-sweep prompt work when D6 lands.
