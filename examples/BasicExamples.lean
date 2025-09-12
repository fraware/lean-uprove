import Uprove
import Mathlib.CategoryTheory.Limits.Basic
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Coproducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Coequalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullbacks
import Mathlib.CategoryTheory.Limits.Shapes.Pushouts
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.Shapes.Initial
import Mathlib.CategoryTheory.Closed.Cartesian

-- Basic examples demonstrating uprove usage
namespace UproveExamples

-- Example 1: Product limits
theorem product_example {C : Type} [Category C] (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Example 2: Coproduct colimits
theorem coproduct_example {C : Type} [Category C] (X Y : C) [HasCoproduct X Y] :
  IsColimit (colimitCocone (copair X Y)) := by uprove

-- Example 3: Equalizers
theorem equalizer_example {C : Type} [Category C] (X Y : C) (f g : X ⟶ Y) [HasEqualizer f g] :
  IsLimit (equalizerCone f g) := by uprove

-- Example 4: Coequalizers
theorem coequalizer_example {C : Type} [Category C] (X Y : C) (f g : X ⟶ Y) [HasCoequalizer f g] :
  IsColimit (coequalizerCocone f g) := by uprove

-- Example 5: Pullbacks
theorem pullback_example {C : Type} [Category C] (X Y Z : C) (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
  IsLimit (pullbackCone f g) := by uprove

-- Example 6: Pushouts
theorem pushout_example {C : Type} [Category C] (X Y Z : C) (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
  IsColimit (pushoutCocone f g) := by uprove

-- Example 7: Terminal objects
theorem terminal_example {C : Type} [Category C] [HasTerminal C] :
  IsLimit (terminalCone C) := by uprove

-- Example 8: Initial objects
theorem initial_example {C : Type} [Category C] [HasInitial C] :
  IsColimit (initialCocone C) := by uprove

-- Example 9: Exponentials
theorem exponential_example {C : Type} [Category C] [CartesianClosed C] (X Y : C) [HasExponential X Y] :
  IsExponential (exp X Y) := by uprove

-- Example 10: Isomorphisms
theorem iso_example {C : Type} [Category C] (X Y : C) (f : X ⟶ Y) [IsIso f] :
  IsIso f := by uprove

-- Example 11: Explainer mode
theorem explained_example {C : Type} [Category C] (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove?

-- Example 12: With configuration
theorem configured_example {C : Type} [Category C] (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [maxSteps := 32, timeout := 1000]

-- Example 13: Multiple goals
theorem multiple_goals_example {C : Type} [Category C] (X Y : C) [HasProduct X Y] [HasCoproduct X Y] :
  IsLimit (limitCone (pair X Y)) ∧ IsColimit (colimitCocone (copair X Y)) := by
  constructor
  · uprove
  · uprove

-- Example 14: Nested universal properties
theorem nested_example {C : Type} [Category C] (X Y Z : C) [HasProduct X Y] [HasProduct (X ⨯ Y) Z] :
  IsLimit (limitCone (pair (X ⨯ Y) Z)) := by uprove

-- Example 15: With custom fallback
theorem custom_fallback_example {C : Type} [Category C] (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [fallback := ["simp", "aesop", "omega"]]

end UproveExamples
