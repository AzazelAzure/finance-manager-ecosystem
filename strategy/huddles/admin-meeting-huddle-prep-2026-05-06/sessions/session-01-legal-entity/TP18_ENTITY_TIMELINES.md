# TP18: Entity Creation Timelines — Cascading from TP11

**Huddle session:** 1 (Legal & Entity)  
**Status:** `decided` (timelines cascade from TP11 deferrals)  
**Cross-refs:** → TP11 (expansion gates — source decisions), → TP25 (fallback — deferred to later session)

---

## Summary

TP18 is functionally **determined by TP11 outcomes**. The entity creation timeline is not an independent variable — it cascades from the financial stabilization and counsel engagement gates decided in TP11.

## Cascading timeline (from TP11 decisions S1-D01 through S1-D08)

```
NOW (May 2026)         Baby (Jun 15)         Post-baby stabilization         Counsel engaged         Entity registered
    |                      |                    (~Aug-Sep 2026)                  (~Sep+ 2026)           (~Oct+ 2026)
    |                      |                         |                              |                       |
    v                      v                         v                              v                       v
 ┌──────────┐        ┌──────────┐            ┌───────────────┐            ┌──────────────┐          ┌──────────────┐
 │ Huddle   │───────>│ Baby +   │───────────>│ Budget        │───────────>│ PH counsel   │─────────>│ DTI sole     │
 │ decisions│        │ recovery │            │ stabilizes;   │            │ engaged;     │          │ prop filed;  │
 │ locked   │        │ period   │            │ concrete data │            │ vehicle      │          │ PSP KYB      │
 │          │        │          │            │ on affordables│            │ confirmed    │          │ begins       │
 └──────────┘        └──────────┘            └───────────────┘            └──────────────┘          └──────────────┘
                                                    │                           │
                                                    v                           v
                                             ┌───────────────┐          ┌──────────────┐
                                             │ SMM family    │          │ Anti-Dummy   │
                                             │ hire scoped   │          │ review done  │
                                             │ (~₱10k/mo)    │          │              │
                                             └───────────────┘          └──────────────┘
```

## Realistic earliest dates (planning estimates, not commitments)


| Milestone                             | Earliest realistic  | Depends on                                                      |
| ------------------------------------- | ------------------- | --------------------------------------------------------------- |
| Post-baby financial stabilization     | Aug–Sep 2026        | Birth recovery + 1–2 months expense data                        |
| PH counsel formally engaged           | Sep–Oct 2026        | Budget clarity + warm contact activation                        |
| Entity vehicle confirmed (DTI vs OPC) | Oct–Nov 2026        | Counsel recommendation                                          |
| DTI sole prop registered              | Nov–Dec 2026        | Filing + processing time                                        |
| US LLC formed                         | Dec 2026 – Jan 2027 | Sequential after PH entity; state selection confirmed           |
| Intercompany agreement drafted        | Jan–Feb 2027        | Both entities exist; joint PH+US counsel                        |
| Cross-border cash flow mapped         | Jan–Feb 2027        | Joint PH+US tax advisory (parking lot item)                     |
| PSP merchant KYB complete             | Feb–Mar 2027        | PH entity + bank account + PayMongo onboarding                  |
| **First paid revenue possible**       | **~Q1 2027**        | All above + product "worth paying for"                          |
| SMM family hire starts                | Aug–Oct 2026        | Post-baby + budget confirmed (can precede entity if contractor) |


## Impact on S1.B exit

The original S1.B anticipated exit was **May–Jul 2026**. With entity formation now on the timeline above, **S1.B exit is realistically Q1 2027 at earliest** — aligning with the "Likely" scenario (30–40 weeks) from [S1B_FEATURE_COMPLETION_PROJECTION.md](../../S1B_FEATURE_COMPLETION_PROJECTION.md).

This is **accepted** per decision S1-D08.

## What can proceed in parallel

Entity formation is on the critical path for *revenue*, but these workstreams are **not blocked** by it:


| Workstream                                | Blocked by entity?      | Can proceed now?                               |
| ----------------------------------------- | ----------------------- | ---------------------------------------------- |
| Feature development (F-001 through F-013) | No                      | ✅ Yes                                          |
| PWA implementation                        | No                      | ✅ Yes (paused for other reasons)               |
| Automation hardening (TP5)                | No                      | ✅ Yes                                          |
| Distribution channel research             | No                      | ✅ Yes                                          |
| Wedge consistency audit                   | No                      | ✅ Yes                                          |
| ToS / Privacy drafting (template stage)   | No                      | ✅ Yes — agent can draft; counsel reviews later |
| SEO / landing page work                   | No                      | ✅ Yes                                          |
| SMM family hire (as informal contractor)  | Partially — counsel TBD | ⚠️ Legal grey area                             |
| PSP merchant onboarding                   | **Yes**                 | ❌ Blocked until entity registered              |
| Collecting any revenue                    | **Yes**                 | ❌ Blocked until entity + PSP + ToS             |
| Formal PH employment                      | **Yes**                 | ❌ Blocked until entity registered              |


**Key takeaway:** The extended entity timeline does **not** idle product work. S1.B feature development and infrastructure can proceed independently. The entity path runs in parallel as a separate workstream that converges at S1.B exit.

## TP25 (Entity Registration Fallback)

**Status:** `deferred` — seated for a later session per HitM direction. The spouse-led path (L4 locked) is the working assumption; fallback discussion is not urgent given the post-baby deferral of all entity work.