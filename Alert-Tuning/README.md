# Alert Tuning: Reducing Alert Fatigue

When most alerts need no action, people stop trusting them, and the real critical alert gets missed. This folder shows the method I use to cut monitoring noise **with data**, plus a script that does the analysis on a ticket export.

## Method

1. **Export** 60 to 90 days of monitoring-generated tickets (number, opened time, alert name, CI, priority, resolution code).
2. **Measure** per alert: volume, tickets per day, and the share closed with *no action / duplicate / auto-cleared / false positive*.
3. **Classify**
   - **Tune** (≥70% noise): raise the threshold, add a duration ("CPU > 90% for 10 min", not one sample), deduplicate, or downgrade to informational.
   - **Review** (30 to 70%): check the threshold and whether the runbook is clear.
   - **Keep** (<30%): actionable; make it stricter if anything.
4. **Protect the critical ones**: anything that means real customer impact (mainframe link down, core service stopped) stays at high priority, sometimes with *tighter* thresholds.
5. **Change control**: threshold changes go through a change record, with a rollback (old values documented).
6. **Measure again** after 30 days and **document** the new thresholds in a configuration guide; brief the team.

## Script

`Measure-AlertNoise.ps1` reads the export and ranks alerts by how much noise you'd remove by tuning them.

```powershell
.\Measure-AlertNoise.ps1 -Path .\sample-tickets.csv
```

Output on the included `sample-tickets.csv` (**synthetic data** generated for this lab, not from a real company):

```
AlertName                      Tickets PerDay Noise NoisePct Recommend
UNIX disk /var > 80%               260    2.9   231       89 Tune: raise threshold, add delay, or downgrade
SNMP interface flap                210    2.3   192       91 Tune: ...
Batch job late (informational)     180      2   171       95 Tune: ...
Windows CPU > 90% 5 min            140    1.6   115       82 Tune: ...
Datastore > 90%                     40    0.4    10       25 Keep: mostly actionable
Backup job failed                   30    0.3     8       27 Keep: mostly actionable
Service stopped: IIS W3SVC          25    0.3     4       16 Keep: mostly actionable
Mainframe link down                  6    0.1     0        0 Keep: mostly actionable

891 tickets over 90 days. 731 (82%) closed with no action.
Tuning the alerts marked 'Tune' would remove up to 709 tickets (80% of volume).
```

The rare **Mainframe link down** alert is never noise, so it stays top priority. Most of the volume comes from four alerts that people had learned to ignore.

## Typical tuning changes

| Alert | Before | After |
|-------|--------|-------|
| Disk usage | Warn at 80%, every poll | Warn 85%, critical 95%, plus a growth-rate alert ("full in < 24 h") |
| CPU | > 90% on one sample | > 90% sustained 10 min, suppressed during known batch windows |
| Interface flap | Every SNMP linkDown trap | Alert only if > 3 flaps in 15 min; single flaps logged |
| Batch late | Ticket for every late job | Ticket only when a critical-path job threatens its deadline |
