# 03-validation: Validate the upgraded solution

Validate the entire solution and relevant build configurations, run discovered tests, and inspect package/dependency compatibility and deployment output. Check that installer payload includes the necessary .NET application artifacts and document external runtime/tooling prerequisites and non-automated desktop or AutoCAD integration checks that cannot be exercised here.

Review the final diff, record build/test results and any accepted limitations, and commit the atomic upgrade. Do not claim runtime or installer validation that was not performed.

**Done when**: Full build and available tests pass, warnings are resolved in modified projects, remaining external validation limitations are explicitly recorded, and the upgrade is committed on the working branch.

## Scope Inventory and Validation Research
- Review all 13 changed source/config/documentation files plus workflow artifacts. Both managed projects target net10.0-windows; WiX remains an installer SDK project, not a managed TFM target.
- Prior task evidence: managed Debug and full Release x64 warning-as-error rebuilds succeeded; MSI and portable ZIP produced; runtime detection action precedes LaunchConditions.
- Re-run IDE build and explicit Release x64 validation with restore/audit, run available Test Explorer tests, inspect runtimeconfig/ZIP payload and final diffs. Keep generated outputs ignored and historical Source projects unchanged.
- Startup inspection found MainWindow's constructor writes HKCR file associations. Do not launch it as a supposedly read-only smoke test or alter registry state. Document UI/AutoCAD and MSI installation tests as not run; static payload checks are not substitutes for runtime tests.
- Final commit follows complete_task so the recorded task state and validation artifacts are included in the single atomic commit.
