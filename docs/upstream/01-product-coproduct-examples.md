# Mathlib PR draft: binary product/coproduct examples (PR U1)

Part of the [Mathlib limits PR queue](MATHLIB_LIMITS_PR_QUEUE.md). **Status: opened [#40711](https://github.com/leanprover-community/mathlib4/pull/40711).**

## Suggested PR title

`doc(CategoryTheory/Limits): add reference examples for binary products and coproducts`

## Target file(s)

- `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean`

Paste the `section ReferenceExamples` block from [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) near the end of the file, inside `namespace CategoryTheory.Limits` and before the closing `end CategoryTheory.Limits`. No new imports are expected.

## PR type

**Examples-only — not a theorem PR.** Do not add automation, attributes, or tactic hooks.

## Rationale

The API (`limit.isLimit`, `colimit.isColimit`, `uniqueUpToIso`) is already present but easy to miss when learning limits-shaped diagrams. lean-uprove extraction ([`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md)) shows that newcomers look for an end-to-end proof template before reaching for automation. Short `noncomputable example` blocks document the canonical universal-property proof pattern with minimal review risk.

## Example list

| # | Statement | Proof idea |
|:--|:--|:--|
| 1 | `IsLimit (limit.cone (pair X Y))` | `limit.isLimit (pair X Y)` |
| 2 | `c ≅ limit.cone (pair X Y)` for `hc : IsLimit c` | `hc.uniqueUpToIso (limit.isLimit (pair X Y))` |
| 3 | `IsColimit (colimit.cocone (pair X Y))` | `colimit.isColimit (pair X Y)` |
| 4 | `c ≅ colimit.cocone (pair X Y)` for `hc : IsColimit c` | `hc.uniqueUpToIso (colimit.isColimit (pair X Y))` |

Preferred style — `noncomputable example`, not `def`:

```lean
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)
```

## Lean content

Full copy-paste draft: [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean).

## Verification checklist

- [ ] Audit draft against Mathlib `v4.31.0` on your Mathlib branch (`limit.isLimit`, `pair`, `uniqueUpToIso` names unchanged).
- [ ] `lake build` on the Mathlib branch after pasting examples.
- [ ] No new axioms; only `noncomputable example` blocks.
- [ ] No automation, attributes, or tactic hooks added.
- [ ] Cross-check against lean-uprove `product_manual` / `coproduct_manual` in [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean).
- [ ] Typecheck all upstream drafts: `lake env lean docs/upstream/_verify_upstream_examples.lean`.
- [ ] Confirm lean-uprove gate still passes: `scripts/verify-gate1.sh` (or `.bat` on Windows).

## Review risk

Low — examples only, no API changes.

## Opening U1 on mathlib4

Repo-local handoff only — open the PR on GitHub when you are ready to contribute upstream.

### Prerequisites

- GitHub CLI authenticated (`gh auth status`).
- A fork of [leanprover-community/mathlib4](https://github.com/leanprover-community/mathlib4). Existing fork: **https://github.com/fraware/mathlib4**

### Steps

1. **Sync fork and branch from `v4.31.0`**

   ```bash
   git clone git@github.com:fraware/mathlib4.git
   cd mathlib4
   git fetch upstream --tags   # add upstream remote if needed: leanprover-community/mathlib4
   git checkout v4.31.0
   git checkout -b limits-binary-product-examples
   ```

2. **Paste examples** into `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean` inside `namespace CategoryTheory.Limits`, immediately before the final `end CategoryTheory.Limits`. Copy the entire `section ReferenceExamples` … `end ReferenceExamples` block from [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean). Do not add imports — the module already has what these examples need.

3. **Build on the Mathlib fork**

   ```bash
   lake build Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
   ```

   Fix any naming drift against your checkout; the draft was verified against Mathlib `v4.31.0`.

4. **Push and open PR** against `leanprover-community/mathlib4` `master` (or current default branch per Mathlib contribution guide).

   - **Title:** `doc(CategoryTheory/Limits): add reference examples for binary products and coproducts`
   - **Body:** state clearly that the PR is **examples-only** (four `noncomputable example` blocks, no API or automation changes). Link back to lean-uprove extraction context if useful.

5. **After merge:** proceed to U2 per [`MATHLIB_LIMITS_PR_QUEUE.md`](MATHLIB_LIMITS_PR_QUEUE.md).
