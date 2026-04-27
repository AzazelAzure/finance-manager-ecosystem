---
name: repo-exploration-briefing
description: Produce fast, accurate codebase briefings by mapping structure, ownership, and key execution paths. Use when the user asks where logic lives, how systems connect, or requests architecture context before changes.
---

# Repo Exploration Briefing

## Workflow Checklist

- [ ] Define question scope and target repository.
- [ ] Identify key files/modules through focused search.
- [ ] Trace main data/control flow paths.
- [ ] Capture unknowns or ambiguous areas.
- [ ] Provide concise summary with recommended next steps.

## Guidance

- Prefer breadth-first mapping before deep dives.
- Avoid speculative conclusions; label assumptions clearly.
- Use the smallest set of files needed for confidence.
- Use `shared-subagent-handoff` for structured output.
