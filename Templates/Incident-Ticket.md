# Incident ticket template

```
Title:          [Service] [symptom] - e.g. "Customer portal - HTTP 500 errors for all users"
Priority:       P1 / P2 / P3 / P4   (impact: ___  urgency: ___)
Opened:         YYYY-MM-DD HH:MM (source: alert name / user / service desk)
Configuration item(s):
Affected service and users:

Symptom:
  What exactly is failing, error messages, since when.

Business impact:
  Who can't do what. Customers affected? Deadline at risk?

Recent changes:
  Change numbers in the last 24-48 h on this CI or its dependencies (or "none found").

Investigation so far (time - action - result):
  HH:MM  checked ...                 -> result
  HH:MM  ran runbook RB-xx step 2     -> result

Escalated to:   team / person, HH:MM, hand-over summary
Workaround:     (if any)
Resolution:     what fixed it, HH:MM
Verification:   monitoring green + functional test + user/owner confirmed
Root cause:     known / suspected / unknown -> problem record PRBxxxxx
```

## Rule

If someone reads only this ticket, at 3 a.m., with no other context, can they take over? If not, add what's missing.
