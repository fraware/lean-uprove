# Contributing to lean-uprove

Thank you for contributing. This project targets **Lean 4.31** with **Mathlib v4.31.0-rc1** (see `lean-toolchain` and `lakefile.lean`).

## Getting started

1. Fork and clone the repository.
2. Use the repository `lean-toolchain` file (currently Lean 4.31.0-rc1).
3. Build:

```bash
lake build
lake build UproveExamples
```

Run `lake update` only when you intend to change dependencies; commit any updated lockfile the tool writes.

## Commands

| Task | Command |
|------|---------|
| Main library | `lake build` |
| Examples (same as CI) | `lake build UproveExamples` |
| Tests | `lake test` |
| Smoke executable | `lake exe test` |
| Benchmark CLI | `lake exe uprove-benchmark` (may fail on some Windows setups) |
| Other test programs | `lake exe uprove-test-simple`, and others listed beside them in the Lake project file |

## Code style

- Follow Lean 4 conventions; this package disables `autoImplicit`.
- Add short docstrings when behavior is not obvious from types.
- Prefer small, focused changes.

## Tests

- Extend [`examples/BasicExamples.lean`](examples/BasicExamples.lean) when you add Mathlib-facing behavior that should keep compiling in CI.
- Keep the `lake test` entrypoint honest: it should fail when new checks fail.
- Small tests can use `#guard` or dedicated modules.

## Registering patterns

1. Update [`Uprove/Patterns.lean`](Uprove/Patterns.lean) and/or [`UproveRegisterInit.lean`](UproveRegisterInit.lean) as needed.
2. Use `@[uproveLemma]` for lemmas (avoid `@[uprove]`, which can clash with the tactic name).
3. Use `@[uprove.iso]` for isomorphism hooks.

## Important paths

| Path | Role |
|------|------|
| `Uprove/Core.lean` | Core types and matching |
| `Uprove/Tactics.lean` | `uprove` / `uprove?` |
| `Uprove/Planner.lean` | Planning |
| `Uprove/Patterns.lean` | Pattern data |
| `Uprove/Configuration.lean` | Options and presets |
| `UproveRegisterInit.lean` | Default registration (root module) |
| `Uprove.lean` | Public exports (does not import `UproveRegisterInit`) |
| `examples/BasicExamples.lean` | Example theorems checked in CI |
| `bench/Benchmark.lean` | Benchmark executable root |

## Versioning

Align package version in `Uprove/Version.lean` with Docker image tags when you release.

## Pull requests

1. `lake build` and `lake build UproveExamples` succeed locally.
2. `lake test` (and any executables you change) succeed where relevant.
3. Update `docs/` and/or `README.md` if user-facing behavior or commands change.

## Community and license

- Issues: GitHub Issues.
- Conduct: [Lean community code of conduct](https://leanprover-community.github.io/contribute/code_of_conduct.html).
- Contributions are under the project **MIT** license.
