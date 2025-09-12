# Uprove Cookbook

A collection of 20 common patterns and examples for using the `uprove` tactic.

## Basic Universal Properties

### 1. Product Limits
```lean
theorem product_limit {C : Type} [Category C] (X Y : C) [HasProduct X Y] : 
  IsLimit (limitCone (pair X Y)) := by uprove
```

### 2. Coproduct Colimits
```lean
theorem coproduct_colimit {C : Type} [Category C] (X Y : C) [HasCoproduct X Y] : 
  IsColimit (colimitCocone (copair X Y)) := by uprove
```

### 3. Equalizers
```lean
theorem equalizer_limit {C : Type} [Category C] (X Y : C) (f g : X ⟶ Y) [HasEqualizer f g] : 
  IsLimit (equalizerCone f g) := by uprove
```

### 4. Coequalizers
```lean
theorem coequalizer_colimit {C : Type} [Category C] (X Y : C) (f g : X ⟶ Y) [HasCoequalizer f g] : 
  IsColimit (coequalizerCocone f g) := by uprove
```

### 5. Pullbacks
```lean
theorem pullback_limit {C : Type} [Category C] (X Y Z : C) (f : X ⟶ Z) (g : Y ⟶ Z) [HasPullback f g] : 
  IsLimit (pullbackCone f g) := by uprove
```

### 6. Pushouts
```lean
theorem pushout_colimit {C : Type} [Category C] (X Y Z : C) (f : X ⟶ Y) (g : X ⟶ Z) [HasPushout f g] : 
  IsColimit (pushoutCocone f g) := by uprove
```

### 7. Terminal Objects
```lean
theorem terminal_limit {C : Type} [Category C] [HasTerminal C] : 
  IsLimit (terminalCone C) := by uprove
```

### 8. Initial Objects
```lean
theorem initial_colimit {C : Type} [Category C] [HasInitial C] : 
  IsColimit (initialCocone C) := by uprove
```

### 9. Exponentials
```lean
theorem exponential_limit {C : Type} [Category C] [CartesianClosed C] (X Y : C) [HasExponential X Y] : 
  IsExponential (exp X Y) := by uprove
```

### 10. Isomorphisms
```lean
theorem iso_proof {C : Type} [Category C] (X Y : C) (f : X ⟶ Y) [IsIso f] : 
  IsIso f := by uprove
```

## Configuration Patterns

### 11. Fast Mode
```lean
theorem fast_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [config := Uprove.fastConfig]
```

### 12. Thorough Mode
```lean
theorem thorough_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [config := Uprove.thoroughConfig]
```

### 13. Debug Mode
```lean
theorem debug_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [config := Uprove.debugConfig]
```

### 14. Custom Configuration
```lean
theorem custom_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [maxSteps := 128, timeout := 5000, trace := true, enableTelemetry := true]
```

### 15. Strict Mode
```lean
theorem strict_proof : IsLimit (limitCone (pair X Y)) := by uprove [strict := true]
```

## Advanced Patterns

### 16. Explainer Mode
```lean
theorem explained_proof : IsLimit (limitCone (pair X Y)) := by uprove?
```

### 17. Multiple Goals
```lean
theorem multiple_goals : IsLimit (limitCone (pair X Y)) ∧ IsColimit (colimitCocone (copair X Y)) := by
  constructor
  · uprove
  · uprove
```

### 18. Nested Universal Properties
```lean
theorem nested_proof : IsLimit (limitCone (pair (limit X) (limit Y))) := by uprove
```

### 19. Duality Patterns
```lean
theorem duality : IsColimit (pushoutCocone f g) ↔ IsLimit (pullbackCone f.op g.op) := by
  constructor
  · uprove
  · uprove
```

### 20. Conditional Proofs
```lean
theorem conditional_proof (h : HasProduct X Y) : IsLimit (limitCone (pair X Y)) := by
  cases h
  uprove
```

## Troubleshooting Patterns

### When uprove fails

1. **Check pattern matching**: Ensure the goal matches a universal property pattern
2. **Enable tracing**: `uprove [trace := true]` to see what's happening
3. **Increase timeout**: `uprove [timeout := 5000]` for complex proofs
4. **Use fallback**: `uprove [strict := false]` to enable fallback tactics
5. **Check configuration**: Verify all configuration options are valid

### Common Issues

- **Goal not recognized**: The goal doesn't match any registered universal property pattern
- **Timeout**: The proof takes too long; try increasing timeout or reducing maxSteps
- **Memory issues**: The proof uses too much memory; try reducing complexity
- **Pattern mismatch**: The goal structure doesn't match expected patterns
- **Missing dependencies**: Required lemmas or instances are not available

## Best Practices

1. **Use appropriate configuration**: Choose fast, default, or thorough based on your needs
2. **Enable telemetry**: Use `enableTelemetry := true` for performance monitoring
3. **Use explainer mode**: Use `uprove?` when learning or debugging
4. **Handle errors gracefully**: Use `strict := false` in development
5. **Monitor performance**: Check that proofs complete within SLA bounds
6. **Test thoroughly**: Use the golden test suite to ensure correctness
7. **Document patterns**: Add new patterns to the cookbook when discovered

## Performance Tips

1. **Use fast mode** for simple proofs
2. **Use thorough mode** for complex proofs
3. **Enable telemetry** to monitor performance
4. **Set appropriate timeouts** based on proof complexity
5. **Use fallback tactics** when patterns don't match
6. **Monitor memory usage** for large proofs

## Integration Tips

1. **Combine with other tactics**: Use `uprove` as part of larger proof strategies
2. **Use in proofs by contradiction**: `uprove` works well in proof by contradiction
3. **Use in induction**: `uprove` can handle base cases and inductive steps
4. **Use in case analysis**: `uprove` works well in case analysis proofs
5. **Use in existential proofs**: `uprove` can construct witnesses for existential goals
