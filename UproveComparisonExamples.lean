import Uprove.Tactics
import examples.BasicExamples

/-!
Optional `uprove` / `uprove?` comparisons against manual examples.

Import `UproveRegisterInit` in your project before using `uprove` tactics.
This module intentionally avoids that import so it can build on all platforms;
tactic examples below remain commented until the planner is stable.

Build with `lake build UproveComparison` — not part of the extraction CI gate.
-/

open CategoryTheory Limits

namespace UproveExamples.Comparison

universe u v

variable {C : Type u} [Category.{v} C]

/-!
After `import UproveRegisterInit` in your file:

example (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) := by
  uprove
-/

/-- Side-by-side reference to the manual proof in `BasicExamples`. -/
noncomputable def product_manual_ref (X Y : C) [HasBinaryProduct X Y] :=
  product_manual X Y

end UproveExamples.Comparison
