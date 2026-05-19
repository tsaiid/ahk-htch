[CmdletBinding()]
param(
    [string[]]$Path
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Resolve-AbsolutePath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $repoRoot $Path))
}

function ConvertTo-RepoRelativePath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $absolutePath = Resolve-AbsolutePath $Path
    $repoUri = New-Object System.Uri((Resolve-AbsolutePath $repoRoot) + [System.IO.Path]::DirectorySeparatorChar)
    $pathUri = New-Object System.Uri($absolutePath)
    $relativePath = [System.Uri]::UnescapeDataString($repoUri.MakeRelativeUri($pathUri).ToString())
    return $relativePath.Replace("/", "\")
}

function Get-ChangedRepoFiles {
    $statusLines = @(git status --porcelain=v1 --untracked-files=all)
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to read git status."
    }

    $changedFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($line in $statusLines) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.Length -lt 4) {
            continue
        }

        $pathText = $line.Substring(3).Trim()
        if ($pathText.Contains(" -> ")) {
            $pathText = ($pathText -split ' -> ')[-1]
        }

        if ($pathText.Length -ge 2 -and $pathText.StartsWith('"') -and $pathText.EndsWith('"')) {
            $pathText = $pathText.Substring(1, $pathText.Length - 2)
            $pathText = $pathText.Replace('\"', '"').Replace('\\', '\')
        }

        if ([string]::IsNullOrWhiteSpace($pathText)) {
            continue
        }

        $changedFiles.Add((ConvertTo-RepoRelativePath $pathText)) | Out-Null
    }

    return @($changedFiles)
}

function Convert-TextFileToCrlf {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $absolutePath = Resolve-AbsolutePath $Path
    $bytes = [System.IO.File]::ReadAllBytes($absolutePath)
    $hasUtf8Bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $text = [System.IO.File]::ReadAllText($absolutePath)
    $normalizedText = $text -replace "`r`n|`n|`r", "`r`n"

    if ($normalizedText -eq $text) {
        return $false
    }

    $encoding = [System.Text.UTF8Encoding]::new($hasUtf8Bom)
    [System.IO.File]::WriteAllText($absolutePath, $normalizedText, $encoding)
    return $true
}

if ($Path.Count -gt 0) {
    $candidateFiles = @($Path | ForEach-Object { ConvertTo-RepoRelativePath $_ })
} else {
    $candidateFiles = Get-ChangedRepoFiles
}

$scriptFiles = @(
    $candidateFiles |
        Where-Object { $_ -match '\.(ahk|ps1)$' } |
        Sort-Object -Unique
)

if ($scriptFiles.Count -eq 0) {
    Write-Host "No changed AHK or PowerShell files to normalize."
    exit 0
}

$normalizedFiles = [System.Collections.Generic.List[string]]::new()

foreach ($scriptFile in $scriptFiles) {
    $absolutePath = Resolve-AbsolutePath $scriptFile
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        continue
    }

    if (Convert-TextFileToCrlf -Path $absolutePath) {
        $normalizedFiles.Add($scriptFile)
    }
}

if ($normalizedFiles.Count -gt 0) {
    Write-Host "Normalized CRLF line endings:"
    foreach ($normalizedFile in $normalizedFiles) {
        Write-Host "  - $normalizedFile"
    }
} else {
    Write-Host "AHK and PowerShell line endings already normalized."
}
