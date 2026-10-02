# Upgrade Options — ScriptProPlus

Assessment: Two SDK-style .NET 8 Windows desktop projects, no reported NuGet dependencies, and desktop API compatibility flags; WiX setup tooling also requires inspection.

## Strategy

### Upgrade Strategy
The two connected desktop projects can be upgraded together without temporary multi-targeting.

| Value | Description |
|-------|-------------|
| **All-at-Once** (selected) | Upgrade both projects together and validate the full solution as one atomic upgrade. |
| Top-Down | Upgrade the application first and temporarily multi-target its shared library. |

## Compatibility

### Unsupported API Handling
The assessment flags binary and source compatibility issues that require verification with the Windows target framework.

| Value | Description |
|-------|-------------|
| **Fix Inline** (selected) | Resolve confirmed API changes within the upgrade task without leaving stubs. |
| Defer Complex Changes | Apply simple fixes directly and track complex replacements as temporary stubs with resolution subtasks. |
