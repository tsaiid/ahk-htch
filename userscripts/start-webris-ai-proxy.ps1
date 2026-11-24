param(
    [string]$ApiKey = "",
    [string]$Model = "gemma-4-31b-it",
    [string]$FallbackModels = "gemini-2.5-flash-lite,gemini-2.5-flash",
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProxyScript = Join-Path $ScriptDir "webris-ai-proxy.js"
$LocalConfig = Join-Path $ScriptDir "webris-ai-proxy.local.ps1"

$explicitApiKey = $PSBoundParameters.ContainsKey("ApiKey")
$explicitModel = $PSBoundParameters.ContainsKey("Model")
$explicitFallbackModels = $PSBoundParameters.ContainsKey("FallbackModels")
$explicitPort = $PSBoundParameters.ContainsKey("Port")

$cliApiKey = $ApiKey
$cliModel = $Model
$cliFallbackModels = $FallbackModels
$cliPort = $Port

if (Test-Path -LiteralPath $LocalConfig) {
    . $LocalConfig
}

if ($explicitApiKey) { $ApiKey = $cliApiKey }
if ($explicitModel) { $Model = $cliModel }
if ($explicitFallbackModels) { $FallbackModels = $cliFallbackModels }
if ($explicitPort) { $Port = $cliPort }

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js ('node') was not found in PATH. Please install Node.js first."
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
$env:WEBRIS_AI_FALLBACK_MODELS = $FallbackModels

$healthUrl = "http://127.0.0.1:$Port/health"
try {
    $health = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 1
    if ($health.ok) {
        Write-Host "WebRIS AI proxy is already running on http://127.0.0.1:$Port"
        Write-Host "Model: $($health.model)"
        if ($health.model -ne $Model) {
            Write-Warning "Running proxy uses model '$($health.model)', which differs from requested '$Model'. Stop it first to apply the new model."
        }
        if (-not $health.hasApiKey) {
            Write-Warning "Running proxy reports hasApiKey=false. Stop and restart it with a valid API key."
        }
        exit 0
    }
} catch {
}

Write-Host "Starting WebRIS AI proxy on http://127.0.0.1:$Port"
Write-Host "Model: $Model"
if ($env:WEBRIS_AI_FALLBACK_MODELS) {
    Write-Host "Fallback models: $env:WEBRIS_AI_FALLBACK_MODELS"
}

node $ProxyScript
