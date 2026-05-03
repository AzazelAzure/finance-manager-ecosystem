---
task_id: T14
status: pending
owner: unassigned
phase: P13
breakpoint: BP_D4_EXEC
last_verification: null
---

# T14 — D4-exec on VPS :8443 (Chrome) + record results

## Objective

Run **D4-exec** per [`../../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md`](../../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md) §2–§4 on **deployed HTTPS :8443** active stack; **Chrome desktop + Chrome Android** for certified items; record outcomes (append to this folder or `runtime_handoff.md`).

## Repo scope

- Evidence artifacts (markdown log) under `plans/S1/S1.B/pwa-implementation-branch/evidence/` optional new dir, or runtime_handoff table only.

## Dependencies

- **BP_OUTBOX**, **BP_D3_AUTH**, **BP_MIN_PWA**, **BP_SW_CACHE**, **BP_SW_UPDATE**, **BP_SEED**, **BP_OFFLINE_READ** PASS.

## Checklist

- [ ] `fm_server_beta.sh smoke --color active` (or current project-standard smoke) where applicable.
- [ ] Manual PWA install, offline, outbox, auth, blue/green post-switch per D4 doc.
- [ ] Waivers only via strategic `PARKING_LOT.md` policy if used.

## Definition of done

- **BP_D4_EXEC** PASS with dated log and tester initials.
- Unblocks research plan **completed** + S1.B strategic bullet when combined with T15.

## Verification

- HitM or delegate signs log; link pasted in Cursor chat.

## Risks

- Environment drift — confirm active color and build IDs in log header.

## PR expectations

- Evidence can be committed in parent repo under plan `evidence/` subfolder (create if used).
