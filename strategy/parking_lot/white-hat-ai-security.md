---
parked: 2026-06-29
revisit_when: post-beta, when security hardening against live threats becomes warranted
owner: HitM
status: parked
---

# White-hat AI for live security hardening

HitM intent: eventually stand up a less-restricted AI to act as a white-hat for genuine attack
hardening — live verification, not only preemptive static work.

**Distinct from** the local security audit suite (`PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29`),
which is *preventive, preemptive* tooling (SAST, dep CVEs, secret scans) with no live attack
simulation. This parked item is the *offensive/verification* counterpart.

**Constraints noted:**
- Cybersecurity is outside HitM's core wheelhouse.
- Standard AI tools refuse offensive security work (Antigravity hard-refuses all security prompts
  regardless of context).
- Repos are private; HitM prefers local tooling and minimal external exposure.

**Revisit trigger:** after beta stabilizes and there's a real threat surface to harden against.
Not S1.B scope.
