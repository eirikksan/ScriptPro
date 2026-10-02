# ScriptProPlus – .NET 10

ScriptProPlus targets **.NET 10 for Windows** and builds with **Visual Studio 2026**.
The existing out-of-process AutoCAD COM automation is retained. Validate your AutoCAD installation using `TestFiles\TEST_CASE.md` before deployment.

## Summary

*   Target framework: `net10.0-windows`
*   Projects converted to SDK-style format    
*   Compatible with AutoCAD 2025+ (64-bit)    
*   Existing functionality and COM automation preserved
    

## Projects

*   **DrawingListUC** – Windows Forms control library (.NET 10)
*   **ScriptUI** – WPF application (.NET 10)
*   **ScriptProSetup** – WiX-based installer (updated)
    

## Build

```powershell
.\Build.ps1                         # Debug x64, including MSI
.\Build.ps1 -Setup                  # Release x64; copies MSI to Release\
.\Build.ps1 -Standalone             # Release x64; framework-dependent portable ZIP
```

Or build `ScriptProPlus.sln` in **Visual Studio 2026**, using **Debug|x64** or **Release|x64**. Use full Visual Studio MSBuild for WPF/WinForms resources and WiX:

```powershell
msbuild ScriptProPlus.sln /restore /p:Configuration=Release /p:Platform=x64
```

Run the last command from a VS 2026 Developer PowerShell. `Build.ps1` locates MSBuild automatically. The installer builds after ScriptUI and consumes its output; Any CPU and x86 solution aliases build managed projects only.

## Requirements

### Development

*   Windows supported by .NET 10
*   Visual Studio 2026 or Build Tools 2026 with the **.NET desktop development** workload
*   .NET 10 SDK
*   WiX SDK and NetFx extension **6.0.2** (restored automatically from NuGet)
*   A VS 2026-compatible WiX project-system extension is needed to load/edit the setup project in the IDE; command-line builds use the restored SDK
    

### Runtime

*   64-bit Windows supported by both .NET 10 and your AutoCAD release
*   **x64 .NET 10 Desktop Runtime**, including for the portable ZIP. The MSI checks this prerequisite; it does not install the runtime. Download: https://dotnet.microsoft.com/download/dotnet/10.0
*   AutoCAD 2025 or later
    

## Compatibility Notes

*   COM automation implementation is retained; the manual AutoCAD scenarios still require validation on the deployment machine
*   Existing scripts, project files, and settings continue to work    
*   x64 builds are recommended due to AutoCAD requirements
*   Builds and installer validation do not replace runtime testing: follow `TestFiles\TEST_CASE.md` for CLI, UI, and existing-instance scenarios
  
## License
This project is licensed under the **MIT License**.

## Maintenance
Maintained by **Madhukar**.

## Community
Open to the community. Contributions, issues, and suggestions are welcome.

## Contributing
Please follow [CONTRIBUTING.md](CONTRIBUTING.md), including required PR test evidence from `TestFiles\TEST_CASE.md`.

