[CmdletBinding()]
param(
    [string]$Entry,
    [switch]$Compile,
    [string]$AhkExe = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe",
    [string]$AhkCompiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe",
    [string]$OutputDir
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$entryList = @(
    "AutoHotkey.v2.ahk"
)

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

function Resolve-IncludePath {
    param(
        [Parameter(Mandatory)]
        [string]$IncludeSpec,
        [Parameter(Mandatory)]
        [string]$SourceFile
    )

    $token = $IncludeSpec.Trim()
    if ([string]::IsNullOrWhiteSpace($token)) {
        return $null
    }

    if ($token -match '^\*i\s+(.+)$') {
        $token = $Matches[1].Trim()
    }

    $candidatePaths = [System.Collections.Generic.List[string]]::new()

    if ($token.StartsWith("<") -and $token.EndsWith(">")) {
        $libToken = $token.Substring(1, $token.Length - 2)
        $candidatePaths.Add((Join-Path $repoRoot ("Lib\" + $libToken)))
        $candidatePaths.Add((Join-Path $repoRoot ("Lib\" + $libToken + ".ahk")))
        $candidatePaths.Add((Join-Path $repoRoot $libToken))
        $candidatePaths.Add((Join-Path $repoRoot ($libToken + ".ahk")))
    } else {
        $trimmed = $token.Trim('"')
        $sourceDir = Split-Path -Parent $SourceFile

        if ([System.IO.Path]::IsPathRooted($trimmed)) {
            $candidatePaths.Add($trimmed)
        } else {
            $candidatePaths.Add((Join-Path $sourceDir $trimmed))
        }
    }

    foreach ($candidatePath in $candidatePaths) {
        $fullPath = [System.IO.Path]::GetFullPath($candidatePath)
        if (Test-Path -LiteralPath $fullPath) {
            return $fullPath
        }
    }

    return $null
}

function Get-DirectIncludes {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    $includes = [System.Collections.Generic.List[string]]::new()

    foreach ($line in Get-Content -LiteralPath $FilePath) {
        $trimmed = $line.Trim()
        if ($trimmed.StartsWith(";")) {
            continue
        }

        if ($trimmed -match '^\s*#Include\b\s*(.+?)\s*$') {
            $includeSpec = $Matches[1].Trim()
            $resolvedInclude = Resolve-IncludePath -IncludeSpec $includeSpec -SourceFile $FilePath
            if ($null -ne $resolvedInclude) {
                $includes.Add($resolvedInclude)
            }
        }
    }

    return $includes
}

function Get-EntryDependencyClosure {
    param(
        [Parameter(Mandatory)]
        [string]$EntryPath
    )

    $visited = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $pending = [System.Collections.Generic.Queue[string]]::new()
    $pending.Enqueue($EntryPath)

    while ($pending.Count -gt 0) {
        $currentPath = $pending.Dequeue()
        if (-not $visited.Add($currentPath)) {
            continue
        }

        foreach ($includePath in Get-DirectIncludes -FilePath $currentPath) {
            if (-not $visited.Contains($includePath)) {
                $pending.Enqueue($includePath)
            }
        }
    }

    return $visited
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

function Get-SelectedEntries {
    param(
        [string]$RequestedEntry
    )

    if (-not [string]::IsNullOrWhiteSpace($RequestedEntry)) {
        $requestedRelative = ConvertTo-RepoRelativePath $RequestedEntry
        foreach ($knownEntry in $entryList) {
            if ($knownEntry -ieq $requestedRelative) {
                return @($knownEntry)
            }
        }

        throw "Unknown entry: $RequestedEntry"
    }

    $changedFiles = Get-ChangedRepoFiles
    if ($changedFiles.Count -eq 0) {
        Write-Host "No changed files detected. Validating all entries."
        return @($entryList)
    }

    Write-Host "Changed files:"
    foreach ($changedFile in $changedFiles) {
        Write-Host "  - $changedFile"
    }

    $entryDependencyMap = @{}
    foreach ($knownEntry in $entryList) {
        $entryPath = Resolve-AbsolutePath $knownEntry
        $dependencySet = Get-EntryDependencyClosure -EntryPath $entryPath

        $relativeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($dependencyPath in $dependencySet) {
            $relativeSet.Add((ConvertTo-RepoRelativePath $dependencyPath)) | Out-Null
        }

        $entryDependencyMap[$knownEntry] = $relativeSet
    }

    $selectedEntries = [System.Collections.Generic.List[string]]::new()
    $hasUnknownImpact = $false

    foreach ($changedFile in $changedFiles) {
        $matchedEntry = $false

        foreach ($knownEntry in $entryList) {
            if ($entryDependencyMap[$knownEntry].Contains($changedFile)) {
                if (-not $selectedEntries.Contains($knownEntry)) {
                    $selectedEntries.Add($knownEntry)
                }
                $matchedEntry = $true
            }
        }

        if (-not $matchedEntry) {
            Write-Host "Changed file is outside known entry dependency graph: $changedFile"
            $hasUnknownImpact = $true
        }
    }

    if ($hasUnknownImpact -or $selectedEntries.Count -eq 0) {
        Write-Host "Falling back to validating all entries."
        return @($entryList)
    }

    return @($selectedEntries)
}

function New-ValidationWrapper {
    param(
        [Parameter(Mandatory)]
        [string]$EntryPath
    )

    $wrapperName = ".compile-check.{0}.{1}.ahk" -f [System.IO.Path]::GetFileNameWithoutExtension($EntryPath), [System.Guid]::NewGuid().ToString("N")
    $wrapperPath = Join-Path $repoRoot $wrapperName
    $escapedEntryPath = $EntryPath.Replace('"', '""')

    $wrapperContent = @(
        "#Requires AutoHotkey v2.0"
        "#Warn All, StdOut"
        "#ErrorStdOut"
        ('#Include "{0}"' -f $escapedEntryPath)
    )

    Set-Content -LiteralPath $wrapperPath -Value $wrapperContent -Encoding ascii
    return $wrapperPath
}

function Invoke-Validation {
    param(
        [Parameter(Mandatory)]
        [string]$EntryPath
    )

    $wrapperPath = New-ValidationWrapper -EntryPath $EntryPath

    try {
        Write-Host "Validating $EntryPath"
        $stdoutPath = Join-Path $env:TEMP ("ahk-validate-stdout-" + [System.Guid]::NewGuid().ToString("N") + ".log")
        $stderrPath = Join-Path $env:TEMP ("ahk-validate-stderr-" + [System.Guid]::NewGuid().ToString("N") + ".log")

        $validateProcess = Start-Process `
            -FilePath $AhkExe `
            -ArgumentList "/Validate", $wrapperPath `
            -RedirectStandardOutput $stdoutPath `
            -RedirectStandardError $stderrPath `
            -Wait `
            -PassThru `
            -NoNewWindow

        $validateExitCode = $validateProcess.ExitCode
        $rawOutput = @()

        if (Test-Path -LiteralPath $stdoutPath) {
            $rawOutput += @(Get-Content -LiteralPath $stdoutPath)
        }

        if (Test-Path -LiteralPath $stderrPath) {
            $rawOutput += @(Get-Content -LiteralPath $stderrPath)
        }

        foreach ($line in $rawOutput) {
            Write-Host $line
        }

        $validationText = ($rawOutput -join [Environment]::NewLine)
        $hasValidationError = $validationText -match '(^|\r?\n)\s*Error:'

        if ($validateExitCode -ne 0 -or $hasValidationError) {
            Write-Host "Validation failed with exit code $validateExitCode"
            exit ([Math]::Max($validateExitCode, 1))
        }

        Write-Host "Validation passed."
    } finally {
        if ($stdoutPath -and (Test-Path -LiteralPath $stdoutPath)) {
            Remove-Item -LiteralPath $stdoutPath -Force
        }

        if ($stderrPath -and (Test-Path -LiteralPath $stderrPath)) {
            Remove-Item -LiteralPath $stderrPath -Force
        }

        if (Test-Path -LiteralPath $wrapperPath) {
            Remove-Item -LiteralPath $wrapperPath -Force
        }
    }
}

function Invoke-Compile {
    param(
        [Parameter(Mandatory)]
        [string]$EntryPath
    )

    $outputExe = Join-Path $OutputDir (([System.IO.Path]::GetFileNameWithoutExtension($EntryPath)) + ".exe")

    Write-Host "Compiling to $outputExe"
    $compileProcess = Start-Process -FilePath $AhkCompiler -ArgumentList "/in", $EntryPath, "/out", $outputExe -Wait -PassThru
    $compileExitCode = $compileProcess.ExitCode

    if ($compileExitCode -ne 0) {
        Write-Host "Compile failed with exit code $compileExitCode"
        exit $compileExitCode
    }

    Write-Host "Compile passed."
    Write-Host "Output: $outputExe"
}

function Resolve-ToolPath {
    param(
        [Parameter(Mandatory)]
        [string]$ConfiguredPath,
        [Parameter(Mandatory)]
        [string[]]$CommandNames,
        [string[]]$FallbackPaths = @()
    )

    if (Test-Path -LiteralPath $ConfiguredPath) {
        return $ConfiguredPath
    }

    foreach ($commandName in $CommandNames) {
        $command = Get-Command $commandName -ErrorAction SilentlyContinue
        if ($command -and (Test-Path -LiteralPath $command.Source)) {
            return $command.Source
        }
    }

    foreach ($fallbackPath in $FallbackPaths) {
        if (Test-Path -LiteralPath $fallbackPath) {
            return $fallbackPath
        }
    }

    return $ConfiguredPath
}

$AhkExe = Resolve-ToolPath `
    -ConfiguredPath $AhkExe `
    -CommandNames @("AutoHotkey64.exe", "AutoHotkey.exe") `
    -FallbackPaths @(
        "F:\Apps\Scoop\apps\autohotkey\current\v2\AutoHotkey64.exe",
        "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"
    )

$AhkCompiler = Resolve-ToolPath `
    -ConfiguredPath $AhkCompiler `
    -CommandNames @("Ahk2Exe.exe") `
    -FallbackPaths @(
        "F:\Apps\Scoop\apps\autohotkey\current\Compiler\Ahk2Exe.exe",
        "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe",
        "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
    )

if (-not (Test-Path -LiteralPath $AhkExe)) {
    Write-Error "AutoHotkey executable not found: $AhkExe"
}

$selectedEntries = Get-SelectedEntries -RequestedEntry $Entry
Write-Host "Selected entries:"
foreach ($selectedEntry in $selectedEntries) {
    Write-Host "  - $selectedEntry"
}

foreach ($selectedEntry in $selectedEntries) {
    $entryPath = Resolve-AbsolutePath $selectedEntry
    if (-not (Test-Path -LiteralPath $entryPath)) {
        Write-Error "Entry script not found: $entryPath"
    }

    Invoke-Validation -EntryPath $entryPath
}

if (-not $Compile) {
    exit 0
}

if (-not (Test-Path -LiteralPath $AhkCompiler)) {
    Write-Error "AHK compiler not found: $AhkCompiler"
}

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $env:TEMP ("ahk-compile-check-" + [DateTime]::Now.ToString("yyyyMMdd-HHmmss"))
}

$OutputDir = [System.IO.Path]::GetFullPath($OutputDir)
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

foreach ($selectedEntry in $selectedEntries) {
    $entryPath = Resolve-AbsolutePath $selectedEntry
    Invoke-Compile -EntryPath $entryPath
}

exit 0
