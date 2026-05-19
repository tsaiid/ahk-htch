param(
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"

$connections = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort $Port -State Listen -ErrorAction SilentlyContinue

if (-not $connections) {
    Write-Host "WebRIS AI proxy is not running on http://127.0.0.1:$Port"
    exit 0
}

$processIds = $connections | Select-Object -ExpandProperty OwningProcess -Unique

foreach ($processId in $processIds) {
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    if (-not $process) {
        continue
    }

    Write-Host "Stopping WebRIS AI proxy process $processId ($($process.ProcessName))"
    Stop-Process -Id $processId
}

Write-Host "WebRIS AI proxy stopped."
