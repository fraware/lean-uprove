import Uprove.TestRunner
import Uprove.Core
import Uprove.Patterns
import Uprove.Tactics
import Uprove.PerformanceReal
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Coproducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Coequalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullbacks
import Mathlib.CategoryTheory.Limits.Shapes.Pushouts
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.Shapes.Initial
import Mathlib.CategoryTheory.Limits.Shapes.Exponentials
import Mathlib.CategoryTheory.Isomorphism
import Mathlib.CategoryTheory.Functor.Basic
import Mathlib.CategoryTheory.NaturalTransformation
import Lean.Meta
import Lean.Elab.Tactic

namespace Uprove

-- Comprehensive benchmark runner for production performance validation
def main : IO Unit := do
  IO.println "Running Uprove Performance Benchmark Suite"
  IO.println "=========================================="

  -- Run performance benchmark suite
  let result ← Lean.Meta.runMetaM (PerformanceReal.runPerformanceSuite)
  let report := PerformanceReal.generatePerformanceReport result

  IO.println report

  -- Validate performance SLAs
  let slaCompliance := PerformanceReal.validatePerformanceSLAs result
  if slaCompliance then
    IO.println "\n✅ All performance SLAs met! Production ready."
  else
    IO.println "\n❌ Some performance SLAs not met. Not production ready."

    -- Show which SLAs failed
    for metric in result do
      let p50Ok := metric.p50 ≤ 0.15
      let p95Ok := metric.p95 ≤ 0.8
      let memoryOk := metric.memoryUsage ≤ 256 * 1024 * 1024
      let successOk := metric.successRate ≥ 0.95

      if not (p50Ok && p95Ok && memoryOk && successOk) then
        IO.println s!"Failed SLA for {metric.testName}:"
        if not p50Ok then
          IO.println s!"  P50: {metric.p50:.3f}s > 0.15s"
        if not p95Ok then
          IO.println s!"  P95: {metric.p95:.3f}s > 0.8s"
        if not memoryOk then
          IO.println s!"  Memory: {metric.memoryUsage / 1024 / 1024:.1f}MB > 256MB"
        if not successOk then
          IO.println s!"  Success Rate: {metric.successRate * 100:.1f}% < 95%"

end Uprove
