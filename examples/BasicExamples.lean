import Uprove
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Iso

open CategoryTheory Limits

namespace UproveExamples

universe u v

variable {C : Type u} [Category.{v} C]

noncomputable def product_example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit _

noncomputable def coproduct_example (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit _

noncomputable def equalizer_example {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit _

noncomputable def coequalizer_example {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit _

noncomputable def pullback_example {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit _

noncomputable def pushout_example {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit _

noncomputable def terminal_example [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit _

noncomputable def initial_example [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit _

theorem iso_example {X Y : C} (f : X ⟶ Y) [IsIso f] : IsIso f :=
  inferInstance

end UproveExamples
