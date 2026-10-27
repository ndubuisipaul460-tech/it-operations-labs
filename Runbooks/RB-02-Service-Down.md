# RB-02: Windows or Linux service stopped

| Field | Value |
|-------|-------|
| Trigger | Monitored service not running, or health check failing |
| Default priority | From the service's criticality in the CMDB (customer-facing: P2 or higher) |

## 1. Assess

- What does the service do, and who is affected? Is there a redundant node still serving?
- Did a **change** or **patching** run on this server recently?

## 2. Investigate

Windows:
```powershell
.\Get-ServiceHealth.ps1 -Name W3SVC, WAS
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Service Control Manager'; StartTime=(Get-Date).AddHours(-2)} |
  Select-Object TimeCreated, Id, Message | Format-List
Get-Service W3SVC -DependentServices; Get-Service W3SVC -RequiredServices
```
Event IDs worth knowing: **7031/7034** service terminated unexpectedly, **7000/7009** failed to start / timeout, **7036** state change.

Linux:
```bash
systemctl status nginx
journalctl -u nginx --since "1 hour ago" --no-pager
systemctl list-dependencies nginx
```

## 3. Act within procedure

- If the runbook for that service allows **one restart**: restart once, then verify.
  ```powershell
  .\Get-ServiceHealth.ps1 -Name W3SVC -Restart -WhatIf   # see what would happen
  .\Get-ServiceHealth.ps1 -Name W3SVC -Restart
  ```
- If it stops again, or the restart isn't allowed: **do not keep restarting**; escalate.

## 4. Escalate

To the application/server owner with: service, server, time stopped, error events, what you tried and the result.

## 5. Close

Verify in monitoring and with a functional test (the page loads, the API responds). If it crashed unexpectedly, link a problem record.
