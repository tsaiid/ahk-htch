param(
    [int]$Port = 8787,
    [string]$Text = "",
    [switch]$HealthOnly,
    [switch]$Json,
    [int]$TimeoutMs = 60000
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TestScript = Join-Path $ScriptDir "test-webris-ai-proxy.js"
$LocalConfig = Join-Path $ScriptDir "webris-ai-proxy.local.ps1"

$portExplicit = $PSBoundParameters.ContainsKey("Port")
if (-not $portExplicit -and (Test-Path -LiteralPath $LocalConfig)) {
    . $LocalConfig
}

$nodeArgs = @($TestScript, "--port", [string]$Port, "--timeout", [string]$TimeoutMs)

if ($Text) {
    $nodeArgs += @("--text", $Text)
}
if ($HealthOnly) {
    $nodeArgs += "--health-only"
}
if ($Json) {
    $nodeArgs += "--json"
}

node @nodeArgs
exit $LASTEXITCODE
