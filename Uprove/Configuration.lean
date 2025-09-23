import Lean
import Uprove.Core

open Lean

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

-- Parsing helpers can be added later; for now, use explicit construction

-- Default configuration
def defaultConfig : UproveOptions := {}

-- Preset configurations
def fastConfig : UproveOptions :=
  { UproveOptions.mk with maxSteps := 32, timeout := 1000, fallback := ["simp"] }

def thoroughConfig : UproveOptions :=
  { UproveOptions.mk with maxSteps := 128, timeout := 5000, fallback := ["simp", "aesop", "omega"] }

def debugConfig : UproveOptions :=
  { UproveOptions.mk with trace := true, enableTelemetry := true }

-- Configuration from environment variables
def configFromEnv : IO UproveOptions := do
  let maxSteps? ← IO.getEnv "UPROVE_MAX_STEPS"
  let timeout? ← IO.getEnv "UPROVE_TIMEOUT"
  let trace? ← IO.getEnv "UPROVE_TRACE"
  let strict? ← IO.getEnv "UPROVE_STRICT"
  let telemetry? ← IO.getEnv "UPROVE_TELEMETRY"
  let fallback? ← IO.getEnv "UPROVE_FALLBACK"
  let simpSet? ← IO.getEnv "UPROVE_SIMPSET"

  let maxSteps := maxSteps?.bind (fun s => s.toNat?) |>.getD 64
  let timeout := timeout?.bind (fun s => s.toNat?) |>.getD 2000
  let trace := trace?.map (fun s => s = "1" ∨ s = "true").getD false
  let strict := strict?.map (fun s => s = "1" ∨ s = "true").getD false
  let enableTelemetry := telemetry?.map (fun s => s = "1" ∨ s = "true").getD false
  let fallback := fallback?.map (fun s => s.splitOn ",").getD ["simp", "aesop"]

  let cfg : UproveOptions := {
    maxSteps := maxSteps,
    timeout := timeout,
    simpSet := simpSet?,
    trace := trace,
    strict := strict,
    fallback := fallback,
    enableTelemetry := enableTelemetry
  }
  match validateConfig cfg with
  | some err => throw <| IO.userError s!"Invalid configuration from env: {err}"
  | none => pure cfg

end Uprove
