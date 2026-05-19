param(
    [string]$ApiKey = "",
    [string]$Model = "gemma-4-31b-it",
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProxyScript = Join-Path $ScriptDir "webris-ai-proxy.js"
$LocalConfig = Join-Path $ScriptDir "webris-ai-proxy.local.ps1"

if (Test-Path -LiteralPath $LocalConfig) {
    . $LocalConfig
}

if ($ApiKey) {
    $env:GOOGLE_AI_API_KEY = $ApiKey
}

if (-not $env:GOOGLE_AI_API_KEY -and -not $env:GEMINI_API_KEY) {
    throw @"
Missing Google AI API key.

Create $LocalConfig with:
`$ApiKey = "your-api-key"

Or set one of these environment variables before running:
`$env:GOOGLE_AI_API_KEY = "your-api-key"
`$env:GEMINI_API_KEY = "your-api-key"
"@
}

$env:WEBRIS_AI_GOOGLE_MODEL = $Model
$env:WEBRIS_AI_PROXY_PORT = [string]$Port

$healthUrl = "http://127.0.0.1:$Port/health"
try {
    $health = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 1
    if ($health.ok) {
        Write-Host "WebRIS AI proxy is already running on http://127.0.0.1:$Port"
        Write-Host "Model: $($health.model)"
        exit 0
    }
} catch {
}

Write-Host "Starting WebRIS AI proxy on http://127.0.0.1:$Port"
Write-Host "Model: $Model"

node $ProxyScript
