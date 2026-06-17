/-
Copyright (c) 2026 lean-uprove contributors.
Released under Apache 2.0 license as described in the file LICENSE.

! Upstream draft for mathlib4 — not part of the Lake build.
!
! Target file: `Mathlib/CategoryTheory/Limits/Shapes/BinaryProducts.lean`
! Paste context: inside `namespace CategoryTheory.Limits`, before the final
! `end CategoryTheory.Limits`. That file already has `open CategoryTheory` and
! imports `HasLimits` / terminal shapes; no new imports should be required.
! Source patterns: `examples/BasicExamples.lean`, `examples/ManualProofs.lean`.
-/

import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.HasLimits

/-!
# Examples: binary product and coproduct universal properties

Worked examples showing that canonical cones/cocones are (co)limits and that
alternative (co)limit cones are unique up to isomorphism.

These patterns are the first Mathlib upstream target from lean-uprove extraction (PR U1).
-/

namespace CategoryTheory.Limits

universe u v

variable {C : Type u} [Category.{v} C]

section ReferenceExamples

/-- The canonical cone for a binary product diagram is a limit. -/
noncomputable example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

/-- Any limit cone for `pair X Y` is isomorphic to the canonical one. -/
noncomputable example (X Y : C) [HasBinaryProduct X Y] {c : Cone (pair X Y)} (hc : IsLimit c) :
    c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

/-- The canonical cocone for a binary coproduct diagram is a colimit. -/
noncomputable example (X Y : C) [HasBinaryCoproduct X Y] :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

/-- Any colimit cocone for `pair X Y` is isomorphic to the canonical one. -/
noncomputable example (X Y : C) [HasBinaryCoproduct X Y] {c : Cocone (pair X Y)} (hc : IsColimit c) :
    c ≅ colimit.cocone (pair X Y) :=
  hc.uniqueUpToIso (colimit.isColimit (pair X Y))

end ReferenceExamples

end CategoryTheory.Limits
