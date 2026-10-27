# Monitoring Scripts (PowerShell)

Small, single-purpose checks that behave like monitoring plugins: they print a readable table **and** return an exit code, so they can run from Task Scheduler, a monitoring agent, or by hand during a shift.

| Script | What it checks | Exit codes | Example |
|--------|----------------|------------|---------|
| `Get-DiskAlert.ps1` | Fixed-disk usage against WARNING/CRITICAL thresholds | 0 OK, 1 WARNING, 2 CRITICAL, 3 UNKNOWN | `.\Get-DiskAlert.ps1 -Warning 80 -Critical 90` |
| `Get-ServiceHealth.ps1` | Automatic services that aren't running; optional restart with `-WhatIf` support | 0 healthy, 1 unhealthy, 2 not found | `.\Get-ServiceHealth.ps1 -Name Spooler -Restart -WhatIf` |
| `Test-Endpoints.ps1` | DNS resolution + TCP port reachability + connect time for a CSV of endpoints | 0 all up, 1 any down, 2 bad input | `.\Test-Endpoints.ps1 -Path .\endpoints.csv` |
| `Get-EventLogReport.ps1` | Critical/Error events grouped by source and ID, most frequent first | 0 | `.\Get-EventLogReport.ps1 -Hours 24 -Top 15` |
| `Invoke-HealthCheck.ps1` | Runs all of the above and writes a dated Markdown report to `reports/` | n/a | `.\Invoke-HealthCheck.ps1` |

`endpoints.csv` includes two entries that are **meant to fail** (a closed local port and an invalid DNS name) so you can see what a DOWN result and a DNS failure look like. That's why a sample health check shows **Endpoints: WARNING**.

## Design choices

- **Validated parameters** (`ValidateRange`, required columns) so bad input fails fast with exit code 2 or 3, not a confusing error mid-run.
- **Exit codes** follow the OK/WARNING/CRITICAL/UNKNOWN convention used by Nagios-style monitoring.
- **Safe by default**: `Get-ServiceHealth.ps1` only restarts with `-Restart`, and `-WhatIf` shows what it would do, matching a runbook's "restart only if allowed".
- **Remote-ready**: `Get-DiskAlert.ps1 -ComputerName SRV01` uses CIM over WinRM for other servers; local checks need no WinRM.

## Schedule it

```powershell
$action  = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\labs\Monitoring-Scripts\Invoke-HealthCheck.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At 7am
Register-ScheduledTask -TaskName 'Morning health check' -Action $action -Trigger $trigger
```

## Sample output

```
Computer  Drive Label SizeGB FreeGB UsedPct Severity
--------  ----- ----- ------ ------ ------- --------
LAB-PC    C:           237.5   42.7      82 OK

Disk space         OK
Windows services   OK
Endpoints          WARNING
Event log (24h)    OK
```
