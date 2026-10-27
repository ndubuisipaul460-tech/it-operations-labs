# Post-incident review template

Blameless: focus on how the system and process allowed it, not who to blame.

```
Incident:          INC#        Priority: P1      Problem record: PRB#
Duration:          HH:MM - HH:MM (total)        Detected by: monitoring / user
Services affected:
Customer / business impact:

Timeline
  HH:MM  first symptom (source)
  HH:MM  alert fired / ticket opened
  HH:MM  acknowledged
  HH:MM  escalated to ...
  HH:MM  root cause identified
  HH:MM  service restored
  HH:MM  confirmed stable

Root cause
  Technical:
  Process (why wasn't it prevented / detected earlier?):

What went well

What could be better
  Detection:
  Diagnosis:
  Communication:

Actions
  #  Action                                   Owner     Due        Status
  1  e.g. add alert for queue depth           Monitoring 2026-11-15  open
  2  e.g. update runbook RB-03 step 3         Ops        2026-11-08  open
```

## Metrics to record

Time to detect, time to acknowledge, time to restore; whether the monitoring caught it before users did.
