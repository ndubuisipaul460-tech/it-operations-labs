# IT Operations Interview Notes

**Incident vs problem vs change?**
An incident is an unplanned interruption; restore service fast. A problem is the underlying cause of one or more incidents; find and remove it. A change is a planned, approved modification, controlled to reduce risk.

**How do you prioritise?**
Impact × urgency gives P1 to P4. When several hit at once, highest first, but every incident has an owner and a status.

**An alert fires at 3 a.m. and there's no runbook. What do you do?**
Acknowledge, assess impact, check context (related alerts, recent changes, batch schedule). If impact is real, escalate to on-call or the Incident Manager with a clear hand-over. Don't experiment on production. Document, then propose a runbook.

**Many alerts fire at once?**
Look for the common factor (site, host, storage, database, change) before chasing each one. One incident for the root, link the rest, inform the Incident Manager.

**What makes a good escalation?**
What, since when, impact, what was checked and the results, what you need from them, the ticket number.

**How do you hand over a shift?**
Written first: open incidents and next steps, changes in progress, batch status, watch list. Then a short verbal walk-through. Nothing lives only in memory.

**How would you reduce alert fatigue?**
With data: export 90 days of monitoring tickets, measure noise per alert, tune the noisy ones (thresholds, durations, deduplication), keep critical ones strict, put it through change control, and measure again.

**A batch job failed. What do you do?**
Job log, failing step, RC or ABEND; what depends on it and the deadline; rerun only if the runbook allows; escalate early if the deadline is at risk.

**What's DORA and why does it matter for an operations centre?**
The EU Digital Operational Resilience Act (applies since January 2025) requires financial firms to manage ICT risk, classify and report major ICT incidents, test resilience and control third-party providers. Fast detection, correct classification and good records come straight from the operations centre.

**A senior colleague asks you to skip the change process to fix something quickly.**
Explain the risk politely, offer the right route (emergency change, Incident Manager approval), and document it. In a bank, speed never beats control.

**What would you check if a user says an app is slow but monitoring is green?**
Take it seriously: others affected? Reproduce it if allowed, check dependencies (DB, network, auth), log an incident with evidence for the app team, and suggest a monitoring improvement afterwards.
