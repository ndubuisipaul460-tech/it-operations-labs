# RB-04: High CPU on a server

| Field | Value |
|-------|-------|
| Trigger | CPU > 90% sustained for 10 minutes |
| Default priority | P3; P2 if users are affected |

## 1. Assess

- Are users or services affected (slow responses, timeouts)? Is it still rising?
- Is this a **known batch or backup window**? Check the schedule before acting.
- Did a change or deployment just happen?

## 2. Investigate

Windows:
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, Id, CPU, WorkingSet
Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 2 -MaxSamples 5
Get-CimInstance Win32_Process -Filter "ProcessId=1234" | Select-Object CommandLine   # what is that process?
```

Linux:
```bash
top -o %CPU          # or: ps aux --sort=-%cpu | head
uptime               # load average vs number of cores (nproc)
```

## 3. Act within procedure

- If it's expected (batch window), note it in the ticket and monitor until the window ends.
- Never kill a process you don't own unless the runbook names it.

## 4. Escalate

To the server or application owner with the top processes, graph/trend, start time and user impact. If it started with a change, tell the **change owner** straight away; they may roll back.

## 5. Close

CPU back to normal in monitoring; cause recorded. If the alert keeps firing during known windows, propose tuning (see [Alert-Tuning](../Alert-Tuning/)).
