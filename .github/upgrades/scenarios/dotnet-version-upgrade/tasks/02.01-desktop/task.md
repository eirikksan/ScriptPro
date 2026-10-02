# 02.01-desktop: Retarget both desktop projects and fix compiler warnings

# Desktop framework upgrade

## Objective
Upgrade DrawingListUC and ScriptUI together to net10.0-windows, preserve behavior, and eliminate compiler warnings.

## Research
Parent task records per-project assessment queries and dependency inspection. No imported overrides or managed packages. Existing latest language version already selects installed compiler. WinForms/WPF flags require recompilation with Windows targeting, not wholesale API replacement. ScriptUI Uri flags are generated StartupUri code. AcadComUtils.cs has ten CS8632 warnings from existing nullable annotations in a disabled context; activate file-local annotations without project-wide NRT migration. No stubs found in inspected code.

## Scope
DrawingListUC/DrawingListUC.csproj, ScriptUI/ScriptUI.csproj, DrawingListUC/AcadComUtils.cs and only confirmed compatibility fixes.

## Confirmed Compatibility Fix
The first .NET 10 build reports WFO1000 on eight OptionsDlg properties and three DrawingListControl properties. These represent runtime dialog options, project state, or the WPF host and are not designer configuration. Mark them DesignerSerializationVisibility.Hidden, retaining their runtime getters/setters. MC3074 in WPF is downstream of the failed control-library build. No diagnostic suppression is needed.

**Done when**: Both projects target net10.0-windows, full managed solution build succeeds without warnings, and available automated tests are run.
