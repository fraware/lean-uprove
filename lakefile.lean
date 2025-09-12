import Lake
open Lake DSL

package «lean-uprove» where
  moreServerOptions := #[⟨`autoImplicit, false⟩]
  moreLeanArgs := #["-DautoImplicit=false"]

-- Temporarily disable mathlib to verify core correctness
-- require mathlib from git
--   "https://github.com/leanprover-community/mathlib4.git" @ "master"

@[default_target]
lean_lib «Uprove» where
  roots := #[`Uprove.Core]

-- Test target
lean_exe test where
  root := `Test
  supportInterpreter := true


-- Production test suite
lean_exe «uprove-test-production» where
  root := `Uprove.TestProduction
  supportInterpreter := true

-- Performance validation
lean_exe «uprove-performance-validation» where
  root := `Uprove.PerformanceValidation
  supportInterpreter := true

-- Simple test runner (no mathlib dependencies)
lean_exe «uprove-test-simple» where
  root := `Uprove.TestRunnerSimple
  supportInterpreter := true

-- Minimal core test (no mathlib dependencies)
lean_exe «uprove-test-minimal-core» where
  root := `Uprove.TestMinimalCore
  supportInterpreter := true

-- Security scanning
lean_exe «uprove-license-scan» where
  root := `Uprove.LicenseScan
  supportInterpreter := true

lean_exe «uprove-network-scan» where
  root := `Uprove.NetworkScan
  supportInterpreter := true

-- Real testing and validation
lean_exe «uprove-test-real» where
  root := `Uprove.TestReal
  supportInterpreter := true

lean_exe «uprove-performance-real» where
  root := `Uprove.PerformanceReal
  supportInterpreter := true

lean_exe «uprove-sla-validation» where
  root := `Uprove.SLAValidation
  supportInterpreter := true
