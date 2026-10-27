# Problem Management

**Goal:** find and remove the root cause of one or more incidents, so they don't happen again.

| Term | Meaning |
|------|---------|
| Problem | The unknown underlying cause of one or more incidents |
| Known error | A problem whose root cause is known (documented in the known error database) |
| Workaround | A temporary way to restore service until the permanent fix |
| Reactive | Starts after incidents (often after a major incident) |
| Proactive | Starts from trends: the same alert or incident keeps coming back |

## Root cause techniques

- **Timeline**: exact sequence from first symptom to recovery, with sources (logs, alerts, ticket notes).
- **5 Whys**: keep asking "why" until you reach something you can fix in a process or system.
- **What changed?**: changes, deployments, patches, certificate expiry, capacity growth.
- **Compare**: a working system vs the failing one.
- **Correlate**: line up logs from different layers (gateway, AD, firewall) on the same timestamps.

## 5 Whys example

1. Why did the portal show errors? Data sync from the mainframe stopped.
2. Why did the sync stop? The message queue was blocked.
3. Why was the queue blocked? An overnight batch job stalled and held it.
4. Why wasn't it caught earlier? The SNMP trap for that queue wasn't covered by a procedure, so it was missed.
5. Why wasn't it covered? The monitoring procedure was never updated when the queue was added.

**Fix:** update the procedure and alert routing for that queue, add it to the knowledge base, brief the team. **Problem closed** when the change is in place and verified.

## Problem record checklist

- Linked incidents
- Impact summary (duration, users, business impact)
- Timeline
- Root cause (technical + process)
- Workaround (if any) and known error entry
- Permanent fix → change record number
- Verification that it worked
