import Lean

namespace Uprove

/-- Lightweight metrics for exported benchmark API (see `Uprove.lean`). -/
structure PerformanceMetrics where
  duration : Nat := 0
  memory : Nat := 0
  success : Bool := true
  p50 : Nat := 0
  p95 : Nat := 0
  p99 : Nat := 0
  deriving Inhabited, Repr

structure BenchmarkResult where
  name : String
  metrics : PerformanceMetrics
  deriving Inhabited, Repr

structure BenchmarkSuite where
  name : String
  results : List BenchmarkResult
  totalDuration : Nat := 0
  deriving Inhabited, Repr

def runBenchmarks : IO (List BenchmarkSuite) :=
  pure []

def analyzePerformance (_suites : List BenchmarkSuite) : IO Unit :=
  IO.println "Performance analysis: no suites (stub; use PerformanceReal via `lake exe uprove-benchmark`)."

end Uprove
