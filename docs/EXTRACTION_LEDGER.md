# Universal-property extraction ledger

Tracks Mathlib upstream candidates from `lean-uprove` modernization on **Lean 4.31.0** / **Mathlib v4.31.0**.

| Construction | Goal shape | Manual proof | Automation proof | Missing lemma or missing documentation | Candidate Mathlib file | Review risk | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| Product `IsLimit` | `IsLimit (limit.cone (pair X Y))` | `product_manual`, `product_manual_uniq` | `product_automation` | API exists; need **worked example** pairing existence + `uniqueUpToIso` | `Limits/Shapes/BinaryProducts.lean` | Low | Ready |
| Coproduct `IsColimit` | `IsColimit (colimit.cocone (pair X Y))` | `coproduct_manual`, `coproduct_manual_uniq` | `coproduct_automation` | Same as product | `Limits/Shapes/BinaryProducts.lean` | Low | Ready |
| Equalizer uniqueness | `IsLimit (limit.cone (parallelPair f g))` | `equalizer_manual`, `equalizer_manual_uniq` | `equalizer_automation` | Factorization steps not collected in one example | `Limits/Shapes/Equalizers.lean` | Medium | Ready |
| Coequalizer uniqueness | `IsColimit (colimit.cocone (parallelPair f g))` | `coequalizer_manual`, `coequalizer_manual_uniq` | `coequalizer_automation` | Dual to equalizer | `Limits/Shapes/Coequalizers.lean` | Medium | Ready |
| Pullback projection | `IsLimit (limit.cone (cospan f g))` | `pullback_manual`, `pullback_manual_uniq` | `pullback_automation` | End-to-end `IsLimit` + uniqueness example missing | `Limits/Shapes/Pullbacks.lean` | Medium | Ready |
| Pushout injection | `IsColimit (colimit.cocone (span f g))` | `pushout_manual`, `pushout_manual_uniq` | `pushout_automation` | Dual to pullback | `Limits/Shapes/Pushouts.lean` | Medium | Ready |
| Terminal object uniqueness | `IsLimit (limit.cone (Functor.empty C))` | `terminal_manual`, `terminal_manual_uniq` | `terminal_automation` | Uniqueness example scattered | `Limits/Shapes/Terminal.lean` | Low | Ready |
| Initial object uniqueness | `IsColimit (colimit.cocone (Functor.empty C))` | `initial_manual`, `initial_manual_uniq` | `initial_automation` | Dual to terminal | `Limits/Shapes/Initial.lean` | Low | Ready |

| Layer | File | Purpose |
|:---|:---|:---|
| Abstract (any category) | [`examples/BasicExamples.lean`](../examples/BasicExamples.lean) | `*_manual`, `*_manual_uniq`, `*_automation` |
| Concrete (`Type`) | [`examples/ManualProofs.lean`](../examples/ManualProofs.lean) | Explicit `by` tactic scripts + term-mode proofs |
| Tactic comparison (optional) | [`UproveComparisonExamples.lean`](../UproveComparisonExamples.lean) | Not in CI gate |

## Upstream drafts (ready for Mathlib PR #1)

| Draft | Description |
|:---|:---|
| [`docs/upstream/01-product-coproduct-examples.lean`](upstream/01-product-coproduct-examples.lean) | Lean content to adapt |
| [`docs/upstream/01-product-coproduct-examples.md`](upstream/01-product-coproduct-examples.md) | PR title, summary, test plan |
| [`docs/upstream/MATHLIB_LIMITS_PR_QUEUE.md`](upstream/MATHLIB_LIMITS_PR_QUEUE.md) | Ordered PR queue (U1–U5) and guidelines |

## Upstream PR order

See [`docs/upstream/MATHLIB_LIMITS_PR_QUEUE.md`](upstream/MATHLIB_LIMITS_PR_QUEUE.md) for the full queue. Summary:

1. **U1** — Mathlib **examples** for product/coproduct (`limit.isLimit _` / `colimit.isColimit _` + `uniqueUpToIso`). **Draft ready** — see `docs/upstream/`.
2. **U2** — equalizer/coequalizer examples.
3. **U3** — pullback/pushout examples.
4. **U4** — terminal/initial object examples.
5. **U5** — helper lemmas only where manual proofs expose repeated boilerplate.
6. Tactic discussion (`uprove` / `uprove?`) — **out of scope** for this sprint.

## Build certification

Verified locally on branch `modernize/lean-4-31-extraction`:

```bash
scripts/verify-gate1.sh   # or scripts/verify-gate1.bat on Windows
# Fresh dependency sync (CI): LAKE_UPDATE=1 scripts/verify-gate1.sh
```

## Notes

- Manual proofs compile without `Uprove` or `UproveRegisterInit`.
- `UproveComparisonExamples.lean` holds optional tactic comparisons (not part of the extraction gate).
- Stable import `Uprove.lean` excludes performance, smoke-test, and test-support modules.
