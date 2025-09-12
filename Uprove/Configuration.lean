import Uprove.Core

namespace Uprove

-- Configuration options with their default values
structure UproveOptions where
  maxSteps : Nat := 64
  timeout : Nat := 2000
  simpSet : Option String := none
  trace : Bool := false
  strict : Bool := false
  fallback : List String := ["simp", "aesop"]
  enableTelemetry : Bool := false
  deriving Inhabited, Repr, BEq

-- Configuration validation
def validateConfig (config : UproveOptions) : Option String :=
  if config.maxSteps = 0 then
    some "maxSteps must be positive"
  else if config.timeout = 0 then
    some "timeout must be positive"
  else if config.maxSteps > 1000 then
    some "maxSteps too large (max 1000)"
  else if config.timeout > 30000 then
    some "timeout too large (max 30000ms)"
  else if config.fallback.isEmpty then
    some "fallback tactics list cannot be empty"
  else
    none

-- Global configuration state
variable [Lean.MonadState UproveOptions] in

-- Get current configuration
def getConfig : Lean.MonadState UproveOptions m => m UproveOptions :=
  Lean.MonadState.get

-- Set configuration with validation
def setConfig (cfg : UproveOptions) : Lean.MonadState UproveOptions m => m Unit := do
  match validateConfig cfg with
  | some error => throwError s!"Invalid configuration: {error}"
  | none => Lean.MonadState.set cfg

-- Update specific configuration options
def setMaxSteps (n : Nat) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with maxSteps := n }

def setTimeout (ms : Nat) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with timeout := ms }

def setSimpSet (name : Option String) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with simpSet := name }

def setTrace (enabled : Bool) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with trace := enabled }

def setStrict (enabled : Bool) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with strict := enabled }

def setFallback (tactics : List String) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with fallback := tactics }

def setTelemetry (enabled : Bool) : Lean.MonadState UproveOptions m => m Unit := do
  let cfg ← getConfig
  setConfig { cfg with enableTelemetry := enabled }

-- Configuration parsing from tactic arguments
def parseConfig (args : List Lean.Syntax) : Lean.Elab.TermElabM UproveOptions := do
  let mut config := UproveOptions.mk
  for arg in args do
    match arg with
    | `(uprove| maxSteps := $n) =>
      let steps := n.getNat
      if steps = 0 then
        throwError "maxSteps must be positive"
      config := { config with maxSteps := steps }
    | `(uprove| timeout := $ms) =>
      let timeout := ms.getNat
      if timeout = 0 then
        throwError "timeout must be positive"
      config := { config with timeout := timeout }
    | `(uprove| simpSet := $name) =>
      config := { config with simpSet := some name.getString }
    | `(uprove| trace := $b) =>
      config := { config with trace := b.getBool }
    | `(uprove| strict := $b) =>
      config := { config with strict := b.getBool }
    | `(uprove| fallback := $tactics) =>
      let tacticList := tactics.getList.map (fun t => t.getString)
      if tacticList.isEmpty then
        throwError "fallback tactics list cannot be empty"
      config := { config with fallback := tacticList }
    | `(uprove| enableTelemetry := $b) =>
      config := { config with enableTelemetry := b.getBool }
    | _ =>
      throwError s!"Unknown configuration option: {arg}"

  -- Validate the final configuration
  match validateConfig config with
  | some error => throwError s!"Invalid configuration: {error}"
  | none => pure config

-- Default configuration
def defaultConfig : UproveOptions := UproveOptions.mk

-- Preset configurations
def fastConfig : UproveOptions :=
  { UproveOptions.mk with maxSteps := 32, timeout := 1000, fallback := ["simp"] }

def thoroughConfig : UproveOptions :=
  { UproveOptions.mk with maxSteps := 128, timeout := 5000, fallback := ["simp", "aesop", "omega"] }

def debugConfig : UproveOptions :=
  { UproveOptions.mk with trace := true, enableTelemetry := true }

-- Configuration from environment variables
def configFromEnv : IO UproveOptions := do
  let maxSteps := (System.getEnv "UPROVE_MAX_STEPS").map (·.toNat!).getD 64
  let timeout := (System.getEnv "UPROVE_TIMEOUT").map (·.toNat!).getD 2000
  let trace := (System.getEnv "UPROVE_TRACE").map (·.toBool!).getD false
  let strict := (System.getEnv "UPROVE_STRICT").map (·.toBool!).getD false
  let enableTelemetry := (System.getEnv "UPROVE_TELEMETRY").map (·.toBool!).getD false

  let fallback := match System.getEnv "UPROVE_FALLBACK" with
  | some tactics => tactics.splitOn ","
  | none => ["simp", "aesop"]

  pure {
    maxSteps, timeout, trace, strict, enableTelemetry, fallback,
    simpSet := System.getEnv "UPROVE_SIMPSET"
  }

end Uprove
