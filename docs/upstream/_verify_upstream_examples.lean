/-
API verification harness for upstream draft examples (not part of the Lake build).

Mirrors the `section ReferenceExamples` blocks in `01`–`04` draft `.lean` files.
Update this file whenever those drafts change.

Run from repo root:
  lake env lean docs/upstream/_verify_upstream_examples.lean
-/

import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.HasLimits

namespace CategoryTheory.Limits

universe u v
variable {C : Type u} [Category.{v} C]

-- U1: binary products / coproducts
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

noncomputable example (X Y : C) [HasBinaryProduct X Y] {c : Cone (pair X Y)} (hc : IsLimit c) :
    c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

noncomputable example (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

noncomputable example (X Y : C) [HasBinaryCoproduct X Y] {c : Cocone (pair X Y)} (hc : IsColimit c) :
    c ≅ colimit.cocone (pair X Y) :=
  hc.uniqueUpToIso (colimit.isColimit (pair X Y))

-- U2: equalizers / coequalizers
noncomputable example {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit (parallelPair f g)

noncomputable example {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g]
    {c : Cone (parallelPair f g)} (hc : IsLimit c) :
    c ≅ limit.cone (parallelPair f g) :=
  hc.uniqueUpToIso (limit.isLimit (parallelPair f g))

noncomputable example {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit (parallelPair f g)

noncomputable example {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g]
    {c : Cocone (parallelPair f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (parallelPair f g) :=
  hc.uniqueUpToIso (colimit.isColimit (parallelPair f g))

-- U3: pullbacks / pushouts
noncomputable example {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit (cospan f g)

noncomputable example {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g]
    {c : Cone (cospan f g)} (hc : IsLimit c) :
    c ≅ limit.cone (cospan f g) :=
  hc.uniqueUpToIso (limit.isLimit (cospan f g))

noncomputable example {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit (span f g)

noncomputable example {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g]
    {c : Cocone (span f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (span f g) :=
  hc.uniqueUpToIso (colimit.isColimit (span f g))

-- U4: terminal / initial
noncomputable example [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit (Functor.empty C)

noncomputable example [HasTerminal C] {c : Cone (Functor.empty C)} (hc : IsLimit c) :
    c ≅ limit.cone (Functor.empty C) :=
  hc.uniqueUpToIso (limit.isLimit (Functor.empty C))

noncomputable example [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit (Functor.empty C)

noncomputable example [HasInitial C] {c : Cocone (Functor.empty C)} (hc : IsColimit c) :
    c ≅ colimit.cocone (Functor.empty C) :=
  hc.uniqueUpToIso (colimit.isColimit (Functor.empty C))

end CategoryTheory.Limits
