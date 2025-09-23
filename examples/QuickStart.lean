import Uprove
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Coproducts

-- Quick Start Example for lean-uprove
-- This file demonstrates the core functionality in under 5 minutes

namespace QuickStart

-- Basic category setup
variable {C : Type} [Category C]

-- Example 1: Product limits (most common use case)
theorem product_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Example 2: Coproduct colimits
theorem coproduct_example (X Y : C) [HasCoproduct X Y] :
  IsColimit (colimitCocone (copair X Y)) := by uprove

-- Example 3: Explainer mode - shows exactly what uprove does
theorem explained_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove?

-- Example 4: With custom configuration
theorem configured_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [maxSteps := 32, timeout := 1000]

-- Example 5: Multiple goals
theorem multiple_goals_example (X Y : C) [HasProduct X Y] [HasCoproduct X Y] :
  IsLimit (limitCone (pair X Y)) ∧ IsColimit (colimitCocone (copair X Y)) := by
  constructor
  · uprove
  · uprove

-- Example 6: Performance test
theorem performance_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Example 7: Error handling
theorem error_handling_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [strict := true]

-- Example 8: Telemetry
theorem telemetry_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [enableTelemetry := true]

-- Example 9: Custom fallback
theorem custom_fallback_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [fallback := ["simp", "aesop", "omega"]]

-- Example 10: Complex proof
theorem complex_example (X Y Z : C) [HasProduct X Y] [HasProduct (X ⨯ Y) Z] :
  IsLimit (limitCone (pair (X ⨯ Y) Z)) := by uprove

end QuickStart

-- Usage instructions:
-- 1. Install lean-uprove using one of the methods in README.md
-- 2. Add this file to your project
-- 3. Run: lean-uprove examples
-- 4. Or compile with: lake build
-- 5. Or run tests with: lake test
