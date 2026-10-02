# 02-desktop-and-setup: Upgrade the desktop solution and installer integration

Retarget DrawingListUC and ScriptUI together to `net10.0-windows`, preserving WPF/WinForms behavior and existing application configuration. Resolve actual compiler/API compatibility issues and warnings, checking the assessment's configuration and behavioral flags against source and build results. Inspect related runtime, deployment, and build references so old framework paths do not remain in active configuration.

Modernize the WiX setup/build integration as needed for Visual Studio 2026 and the .NET 10 application payload. Preserve installer identity and functionality; pause if missing tools or an installer migration requires an unresolved user decision. Document any external prerequisites rather than silently excluding the installer from validation.

**Done when**: Both managed projects target .NET 10 Windows, affected projects build warning-free, installer integration is aligned and validated where supported, and confirmed API changes are resolved without stubs.

## Scope Inventory and Research
- Managed concern: DrawingListUC and ScriptUI retargeted together. Dependency inspection found no local imported property overrides or package references; TargetFramework lives in each csproj. Preserve existing LangVersion latest (already using the installed compiler) and disabled project-wide nullability; avoid unrelated syntax refactors.
- Queried summary and issues for both managed projects. DrawingListUC flags ApplicationSettingsBase, System.Drawing and WinForms APIs; ScriptUI flags WPF/WinForms and generated App.g.i.cs relative StartupUri System.Uri usage. Regenerate outputs on net10.0-windows and verify actual compilation/runtime rather than edit generated source or replace supported APIs.
- Baseline CS8632 warnings are confined to AcadComUtils.cs existing nullable annotations. Supply a local annotation context without changing project-wide analysis policy or suppressing diagnostics.
- Setup concern: WiX 6.0.2 SDK and NetFx extension restore successfully. Product.wxs needs new payload paths and real x64 desktop-runtime detection. Solution x64 configuration must build setup after ScriptUI; preserve product upgrade/component identifiers. Verify payload and use actual ICO instead of PNG for installer icon.
- Build.ps1 needs .NET 10 output paths, dependable VS MSBuild discovery and native-command failure checks; workflow SDK/toolchain and active README/help/test instructions must match. Historical Source projects and historical release notes remain untouched.
- No automated tests discovered. Manual AutoCAD testing requires the TestFiles contract and external application/data prerequisites.

## Execution Breakdown
Split into an atomic managed retarget/warning fix and installer/build integration because these require distinct validation and tooling context. Both managed projects stay together. No incompatible package replacement batch or managed three-project dependency hint applies.
