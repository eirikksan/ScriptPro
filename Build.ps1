# ScriptProPlus Build Script
# Usage:
#   .\Build.ps1                    # Build Debug x64 (default)
#   .\Build.ps1 -Release           # Build Release x64
#   .\Build.ps1 -Setup             # Build + Create MSI Installer
#   .\Build.ps1 -Standalone        # Create portable standalone package

param(
    [switch]$Release,
    [switch]$Setup,
    [switch]$Standalone
)

$ErrorActionPreference = "Stop"
$SolutionPath = Join-Path $PSScriptRoot "ScriptProPlus.sln"

# Use the Visual Studio toolchain for WPF/WinForms resources and WiX.
$MSBuildPath = $null
if ($env:VSINSTALLDIR) {
    $Candidate = Join-Path $env:VSINSTALLDIR "MSBuild\Current\Bin\MSBuild.exe"
    if (Test-Path $Candidate) { $MSBuildPath = $Candidate }
}
if (!$MSBuildPath) {
    $VsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $VsWhere) {
        $MSBuildPath = & $VsWhere -latest -products * -version '[18.0,19.0)' -requires Microsoft.Component.MSBuild -find 'MSBuild\Current\Bin\MSBuild.exe' | Select-Object -First 1
    }
}
if (!$MSBuildPath -or !(Test-Path $MSBuildPath)) {
    throw "Visual Studio 2026 (or Build Tools) with the .NET desktop development workload is required."
}
if ((Get-Item $MSBuildPath).VersionInfo.FileMajorPart -lt 18) {
    throw "Visual Studio 2026 MSBuild 18 or later is required."
}

# Determine configuration
$Config = if ($Release -or $Setup -or $Standalone) { "Release" } else { "Debug" }
$Platform = "x64"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ScriptProPlus Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuration: $Config"
Write-Host "Platform: $Platform"
Write-Host ""

# Restore and build with the same toolchain. The x64 solution includes the installer.
Write-Host "Restoring and building solution..." -ForegroundColor Yellow
& $MSBuildPath $SolutionPath /restore /p:Configuration=$Config /p:Platform=$Platform /t:Rebuild /m /v:minimal

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    throw "MSBuild exited with code $LASTEXITCODE."
}

Write-Host "Build successful!" -ForegroundColor Green
Write-Host ""

$OutputPath = Join-Path $PSScriptRoot "Binaries\$Platform\$Config\net10.0-windows"
$ReleasePath = Join-Path $PSScriptRoot "Release"
Write-Host "Output: $OutputPath" -ForegroundColor Green

# Create MSI Installer
if ($Setup) {
    Write-Host ""
    $MsiPath = Join-Path $PSScriptRoot "ScriptProSetup\bin\$Config\ScriptProSetup.msi"
    if (Test-Path $MsiPath) {
        Write-Host "Installer created: $MsiPath" -ForegroundColor Green
        
        # Copy to Release folder
        if (!(Test-Path $ReleasePath)) { New-Item -ItemType Directory -Path $ReleasePath | Out-Null }
        Copy-Item $MsiPath (Join-Path $ReleasePath "ScriptProSetup.msi") -Force
        Write-Host "Copied to: Release\ScriptProSetup.msi" -ForegroundColor Green
    } else {
        throw "Expected installer was not produced: $MsiPath"
    }
}

# Create Standalone Package
if ($Standalone) {
    Write-Host ""
    Write-Host "Creating standalone package..." -ForegroundColor Yellow
    
    $StandaloneDir = Join-Path $PSScriptRoot "Standalone\ScriptPro-Portable"
    if (Test-Path $StandaloneDir) {
        Remove-Item $StandaloneDir -Recurse -Force
    }
    
    New-Item -ItemType Directory -Path $StandaloneDir | Out-Null
    
    # Copy binaries
    Copy-Item "$OutputPath\*" $StandaloneDir -Recurse -Force
    
    # Copy README.md from root
    if (Test-Path (Join-Path $PSScriptRoot "README.md")) {
        Copy-Item (Join-Path $PSScriptRoot "README.md") $StandaloneDir -Force
    }
    
    Write-Host "Standalone package created: $StandaloneDir" -ForegroundColor Green
    
    # Create ZIP
    $ZipPath = Join-Path $ReleasePath "ScriptPro-Portable.zip"
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    
    # Create Release folder if needed
    if (!(Test-Path $ReleasePath)) { New-Item -ItemType Directory -Path $ReleasePath | Out-Null }
    
    Compress-Archive -Path "$StandaloneDir\*" -DestinationPath $ZipPath
    
    Write-Host "ZIP created: $ZipPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

