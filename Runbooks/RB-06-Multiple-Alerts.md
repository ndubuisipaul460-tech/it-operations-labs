# RB-06: Many alerts at once (alert storm)

| Field | Value |
|-------|-------|
| Trigger | Many alerts from different systems within a few minutes |
| Default priority | Treat as a potential major incident until proven otherwise |

## 1. Don't chase each alert

Look for the **common factor** first:

| Common factor | Suspect |
|---------------|---------|
| All alerts from one site or rack | Network device, power, uplink |
| All VMs on one host or datastore | ESXi host, storage |
| Many apps that share one database | Database server or cluster |
| All authentication-related | Active Directory / domain controllers, certificates |
| Started at a round time (e.g. 22:00) | A change or scheduled job |

## 2. Act

1. Open **one** incident for the probable root; link the other alerts/tickets to it.
2. Check the **change calendar** and scheduled jobs for that time.
3. Inform the **Incident Manager**; they decide on a major incident and a bridge.
4. Give regular updates: what's affected, what's ruled out, next step.

## 3. While waiting for resolver teams

- Keep a **timeline** (time, event, source).
- Gather evidence: which alerts fired first, graphs, logs.
- Watch for the first alert to **clear**; recovery order also tells you a lot.

## 4. Close

When the root is fixed, confirm all linked alerts have cleared, then close linked tickets with a reference to the main incident. A major incident review and a problem record follow.
