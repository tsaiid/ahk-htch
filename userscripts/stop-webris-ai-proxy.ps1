param(
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalConfig = Join-Path $ScriptDir "webris-ai-proxy.local.ps1"

$explicitPort = $PSBoundParameters.ContainsKey("Port")
if (-not $explicitPort -and (Test-Path -LiteralPath $LocalConfig)) {
    . $LocalConfig
}

$connections = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort $Port -State Listen -ErrorAction SilentlyContinue

if (-not $connections) {
    Write-Host "WebRIS AI proxy is not running on http://127.0.0.1:$Port"
    exit 0
}

$processIds = $connections | Select-Object -ExpandProperty OwningProcess -Unique
$stoppedCount = 0

foreach ($processId in $processIds) {
    $procInfo = Get-CimInstance Win32_Process -Filter "ProcessId = $processId" -ErrorAction SilentlyContinue
    if (-not $procInfo) {
        continue
    }

    $cmdLine = [string]$procInfo.CommandLine
    if ($procInfo.Name -notmatch '^node(\.exe)?$' -or $cmdLine -notmatch 'webris-ai-proxy\.js') {
        Write-Warning "Skipping process $processId ($($procInfo.Name)) on port ${Port}: does not appear to be webris-ai-proxy.js."
        continue
    }

    Write-Host "Stopping WebRIS AI proxy process $processId ($($procInfo.Name))"
    Stop-Process -Id $processId
    $stoppedCount++
}

if ($stoppedCount -gt 0) {
    Write-Host "WebRIS AI proxy stopped."
} else {
    Write-Host "No WebRIS AI proxy process was stopped on http://127.0.0.1:$Port"
}
