import Uprove.Core
import Uprove.Tactics
import Uprove.Attributes
import Uprove.Configuration
import Uprove.Patterns
import Uprove.Planner
import Uprove.Telemetry
import Uprove.TestInfrastructure
import Uprove.Performance

-- Main module that exports the public API
-- This is the main entry point for users of the uprove tactic

-- Export core types
export Uprove (UniversalProperty PatternMatch UproveConfig UproveState)

-- Export tactics
export Uprove (uprove uprove?)

-- Export attributes
export Uprove (uprove uprove.iso)

-- Export configuration
export Uprove (UproveOptions fastConfig thoroughConfig debugConfig configFromEnv)

-- Export telemetry
export Uprove (TelemetryData TelemetryConfig enableTelemetry disableTelemetry)

-- Export planner
export Uprove (planProof safePlanProof)

-- Export patterns
export Uprove (registerUniversalProperty registerCanonicalIso)

-- Export testing infrastructure
export Uprove (TestResult TestSuite runTestSuite runAllTests printTestResults)

-- Export performance measurement
export Uprove (PerformanceMetrics BenchmarkResult BenchmarkSuite runBenchmarks analyzePerformance)
