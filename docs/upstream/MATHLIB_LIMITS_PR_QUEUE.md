# Mathlib limits upstream PR queue

Ordered queue for Mathlib contributions from lean-uprove universal-property extraction. See also [`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md) for proof inventory and [`README.md`](README.md) for draft files.

## PR Queue Table

| PR | Content | File target |
|:---|:---|:---|
| PR U1 | product/coproduct manual examples | `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean` |
| PR U2 | equalizer/coequalizer manual examples | relevant limits shape files |
| PR U3 | pullback/pushout examples | pullback/pushout shape files |
| PR U4 | terminal/initial object examples | terminal/initial files |
| PR U5 | helper lemmas only after examples reveal repetition | TBD |

## First Mathlib PR (U1) - Documentation/Examples PR, NOT a theorem PR

- **Suggested title:** `CategoryTheory/Limits: add reference examples for binary products and coproducts`
- Add small, safe, useful reference examples that teach maintainers the project is disciplined.
- **Do not** add automation, attributes, or tactic hooks in Mathlib PRs.

### Product example

```lean
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)
```

### Coproduct example

```lean
noncomputable example (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)
```

Uniqueness examples may follow the same `example` pattern using `uniqueUpToIso`.

### Draft artifacts for U1

| Artifact | Path |
|:---|:---|
| Lean draft | [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) |
| PR notes | [`01-product-coproduct-examples.md`](01-product-coproduct-examples.md) |

## Second Mathlib PR and beyond

After PR U1 merges, submit contributions in this order:

1. **U2** — equalizer/coequalizer manual examples (`Mathlib/CategoryTheory/Limits/Shapes/Equalizers.lean`, `Mathlib/CategoryTheory/Limits/Shapes/Coequalizers.lean`).
2. **U3** — pullback/pushout examples (`Mathlib/CategoryTheory/Limits/Shapes/Pullbacks.lean`, `Mathlib/CategoryTheory/Limits/Shapes/Pushouts.lean`).
3. **U4** — terminal/initial object examples (`Mathlib/CategoryTheory/Limits/Shapes/Terminal.lean`, `Mathlib/CategoryTheory/Limits/Shapes/Initial.lean`).
4. **U5** — helper lemmas **only** where manual proofs in this repo show repeated boilerplate; scope TBD per review.

## Verification before opening a Mathlib PR

1. Audit the draft against current Mathlib on your Mathlib branch.
2. Confirm proofs in this repo still compile: `scripts/verify-gate1.sh` (or `.bat` on Windows).
3. Cross-check names with `examples/BasicExamples.lean` and `examples/ManualProofs.lean`.
