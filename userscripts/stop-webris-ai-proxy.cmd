@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop-webris-ai-proxy.ps1"

endlocal
