# Mathlib upstream drafts

Ready-to-adapt content for Mathlib PRs identified in [`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md). **PR order and policy:** [`MATHLIB_LIMITS_PR_QUEUE.md`](MATHLIB_LIMITS_PR_QUEUE.md).

These files are **not** Lake build targets. They are review artifacts: copy the `section ReferenceExamples` block from a draft `.lean` file, adapt headers if needed, and open an examples-only PR against [mathlib4](https://github.com/leanprover-community/mathlib4) at tag **`v4.31.0`**.

## Draft index

| PR | Status | Lean draft | Maintainer notes | Mathlib target |
|:---|:---|:---|:---|:---|
| U1 | **draft ready** (next) | [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) | [`01-product-coproduct-examples.md`](01-product-coproduct-examples.md) | `Limits/Shapes/BinaryProducts.lean` |
| U2 | draft ready | [`02-equalizer-coequalizer-examples.lean`](02-equalizer-coequalizer-examples.lean) | [`02-equalizer-coequalizer-examples.md`](02-equalizer-coequalizer-examples.md) | `Limits/Shapes/Equalizers.lean` |
| U3 | draft ready | [`03-pullback-pushout-examples.lean`](03-pullback-pushout-examples.lean) | [`03-pullback-pushout-examples.md`](03-pullback-pushout-examples.md) | `Limits/Shapes/Pullback/HasPullback.lean` |
| U4 | draft ready | [`04-terminal-initial-examples.lean`](04-terminal-initial-examples.lean) | [`04-terminal-initial-examples.md`](04-terminal-initial-examples.md) | `Limits/Shapes/Terminal.lean` |
| U5 | TBD | — | — | helper lemmas after U1–U4 |

## Local API verification

[`_verify_upstream_examples.lean`](_verify_upstream_examples.lean) is a **single-file typecheck harness** for all U1–U4 draft patterns. It is not part of `lake build`; run it explicitly to confirm Mathlib `v4.31.0` API names still match the drafts:

```bash
lake env lean docs/upstream/_verify_upstream_examples.lean
```

When you change any draft `.lean` file, update this verifier in the same commit so local checks stay aligned.

The same patterns are also exercised in [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean) (`*_manual` definitions), which is part of the `UproveExamples` target and CI gate.

## Verification before opening a Mathlib PR

See the full checklist in [`MATHLIB_LIMITS_PR_QUEUE.md`](MATHLIB_LIMITS_PR_QUEUE.md#verification-before-opening-a-mathlib-pr). Minimum bar:

1. `lake env lean docs/upstream/_verify_upstream_examples.lean`
2. `lake build UproveExamples`
3. `scripts/verify-gate1.sh` (or `.bat` on Windows)
4. Cross-check against `examples/BasicExamples.lean` and `examples/ManualProofs.lean`
5. `lake build` on your Mathlib fork after pasting examples

## Scope

Examples-only through U4. No automation, attributes, or tactic hooks in Mathlib PRs. No `uprove` upstream until maintainers have seen the reference pattern land.
