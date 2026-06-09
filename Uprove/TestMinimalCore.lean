import Uprove.Core
import Uprove.Configuration

open Uprove

/-- Minimal core smoke test without Mathlib category theory. -/
def main : IO Unit := do
  IO.println "Testing core Lean definitions"

  let up : UniversalProperty := {
    name := "Test"
    pattern := Lean.mkConst ``Nat
    constructor := Lean.mkConst ``Nat
    uniqueness := Lean.mkConst ``Nat
  }
  IO.println s!"UniversalProperty: {up.name}"

  let pm : PatternMatch := {
    goal := Lean.mkConst ``Nat
    up := up
    substitutions := []
    confidence := 0.8
  }
  IO.println s!"PatternMatch confidence: {pm.confidence}"

  let cfg : UproveConfig := {}
  IO.println s!"UproveConfig maxSteps: {cfg.maxSteps}"

  let opts := defaultConfig
  match validateConfig opts with
  | none => IO.println "Valid UproveOptions accepted"
  | some error => IO.println s!"Unexpected validation error: {error}"

  match validateConfig { opts with maxSteps := 0 } with
  | some _ => IO.println "Invalid maxSteps rejected"
  | none => IO.println "Invalid maxSteps should have been rejected"

  let patterns ← getRegisteredPatterns
  IO.println s!"Registered patterns at startup: {patterns.length}"
  IO.println "Core checks completed."
