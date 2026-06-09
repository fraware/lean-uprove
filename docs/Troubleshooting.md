# Troubleshooting

Common issues when using **`uprove`** with **lean-uprove** on Lean 4.31 and the pinned Mathlib.

## "No matching universal property pattern found"

**Cause:** The goal does not match any registered pattern, or defaults were never registered.

**Try:**

1. Compare your goal to the shapes handled in this package (see the patterns and registration in the source tree).
2. Use **`import UproveRegisterInit`** with **`import Uprove`** (or `import Uprove.Tactics`) so defaults are registered.
3. Register your own lemma with **`@[uproveLemma]`** (avoid `@[uprove]`, which can clash with the tactic name).
4. Use `uprove?` to see what the tactic considered.
5. With **`strict := true`**, missing matches fail instead of using fallbacks. While exploring, keep the default non-strict behavior.

## "Unknown tactic" / `uprove` not found

**Cause:** The tactics module is not imported.

**Try:** `import Uprove` or `import Uprove.Tactics`, plus `UproveRegisterInit` for registration.

## Pattern registration not visible

**Cause:** `UproveRegisterInit` was not loaded.

**Try:** Add `import UproveRegisterInit` at the top of your file.

## Tactic timeout

**Cause:** Work exceeded the time budget (milliseconds).

**Try:** Raise `timeout` and/or `maxSteps` in the configuration you pass to `uprove [ … ]`.

## Strict mode

**Cause:** No pattern match and strict mode turns off silent fallback.

**Try:** Use non-strict mode while developing, or finish the proof manually.

## Fallback tactics failed

**Cause:** Fallback tactics did not close residual goals.

**Try:** Inspect goals after `uprove?`, adjust the `fallback` list in options, or complete the proof by hand.

## Performance

**Try:** Enable `trace` in options, lower `maxSteps`, or run the benchmark executable locally (see the root README).

## Examples vs. your project

If this repository’s CI is green but your project fails, build the examples the same way CI does:

```bash
lake build UproveExamples
```

## Windows: linker or `lake exe` failures

Some executables link a large dependency graph and can fail on Windows. Prefer `lake build` and `lake build UproveExamples` to validate the library; report issues with your Lean and Lake versions.

## Getting help

1. [Cookbook](Cookbook.md) for idioms (confirm names against your Mathlib version).
2. `examples/BasicExamples.lean` and `examples/ManualProofs.lean` for current naming (`limit.cone`, `colimit.cocone`, `HasBinaryProduct`, …).
3. GitHub Issues with a small repro, imports, and `uprove?` output when possible.
