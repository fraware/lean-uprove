# CI/CD

What runs in GitHub Actions and how to mirror it locally (Lean **4.31.0-rc1** / Mathlib **v4.31.0-rc1**).

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push to `main`/`develop`, PRs to `main` | Gate 1 build + test executables |
| `performance.yml` | Schedule, branch pushes | Performance smoke |
| `security.yml` | Branch pushes | Security scanning |
| `release.yml` | Version tags | Release build + container |

Open `.github/workflows/` for exact steps.

## Gate 1 (extraction acceptance)

```bash
lake update
lake build Uprove
lake build UproveExamples
lake test
lake exe uprove-test-simple
lake exe uprove-test-real
```

Or run `scripts/verify-gate1.sh` (`.bat` on Windows).

`lake build UproveComparison` is optional and not required for the extraction gate.

## Libraries

| Target | Contents |
|--------|----------|
| `lake build Uprove` | Stable library + `UproveRegisterInit` + `TestRegisterInit` |
| `lake build UproveExamples` | `BasicExamples`, `ManualProofs` |
| `lake build UproveComparison` | Optional tactic comparison module |

Use the repository `lean-toolchain` so Mathlib resolves consistently.
