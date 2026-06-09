import Uprove.TestReal
import Uprove.PerformanceReal
import Uprove.SLAValidation
import Uprove.Core
import Uprove.Configuration

namespace Uprove

-- Comprehensive test runner for production validation
structure TestRunnerConfig where
  runUnitTests : Bool := true
  runPerformanceTests : Bool := true
  runSLAValidation : Bool := true
  runFlakinessTests : Bool := true
  performanceIterations : Nat := 100
  flakinessIterations : Nat := 200
  config : UproveConfig := testConfig
  deriving Inhabited, Repr

structure TestRunnerResult where
  unitTestsPassed : Bool
  performanceTestsPassed : Bool
  slaValidationPassed : Bool
  flakinessTestsPassed : Bool
  overallPassed : Bool
  totalDuration : Nat
  errorMessages : List String
  deriving Inhabited, Repr

-- Run unit tests
def runUnitTests (config : TestRunnerConfig) : IO (Bool × List String) := do
  IO.println "🧪 Running Unit Tests"
  IO.println "===================="

  try
    let result ← TestReal.main
    if result == 0 then
      IO.println "✅ Unit tests passed"
      pure (true, [])
    else
      IO.println "❌ Unit tests failed"
      pure (false, ["Unit tests failed with exit code " ++ toString result])
  catch e =>
    IO.println s!"❌ Unit tests failed with error: {e.toString}"
    pure (false, [s!"Unit tests failed with error: {e.toString}"])

-- Run performance tests
def runPerformanceTests (config : TestRunnerConfig) : IO (Bool × List String) := do
  IO.println "🚀 Running Performance Tests"
  IO.println "============================"

  try
    let suite ← runPerformanceSuite config.config config.performanceIterations
    let slaCompliant := validatePerformanceSLAs suite

    if slaCompliant then
      IO.println "✅ Performance tests passed"
      pure (true, [])
    else
      IO.println "❌ Performance tests failed SLA validation"
      pure (false, ["Performance tests failed SLA validation"])
  catch e =>
    IO.println s!"❌ Performance tests failed with error: {e.toString}"
    pure (false, [s!"Performance tests failed with error: {e.toString}"])

-- Run SLA validation
def runSLAValidationTests (config : TestRunnerConfig) : IO (Bool × List String) := do
  IO.println "🔍 Running SLA Validation"
  IO.println "========================"

  try
    let report ← runSLAValidation
    if report.overallCompliant then
      IO.println "✅ SLA validation passed"
      pure (true, [])
    else
      IO.println "❌ SLA validation failed"
      let failures := report.criticalFailures.map (fun v => s!"{v.requirement.name}: {v.actualValue}{v.requirement.unit} > {v.requirement.threshold}{v.requirement.unit}")
      pure (false, failures)
  catch e =>
    IO.println s!"❌ SLA validation failed with error: {e.toString}"
    pure (false, [s!"SLA validation failed with error: {e.toString}"])

-- Run flakiness tests
def runFlakinessTests (config : TestRunnerConfig) : IO (Bool × List String) := do
  IO.println "🎲 Running Flakiness Tests"
  IO.println "=========================="

  try
    let mut failures : Nat := 0
    let mut errorMessages : List String := []

    for i in [0:config.flakinessIterations] do
      try
        let result ← TestReal.main
        if result != 0 then
          failures := failures + 1
          errorMessages := s!"Flakiness test iteration {i} failed with exit code {result}" :: errorMessages
      catch e =>
        failures := failures + 1
        errorMessages := s!"Flakiness test iteration {i} failed with error: {e.toString}" :: errorMessages

    if failures == 0 then
      IO.println "✅ Flakiness tests passed (0 failures out of {config.flakinessIterations})"
      pure (true, [])
    else
      IO.println s!"❌ Flakiness tests failed ({failures} failures out of {config.flakinessIterations})"
      pure (false, errorMessages)
  catch e =>
    IO.println s!"❌ Flakiness tests failed with error: {e.toString}"
    pure (false, [s!"Flakiness tests failed with error: {e.toString}"])

-- Main test runner
def runAllTests (config : TestRunnerConfig) : IO TestRunnerResult := do
  let startTime ← IO.monoMsNow

  IO.println "🚀 Starting Uprove Comprehensive Test Suite"
  IO.println "=========================================="
  IO.println s!"Configuration: {config}"
  IO.println ""

  let mut allErrors : List String := []
  let mut unitTestsPassed := true
  let mut performanceTestsPassed := true
  let mut slaValidationPassed := true
  let mut flakinessTestsPassed := true

  -- Run unit tests
  if config.runUnitTests then
    let (passed, errors) ← runUnitTests config
    unitTestsPassed := passed
    allErrors := allErrors ++ errors
    IO.println ""

  -- Run performance tests
  if config.runPerformanceTests then
    let (passed, errors) ← runPerformanceTests config
    performanceTestsPassed := passed
    allErrors := allErrors ++ errors
    IO.println ""

  -- Run SLA validation
  if config.runSLAValidation then
    let (passed, errors) ← runSLAValidation config
    slaValidationPassed := passed
    allErrors := allErrors ++ errors
    IO.println ""

  -- Run flakiness tests
  if config.runFlakinessTests then
    let (passed, errors) ← runFlakinessTests config
    flakinessTestsPassed := passed
    allErrors := allErrors ++ errors
    IO.println ""

  let endTime ← IO.monoMsNow
  let totalDuration := (endTime - startTime).toNat

  let overallPassed := unitTestsPassed && performanceTestsPassed && slaValidationPassed && flakinessTestsPassed

  -- Generate summary report
  IO.println "📊 Test Suite Summary"
  IO.println "====================="
  IO.println s!"Unit Tests: {(if unitTestsPassed then "PASS" else "FAIL")}"
  IO.println s!"Performance Tests: {(if performanceTestsPassed then "PASS" else "FAIL")}"
  IO.println s!"SLA Validation: {(if slaValidationPassed then "PASS" else "FAIL")}"
  IO.println s!"Flakiness Tests: {(if flakinessTestsPassed then "PASS" else "FAIL")}"
  IO.println s!"Overall: {(if overallPassed then "PASS" else "FAIL")}"
  IO.println s!"Total Duration: {totalDuration}ms"

  if !allErrors.isEmpty then
    IO.println "\n❌ Errors:"
    for error in allErrors do
      IO.println s!"  - {error}"

  if overallPassed then
    IO.println "\n🎉 All tests passed! Production ready!"
  else
    IO.println "\n⚠️  Some tests failed. Not production ready."

  pure {
    unitTestsPassed := unitTestsPassed
    performanceTestsPassed := performanceTestsPassed
    slaValidationPassed := slaValidationPassed
    flakinessTestsPassed := flakinessTestsPassed
    overallPassed := overallPassed
    totalDuration := totalDuration
    errorMessages := allErrors
  }

-- Main entry point
def main : IO Unit := do
  let config : TestRunnerConfig := {
    runUnitTests := true
    runPerformanceTests := true
    runSLAValidation := true
    runFlakinessTests := true
    performanceIterations := 100
    flakinessIterations := 200
    config := testConfig
  }

  let result ← runAllTests config

  if result.overallPassed then
    IO.exit 0
  else
    IO.exit 1

end Uprove
