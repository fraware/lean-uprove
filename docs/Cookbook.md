# Uprove cookbook

Recipes and patterns for **`uprove`**. This repository targets **Mathlib 4.12.x**. If your Mathlib version differs, check `examples/BasicExamples.lean` and upstream docs for naming.

**Imports (recommended):**

```lean
import UproveRegisterInit
import Uprove
```

**Registration:** use **`@[uproveLemma]`** for universal-property lemmas and **`@[uprove.iso]`** for isomorphism helpers (see README API table).

## Limits and colimits (illustrative)

These snippets are **templates**. In Mathlib 4.12, canonical cones use `limit.cone` / `colimit.cocone` and typeclass names like `HasBinaryProduct`. Many statements are **`noncomputable def`** with `limit.isLimit _` / `colimit.isColimit _` rather than `by uprove`, depending on whether your goal is a `Prop`.

### Binary product

```lean
noncomputable def product_limit {C : Type u} [Category.{v} C] (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit _
```

### Binary coproduct

```lean
noncomputable def coproduct_colimit {C : Type u} [Category.{v} C] (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit _
```

### Equalizer / coequalizer

```lean
noncomputable def equalizer_limit {C : Type u} [Category.{v} C] {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit _

noncomputable def coequalizer_colimit {C : Type u} [Category.{v} C] {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit _
```

### Pullback / pushout

```lean
noncomputable def pullback_limit {C : Type u} [Category.{v} C] {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit _

noncomputable def pushout_colimit {C : Type u} [Category.{v} C] {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit _
```

### Terminal / initial

```lean
noncomputable def terminal_limit {C : Type u} [Category.{v} C] [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit _

noncomputable def initial_colimit {C : Type u} [Category.{v} C] [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit _
```

### Isomorphisms

```lean
theorem iso_proof {C : Type u} [Category.{v} C] {X Y : C} (f : X ⟶ Y) [IsIso f] : IsIso f :=
  inferInstance
```

### Exponentials

Exponential support depends on your Mathlib version and how exponentials are stated. Prefer the same constructs your project already uses for cartesian closed structure; add a custom `@[uproveLemma]` lemma if you need a stable hook for `uprove`.

## Tactic configuration

`uprove` and `uprove?` accept **one** bracket term of type **`UproveOptions`**:

```lean
-- by uprove [Uprove.fastConfig]
-- by uprove [Uprove.thoroughConfig]
-- by uprove [{ maxSteps := 128, timeout := 5000, trace := true with }]
-- by uprove [{ strict := true }]  -- overrides default fields of UproveOptions
```

Presets live in `Uprove/Configuration.lean` (`fastConfig`, `thoroughConfig`, `debugConfig`).

## Explainer and multi-goal

```lean
-- by uprove?

-- constructor then uprove on each branch when goals match registered patterns
```

## Engine expectations

Pattern matching and normalization in `Uprove/Core.lean` are still **partial** relative to full category theory. If `uprove` does not close a goal, use `uprove?`, fallbacks, or a manual proof. Tighten with **`strict := true`** only when you want failures instead of fallback.

## References

- `examples/BasicExamples.lean` — CI-checked Mathlib 4.12 examples.
- [Quickstart](Quickstart.md), [Troubleshooting](Troubleshooting.md).
