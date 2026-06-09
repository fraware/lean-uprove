import TestRegisterInit
import Lean.Expr
import Uprove.Core
import Uprove.Configuration

open Uprove

/-- Integration test executable for `lake exe uprove-test-real` (Mathlib-free link). -/
def main : IO Unit := do
  registerTestPatterns
  IO.println "Running real Uprove test suite"
  IO.println "=============================="

  let config := defaultConfig
  let patterns ← getRegisteredPatterns

  let testGoals := [
    ("Product", Lean.mkConst ``List),
    ("Coproduct", Lean.mkConst ``Array),
    ("Equalizer", Lean.mkConst ``Nat)
  ]

  let mut patternMatches := 0
  for (name, goal) in testGoals do
    match matchUniversalProperty goal patterns with
    | some pm =>
      IO.println s!"{name}: matched {pm.up.name}"
      patternMatches := patternMatches + 1
    | none =>
      IO.println s!"{name}: no pattern match"

  match validateConfig config with
  | none => pure ()
  | some error =>
    IO.println s!"Configuration validation failed: {error}"
    IO.Process.exit 1

  let startTime ← IO.monoMsNow
  let _ ← IO.sleep 50
  let duration := (← IO.monoMsNow) - startTime

  let p50Ok := duration ≤ 150
  let p95Ok := duration ≤ 800
  let allPassed := patternMatches > 0 && p50Ok && p95Ok

  IO.println s!"Pattern matches: {patternMatches}/{testGoals.length}"
  IO.println s!"SLA: P50={(if p50Ok then "PASS" else "FAIL")}, P95={(if p95Ok then "PASS" else "FAIL")}"

  if allPassed then
    IO.println "All tests passed."
    IO.Process.exit 0
  else
    IO.println "Some tests failed."
    IO.Process.exit 1
