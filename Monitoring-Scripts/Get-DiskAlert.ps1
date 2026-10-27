<#
.SYNOPSIS
    Reports fixed-disk usage with WARNING and CRITICAL thresholds.

.DESCRIPTION
    Uses CIM to read every local fixed disk, calculates percent used and free
    space, and gives each disk a severity. Exit codes follow the Nagios-style
    convention used by many monitoring tools:
      0 = OK, 1 = WARNING, 2 = CRITICAL, 3 = UNKNOWN.

.EXAMPLE
    .\Get-DiskAlert.ps1
.EXAMPLE
    .\Get-DiskAlert.ps1 -Warning 80 -Critical 90 -ComputerName SRV01
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 99)]
    [int]$Warning = 85,

    [ValidateRange(1, 100)]
    [int]$Critical = 95,

    [string]$ComputerName = $env:COMPUTERNAME
)

if ($Warning -ge $Critical) {
    Write-Error "Warning ($Warning) must be lower than Critical ($Critical)."
    exit 3
}

try {
    $cim = @{ ClassName = 'Win32_LogicalDisk'; Filter = 'DriveType=3'; ErrorAction = 'Stop' }
    # Only use a remote (WinRM) session for other machines; local queries need no WinRM
    if ($ComputerName -notin @($env:COMPUTERNAME, 'localhost', '.')) { $cim.ComputerName = $ComputerName }
    $disks = Get-CimInstance @cim
} catch {
    Write-Error "Cannot read disks on ${ComputerName}: $($_.Exception.Message)"
    exit 3
}

$report = foreach ($d in $disks) {
    if (-not $d.Size) { continue }
    $usedPct = [math]::Round((($d.Size - $d.FreeSpace) / $d.Size) * 100, 1)
    $severity = if ($usedPct -ge $Critical) { 'CRITICAL' }
                elseif ($usedPct -ge $Warning) { 'WARNING' }
                else { 'OK' }
    [pscustomobject]@{
        Computer = $ComputerName
        Drive    = $d.DeviceID
        Label    = $d.VolumeName
        SizeGB   = [math]::Round($d.Size / 1GB, 1)
        FreeGB   = [math]::Round($d.FreeSpace / 1GB, 1)
        UsedPct  = $usedPct
        Severity = $severity
    }
}

$report | Sort-Object UsedPct -Descending | Format-Table -AutoSize

if ($report.Severity -contains 'CRITICAL') { exit 2 }
elseif ($report.Severity -contains 'WARNING') { exit 1 }
else { exit 0 }
