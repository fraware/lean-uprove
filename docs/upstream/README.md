# Mathlib upstream drafts

Ready-to-adapt content for Mathlib PRs identified in [`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md).

These files are **not** built by `lake build`. They are review artifacts: copy, adapt namespace/module headers, and open a PR against [mathlib4](https://github.com/leanprover-community/mathlib4).

| PR order | Draft | Target Mathlib location |
|:---|:---|:---|
| 1 | [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) | `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean` (or adjacent examples section) |
| 2 | (pending) equalizer/coequalizer | `Limits/Shapes/Equalizers.lean` |
| 3 | (pending) pullbacks/pushouts | `Limits/Shapes/Pullbacks.lean` |

## Verification before opening a Mathlib PR

1. Audit the draft against current Mathlib on your Mathlib branch.
2. Confirm proofs in this repo still compile: `scripts/verify-gate1.sh` (or `.bat` on Windows).
3. Cross-check names with `examples/BasicExamples.lean` and `examples/ManualProofs.lean`.

## Scope

Do **not** upstream `uprove` or `uprove?`. Mathlib needs examples and helper lemmas first.
