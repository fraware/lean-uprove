import Lean
import Uprove.Version

namespace Uprove

structure TelemetryData where
  tacticName : String
  executionTime : Nat
  stepCount : Nat
  success : Bool
  goalHash : String
  leanVersion : String
  mathlibVersion : String
  timestamp : Nat
  deriving Inhabited, Repr

structure TelemetryConfig where
  enabled : Bool := false
  webhookUrl : Option String := none
  logLevel : String := "info"
  batchSize : Nat := 100
  flushInterval : Nat := 5000
  deriving Inhabited, Repr

initialize telemetryCfgRef : IO.Ref TelemetryConfig ← IO.mkRef {}

initialize telemetryBatchRef : IO.Ref (List TelemetryData) ← IO.mkRef []

def isTelemetryEnabled : IO Bool := do
  let c ← telemetryCfgRef.get
  pure c.enabled

def getTelemetryConfig : IO TelemetryConfig :=
  telemetryCfgRef.get

def setTelemetryConfig (config : TelemetryConfig) : IO Unit :=
  telemetryCfgRef.set config

def enableTelemetry : IO Unit := do
  let c ← telemetryCfgRef.get
  telemetryCfgRef.set { c with enabled := true }

def disableTelemetry : IO Unit := do
  let c ← telemetryCfgRef.get
  telemetryCfgRef.set { c with enabled := false }

def setWebhookUrl (url : Option String) : IO Unit := do
  let c ← telemetryCfgRef.get
  telemetryCfgRef.set { c with webhookUrl := url }

def generateGoalHash (_goal : Lean.Expr) : String :=
  "anon"

def recordTelemetry (data : TelemetryData) : IO Unit := do
  if (← IO.getEnv "UPROVE_TELEMETRY") == some "1" then
    IO.println s!"[TELEMETRY] {data.tacticName}: {data.executionTime}ms"
  let batch ← telemetryBatchRef.get
  telemetryBatchRef.set (data :: batch)
  pure ()

def flushTelemetryBatch : IO Unit := do
  telemetryBatchRef.set []

def recordTacticExecution
    (tacticName : String) (executionTime : Nat) (stepCount : Nat) (success : Bool) (goal : Lean.Expr)
    (patternMatched : Option String := none) (confidence : Option Float := none) : IO Unit := do
  let goalHash := generateGoalHash goal
  let timestamp ← IO.monoMsNow
  let _ := patternMatched
  let _ := confidence
  recordTelemetry {
    tacticName := tacticName
    executionTime := executionTime
    stepCount := stepCount
    success := success
    goalHash := goalHash
    leanVersion := leanToolchainString
    mathlibVersion := mathlibPinRev
    timestamp := timestamp
  }

def startTelemetryFlush : IO Unit :=
  flushTelemetryBatch

def collectProductionData
    (tacticName : String) (executionTime : Nat) (stepCount : Nat) (success : Bool) (_goal : Lean.Expr) :
    IO Unit := do
  recordTacticExecution tacticName executionTime stepCount success (Lean.mkConst ``Unit.unit)

def stopPerformanceMonitoring : IO Unit := do
  flushTelemetryBatch
  IO.println "Performance monitoring stopped."

end Uprove
