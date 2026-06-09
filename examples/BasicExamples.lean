import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Iso

/-!
Universal-property examples for Mathlib extraction (Lean 4.31 / current Mathlib).

**Manual** proofs compile without `Uprove` or `UproveRegisterInit`. Each construction has:
1. An `IsLimit` / `IsColimit` proof for the canonical cone/cocone.
2. A uniqueness theorem (`uniqueUpToIso`) exposing the universal property.

**Automation** entries record the Mathlib one-liner (`limit.isLimit _` / `colimit.isColimit _`)
that downstream tactics should eventually match. See `UproveComparisonExamples.lean` for
optional `uprove` comparisons (not part of the extraction gate).
-/

open CategoryTheory Limits

namespace UproveExamples

universe u v

variable {C : Type u} [Category.{v} C]

/-! ## Manual proofs (Mathlib only) -/

/-- Binary product: the canonical cone from `limit.cone (pair X Y)` is a limit. -/
noncomputable def product_manual (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

/-- Any other limit cone for `pair X Y` is unique up to isomorphism. -/
noncomputable def product_manual_uniq (X Y : C) [HasBinaryProduct X Y]
    {c : Cone (pair X Y)} (hc : IsLimit c) :
    c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

/-- Binary coproduct: the canonical cocone is a colimit. -/
noncomputable def coproduct_manual (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

noncomputable def coproduct_manual_uniq (X Y : C) [HasBinaryCoproduct X Y]
    {c : Cocone (pair X Y)} (hc : IsColimit c) :
    c ≅ colimit.cocone (pair X Y) :=
  hc.uniqueUpToIso (colimit.isColimit (pair X Y))

/-- Equalizer: canonical cone for `parallelPair f g`. -/
noncomputable def equalizer_manual {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit (parallelPair f g)

noncomputable def equalizer_manual_uniq {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g]
    {c : Cone (parallelPair f g)} (hc : IsLimit c) :
    c ≅ limit.cone (parallelPair f g) :=
  hc.uniqueUpToIso (limit.isLimit (parallelPair f g))

/-- Coequalizer: canonical cocone for `parallelPair f g`. -/
noncomputable def coequalizer_manual {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit (parallelPair f g)

noncomputable def coequalizer_manual_uniq {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g]
    {c : Cocone (parallelPair f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (parallelPair f g) :=
  hc.uniqueUpToIso (colimit.isColimit (parallelPair f g))

/-- Pullback: canonical cone for `cospan f g`. -/
noncomputable def pullback_manual {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit (cospan f g)

noncomputable def pullback_manual_uniq {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g]
    {c : Cone (cospan f g)} (hc : IsLimit c) :
    c ≅ limit.cone (cospan f g) :=
  hc.uniqueUpToIso (limit.isLimit (cospan f g))

/-- Pushout: canonical cocone for `span f g`. -/
noncomputable def pushout_manual {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit (span f g)

noncomputable def pushout_manual_uniq {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g]
    {c : Cocone (span f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (span f g) :=
  hc.uniqueUpToIso (colimit.isColimit (span f g))

/-- Terminal object: limit of the empty diagram. -/
noncomputable def terminal_manual [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit (Functor.empty C)

noncomputable def terminal_manual_uniq [HasTerminal C] {c : Cone (Functor.empty C)} (hc : IsLimit c) :
    c ≅ limit.cone (Functor.empty C) :=
  hc.uniqueUpToIso (limit.isLimit (Functor.empty C))

/-- Initial object: colimit of the empty diagram. -/
noncomputable def initial_manual [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit (Functor.empty C)

noncomputable def initial_manual_uniq [HasInitial C] {c : Cocone (Functor.empty C)} (hc : IsColimit c) :
    c ≅ colimit.cocone (Functor.empty C) :=
  hc.uniqueUpToIso (colimit.isColimit (Functor.empty C))

/-! ## Automation comparison (Mathlib one-liners) -/

noncomputable def product_automation (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit _

noncomputable def coproduct_automation (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit _

noncomputable def equalizer_automation {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit _

noncomputable def coequalizer_automation {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit _

noncomputable def pullback_automation {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit _

noncomputable def pushout_automation {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit _

noncomputable def terminal_automation [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit _

noncomputable def initial_automation [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit _

theorem iso_example {X Y : C} (f : X ⟶ Y) [IsIso f] : IsIso f :=
  inferInstance

end UproveExamples
