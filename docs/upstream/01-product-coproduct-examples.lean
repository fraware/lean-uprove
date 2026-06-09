/-
Copyright (c) 2026 lean-uprove contributors.
Released under Apache 2.0 license as described in the file LICENSE.

! This file is an **upstream draft** for mathlib4. It is not part of the Lake build.
! Adapt the module header and namespace to match Mathlib conventions before opening a PR.
! Source of truth in lean-uprove: `examples/BasicExamples.lean`, `examples/ManualProofs.lean`.
-/

import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.HasLimits

/-!
# Examples: binary product and coproduct universal properties

Worked examples showing that canonical cones/cocones are (co)limits and that
alternative (co)limit cones are unique up to isomorphism.

These patterns are the first Mathlib upstream target from lean-uprove extraction.
-/

namespace CategoryTheory.Limits.Examples

universe u v

variable {C : Type u} [Category.{v} C]

section BinaryProduct

variable (X Y : C) [HasBinaryProduct X Y]

/-- The canonical cone for a binary product diagram is a limit. -/
noncomputable def binaryProduct_isLimit :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

/-- Any limit cone for `pair X Y` is isomorphic to the canonical one. -/
noncomputable def binaryProduct_unique {c : Cone (pair X Y)} (hc : IsLimit c) :
    c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

end BinaryProduct

section BinaryCoproduct

variable (X Y : C) [HasBinaryCoproduct X Y]

/-- The canonical cocone for a binary coproduct diagram is a colimit. -/
noncomputable def binaryCoproduct_isColimit :
    IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

/-- Any colimit cocone for `pair X Y` is isomorphic to the canonical one. -/
noncomputable def binaryCoproduct_unique {c : Cocone (pair X Y)} (hc : IsColimit c) :
    c ≅ colimit.cocone (pair X Y) :=
  hc.uniqueUpToIso (colimit.isColimit (pair X Y))

end BinaryCoproduct

end CategoryTheory.Limits.Examples
