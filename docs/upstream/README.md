# Mathlib upstream drafts

Ready-to-adapt content for Mathlib PRs identified in [`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md).

**PR order and guidelines:** [`MATHLIB_LIMITS_PR_QUEUE.md`](MATHLIB_LIMITS_PR_QUEUE.md)

These files are **not** built by `lake build`. They are review artifacts: copy, adapt namespace/module headers, and open a PR against [mathlib4](https://github.com/leanprover-community/mathlib4).

| PR | Draft | Target Mathlib location |
|:---|:---|:---|
| U1 | [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) | `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean` |
| U2 | (pending) equalizer/coequalizer | `Limits/Shapes/Equalizers.lean`, `Limits/Shapes/Coequalizers.lean` |
| U3 | (pending) pullbacks/pushouts | `Limits/Shapes/Pullbacks.lean`, `Limits/Shapes/Pushouts.lean` |
| U4 | (pending) terminal/initial | `Limits/Shapes/Terminal.lean`, `Limits/Shapes/Initial.lean` |

## Verification before opening a Mathlib PR

1. Audit the draft against current Mathlib on your Mathlib branch.
2. Confirm proofs in this repo still compile: `scripts/verify-gate1.sh` (or `.bat` on Windows).
3. Cross-check names with `examples/BasicExamples.lean` and `examples/ManualProofs.lean`.

## Scope

Do **not** upstream `uprove` or `uprove?`. Mathlib needs examples and helper lemmas first. Do **not** add automation or attributes in Mathlib PRs.
