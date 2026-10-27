<#
.SYNOPSIS
    Checks that critical Windows services are running, and optionally restarts them.

.DESCRIPTION
    For each service name, reports status and start type. A service that is set to
    Automatic but is not running is flagged. With -Restart, the script tries to
    start flagged services; it supports -WhatIf so you can see what it would do
    first, the same way a runbook says "restart only if allowed".
    Exit codes: 0 all healthy, 1 one or more unhealthy, 2 a service was not found.

.EXAMPLE
    .\Get-ServiceHealth.ps1 -Name Spooler, W32Time, Dnscache
.EXAMPLE
    .\Get-ServiceHealth.ps1 -Name Spooler -Restart -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$Name = @('Dnscache', 'W32Time', 'EventLog', 'LanmanWorkstation', 'Winmgmt'),

    [switch]$Restart
)

$notFound = $false
$report = foreach ($n in $Name) {
    $svc = Get-Service -Name $n -ErrorAction SilentlyContinue
    if (-not $svc) {
        $notFound = $true
        [pscustomobject]@{ Name = $n; DisplayName = '-'; Status = 'NOT FOUND'; StartType = '-'; Healthy = $false; Action = '' }
        continue
    }

    $healthy = -not ($svc.StartType -eq 'Automatic' -and $svc.Status -ne 'Running')
    $action = ''
    if (-not $healthy -and $Restart) {
        if ($PSCmdlet.ShouldProcess($svc.Name, 'Start service')) {
            try {
                Start-Service -Name $svc.Name -ErrorAction Stop
                $svc.Refresh()
                $healthy = $svc.Status -eq 'Running'
                $action = if ($healthy) { 'Started' } else { 'Start failed' }
            } catch {
                $action = "Start failed: $($_.Exception.Message)"
            }
        } else {
            $action = 'Would start (WhatIf)'
        }
    }

    [pscustomobject]@{
        Name        = $svc.Name
        DisplayName = $svc.DisplayName
        Status      = $svc.Status
        StartType   = $svc.StartType
        Healthy     = $healthy
        Action      = $action
    }
}

$report | Format-Table -AutoSize

if ($notFound) { exit 2 }
elseif ($report.Healthy -contains $false) { exit 1 }
else { exit 0 }
