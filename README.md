# IT Operations Labs

Practical material for running IT operations the way a 24/7 operations centre does: **monitor, troubleshoot, follow procedure, escalate cleanly, document**. It includes PowerShell monitoring checks that return proper exit codes, an alert-fatigue analysis tool, ITIL process notes, step-by-step runbooks, and the templates I use for tickets, hand-overs and reviews.

## Repository Structure

```
it-operations-labs/
├── Monitoring-Scripts/   # PowerShell checks: disk, services, endpoints, event logs, health report
├── Alert-Tuning/         # method + script to find noisy alerts in a ticket export
├── ITIL/                 # incident, problem, change management, priority matrix
├── Runbooks/             # disk space, service down, batch failure, high CPU, ESXi, alert storm
├── Templates/            # incident ticket, shift hand-over, post-incident review, change request
├── Platforms/            # Windows Server/AD, mainframe and batch for operators
└── Interview-Notes/      # IT operations interview Q&A
```

## Monitoring Scripts

| Script | What it does | Example |
|--------|--------------|---------|
| `Get-DiskAlert.ps1` | Disk usage with WARNING/CRITICAL thresholds; exit 0/1/2/3 | `.\Get-DiskAlert.ps1 -Warning 80 -Critical 90` |
| `Get-ServiceHealth.ps1` | Finds stopped Automatic services; safe restart with `-WhatIf` | `.\Get-ServiceHealth.ps1 -Name Spooler -Restart -WhatIf` |
| `Test-Endpoints.ps1` | DNS + TCP port + connect time for a list of endpoints | `.\Test-Endpoints.ps1 -Path .\endpoints.csv` |
| `Get-EventLogReport.ps1` | Critical/Error events grouped by source, most frequent first | `.\Get-EventLogReport.ps1 -Hours 24` |
| `Invoke-HealthCheck.ps1` | Runs every check and saves a dated Markdown report | `.\Invoke-HealthCheck.ps1` |
| `Alert-Tuning\Measure-AlertNoise.ps1` | Ranks alerts by noise to target threshold tuning | `.\Measure-AlertNoise.ps1 -Path .\sample-tickets.csv` |

All scripts validate their input and return meaningful exit codes, so they can be scheduled or called by a monitoring agent. Tested on Windows 11 with Windows PowerShell 5.1.

## Runbooks

| Runbook | Scenario |
|---------|----------|
| [RB-01](Runbooks/RB-01-Disk-Space.md) | Disk space alert (Windows and Linux) |
| [RB-02](Runbooks/RB-02-Service-Down.md) | Service stopped |
| [RB-03](Runbooks/RB-03-Batch-Job-Failure.md) | Overnight batch job failed or late |
| [RB-04](Runbooks/RB-04-High-CPU.md) | High CPU |
| [RB-05](Runbooks/RB-05-ESXi-Host-Alert.md) | VMware ESXi host or datastore alert |
| [RB-06](Runbooks/RB-06-Multiple-Alerts.md) | Many alerts at once |

Every runbook follows the same frame: **acknowledge → assess impact → investigate (read-only) → act within procedure → escalate with evidence → verify and close**.

## Skills Demonstrated

| Area | Topics |
|------|--------|
| Monitoring | Thresholds, severities, exit-code checks, alert-fatigue analysis, health reporting |
| ITSM / ITIL | Incident, major incident, problem, change, priority matrix, SLAs, CMDB |
| Windows Server | Services, event logs, Active Directory, Group Policy, PowerShell |
| Linux / Unix | Disk, services, logs (see linux-admin-labs) |
| Virtualisation | VMware ESXi, vCenter, HA, vMotion, snapshots |
| Mainframe | Batch chains, return codes, ABENDs, scheduling, deadlines |
| Communication | Escalation hand-overs, shift hand-overs, post-incident reviews |

## Environment

- Windows 11, Windows PowerShell 5.1
- ServiceNow-style ticket fields in the templates and sample data

## Related Repositories

- [network-engineer-labs](https://github.com/ndubuisipaul460-tech/network-engineer-labs): Packet Tracer labs (VLANs, OSPF, IPsec VPN), Palo Alto troubleshooting
- [linux-admin-labs](https://github.com/ndubuisipaul460-tech/linux-admin-labs): Linux administration notes and Bash scripts
- [wireshark-labs](https://github.com/ndubuisipaul460-tech/wireshark-labs): packet analysis labs
