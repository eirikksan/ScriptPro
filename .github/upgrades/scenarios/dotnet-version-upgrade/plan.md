# .NET 10 and Visual Studio 2026 Upgrade Plan

## Overview

**Target**: .NET 10 Windows desktop and Visual Studio 2026 compatibility.
**Scope**: Two assessed desktop projects, approximately 7,294 lines of code, plus WiX setup/build integration.

### Selected Strategy
**All-At-Once** — All projects upgraded simultaneously in a single operation.
**Rationale**: Two SDK-style .NET 8 projects with a single dependency edge and no reported NuGet dependencies.

Projects in the atomic upgrade: `DrawingListUC/DrawingListUC.csproj` (Windows Forms library), `ScriptUI/ScriptUI.csproj` (WPF application), and associated `ScriptProSetup/ScriptProSetup.wixproj` tooling.

## Tasks

### 01-toolchain: Verify SDK and setup toolchain prerequisites

Verify the installed .NET 10 SDK, SDK selection files, solution configuration, and Visual Studio 2026 build tooling. Inspect the WiX project excluded from the managed assessment, including its imports, extensions, payload, and available build support. Identify test projects and establish the baseline build so existing failures are not mistaken for new framework regressions.

The assessment proposes an invalid `net10.0--windows` moniker for the library; execution must instead use `net10.0-windows`. Preserve Windows desktop support and investigate the broad desktop API flags rather than assuming thousands of API replacements are necessary.

**Done when**: Toolchain and baseline findings are recorded, SDK selection supports .NET 10, and any missing prerequisites or installer decisions are resolved or explicitly reported as blocking.

---

### 02-desktop-and-setup: Upgrade the desktop solution and installer integration

Retarget DrawingListUC and ScriptUI together to `net10.0-windows`, preserving WPF/WinForms behavior and existing application configuration. Resolve actual compiler/API compatibility issues and warnings, checking the assessment's configuration and behavioral flags against source and build results. Inspect related runtime, deployment, and build references so old framework paths do not remain in active configuration.

Modernize the WiX setup/build integration as needed for Visual Studio 2026 and the .NET 10 application payload. Preserve installer identity and functionality; pause if missing tools or an installer migration requires an unresolved user decision. Document any external prerequisites rather than silently excluding the installer from validation.

**Done when**: Both managed projects target .NET 10 Windows, affected projects build warning-free, installer integration is aligned and validated where supported, and confirmed API changes are resolved without stubs.

---

### 03-validation: Validate the upgraded solution

Validate the entire solution and relevant build configurations, run discovered tests, and inspect package/dependency compatibility and deployment output. Check that installer payload includes the necessary .NET application artifacts and document external runtime/tooling prerequisites and non-automated desktop or AutoCAD integration checks that cannot be exercised here.

Review the final diff, record build/test results and any accepted limitations, and commit the atomic upgrade. Do not claim runtime or installer validation that was not performed.

**Done when**: Full build and available tests pass, warnings are resolved in modified projects, remaining external validation limitations are explicitly recorded, and the upgrade is committed on the working branch.
