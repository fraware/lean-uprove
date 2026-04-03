# CI/CD

What runs in GitHub Actions and how to mirror it locally.

## Workflows

- **`ci.yml`** — On pushes to `main` / `develop` and PRs to `main`: caches build outputs, runs `lake build`, `lake build UproveExamples`, `lake test`, `lake exe test`, and selected test executables. Builds Docker on non-PR events (or as configured in the file). Runs install-script and Makefile smoke steps.
- **`performance.yml`** — Scheduled and branch builds; performance-oriented smoke (see workflow file).
- **`security.yml`** — Security scanning with pinned third-party action versions where possible.
- **`release.yml`** — Runs on version tags; builds, tests, publishes the container image, and creates a GitHub Release.

Details change over time; open `.github/workflows/` for the exact steps.

## Match CI locally

```bash
lake build
lake build UproveExamples
lake test
lake exe test
```

Use the same `lean-toolchain` as this repo so Mathlib resolves consistently.

## Libraries in this package

The default library build includes **`Uprove.lean`** and **`UproveRegisterInit.lean`**. Examples are a separate target built with `lake build UproveExamples`.
