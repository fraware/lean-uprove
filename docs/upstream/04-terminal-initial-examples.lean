/-
Copyright (c) 2026 lean-uprove contributors.
Released under Apache 2.0 license as described in the file LICENSE.

! Upstream draft for mathlib4 — not part of the Lake build.
!
! Target file: `Mathlib/CategoryTheory/Limits/Shapes/Terminal.lean`
! (terminal and initial objects live in the same module in Mathlib v4.31.0)
! Paste context: inside `namespace CategoryTheory.Limits`, before the final
! `end CategoryTheory.Limits`. The file already imports `HasLimits` and defines
! `HasTerminal`, `HasInitial`, and `Functor.empty`; no new imports expected.
! Source patterns: `examples/BasicExamples.lean`, `examples/ManualProofs.lean`.
-/

import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.HasLimits

/-!
# Examples: terminal and initial object universal properties

Worked examples for empty diagrams: canonical (co)limit cones and uniqueness
up to isomorphism.
-/

namespace CategoryTheory.Limits

universe u v

variable {C : Type u} [Category.{v} C]

section ReferenceExamples

/-- The canonical cone for the empty diagram is a limit (terminal object). -/
noncomputable example [HasTerminal C] :
    IsLimit (limit.cone (Functor.empty C)) :=
  limit.isLimit (Functor.empty C)

/-- Any limit cone for the empty diagram is isomorphic to the canonical one. -/
noncomputable example [HasTerminal C] {c : Cone (Functor.empty C)} (hc : IsLimit c) :
    c ≅ limit.cone (Functor.empty C) :=
  hc.uniqueUpToIso (limit.isLimit (Functor.empty C))

/-- The canonical cocone for the empty diagram is a colimit (initial object). -/
noncomputable example [HasInitial C] :
    IsColimit (colimit.cocone (Functor.empty C)) :=
  colimit.isColimit (Functor.empty C)

/-- Any colimit cocone for the empty diagram is isomorphic to the canonical one. -/
noncomputable example [HasInitial C] {c : Cocone (Functor.empty C)} (hc : IsColimit c) :
    c ≅ colimit.cocone (Functor.empty C) :=
  hc.uniqueUpToIso (colimit.isColimit (Functor.empty C))

end ReferenceExamples

end CategoryTheory.Limits
