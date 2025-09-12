import Lean
import Uprove.PerformanceReal
import System.IO

namespace Uprove

-- SLA validation for production readiness
structure SLAReport where
  testName : String
  p50_ok : Bool
  p95_ok : Bool
  memory_ok : Bool
  success_ok : Bool
  overall_ok : Bool
  details : String
  deriving Inhabited, Repr

def validatePerformanceSLAs (results : List PerformanceReal.PerformanceResult) : List SLAReport :=
  results.map fun res =>
    let p50_threshold := 150 -- ms
    let p95_threshold := 800 -- ms
    let memory_threshold := 256 * 1024 * 1024 -- 256 MB

    let p50_ok := res.p50 ≤ p50_threshold
    let p95_ok := res.p95 ≤ p95_threshold
    let memory_ok := res.memory ≤ memory_threshold
    let success_ok := res.success

    let overall_ok := p50_ok && p95_ok && memory_ok && success_ok

    let mut details := ""
    if not p50_ok then
      details := details ++ s!"P50 failed: {res.p50}ms > {p50_threshold}ms. "
    if not p95_ok then
      details := details ++ s!"P95 failed: {res.p95}ms > {p95_threshold}ms. "
    if not memory_ok then
      details := details ++ s!"Memory failed: {res.memory / (1024 * 1024)}MB > {memory_threshold / (1024 * 1024)}MB. "
    if not success_ok then
      details := details ++ "Success failed: test did not complete. "

    if details == "" then
      details := "All SLAs met"

    {
      testName := res.testName,
      p50_ok := p50_ok,
      p95_ok := p95_ok,
      memory_ok := memory_ok,
      success_ok := success_ok,
      overall_ok := overall_ok,
      details := details
    }

def generateSLAReport (reports : List SLAReport) : String :=
  let mut report := "SLA Validation Report\n"
  report := report ++ "==================\n\n"

  let mut totalTests := reports.length
  let mut passedTests := 0

  for slaReport in reports do
    let status := if slaReport.overall_ok then "✅ PASS" else "❌ FAIL"
    report := report ++ s!"{status} {slaReport.testName}\n"
    report := report ++ s!"  P50: {'PASS' if slaReport.p50_ok else 'FAIL'} ({slaReport.p50_ok})\n"
    report := report ++ s!"  P95: {'PASS' if slaReport.p95_ok else 'FAIL'} ({slaReport.p95_ok})\n"
    report := report ++ s!"  Memory: {'PASS' if slaReport.memory_ok else 'FAIL'} ({slaReport.memory_ok})\n"
    report := report ++ s!"  Success: {'PASS' if slaReport.success_ok else 'FAIL'} ({slaReport.success_ok})\n"
    report := report ++ s!"  Details: {slaReport.details}\n\n"

    if slaReport.overall_ok then
      passedTests := passedTests + 1

  report := report ++ s!"Summary: {passedTests}/{totalTests} tests passed\n"
  report := report ++ s!"Success Rate: {(passedTests * 100) / totalTests}%\n"

  report

def main : IO Unit := do
  IO.println "📋 Running Uprove SLA Validation"
  IO.println "==============================="

  -- Run performance tests
  let perfResults ← Uprove.PerformanceReal.runPerformanceSuite
  IO.println s!"Completed {perfResults.length} performance tests"

  -- Validate SLAs
  let slaReports := validatePerformanceSLAs perfResults

  -- Generate report
  let report := generateSLAReport slaReports
  IO.println "\n" ++ report

  -- Check overall status
  let allPassed := slaReports.all fun r => r.overall_ok
  let passedCount := (slaReports.filter fun r => r.overall_ok).length

  IO.println s!"\n📊 SLA Summary: {passedCount}/{slaReports.length} tests passed"

  if allPassed then
    IO.println "\n🎉 All SLAs met! Project is production ready!"
    IO.Process.exit 0
  else
    IO.println "\n⚠️  Some SLAs not met. Review the report for details."
    IO.Process.exit 1

end Uprove
