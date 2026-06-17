# Mathlib PR draft: terminal/initial object examples (PR U4)

Part of the [Mathlib limits PR queue](MATHLIB_LIMITS_PR_QUEUE.md). **Status: draft ready.**

## Suggested PR title

`CategoryTheory/Limits: add reference examples for terminal and initial objects`

## Target file(s)

- `Mathlib/CategoryTheory/Limits/Shapes/Terminal.lean`

In Mathlib v4.31.0, `HasTerminal`, `HasInitial`, `terminal`, and `initial` are defined in this single module (there is no separate `Initial.lean` under `Limits/Shapes/`). Paste the `section ReferenceExamples` block from [`04-terminal-initial-examples.lean`](04-terminal-initial-examples.lean) inside `namespace CategoryTheory.Limits`, before the closing `end CategoryTheory.Limits`.

## PR type

**Examples-only — not a theorem PR.** Do not add automation, attributes, or tactic hooks.

## Rationale

Terminal and initial objects are limits/colimits of `Functor.empty C`, but users often meet `HasTerminal` / `HasInitial` before the general empty-diagram API. These examples connect the shape-specific typeclasses to the canonical `limit.cone` / `colimit.cocone` proof pattern used in lean-uprove (`terminal_manual`, `initial_manual`).

## Example list

| # | Statement | Proof idea |
|:--|:--|:--|
| 1 | `IsLimit (limit.cone (Functor.empty C))` | `limit.isLimit (Functor.empty C)` |
| 2 | `c ≅ limit.cone (Functor.empty C)` for `hc : IsLimit c` | `hc.uniqueUpToIso (limit.isLimit (Functor.empty C))` |
| 3 | `IsColimit (colimit.cocone (Functor.empty C))` | `colimit.isColimit (Functor.empty C)` |
| 4 | `c ≅ colimit.cocone (Functor.empty C)` for `hc : IsColimit c` | `hc.uniqueUpToIso (colimit.isColimit (Functor.empty C))` |

## Lean content

Full copy-paste draft: [`04-terminal-initial-examples.lean`](04-terminal-initial-examples.lean).

## Verification checklist

- [ ] Confirm `HasTerminal`, `HasInitial`, and `Functor.empty` API on Mathlib `v4.31.0`.
- [ ] `lake build` on the Mathlib branch after pasting examples.
- [ ] No new axioms; only `noncomputable example` blocks.
- [ ] No automation, attributes, or tactic hooks added.
- [ ] Cross-check against `terminal_manual` / `initial_manual` in [`examples/BasicExamples.lean`](../../examples/BasicExamples.lean).
- [ ] Typecheck all upstream drafts: `lake env lean docs/upstream/_verify_upstream_examples.lean`.
- [ ] Confirm lean-uprove gate still passes: `scripts/verify-gate1.sh` (or `.bat` on Windows).

## Review risk

Low — examples only, no API changes.
