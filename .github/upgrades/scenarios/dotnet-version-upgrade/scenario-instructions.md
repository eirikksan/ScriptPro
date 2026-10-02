# .NET Version Upgrade

## Preferences
- **Flow Mode**: Automatic
- **Commit Strategy**: Single Commit at End
- **Target Framework**: net10.0
- **Solution**: ScriptProPlus.sln
- **Scope**: Upgrade solution to .NET 10 and modernize for Visual Studio 2026 compatibility, including checking WiX setup and build tooling.

## Source Control
- **Source Branch**: master
- **Working Branch**: upgrade-dotnet-10
- **Pending Changes**: Confirmed commit of four existing UpgradeLog HTML files before branching; completed.
- **Commit Strategy**: After Each Task
- **Execution Commit Override**: Single Commit at End, selected during All-at-Once planning.
- **Branch Sync**: Auto (Merge)

## Key Decisions Log
- User confirmed target .NET 10, solution scope, Visual Studio 2026 compatibility, Automatic flow, and proposed source-control settings.
- User confirmed All-at-Once strategy and Fix Inline API handling.

## Upgrade Options
**Source**: .github/upgrades/scenarios/dotnet-version-upgrade/upgrade-options.md

### Strategy
- Upgrade Strategy: All-at-Once

### Compatibility
- Unsupported API Handling: Fix Inline

## Strategy
**Selected**: All-at-Once
**Rationale**: Two SDK-style .NET 8 desktop projects with one project reference and no reported package dependencies.

### Execution Constraints
- Update both desktop projects together to net10.0-windows; retain WPF and Windows Forms support.
- Inspect WiX setup tooling and align installer payload with the upgraded application; do not treat wixproj as a .NET application.
- Restore dependencies after project updates and fix confirmed API issues inline without stubs.
- Validate the full solution with zero errors and resolve warnings in modified projects before completion.
- Run available tests after the atomic upgrade; commit the validated upgrade once at the end.

## Build Tool Decisions
- **Managed desktop projects**: Prefer IDE build; use full Visual Studio MSBuild with /restore for configuration-specific WPF/WinForms validation.
- **ScriptProSetup.wixproj**: Existing WixToolset.Sdk 6.0.2 and NetFx extension restore under Visual Studio 2026 MSBuild; retain this toolset unless a verified incompatibility requires a change.
- **Historical Source projects**: Not part of ScriptProPlus.sln; preserve them unchanged.
