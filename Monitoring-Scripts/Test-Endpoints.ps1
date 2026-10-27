<#
.SYNOPSIS
    Checks DNS resolution and TCP port reachability for a list of endpoints.

.DESCRIPTION
    Reads a CSV with the columns Name, Host, Port. For each endpoint it resolves
    the host name, opens a TCP connection with a timeout, and measures the time
    taken. Prints an UP/DOWN table and returns exit code 0 when all endpoints are
    up, 1 when any is down, and 2 on bad input, so it can run from Task Scheduler
    or a monitoring agent.

.EXAMPLE
    .\Test-Endpoints.ps1 -Path .\endpoints.csv
.EXAMPLE
    .\Test-Endpoints.ps1 -Path .\endpoints.csv -TimeoutMs 1500 -OutCsv .\reports\endpoints.csv
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [ValidateRange(100, 30000)]
    [int]$TimeoutMs = 2000,

    [string]$OutCsv
)

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Error "Endpoint file not found: $Path"
    exit 2
}

$endpoints = Import-Csv -LiteralPath $Path
$required = 'Name', 'Host', 'Port'
$missing = $required | Where-Object { $_ -notin $endpoints[0].PSObject.Properties.Name }
if ($missing) {
    Write-Error "CSV is missing column(s): $($missing -join ', ')"
    exit 2
}

function Test-TcpPort {
    param([string]$HostName, [int]$Port, [int]$Timeout)
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $task = $client.ConnectAsync($HostName, $Port)
        return ($task.Wait($Timeout) -and $client.Connected)
    } catch {
        return $false
    } finally {
        $client.Dispose()
    }
}

$results = foreach ($ep in $endpoints) {
    $dns = 'OK'
    $ip = $null
    try {
        $ip = ([System.Net.Dns]::GetHostAddresses($ep.Host) |
               Where-Object AddressFamily -eq 'InterNetwork' |
               Select-Object -First 1).IPAddressToString
        if (-not $ip) { $dns = 'NO IPv4' }
    } catch {
        $dns = 'FAILED'
    }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $open = if ($dns -eq 'FAILED') { $false } else { Test-TcpPort -HostName $ep.Host -Port ([int]$ep.Port) -Timeout $TimeoutMs }
    $sw.Stop()

    [pscustomobject]@{
        Time     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        Name     = $ep.Name
        Host     = $ep.Host
        IP       = $ip
        Port     = [int]$ep.Port
        DNS      = $dns
        Status   = if ($open) { 'UP' } else { 'DOWN' }
        TimeMs   = if ($open) { $sw.ElapsedMilliseconds } else { $null }
    }
}

$results | Format-Table -AutoSize

if ($OutCsv) {
    $dir = Split-Path -Parent $OutCsv
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $results | Export-Csv -LiteralPath $OutCsv -NoTypeInformation -Append
}

$down = @($results | Where-Object Status -eq 'DOWN')
Write-Host ("{0} endpoint(s) checked, {1} down." -f $results.Count, $down.Count)
if ($down.Count -gt 0) { exit 1 } else { exit 0 }
