# Uprove Quickstart Guide

Get up and running with `uprove` in 90 seconds.

## Installation

Add to your `lakefile.lean`:

```lean
require uprove from git "https://github.com/fraware/lean-uprove.git"
```

Then run:
```bash
lake update
lake build
```

## Basic Usage

Import the library and use the tactic:

```lean
import Uprove

-- Basic universal property proof
theorem my_proof : IsLimit (limitCone (pair X Y)) := by uprove

-- Multiple goals
theorem multiple_goals : IsLimit (limitCone (pair X Y)) ∧ IsColimit (colimitCocone (copair X Y)) := by
  constructor
  · uprove
  · uprove
```

## Configuration

```lean
-- With custom configuration
theorem configured_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [maxSteps := 32, timeout := 1000, trace := true]

-- Using preset configurations
theorem fast_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [config := Uprove.fastConfig]

theorem thorough_proof : IsLimit (limitCone (pair X Y)) := by 
  uprove [config := Uprove.thoroughConfig]
```

## Explainer Mode

```lean
-- Get human-readable proof plan
theorem explained_proof : IsLimit (limitCone (pair X Y)) := by uprove?

-- With configuration
theorem explained_configured : IsLimit (limitCone (pair X Y)) := by 
  uprove? [maxSteps := 64, trace := true]
```

## Common Patterns

```lean
-- Products
theorem product_limit : IsLimit (limitCone (pair X Y)) := by uprove

-- Coproducts  
theorem coproduct_colimit : IsColimit (colimitCocone (copair X Y)) := by uprove

-- Equalizers
theorem equalizer_limit : IsLimit (equalizerCone f g) := by uprove

-- Pullbacks
theorem pullback_limit : IsLimit (pullbackCone f g) := by uprove

-- Terminal objects
theorem terminal_limit : IsLimit (terminalCone C) := by uprove
```

## Supported Universal Properties

- Products and coproducts
- Equalizers and coequalizers
- Pullbacks and pushouts
- Terminal and initial objects
- Exponentials
- Isomorphisms

## Configuration Options

- `maxSteps`: Maximum proof steps (default: 64)
- `timeout`: Timeout in milliseconds (default: 2000)
- `simpSet`: Named simp set to use
- `trace`: Enable tracing (default: false)
- `strict`: Fail instead of fallback (default: false)
- `fallback`: List of fallback tactics (default: ["simp", "aesop"])
- `enableTelemetry`: Enable performance telemetry (default: false)

## Environment Variables

Set these environment variables for global configuration:

```bash
export UPROVE_MAX_STEPS=64
export UPROVE_TIMEOUT=2000
export UPROVE_TRACE=false
export UPROVE_STRICT=false
export UPROVE_TELEMETRY=false
export UPROVE_FALLBACK="simp,aesop"
export UPROVE_SIMPSET="uprove"
```

## Troubleshooting

If `uprove` fails:

1. **Check strict mode**: Set `strict := false` to enable fallback tactics
2. **Increase timeout**: Set `timeout := 5000` for complex proofs
3. **Enable tracing**: Set `trace := true` to see what's happening
4. **Check fallback**: Ensure fallback tactics are available

## Next Steps

- Read the [Cookbook](Cookbook.md) for advanced patterns
- Check the [API Reference](https://fraware.github.io/lean-uprove/) for full documentation
- See [Troubleshooting](Troubleshooting.md) for common issues

That's it! You're ready to use `uprove` for universal property proofs.
