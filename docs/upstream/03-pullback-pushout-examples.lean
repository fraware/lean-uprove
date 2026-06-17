/-
Copyright (c) 2026 lean-uprove contributors.
Released under Apache 2.0 license as described in the file LICENSE.

! Upstream draft for mathlib4 — not part of the Lake build.
!
! Target file: `Mathlib/CategoryTheory/Limits/Shapes/Pullback/HasPullback.lean`
! (pullbacks and pushouts share this module in Mathlib v4.31.0)
! Paste context: inside `namespace CategoryTheory.Limits`, before the final
! `end CategoryTheory.Limits`. The file already defines `HasPullback`, `HasPushout`,
! `cospan`, and `span`; no new imports should be required.
! Source patterns: `examples/BasicExamples.lean`, `examples/ManualProofs.lean`.
-/

import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.HasLimits

/-!
# Examples: pullback and pushout universal properties

Worked examples for `cospan` / `span` diagrams: canonical (co)limit cones and
uniqueness up to isomorphism.
-/

namespace CategoryTheory.Limits

universe u v

variable {C : Type u} [Category.{v} C]

section ReferenceExamples

/-- The canonical cone for a pullback diagram is a limit. -/
noncomputable example {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
    IsLimit (limit.cone (cospan f g)) :=
  limit.isLimit (cospan f g)

/-- Any limit cone for `cospan f g` is isomorphic to the canonical one. -/
noncomputable example {X Y Z : C} (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g]
    {c : Cone (cospan f g)} (hc : IsLimit c) :
    c ≅ limit.cone (cospan f g) :=
  hc.uniqueUpToIso (limit.isLimit (cospan f g))

/-- The canonical cocone for a pushout diagram is a colimit. -/
noncomputable example {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
    IsColimit (colimit.cocone (span f g)) :=
  colimit.isColimit (span f g)

/-- Any colimit cocone for `span f g` is isomorphic to the canonical one. -/
noncomputable example {X Y Z : C} (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g]
    {c : Cocone (span f g)} (hc : IsColimit c) :
    c ≅ colimit.cocone (span f g) :=
  hc.uniqueUpToIso (colimit.isColimit (span f g))

end ReferenceExamples

end CategoryTheory.Limits
