<#
.SYNOPSIS
    Finds noisy monitoring alerts in a ticket export, to support alert-threshold tuning.

.DESCRIPTION
    Reads a CSV export of monitoring tickets (for example from ServiceNow) with the
    columns: Number, Opened, AlertName, ConfigItem, Priority, ResolutionCode.
    A ticket counts as "noise" when its ResolutionCode is one of the -NoiseCodes
    (closed with no action needed). For every alert it reports the ticket count,
    noise percentage and a recommendation, sorted so the biggest wins come first.

.EXAMPLE
    .\Measure-AlertNoise.ps1 -Path .\sample-tickets.csv
.EXAMPLE
    .\Measure-AlertNoise.ps1 -Path .\export.csv -NoiseCodes 'No action','Duplicate','Auto-cleared' -OutCsv .\noise.csv
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string[]]$NoiseCodes = @('No action required', 'Duplicate', 'Auto-cleared', 'False positive'),

    [ValidateRange(1, 100)]
    [int]$NoiseThresholdPct = 70,

    [string]$OutCsv
)

if (-not (Test-Path -LiteralPath $Path)) { Write-Error "File not found: $Path"; exit 2 }
$tickets = Import-Csv -LiteralPath $Path
foreach ($col in 'AlertName', 'ResolutionCode', 'Opened') {
    if ($col -notin $tickets[0].PSObject.Properties.Name) { Write-Error "Missing column: $col"; exit 2 }
}

$dates = $tickets | ForEach-Object { [datetime]$_.Opened }
$days = [math]::Max(1, (($dates | Measure-Object -Maximum).Maximum - ($dates | Measure-Object -Minimum).Minimum).TotalDays)

$report = $tickets | Group-Object AlertName | ForEach-Object {
    $noise = @($_.Group | Where-Object { $_.ResolutionCode -in $NoiseCodes }).Count
    $pct = [math]::Round(100 * $noise / $_.Count, 0)
    $rec = if ($pct -ge $NoiseThresholdPct) { 'Tune: raise threshold, add delay, or downgrade to informational' }
           elseif ($pct -ge 30) { 'Review: check threshold and runbook' }
           else { 'Keep: mostly actionable' }
    [pscustomobject]@{
        AlertName  = $_.Name
        Tickets    = $_.Count
        PerDay     = [math]::Round($_.Count / $days, 1)
        Noise      = $noise
        NoisePct   = $pct
        Recommend  = $rec
    }
} | Sort-Object Noise -Descending

$total = $tickets.Count
$totalNoise = ($report | Measure-Object Noise -Sum).Sum
$tunable = ($report | Where-Object NoisePct -ge $NoiseThresholdPct | Measure-Object Noise -Sum).Sum

$report | Format-Table -AutoSize -Wrap
Write-Host ("{0} tickets over {1:N0} days. {2} ({3:N0}%) closed with no action." -f $total, $days, $totalNoise, (100 * $totalNoise / $total))
Write-Host ("Tuning the alerts marked 'Tune' would remove up to {0} tickets ({1:N0}% of volume)." -f $tunable, (100 * $tunable / $total))

if ($OutCsv) { $report | Export-Csv -LiteralPath $OutCsv -NoTypeInformation }
exit 0
