import Uprove.Core
import Uprove.Configuration
import Uprove.Patterns
import Uprove.Tactics
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Iso
import Mathlib.CategoryTheory.Functor.Basic
import Mathlib.CategoryTheory.NatTrans
import Lean.Expr
import Lean.Meta
import Lean.Elab.Tactic

namespace Uprove

-- Production test results
structure TestResult where
  name : String
  success : Bool
  duration : Nat -- milliseconds
  memory : Nat -- nonnegative net resident-RSS growth in bytes
  error : Option String := none
  patternMatched : Option String := none
  confidence : Option Float := none
  deriving Inhabited, Repr

structure TestSuite where
  name : String
  results : List TestResult
  totalDuration : Nat
  successCount : Nat
  failureCount : Nat
  p50 : Nat
  p95 : Nat
  p99 : Nat
  maxMemory : Nat
  avgMemory : Nat
  slaCompliant : Bool
  deriving Inhabited, Repr

-- Linux RSS sampling. An absent metric is a test error. The measured quantity
-- is nonnegative net RSS growth between samples, not peak memory or uniquely
-- attributable allocation.
private def readResidentBytes : IO Nat := do
  let status ← IO.FS.readFile "/proc/self/status"
  let line? := (status.splitOn "\n").find? (fun line => line.startsWith "VmRSS:")
  match line? with
  | none => throw <| IO.userError "VmRSS unavailable in /proc/self/status"
  | some line =>
    let fields := (line.replace "\t" " ").splitOn " "
    match (fields.filterMap String.toNat?).head? with
    | none => throw <| IO.userError "invalid VmRSS in /proc/self/status"
    | some kib => pure (kib * 1024)

-- Evaluate whether a registered-pattern match agrees with the declared
-- expectation (including negative controls). This does not execute proofs.
def measurePerformance (testName : String) (goal : Lean.Expr)
    (_config : UproveConfig) (expectedMatch : Bool := true) : IO TestResult := do
  let startTime ← IO.monoMsNow
  let startMemory ← readResidentBytes
  try
    let patterns ← getRegisteredPatterns
    let matchResult := matchUniversalProperty goal patterns
    let endTime ← IO.monoMsNow
    let memory ← readResidentBytes
    let observedMatch := matchResult.isSome
    let success := observedMatch == expectedMatch
    let (patternMatched, confidence) := match matchResult with
      | some pm => (some pm.up.name, some pm.confidence)
      | none => (none, none)
    pure {
      name := testName
      success := success
      duration := endTime - startTime
      memory := memory - startMemory
      error := if success then none
        else some s!"expected pattern match = {expectedMatch}, observed = {observedMatch}"
      patternMatched := patternMatched
      confidence := confidence
    }
  catch e =>
    let endTime ← IO.monoMsNow
    let endMemory ← readResidentBytes
    pure {
      name := testName
      success := false
      duration := endTime - startTime
      memory := endMemory - startMemory
      error := some e.toString
    }

-- Register the actual production pattern definitions at executable runtime.
-- This avoids invoking the mathlib-dependent UproveRegisterInit initializers during
-- compilation of this standalone test executable. A match is not a proof.
private def registerProductionPatterns : IO Unit := do
  for pat in #[
    productPattern, coproductPattern, equalizerPattern,
    coequalizerPattern, pullbackPattern, pushoutPattern,
    terminalPattern, initialPattern, isomorphismPattern
  ] do
    registerPattern pat

-- P0 Golden Suite Tests
def runP0Tests (config : UproveConfig) : IO (List TestResult) := do
  let tests := [
    ("Product Basic", Lean.mkConst ``CategoryTheory.Limits.IsLimit),
    ("Coproduct Basic", Lean.mkConst ``CategoryTheory.Limits.IsColimit),
    ("Equalizer Basic", Lean.mkConst ``CategoryTheory.Limits.IsLimit),
    ("Coequalizer Basic", Lean.mkConst ``CategoryTheory.Limits.IsColimit),
    ("Pullback Basic", Lean.mkConst ``CategoryTheory.Limits.IsLimit),
    ("Pushout Basic", Lean.mkConst ``CategoryTheory.Limits.IsColimit),
    ("Terminal Basic", Lean.mkConst ``CategoryTheory.Limits.IsLimit),
    ("Initial Basic", Lean.mkConst ``CategoryTheory.Limits.IsColimit),
    ("Isomorphism Basic", Lean.mkConst ``CategoryTheory.IsIso)
  ]

  let mut results : List TestResult := []

  for (testName, goal) in tests do
    IO.println s!"Testing {testName}..."
    let result ← measurePerformance testName goal config
    results := result :: results

    if result.success then
      IO.println s!"  ✅ {testName}: {result.duration}ms, {result.memory} net RSS-growth bytes"
    else
      IO.println s!"  ❌ {testName}: {result.error.getD "No registered pattern matched"}"

  pure results.reverse

-- P1 Advanced Tests
def runP1Tests (config : UproveConfig) : IO (List TestResult) := do
  let tests := [
    ("Finite Cone", Lean.mkConst ``CategoryTheory.Limits.IsLimit, true),
    ("Finite Cocone", Lean.mkConst ``CategoryTheory.Limits.IsColimit, true),
    -- Explicit negative controls: these heads are not universal-property patterns.
    ("Functor Basic", Lean.mkConst ``CategoryTheory.Functor, false),
    ("Natural Transformation", Lean.mkConst ``CategoryTheory.NatTrans, false),
    ("Complex Product", Lean.mkConst ``CategoryTheory.Limits.IsLimit, true)
  ]

  let mut results : List TestResult := []

  for (testName, goal, expectedMatch) in tests do
    IO.println s!"Testing {testName}..."
    let result ← measurePerformance testName goal config expectedMatch
    results := result :: results

    if result.success then
      IO.println s!"  ✅ {testName}: {result.duration}ms, {result.memory} net RSS-growth bytes"
    else
      IO.println s!"  ❌ {testName}: {result.error.getD "No registered pattern matched"}"

  pure results.reverse

-- Nondeterminism Tests
def runNondeterminismTests (config : UproveConfig) : IO (List TestResult) := do
  let goal := Lean.mkConst ``CategoryTheory.Limits.IsLimit
  let mut results : List TestResult := []

  IO.println "Running nondeterminism tests (10 iterations)..."

  for i in [0:10] do
    let testName := s!"Nondeterminism_{i}"
    let result ← measurePerformance testName goal config
    results := result :: results

    if result.success then
      IO.println s!"  ✅ Iteration {i}: {result.duration}ms"
    else
      IO.println s!"  ❌ Iteration {i}: {result.error.getD "No registered pattern matched"}"

  pure results.reverse

-- Performance Tests
def runPerformanceTests (config : UproveConfig) : IO (List TestResult) := do
  let goal := Lean.mkConst ``CategoryTheory.Limits.IsLimit
  let mut results : List TestResult := []

  IO.println "Running performance tests (50 iterations)..."

  for i in [0:50] do
    let testName := s!"Performance_{i}"
    let result ← measurePerformance testName goal config
    results := result :: results

    if i % 10 == 0 then
      IO.println s!"  Completed {i}/50 iterations"

  pure results.reverse

-- Calculate statistics
def calculateStatistics (results : List TestResult) : (Nat × Nat × Nat × Nat × Nat × Bool) :=
  let durations := results.map (·.duration)
  let memories := results.map (·.memory)
  let sortedDurations := durations.mergeSort (· < ·)

  let p50 := if sortedDurations.length > 0 then sortedDurations[sortedDurations.length / 2]! else 0
  let p95 := if sortedDurations.length > 0 then sortedDurations[(sortedDurations.length * 95) / 100]! else 0
  let p99 := if sortedDurations.length > 0 then sortedDurations[(sortedDurations.length * 99) / 100]! else 0

  let maxMemory := memories.foldl Nat.max 0
  let avgMemory := if memories.length > 0 then memories.foldl (· + ·) 0 / memories.length else 0

  let slaCompliant := p50 ≤ 150 && p95 ≤ 800 && maxMemory ≤ 256 * 1024 * 1024 && results.all (·.success)

  (p50, p95, p99, maxMemory, avgMemory, slaCompliant)

-- Run comprehensive test suite
def runTestSuite (config : UproveConfig) : IO TestSuite := do
  IO.println "🚀 Running Uprove Production Test Suite"
  IO.println "====================================="

  -- Run P0 tests
  IO.println "\n📋 P0 Golden Suite Tests"
  IO.println "========================"
  let p0Results ← runP0Tests config

  -- Run P1 tests
  IO.println "\n📋 P1 Advanced Tests"
  IO.println "==================="
  let p1Results ← runP1Tests config

  -- Run nondeterminism tests
  IO.println "\n🎲 Nondeterminism Tests"
  IO.println "======================"
  let nondetResults ← runNondeterminismTests config

  -- Run performance tests
  IO.println "\n⚡ Performance Tests"
  IO.println "==================="
  let perfResults ← runPerformanceTests config

  -- Combine all results
  let allResults := p0Results ++ p1Results ++ nondetResults ++ perfResults
  let totalDuration := allResults.foldl (· + ·.duration) 0
  let successCount : Nat := (allResults.filter (fun result : TestResult => result.success)).length
  let failureCount : Nat := allResults.length - successCount

  let (p50, p95, p99, maxMemory, avgMemory, slaCompliant) := calculateStatistics allResults

  pure {
    name := "Uprove Production Test Suite"
    results := allResults
    totalDuration := totalDuration
    successCount := successCount
    failureCount := failureCount
    p50 := p50
    p95 := p95
    p99 := p99
    maxMemory := maxMemory
    avgMemory := avgMemory
    slaCompliant := slaCompliant
  }

-- Generate test report
def generateTestReport (suite : TestSuite) : String :=
  s!"\n📊 Test Suite Report: {suite.name}\n" ++
  s!"=====================================\n" ++
  s!"Total tests: {suite.results.length}\n" ++
  s!"Successful: {suite.successCount}\n" ++
  s!"Failed: {suite.failureCount}\n" ++
  s!"Success rate: {suite.successCount * 100 / suite.results.length}%\n" ++
  s!"Total duration: {suite.totalDuration}ms\n" ++
  s!"Average duration: {suite.totalDuration / suite.results.length}ms\n\n" ++
  s!"Latency percentiles:\n" ++
  s!"  P50: {suite.p50}ms\n" ++
  s!"  P95: {suite.p95}ms\n" ++
  s!"  P99: {suite.p99}ms\n\n" ++
  s!"Memory usage:\n" ++
  s!"  Max observed net RSS growth: {suite.maxMemory / (1024 * 1024)}MB\n" ++
  s!"  Average observed net RSS growth: {suite.avgMemory / (1024 * 1024)}MB\n\n" ++
  s!"SLA Compliance:\n" ++
  s!"  P50 ≤ 150ms: {if suite.p50 ≤ 150 then "PASS" else "FAIL"} ({suite.p50}ms)\n" ++
  s!"  P95 ≤ 800ms: {if suite.p95 ≤ 800 then "PASS" else "FAIL"} ({suite.p95}ms)\n" ++
  s!"  Observed net RSS growth ≤ 256MB: {if suite.maxMemory ≤ 256 * 1024 * 1024 then "PASS" else "FAIL"} ({suite.maxMemory / (1024 * 1024)}MB)\n" ++
  s!"  100% Success Rate: {if suite.successCount == suite.results.length then "PASS" else "FAIL"} ({suite.successCount}/{suite.results.length})\n\n" ++
  s!"Overall SLA Compliance: {if suite.slaCompliant then "PASS" else "FAIL"}\n"

-- Main test runner
def main : IO Unit := do
  registerProductionPatterns
  let config := testConfig
  let suite ← runTestSuite config
  let report := generateTestReport suite
  IO.println report

  if suite.slaCompliant then
    IO.println "Registry recognition and observed RSS-growth thresholds passed; no proof execution was checked"
    IO.Process.exit 0
  else
    IO.println "Registry-recognition or observed RSS-growth thresholds failed"
    IO.Process.exit 1

end Uprove

-- Lake's native executable links the top-level entry point.
def main : IO Unit := Uprove.main
