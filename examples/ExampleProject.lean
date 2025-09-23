import Uprove
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Coproducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Coequalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullbacks
import Mathlib.CategoryTheory.Limits.Shapes.Pushouts
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.Shapes.Initial
import Mathlib.CategoryTheory.Closed.Cartesian

-- Example project demonstrating lean-uprove usage
-- This file shows how to use the uprove tactic in a real project

namespace ExampleProject

-- Basic category setup
variable {C : Type} [Category C]

-- Example 1: Product limits - the most common use case
theorem product_limit_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Example 2: Coproduct colimits
theorem coproduct_colimit_example (X Y : C) [HasCoproduct X Y] :
  IsColimit (colimitCocone (copair X Y)) := by uprove

-- Example 3: Equalizers
theorem equalizer_example (X Y : C) (f g : X ⟶ Y) [HasEqualizer f g] :
  IsLimit (equalizerCone f g) := by uprove

-- Example 4: Coequalizers
theorem coequalizer_example (X Y : C) (f g : X ⟶ Y) [HasCoequalizer f g] :
  IsColimit (coequalizerCocone f g) := by uprove

-- Example 5: Pullbacks
theorem pullback_example (X Y Z : C) (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
  IsLimit (pullbackCone f g) := by uprove

-- Example 6: Pushouts
theorem pushout_example (X Y Z : C) (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] :
  IsColimit (pushoutCocone f g) := by uprove

-- Example 7: Terminal objects
theorem terminal_example [HasTerminal C] :
  IsLimit (terminalCone C) := by uprove

-- Example 8: Initial objects
theorem initial_example [HasInitial C] :
  IsColimit (initialCocone C) := by uprove

-- Example 9: Exponentials (in Cartesian closed categories)
theorem exponential_example [CartesianClosed C] (X Y : C) [HasExponential X Y] :
  IsExponential (exp X Y) := by uprove

-- Example 10: Explainer mode - shows proof steps
theorem explained_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove?

-- Example 11: With custom configuration
theorem configured_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [maxSteps := 32, timeout := 1000]

-- Example 12: Multiple goals
theorem multiple_goals_example (X Y : C) [HasProduct X Y] [HasCoproduct X Y] :
  IsLimit (limitCone (pair X Y)) ∧ IsColimit (colimitCocone (copair X Y)) := by
  constructor
  · uprove
  · uprove

-- Example 13: Nested universal properties
theorem nested_example (X Y Z : C) [HasProduct X Y] [HasProduct (X ⨯ Y) Z] :
  IsLimit (limitCone (pair (X ⨯ Y) Z)) := by uprove

-- Example 14: With custom fallback tactics
theorem custom_fallback_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [fallback := ["simp", "aesop", "omega"]]

-- Example 15: Complex category theory proof
theorem pullback_preserves_limits {C : Type} [Category C]
  (F : C ⥤ C) (preserves_limits : PreservesLimits F) (X Y : C) [HasProduct X Y] :
  IsLimit (F.mapCone (limitCone (pair X Y))) := by uprove

-- Example 16: Functor applications
theorem functor_applications {C D : Type} [Category C] [Category D]
  (F : C ⥤ D) (X Y : C) [HasProduct X Y] :
  IsLimit (F.mapCone (limitCone (pair X Y))) := by uprove

-- Example 17: Natural transformations
theorem natural_transformation_example {C D : Type} [Category C] [Category D]
  (F G : C ⥤ D) (α : F ⟶ G) (X Y : C) [HasProduct X Y] :
  IsLimit (G.mapCone (limitCone (pair X Y))) := by uprove

-- Example 18: Adjoint functors
theorem adjoint_example {C D : Type} [Category C] [Category D]
  (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G) (X Y : C) [HasProduct X Y] :
  IsLimit (F.mapCone (limitCone (pair X Y))) := by uprove

-- Example 19: Monoidal categories
theorem monoidal_example {C : Type} [Category C] [MonoidalCategory C]
  (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Example 20: Enriched categories
theorem enriched_example {C : Type} [Category C] [EnrichedCategory C]
  (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

-- Performance test examples
theorem performance_test_1 (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove

theorem performance_test_2 (X Y : C) [HasCoproduct X Y] :
  IsColimit (colimitCocone (copair X Y)) := by uprove

theorem performance_test_3 (X Y : C) (f g : X ⟶ Y) [HasEqualizer f g] :
  IsLimit (equalizerCone f g) := by uprove

theorem performance_test_4 (X Y : C) (f g : X ⟶ Y) [HasCoequalizer f g] :
  IsColimit (coequalizerCocone f g) := by uprove

theorem performance_test_5 (X Y Z : C) (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] :
  IsLimit (pullbackCone f g) := by uprove

-- Error handling examples
theorem error_handling_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [strict := true]

-- Telemetry examples
theorem telemetry_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [enableTelemetry := true]

-- Configuration examples
theorem config_example (X Y : C) [HasProduct X Y] :
  IsLimit (limitCone (pair X Y)) := by uprove [
    maxSteps := 64,
    timeout := 2000,
    simpSet := "uprove",
    trace := false,
    strict := false,
    fallback := ["simp", "aesop"],
    enableTelemetry := false
  ]

end ExampleProject
