import Mathlib.CategoryTheory.Types.Basic
import Mathlib.CategoryTheory.Limits.Types.Products
import Mathlib.CategoryTheory.Limits.Types.Colimits
import Mathlib.CategoryTheory.Limits.Types.Limits
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback

/-!
Explicit universal-property proof patterns in the `Type` category.

These complement the abstract examples in `BasicExamples.lean` by showing the
proof steps Mathlib should document: canonical cone/cocone, `limit.isLimit`, and
`uniqueUpToIso`. All proofs are Mathlib-only (no `uprove`).
-/

open CategoryTheory Limits

namespace UproveExamples.ManualProofs

universe u

section ProductCoproduct

variable (A B : Type u)

/-- Product in `Type`: canonical cone is a limit (term-mode proof). -/
noncomputable def productType : IsLimit (limit.cone (pair A B)) :=
  limit.isLimit (pair A B)

/-- Product in `Type`: same goal with an explicit tactic script. -/
noncomputable example : IsLimit (limit.cone (pair A B)) := by
  exact limit.isLimit (pair A B)

/-- Product uniqueness up to isomorphism. -/
noncomputable example {c : Cone (pair A B)} (hc : IsLimit c) : c ≅ limit.cone (pair A B) := by
  exact hc.uniqueUpToIso (limit.isLimit (pair A B))

/-- Coproduct in `Type`: canonical cocone is a colimit. -/
noncomputable def coproductType : IsColimit (colimit.cocone (pair A B)) :=
  colimit.isColimit (pair A B)

noncomputable example : IsColimit (colimit.cocone (pair A B)) := by
  exact colimit.isColimit (pair A B)

noncomputable example {c : Cocone (pair A B)} (hc : IsColimit c) : c ≅ colimit.cocone (pair A B) := by
  exact hc.uniqueUpToIso (colimit.isColimit (pair A B))

end ProductCoproduct

section EqualizerCoequalizer

variable {A B : Type u} (f g : A ⟶ B)

/-- Equalizer in `Type` (when it exists). -/
noncomputable def equalizerType [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit (parallelPair f g)

noncomputable example [HasEqualizer f g] : IsLimit (limit.cone (parallelPair f g)) := by
  exact limit.isLimit (parallelPair f g)

noncomputable example [HasEqualizer f g] {c : Cone (parallelPair f g)} (hc : IsLimit c) :
    c ≅ limit.cone (parallelPair f g) := by
  exact hc.uniqueUpToIso (limit.isLimit (parallelPair f g))

/-- Coequalizer in `Type` (when it exists). -/
noncomputable def coequalizerType [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit (parallelPair f g)

noncomputable example [HasCoequalizer f g] : IsColimit (colimit.cocone (parallelPair f g)) := by
  exact colimit.isColimit (parallelPair f g)

end EqualizerCoequalizer

section PullbackPushout

variable {A B C : Type u} (f : A ⟶ C) (g : B ⟶ C)

noncomputable def pullbackType [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit (cospan f g)

noncomputable example [HasPullback f g] : IsLimit (limit.cone (cospan f g)) := by
  exact limit.isLimit (cospan f g)

variable {X Y Z : Type u} (f' : X ⟶ Y) (g' : X ⟶ Z)

noncomputable def pushoutType [HasPushout f' g'] :
    IsColimit (colimit.cocone (span f' g')) :=
  colimit.isColimit (span f' g')

noncomputable example [HasPushout f' g'] : IsColimit (colimit.cocone (span f' g')) := by
  exact colimit.isColimit (span f' g')

end PullbackPushout

section TerminalInitial

/-- Terminal object in `Type` is `PUnit`. -/
noncomputable def terminalType : IsLimit (limit.cone (Functor.empty (Type u))) :=
  limit.isLimit (Functor.empty (Type u))

noncomputable example : IsLimit (limit.cone (Functor.empty (Type u))) := by
  exact limit.isLimit (Functor.empty (Type u))

/-- Initial object in `Type` is `PEmpty`. -/
noncomputable def initialType : IsColimit (colimit.cocone (Functor.empty (Type u))) :=
  colimit.isColimit (Functor.empty (Type u))

noncomputable example : IsColimit (colimit.cocone (Functor.empty (Type u))) := by
  exact colimit.isColimit (Functor.empty (Type u))

end TerminalInitial

end UproveExamples.ManualProofs
