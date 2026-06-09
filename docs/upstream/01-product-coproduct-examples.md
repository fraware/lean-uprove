# Mathlib PR draft: binary product/coproduct examples

## Title

`docs: add binary product/coproduct universal property examples`

## Summary

Add short worked examples showing:

1. `limit.cone (pair X Y)` is an `IsLimit` via `limit.isLimit`.
2. Uniqueness up to isomorphism via `IsLimit.uniqueUpToIso`.
3. Dual statements for coproducts.

## Motivation

The API exists but is easy to miss. lean-uprove extraction ([`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md)) shows newcomers look for an end-to-end proof template before reaching for automation.

## Lean content

See [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean).

## Test plan

- [ ] `lake build` on the Mathlib branch
- [ ] No new axioms; only `noncomputable def` examples
- [ ] Cross-check against lean-uprove `product_manual` / `coproduct_manual` naming

## Review risk

Low — examples only, no API changes.
