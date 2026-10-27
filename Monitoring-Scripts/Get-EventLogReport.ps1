<#
.SYNOPSIS
    Summarises Critical and Error events from the System and Application logs.

.DESCRIPTION
    Pulls Critical (level 1) and Error (level 2) events from the last N hours,
    groups them by log, source and event ID, and shows the most frequent first.
    That is the first question in a problem investigation: what keeps failing,
    since when, and how often?

.EXAMPLE
    .\Get-EventLogReport.ps1 -Hours 24
.EXAMPLE
    .\Get-EventLogReport.ps1 -Hours 72 -Top 20 -OutCsv .\reports\events.csv
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 720)]
    [int]$Hours = 24,

    [ValidateRange(1, 200)]
    [int]$Top = 15,

    [string[]]$LogName = @('System', 'Application'),

    [string]$OutCsv
)

$since = (Get-Date).AddHours(-$Hours)
$events = foreach ($log in $LogName) {
    try {
        Get-WinEvent -FilterHashtable @{ LogName = $log; Level = 1, 2; StartTime = $since } -ErrorAction Stop
    } catch [System.Exception] {
        if ($_.Exception.Message -notmatch 'No events were found') {
            Write-Warning "Could not read ${log}: $($_.Exception.Message)"
        }
    }
}

if (-not $events) {
    Write-Host "No Critical or Error events in the last $Hours hour(s)."
    exit 0
}

$summary = $events |
    Group-Object LogName, ProviderName, Id |
    ForEach-Object {
        $first = $_.Group | Sort-Object TimeCreated | Select-Object -First 1
        $last  = $_.Group | Sort-Object TimeCreated | Select-Object -Last 1
        [pscustomobject]@{
            Count     = $_.Count
            Log       = $first.LogName
            Source    = $first.ProviderName
            EventId   = $first.Id
            Level     = $first.LevelDisplayName
            FirstSeen = $first.TimeCreated
            LastSeen  = $last.TimeCreated
            Message   = (($last.Message -split "`r?`n")[0]).Trim()
        }
    } |
    Sort-Object Count -Descending |
    Select-Object -First $Top

Write-Host ("{0} Critical/Error event(s) in the last {1} hour(s); top {2} groups:" -f $events.Count, $Hours, $summary.Count)
$summary | Format-Table Count, Log, Source, EventId, Level, LastSeen, Message -AutoSize -Wrap

if ($OutCsv) {
    $dir = Split-Path -Parent $OutCsv
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $summary | Export-Csv -LiteralPath $OutCsv -NoTypeInformation
}
exit 0
