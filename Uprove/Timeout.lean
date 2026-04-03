import Uprove.Core
import Uprove.Telemetry

namespace Uprove

/-- Placeholder execution state for future timeout / step-limit wiring. -/
structure ExecutionState where
  startTime : Nat := 0
  currentSteps : Nat := 0
  maxSteps : Nat := 64
  timeout : Nat := 2000
  isTimedOut : Bool := false
  isStepLimited : Bool := false
  error : Option String := none
  deriving Inhabited

structure ExecutionContext where
  state : ExecutionState
  config : UproveConfig
  telemetry : Option TelemetryData := none
  deriving Inhabited

def initExecutionContext (config : UproveConfig) : IO ExecutionContext :=
  pure { state := { maxSteps := config.maxSteps, timeout := config.timeout }, config := config }

def validateTimeoutConfig (config : UproveConfig) : List String :=
  if config.timeout = 0 then ["Timeout must be positive"] else []

def validateStepConfig (config : UproveConfig) : List String :=
  if config.maxSteps = 0 then ["maxSteps must be positive"] else []

def validateLimitsConfig (config : UproveConfig) : List String :=
  validateTimeoutConfig config ++ validateStepConfig config

end Uprove
