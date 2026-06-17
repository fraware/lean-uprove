# Mathlib PR draft: pullback/pushout examples (PR U3)

Part of the [Mathlib limits PR queue](MATHLIB_LIMITS_PR_QUEUE.md). **Status: draft ready.**

## Suggested PR title

`CategoryTheory/Limits: add reference examples for pullbacks and pushouts`

## Target file(s)

- `Mathlib/CategoryTheory/Limits/Shapes/Pullback/HasPullback.lean`

In Mathlib v4.31.0, `HasPullback`, `HasPushout`, `pullback`, and `pushout` are defined together in this file (there are no top-level `Pullbacks.lean` or `Pushouts.lean` under `Limits/Shapes/`). Paste the `section ReferenceExamples` block from [`03-pullback-pushout-examples.lean`](03-pullback-pushout-examples.lean) inside `namespace CategoryTheory.Limits`, before the closing `end CategoryTheory.Limits`.

## PR type

**Examples-only — not a theorem PR.** Do not add automation, attributes, or tactic hooks.

## Rationale

Pullbacks and pushouts are abbreviations for limits/colimits of `cospan` / `span` diagrams. The `HasPullback.lean` module header documents the API but does not show the one-line universal-property proof pattern that lean-uprove uses in `pullback_manual` and `pushout_manual`.

## Example list

| # | Statement | Proof idea |
|:--|:--|:--|
| 1 | `IsLimit (limit.cone (cospan f g))` | `limit.isLimit (cospan f g)` |
| 2 | `c ≅ limit.cone (cospan f g)` for `hc : IsLimit c` | `hc.uniqueUpToIso (limit.isLimit (cospan f g))` |
| 3 | `IsColimit (colimit.cocone (span f g))` | `colimit.isColimit (span f g)` |
| 4 | `c ≅ colimit.cocone (span f g)` for `hc : IsColimit c` | `hc.uniqueUpToIso (colimit.isColimit (span f g))` |

## Lean content

Full copy-paste draft: [`03-pullback-pushout-examples.lean`](03-pullback-pushout-examples.lean).

## Verification checklist

- [ ] Confirm `HasPullback`, `HasPushout`, `cospan`, and `span` API on Mathlib `v4.31.0`.
- [ ] `lake build` on the Mathlib branch after pasting examples.
- [ ] No new axioms; only `noncomputable example` blocks.
- [ ] No automation, attributes, or tactic hooks added.
- [ ] Cross-check against `pullback_manual` / `pushout_manual` in [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean).
- [ ] Typecheck all upstream drafts: `lake env lean docs/upstream/_verify_upstream_examples.lean`.
- [ ] Confirm lean-uprove gate still passes: `scripts/verify-gate1.sh` (or `.bat` on Windows).

## Review risk

Low — examples only, no API changes.
