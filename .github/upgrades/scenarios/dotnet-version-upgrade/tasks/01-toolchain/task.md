# 01-toolchain: Verify SDK and setup toolchain prerequisites

Verify the installed .NET 10 SDK, SDK selection files, solution configuration, and Visual Studio 2026 build tooling. Inspect the WiX project excluded from the managed assessment, including its imports, extensions, payload, and available build support. Identify test projects and establish the baseline build so existing failures are not mistaken for new framework regressions.

The assessment proposes an invalid `net10.0--windows` moniker for the library; execution must instead use `net10.0-windows`. Preserve Windows desktop support and investigate the broad desktop API flags rather than assuming thousands of API replacements are necessary.

**Done when**: Toolchain and baseline findings are recorded, SDK selection supports .NET 10, and any missing prerequisites or installer decisions are resolved or explicitly reported as blocking.

## Scope Inventory
- Two managed projects plus SDK-style WiX 6.0.2 setup; no application edits in this research task.
- Concerns: SDK/toolchain, baseline build, installer payload/build mapping, available tests.
- Assessment: DrawingListUC has 3,045 API flags; ScriptUI has 121; no reported NuGet dependencies. Preserve Windows desktop TFMs.
- Building-projects, managing-target-frameworks, modifying-project-properties, and common breakdown guidance loaded. No prerequisite decomposition needed.

## Research Findings
- Installed SDKs include 10.0.401 and 8.0.425; Windows Desktop runtime 10.0.12 is installed. No global.json or tracked Directory.Build files.
- VS 2026 MSBuild is available through VSINSTALLDIR. Prefer IDE builds; use this full MSBuild with /restore for setup and x64 release validation.
- Both managed projects set net8.0-windows directly, use LangVersion latest and Nullable disable. ScriptUI references DrawingListUC; existing Source/ projects are not in this solution.
- Baseline IDE Debug Any CPU build succeeded with ten CS8632 warnings in DrawingListUC/AcadComUtils.cs. These must be fixed when that project is upgraded.
- WiX SDK and NetFx extension 6.0.2 restore successfully. No WiX major-version migration is necessary. The solution currently maps setup to x86 and omits it from x64 builds; Product.wxs uses net8.0-windows paths and an OS-only condition falsely labeled runtime detection.
- Build.ps1 and .github/workflows/build-msi.yml hardcode .NET 8. README, Modern.Help.html, and TestFiles/TEST_CASE.md contain active runtime/build instructions needing alignment.
- Test discovery and execution found no automated tests (0 run). CONTRIBUTING.md requires evidence for AutoCAD/manual scenarios in TestFiles/TEST_CASE.md; do not claim those passed without execution logs.
