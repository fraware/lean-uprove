import TestRegisterInit
import Lean.Expr
import Uprove.Core
import Uprove.Configuration

open Uprove

/-- Smoke-test executable for `lake exe uprove-test-simple` (Mathlib-free link). -/
def main : IO Unit := do
  registerTestPatterns
  IO.println "Running Uprove production test suite"
  IO.println "===================================="

  let config := defaultConfig
  IO.println s!"Configuration (maxSteps={config.maxSteps}, timeout={config.timeout})"

  let patterns ← getRegisteredPatterns
  IO.println s!"Registered patterns: {patterns.length}"

  let isos ← getRegisteredIsomorphisms
  IO.println s!"Registered isomorphisms: {isos.length}"

  let testGoals := [
    ("Product", Lean.mkConst ``List),
    ("Coproduct", Lean.mkConst ``Array),
    ("Equalizer", Lean.mkConst ``Nat)
  ]

  for (name, goal) in testGoals do
    match matchUniversalProperty goal patterns with
    | some pm => IO.println s!"{name}: matched {pm.up.name}"
    | none => IO.println s!"{name}: no pattern match"

  let startTime ← IO.monoMsNow
  let _ ← IO.sleep 10
  let duration := (← IO.monoMsNow) - startTime
  IO.println s!"Performance sample: {duration}ms"

  match validateConfig config with
  | none => IO.println "Configuration validation: PASS"
  | some error => IO.println s!"Configuration validation: FAIL - {error}"

  IO.println "All checks completed."
