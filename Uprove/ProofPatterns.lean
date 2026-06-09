import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts

/-!
Universal-property **proof patterns** for Mathlib extraction.

Recurring shapes the `uprove` planner targets. Stable reference only — no tactic imports.
Compare with `examples/BasicExamples.lean` and `docs/EXTRACTION_LEDGER.md`.
-/

namespace Uprove.ProofPatterns

open CategoryTheory Limits

universe u v

variable {C : Type u} [Category.{v} C]

section BinaryProduct

variable (X Y : C) [HasBinaryProduct X Y]

/-- Goal shape: canonical binary-product cone is a limit. -/
noncomputable def productGoal : IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit (pair X Y)

/-- Goal shape: any limit cone is unique up to isomorphism. -/
noncomputable def productUniq {c : Cone (pair X Y)} (hc : IsLimit c) :
    c ≅ limit.cone (pair X Y) :=
  hc.uniqueUpToIso (limit.isLimit (pair X Y))

end BinaryProduct

section BinaryCoproduct

variable (X Y : C) [HasBinaryCoproduct X Y]

/-- Goal shape: canonical binary-coproduct cocone is a colimit. -/
noncomputable def coproductGoal : IsColimit (colimit.cocone (pair X Y)) :=
  colimit.isColimit (pair X Y)

/-- Goal shape: any colimit cocone is unique up to isomorphism. -/
noncomputable def coproductUniq {c : Cocone (pair X Y)} (hc : IsColimit c) :
    c ≅ colimit.cocone (pair X Y) :=
  hc.uniqueUpToIso (colimit.isColimit (pair X Y))

end BinaryCoproduct

end Uprove.ProofPatterns
