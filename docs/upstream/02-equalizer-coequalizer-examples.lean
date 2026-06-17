/-
Copyright (c) 2026 lean-uprove contributors.
Released under Apache 2.0 license as described in the file LICENSE.

! Upstream draft for mathlib4 — not part of the Lake build.
!
! Target file: `Mathlib/CategoryTheory/Limits/Shapes/Equalizers.lean`
! (equalizers and coequalizers live in the same module in Mathlib v4.31.0)
! Paste context: inside `namespace CategoryTheory.Limits`, before the final
! `end CategoryTheory.Limits`. The file already imports `HasLimits` and pullback
! shapes; no new imports should be required.
! Source patterns: `examples/BasicExamples.lean`, `examples/ManualProofs.lean`.
-/

import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.HasLimits

/-!
# Examples: equalizer and coequalizer universal properties

Worked examples for `parallelPair` diagrams: canonical (co)limit cones and
uniqueness up to isomorphism.
-/

namespace CategoryTheory.Limits

universe u v

variable {C : Type u} [Category.{v} C]

section ReferenceExamples

/-- The canonical cone for an equalizer diagram is a limit. -/
noncomputable example {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g] :
    IsLimit (limit.cone (parallelPair f g)) :=
  limit.isLimit (parallelPair f g)

/-- Any limit cone for `parallelPair f g` is isomorphic to the canonical one. -/
noncomputable example {X Y : C} (f g : X ⟶ Y) [HasEqualizer f g]
    {c : Cone (parallelPair f g)} (hc : IsLimit c) :
    c ≅ limit.cone (parallelPair f g) :=
  hc.uniqueUpToIso (limit.isLimit (parallelPair f g))

/-- The canonical cocone for a coequalizer diagram is a colimit. -/
noncomputable example {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g] :
    IsColimit (colimit.cocone (parallelPair f g)) :=
  colimit.isColimit (parallelPair f g)

/-- Any colimit cocone for `parallelPair f g` is isomorphic to the canonical one. -/
noncomputable example {X Y : C} (f g : X ⟶ Y) [HasCoequalizer f g]
    {c : Cocone (parallelPair f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (parallelPair f g) :=
  hc.uniqueUpToIso (colimit.isColimit (parallelPair f g))

end ReferenceExamples

end CategoryTheory.Limits
