# 02.02-setup: Align WiX installer and build workflow with .NET 10 and VS 2026

# Setup and build integration

## Objective
Align WiX payload, runtime requirement, solution platform/dependency mappings, build script, CI and active documentation with the upgraded application.

## Research
Existing WixToolset.Sdk and NetFx extension 6.0.2 restore on VS 2026. Retain versions. Product.wxs incorrectly checks VersionNT instead of runtime and uses net8.0-windows payload paths. Setup solution mappings use x86 and omit x64 builds. Build.ps1 relies on msbuild on PATH and .NET 8 paths. Preserve existing installer identities; verify runtime detection API before editing. README/help/test instructions must reflect .NET 10.

## Verified Implementation Details
- FireGiant DotNetCompatibilityCheck schema confirms RuntimeType=desktop, Platform=x64, Version=10.0.0, RollForward=latestMinor and result property string 0 for success; this matches the generated runtimeconfig LatestMinor policy. Require an explicit successful check for new installs, allowing maintenance/uninstall via Installed.
- Use a WiX ProjectReference to ScriptUI to establish build order and its TargetDir preprocessor variable for payload paths; avoid repeated hardcoded framework directories. Preserve component GUIDs and upgrade code. Use ScriptPro3.ico for ARP icon rather than the existing PNG.
- GitHub actions/runner-images README currently lists windows-2025-vs2026; use that explicit image and request MSBuild [18.0,19.0), .NET SDK 10.0.x.
- Build.ps1 will locate full VS MSBuild using VSINSTALLDIR, then vswhere, validate version 18+, and use /restore with fail-fast exit checking. Preserve framework-dependent portable packaging semantics.
- Managed output inventory includes both assemblies/configs, deps/runtimeconfig, help and images. No additional NuGet runtime payload found.

**Done when**: x64 solution and installer build warning-free, installer files and runtime check are verified, Build.ps1 produces expected packages, and documentation identifies VS 2026/.NET 10 prerequisites and remaining manual tests.
