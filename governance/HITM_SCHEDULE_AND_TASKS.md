# HitM calendar, tasks, and agent-visible schedule

**Audience:** HitM (`pproctor`) and AI agents planning sprints, load, and absence-sensitive work.

## Goals

- **Calendar (events):** time boxes, deadlines, tentative roadmap anchors, personal holds — managed with **khal** on a vdir at `~/.local/share/calendars/work/`.
- **Tasks (VTODO):** actionable items, sprint todos, dated follow-ups — managed with **todoman** (`todo` CLI); files live under `~/.local/share/calendars/tasks/` (see your `~/.config/todoman/config.py` `path` glob).
- **Agents:** read the **generated snapshot** after refresh so time windows and absence risk stay aligned with reality (without giving agents raw shell access to your home directory).

Todoman does **not** paste tasks *into* the same ICS files as khal; both are standard **vdir** collections. Desktop sync (e.g. vdirsyncer + CalDAV) may still show both in one UI.

## Refresh the in-repo snapshot

From the finance_manager repo root:

```bash
./scripts/schedule_agent_sync.sh
```

Optional:

```bash
SCHEDULE_DAYS=120 ./scripts/schedule_agent_sync.sh
SCHEDULE_SNAPSHOT=/path/to/custom.md ./scripts/schedule_agent_sync.sh
KHAL_CAL=work ./scripts/schedule_agent_sync.sh
```

Output default: `governance/HITM_SCHEDULE_SNAPSHOT.md` (gitignored — personal).

## Agent reading order

1. This file (pointers + workflow).
2. `HITM_SCHEDULE_SNAPSHOT.md` — **if present** (run the script locally; not shipped in git).
3. Strategic cadence and gates: `plans/cursor/strategic-roadmap-reframe-53be/README.md`, `kill_commit_gates.md`, `validation_gates.md`.

If the snapshot is missing, assume schedule is unknown and ask HitM before assuming availability.

## Adding tasks for shared visibility

```bash
todo new "S1.B: close PWA D4-exec checklist" -d 2026-08-15
todo list
```

Use **due dates** and clear summaries so sprint planning and agent handoffs stay unambiguous.