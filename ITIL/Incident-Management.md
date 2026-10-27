# Incident Management

**Goal:** restore normal service as fast as possible with minimum impact on the business. Finding the root cause is problem management's job; incident management restores first.

## Lifecycle

```
Detect / log → Categorise → Prioritise → Diagnose → Escalate (if needed) → Resolve → Close
                                     ↑_________ update the ticket at every step _________|
```

| Step | What the operations centre does |
|------|---------------------------------|
| Detect / log | Alert or user report → ticket with time, CI, symptom, evidence |
| Categorise | Service, component (network, server, application, batch…) |
| Prioritise | Impact × urgency (see [Priority-Matrix.md](Priority-Matrix.md)) |
| Diagnose | Runbook first; check recent changes, related alerts, dependencies |
| Escalate | **Functional**: to the resolver team (L2, vendor). **Hierarchical**: to management/Incident Manager when impact or SLA risk is high |
| Resolve | Fix or workaround; confirm service is healthy in monitoring |
| Close | Confirm with the user/owner, resolution code, notes good enough for the next person |

## Major incident

Highest-impact incidents follow a separate procedure:

- Declared by the **Incident Manager**; a **bridge call** brings resolver teams together.
- One person keeps a **timeline**; status updates at a fixed interval (e.g. every 30 minutes).
- The operations centre provides monitoring evidence, checks related systems, and executes runbook actions on request.
- After restoration: a **major incident review** and a **problem record** for root cause.

## Good escalation hand-over

> **What:** Sync from mainframe gateway to web tier stopped. **Since:** 02:10. **Impact:** customer portal errors, ~40 tickets in 20 min. **Checked:** VMs healthy in vCenter, gateway logs show the message queue blocked behind batch job XYZ. **Need:** mainframe team to check the job region. **Ticket:** INC123456.

## Metrics

- **MTTA**: mean time to acknowledge
- **MTTR**: mean time to restore
- % resolved within SLA, % first-time-right escalations, reopen rate
