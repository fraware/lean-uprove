import Lake
open Lake DSL

package «lean-uprove» where
  moreServerOptions := #[⟨`autoImplicit, false⟩]
  moreLeanArgs := #["-DautoImplicit=false"]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.31.0-rc1"

@[default_target]
lean_lib «Uprove» where
  -- `UproveRegisterInit` lives next to `Uprove.lean` (not under `Uprove/`) to avoid a
  -- Windows crash when a `Uprove.*` module imports sibling registration initializers.
  roots := #[`Uprove, `UproveRegisterInit, `TestRegisterInit]

/-- Mathlib examples and integration theorems; must compile in CI. -/
lean_lib «UproveExamples» where
  roots := #[`examples.BasicExamples, `examples.ManualProofs]

/-- Optional tactic comparisons; not part of the extraction CI gate. -/
lean_lib «UproveComparison» where
  roots := #[`UproveComparisonExamples]

@[test_driver]
lean_exe test where
  root := `Test
  supportInterpreter := true

lean_exe «uprove-benchmark» where
  root := `bench.Benchmark
  supportInterpreter := true

lean_exe «uprove-test-production» where
  root := `Uprove.TestProduction
  supportInterpreter := true

lean_exe «uprove-performance-validation» where
  root := `Uprove.PerformanceValidation
  supportInterpreter := true

lean_exe «uprove-test-simple» where
  root := `Uprove.TestRunnerSimple
  supportInterpreter := true

lean_exe «uprove-test-minimal-core» where
  root := `Uprove.TestMinimalCore
  supportInterpreter := true

lean_exe «uprove-license-scan» where
  root := `Uprove.LicenseScan
  supportInterpreter := true

lean_exe «uprove-network-scan» where
  root := `Uprove.NetworkScan
  supportInterpreter := true

lean_exe «uprove-test-real» where
  root := `Uprove.TestReal
  supportInterpreter := true

lean_exe «uprove-performance-real» where
  root := `Uprove.PerformanceReal
  supportInterpreter := true

lean_exe «uprove-sla-validation» where
  root := `Uprove.SLAValidation
  supportInterpreter := true
