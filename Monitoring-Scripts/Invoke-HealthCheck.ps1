<#
.SYNOPSIS
    Runs all monitoring checks and writes one dated Markdown health report.

.DESCRIPTION
    Calls Get-DiskAlert, Get-ServiceHealth, Test-Endpoints and Get-EventLogReport,
    records each check's exit code as OK / WARNING / CRITICAL, and saves a report
    to .\reports\health-<timestamp>.md, like a start-of-shift health check.

.EXAMPLE
    .\Invoke-HealthCheck.ps1
#>
[CmdletBinding()]
param(
    [string]$EndpointFile = (Join-Path $PSScriptRoot 'endpoints.csv'),
    [string]$ReportDir = (Join-Path $PSScriptRoot 'reports')
)

if (-not (Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportPath = Join-Path $ReportDir "health-$stamp.md"

$checks = @(
    @{ Name = 'Disk space';        Script = 'Get-DiskAlert.ps1';      Args = @{} }
    @{ Name = 'Windows services';  Script = 'Get-ServiceHealth.ps1';  Args = @{} }
    @{ Name = 'Endpoints';         Script = 'Test-Endpoints.ps1';     Args = @{ Path = $EndpointFile } }
    @{ Name = 'Event log (24h)';   Script = 'Get-EventLogReport.ps1'; Args = @{ Hours = 24; Top = 10 } }
)

$lines = @("# Health check $(Get-Date -Format 'yyyy-MM-dd HH:mm') on $env:COMPUTERNAME", '')
$summary = @('| Check | Result |', '|-------|--------|')
$details = @()

foreach ($c in $checks) {
    $scriptPath = Join-Path $PSScriptRoot $c.Script
    $splat = $c.Args
    # 'exit N' inside a script run with & returns to this script and sets $LASTEXITCODE
    $output = & $scriptPath @splat *>&1 | Out-String -Width 200
    $code = $LASTEXITCODE
    $result = switch ($code) { 0 { 'OK' } 1 { 'WARNING' } 2 { 'CRITICAL' } default { 'UNKNOWN' } }
    $summary += "| $($c.Name) | $result (exit $code) |"
    $details += @("## $($c.Name)", '', '```', ($output | Out-String).TrimEnd(), '```', '')
    Write-Host ("{0,-18} {1}" -f $c.Name, $result)
}

($lines + $summary + @('') + $details) | Set-Content -LiteralPath $reportPath -Encoding UTF8
Write-Host "Report saved: $reportPath"
