# Setup and Build Integration Results

- Retained WiX SDK/NetFx 6.0.2, verified on Visual Studio 2026. Added ScriptUI project reference and used its TargetDir for payload binding.
- Corrected solution configuration so Debug/Release x64 build setup; Any CPU/x86 aliases do not attempt an x86 installer. Editor tools could not edit the solution file; applied exact mappings through a bounded text replacement.
- Added x64 .NET 10 desktop compatibility check with latestMinor roll-forward. MSI inspection confirms custom action Wix4NetFxDotNetCompatibilityCheck_X64 at sequence 99, before LaunchConditions at 100. New installs require explicit success; Installed permits maintenance/removal. Runtime-present/missing installation scenarios still require a test machine.
- Kept component GUIDs and UpgradeCode. Used the actual ICO resource; fixed pre-existing ICE69 by making the non-advertised shortcut target the application directory rather than a file in another component.
- Updated Build.ps1 to find VS 2026 MSBuild, use /restore, fail on native build errors or missing MSI, and resolve paths from PSScriptRoot. Exercised -Setup -Standalone: MSI and portable ZIP produced successfully.
- Full Release x64 solution /restore /t:Rebuild /warnaserror passed with both managed projects and MSI. MSI tables contain the two assemblies, deps/runtimeconfig/config files, README/help and images.
- CI now selects the verified windows-2025-vs2026 runner, MSBuild 18, and .NET 10 SDK. Hosted CI itself has not run locally.
- README, help runtime requirements and TestFiles/TEST_CASE.md point to .NET 10; historical release notes and historical Source projects are unchanged.
- Progress-view drift was traced to stale tasks.md entries; scenario.json taskStates correctly retained completed work. Reconciled only the derived view, never edited state JSON.
