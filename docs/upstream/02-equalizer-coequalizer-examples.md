# Mathlib PR draft: equalizer/coequalizer examples (PR U2)

Part of the [Mathlib limits PR queue](MATHLIB_LIMITS_PR_QUEUE.md). **Status: draft ready.**

## Suggested PR title

`CategoryTheory/Limits: add reference examples for equalizers and coequalizers`

## Target file(s)

- `Mathlib/CategoryTheory/Limits/Shapes/Equalizers.lean`

In Mathlib v4.31.0, equalizers and coequalizers share this single module (there is no separate `Coequalizers.lean` under `Limits/Shapes/`). Paste the `section ReferenceExamples` block from [`02-equalizer-coequalizer-examples.lean`](02-equalizer-coequalizer-examples.lean) inside `namespace CategoryTheory.Limits`, before the closing `end CategoryTheory.Limits`.

## PR type

**Examples-only — not a theorem PR.** Do not add automation, attributes, or tactic hooks.

## Rationale

`(Co)equalizers` are defined as `(co)limits` of `parallelPair f g`, but that connection is easy to overlook when browsing fork/cofork API. These examples mirror the binary product pattern and match lean-uprove manual proofs (`equalizer_manual`, `coequalizer_manual`).

## Example list

| # | Statement | Proof idea |
|:--|:--|:--|
| 1 | `IsLimit (limit.cone (parallelPair f g))` | `limit.isLimit (parallelPair f g)` |
| 2 | `c ≅ limit.cone (parallelPair f g)` for `hc : IsLimit c` | `hc.uniqueUpToIso (limit.isLimit (parallelPair f g))` |
| 3 | `IsColimit (colimit.cocone (parallelPair f g))` | `colimit.isColimit (parallelPair f g)` |
| 4 | `c ≅ colimit.cocone (parallelPair f g)` for `hc : IsColimit c` | `hc.uniqueUpToIso (colimit.isColimit (parallelPair f g))` |

## Lean content

Full copy-paste draft: [`02-equalizer-coequalizer-examples.lean`](02-equalizer-coequalizer-examples.lean).

## Verification checklist

- [ ] Confirm `HasEqualizer`, `HasCoequalizer`, and `parallelPair` API on Mathlib `v4.31.0`.
- [ ] `lake build` on the Mathlib branch after pasting examples.
- [ ] No new axioms; only `noncomputable example` blocks.
- [ ] No automation, attributes, or tactic hooks added.
- [ ] Cross-check against `equalizer_manual` / `coequalizer_manual` in [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean).
- [ ] Typecheck all upstream drafts: `lake env lean docs/upstream/_verify_upstream_examples.lean`.
- [ ] Confirm lean-uprove gate still passes: `scripts/verify-gate1.sh` (or `.bat` on Windows).

## Review risk

Low — examples only, no API changes.
