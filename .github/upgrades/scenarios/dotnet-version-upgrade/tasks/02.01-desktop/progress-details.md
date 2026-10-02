# Desktop Upgrade Results

- Retargeted DrawingListUC and ScriptUI to net10.0-windows, retaining Windows Forms/WPF and existing language/project settings.
- Fixed ten existing CS8632 warnings by enabling file-local nullable annotations in AcadComUtils.cs; no diagnostics suppressed.
- Resolved eleven WFO1000 errors by marking runtime-only properties in OptionsDlg and DrawingListControl with DesignerSerializationVisibility.Hidden. Runtime getters/setters remain unchanged. Downstream WPF MC3074 disappeared after the library compiled.
- Full managed solution Debug Any CPU rebuild using VS 2026 MSBuild /restore /t:Rebuild /warnaserror passed. IDE build also passed.
- Runtimeconfig targets .NET 10 and Microsoft.WindowsDesktop.App 10.0.0 with LatestMinor roll-forward. No migration stubs found.
- Test Explorer executed: 0 tests found, 0 failures. Manual AutoCAD/UI scenarios not claimed as tested.
- WiX is not built by the existing Any CPU mapping; packaging validation belongs to the next subtask.
