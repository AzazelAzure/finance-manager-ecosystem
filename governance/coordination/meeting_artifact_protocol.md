# Meeting Artifact Protocol

How admin-meeting and discussion files are created, kept current, and retired — so `strategy/`
stays navigable instead of accumulating dead one-off files.

**Origin:** D6 Q4 (2026-06-29). HitM: "Some of these are just there for the meeting in the
moment. We should have protocols on what files get saved, updated, or archived within meetings."

## Artifact classes

| Class | Example | Lifecycle |
|---|---|---|
| **Durable record** | `meetings/admin_meeting_notes_YYYY-MM-DD.md` (consolidated) | Keep. This is the canonical record of decisions for that day. |
| **In-the-moment scratch** | discussion thread w/ inline back-and-forth, screenshots, raw paste | Archive after the meeting once decisions are extracted into the durable record. |
| **Seed proposal** | `doc_structure_consolidation_proposal_YYYY-MM-DD.md` | Keep until resolved; on resolution, mark `Status: resolved` and move decisions to their permanent home (registry, AGENTS.md, the relevant `strategy/` artifact). Then archive the seed. |
| **Routed item** | a decision that becomes work | Graduates to a `plans/` plan, a `strategy/parking_lot/` file, the `risk_register.md`, or an anomaly. The meeting note links to it; it does not live on in the note. |

## Rules

1. **One durable record per meeting.** The consolidated notes file is the source of truth.
   Discussion scratch (inline comment threads, the "_discussion" archive) is preserved but is
   not the canonical record.
2. **Extract before archive.** Never archive a scratch/seed file until its decisions are written
   into their permanent home. Losing an uncommitted decision is the failure mode to avoid
   (e.g. archive a discussion file → its inline answers must already be in the durable record).
3. **Route, don't accumulate.** A decision that becomes work leaves the meeting note as a link to
   a plan / parking-lot item / risk / anomaly. The meeting note records *that the decision was
   made*, not the ongoing work.
4. **Archive cadence.** Move resolved seeds, extracted scratch, screenshots, and one-off CBA/audit
   pastes into `strategy/archived/` once their meeting is closed and decisions are routed. Target:
   no loose one-off files older than the current + previous meeting in `strategy/` top level.
5. **Index, don't duplicate.** `strategy/README.md` indexes the homes. Don't re-list contents
   inside multiple files (that's how drift starts).

## MINUTES.md — live session state (anti-compaction artifact)

Every meeting day folder must have a `MINUTES.md`. It is the canonical "where we are right now"
document and the first thing read after any context compaction.

**Update triggers (Claude updates immediately, not batched):**
- Topic opened — set as current topic
- Topic completed — move to completed list, update open items
- Topic parked — move to open with PARKED note
- Queue state changes (task pushed, Cursor reports done)
- Key decision made — add to decisions table

**Format:** Current topic → Completed → Open (priority order) → Queue state → Key decisions → Update log

**Rule:** If MINUTES.md is stale (current topic wrong, completed list behind), update it before
doing any other work. A stale MINUTES.md is worse than no MINUTES.md because it gives false
context after compaction.

## Quick checklist (end of each meeting)

- [ ] Decisions written into the durable consolidated note
- [ ] Each actionable decision routed (plan / parking_lot / risk_register / anomaly) and linked
- [ ] Scratch/discussion files preserved but no longer the record
- [ ] Resolved seed proposals marked resolved; decisions moved to permanent homes
- [ ] Loose/stale one-offs swept to `strategy/archived/`
