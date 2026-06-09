import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal

/-!
Stable reference shapes for universal-property goals on the current Mathlib line.

Full manual + automation comparisons live in `examples/BasicExamples.lean`.
-/

namespace Uprove

open CategoryTheory Limits

universe u v

variable {C : Type u} [Category.{v} C]

noncomputable def productGoal (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

noncomputable def productGoalUniq (X Y : C) [HasBinaryProduct X Y]
    {c : Cone (pair X Y)} (hc : IsLimit c) : c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

noncomputable def coproductGoal (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

noncomputable def equalizerGoal {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit (parallelPair f g)

noncomputable def coequalizerGoal {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit (parallelPair f g)

noncomputable def pullbackGoal {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit (cospan f g)

noncomputable def pushoutGoal {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit (span f g)

noncomputable def terminalGoal [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit (Functor.empty C)

noncomputable def initialGoal [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit (Functor.empty C)

end Uprove
