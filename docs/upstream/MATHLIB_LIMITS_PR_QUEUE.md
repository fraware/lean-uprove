# Mathlib limits upstream PR queue

Ordered queue for Mathlib contributions from lean-uprove universal-property extraction. This repo pins **Lean / Mathlib `v4.31.0`** (`lake-manifest.json`); audit every draft against that tag before opening a PR.

Related docs: [`EXTRACTION_LEDGER.md`](../EXTRACTION_LEDGER.md) (proof inventory), [`README.md`](README.md) (draft index and local verification).

## PR queue

| PR | Content | Mathlib target | Draft |
|:---|:---|:---|:---|
| **U1** | binary product / coproduct reference examples | `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean` | [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean) · [notes](01-product-coproduct-examples.md) |
| **U2** | equalizer / coequalizer reference examples | `Mathlib/CategoryTheory/Limits/Shapes/Equalizers.lean` | [`02-equalizer-coequalizer-examples.lean`](02-equalizer-coequalizer-examples.lean) · [notes](02-equalizer-coequalizer-examples.md) |
| **U3** | pullback / pushout reference examples | `Mathlib/CategoryTheory/Limits/Shapes/Pullback/HasPullback.lean` | [`03-pullback-pushout-examples.lean`](03-pullback-pushout-examples.lean) · [notes](03-pullback-pushout-examples.md) |
| **U4** | terminal / initial object reference examples | `Mathlib/CategoryTheory/Limits/Shapes/Terminal.lean` | [`04-terminal-initial-examples.lean`](04-terminal-initial-examples.lean) · [notes](04-terminal-initial-examples.md) |
| **U5** | helper lemmas only where repetition is proven | TBD | **TBD** — see [U5 criteria](#pr-u5-criteria) |

Submit in order **U1 → U2 → U3 → U4**. Open **U5** only after U1–U4 merge and maintainer feedback.

## Examples-only policy

Every queued PR through U4 is **documentation / examples only — not a theorem PR**.

- Use `noncomputable example` blocks inside `section ReferenceExamples` (see draft `.lean` files).
- **Do not** add automation, attributes, tactic hooks, or new API surface.
- **Do not** upstream `uprove` or `uprove?`; Mathlib needs teachable reference patterns first.
- Prefer one-line proofs via existing lemmas (`limit.isLimit`, `colimit.isColimit`, `uniqueUpToIso`).

## U1 (opened)

- **PR:** [#40711](https://github.com/leanprover-community/mathlib4/pull/40711) — `CategoryTheory/Limits: add reference examples for binary products and coproducts`
- **Branch:** `fraware:ct-limits-binary-product-examples`
- **Draft:** [`01-product-coproduct-examples.lean`](01-product-coproduct-examples.lean)
- **Handoff steps:** [Opening U1 on mathlib4](01-product-coproduct-examples.md#opening-u1-on-mathlib4)

Canonical proof pattern (product; coproduct is analogous):

```lean
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)
```

Uniqueness examples use `hc.uniqueUpToIso (limit.isLimit …)` (or the colimit dual).

## After U1 merges

1. **U2** — paste [`02-equalizer-coequalizer-examples.lean`](02-equalizer-coequalizer-examples.lean) into `Equalizers.lean` (equalizers and coequalizers share one module in v4.31.0).
2. **U3** — paste [`03-pullback-pushout-examples.lean`](03-pullback-pushout-examples.lean) into `Pullback/HasPullback.lean` (pullbacks and pushouts share one module).
3. **U4** — paste [`04-terminal-initial-examples.lean`](04-terminal-initial-examples.lean) into `Terminal.lean` (terminal and initial objects share one module).
4. **U5** — helper lemmas only where manual proofs show repeated boilerplate; scope agreed with reviewers.

## PR U5 criteria

Do **not** invent lemmas speculatively. A candidate U5 item must satisfy **all** of:

- The same proof step appears in multiple upstream examples or in lean-uprove manual proofs with no meaningful variation.
- A small named lemma shortens examples without hiding the universal-property idea.
- The lemma is not already available under another name in Mathlib.
- Scope is agreed with a Mathlib reviewer before opening the PR.

## Verification before opening a Mathlib PR

Run these checks in lean-uprove **before** copying a draft into a Mathlib fork:

1. Typecheck all draft patterns locally:

   ```bash
   lake env lean docs/upstream/_verify_upstream_examples.lean
   ```

2. Confirm the main example library still builds: `lake build UproveExamples`.
3. Run the repo gate: `scripts/verify-gate1.sh` (or `.bat` on Windows).
4. Cross-check names with [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean) and [`examples/ManualProofs.lean`](../../examples/ManualProofs.lean).
5. On your Mathlib fork at tag `v4.31.0`, paste the draft `section ReferenceExamples`, then `lake build` the touched module (or full Mathlib).
