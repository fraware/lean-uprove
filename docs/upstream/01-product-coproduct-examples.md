# Mathlib PR draft: binary product/coproduct examples (PR U1)

Part of the [Mathlib limits PR queue](MATHLIB_LIMITS_PR_QUEUE.md).

## Title

`CategoryTheory/Limits: add reference examples for binary products and coproducts`

## Summary

Add short worked **examples** (not new theorems) showing:

1. `limit.cone (pair X Y)` is an `IsLimit` via `limit.isLimit`.
2. Uniqueness up to isomorphism via `IsLimit.uniqueUpToIso`.
3. Dual statements for coproducts.

## Motivation

The API exists but is easy to miss. lean-uprove extraction ([`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md)) shows newcomers look for an end-to-end proof template before reaching for automation.

## Lean content

See [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean).

Preferred style — `noncomputable example`, not `def`:

```lean
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)
```

## Test plan

- [ ] `lake build` on the Mathlib branch
- [ ] No new axioms; only `noncomputable example` blocks
- [ ] No automation or attributes added
- [ ] Cross-check against lean-uprove `product_manual` / `coproduct_manual` naming

## Review risk

Low — examples only, no API changes.
