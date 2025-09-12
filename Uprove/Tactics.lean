import Uprove.Core
import Lean.Elab.Tactic
import Lean.Meta
import Lean.Elab.Command

namespace Uprove

-- Enhanced tactic syntax with proper configuration parsing
syntax "uprove" (config)? : tactic
syntax uproveConfig := "[" (uproveConfigOption,*)? "]"
syntax uproveConfigOption := "maxSteps" " := " term
  | "timeout" " := " term
  | "simpSet" " := " term
  | "trace" " := " term
  | "strict" " := " term
  | "fallback" " := " term
  | "enableTelemetry" " := " term

macro_rules
| `(tactic| uprove) => `(tactic|
    let config := Uprove.defaultConfig
    Uprove.uproveTactic config)
| `(tactic| uprove [$cfg:term]) => `(tactic|
    let config := $cfg
    Uprove.uproveTactic config)

-- Explainer mode with enhanced syntax
syntax "uprove?" (config)? : tactic

macro_rules
| `(tactic| uprove?) => `(tactic|
    let config := Uprove.defaultConfig
    Uprove.uproveExplainTactic config)
| `(tactic| uprove? [$cfg:term]) => `(tactic|
    let config := $cfg
    Uprove.uproveExplainTactic config)

-- Enhanced core tactic implementation with proper error handling
def uproveTactic (config : UproveConfig) : Lean.TacticM Unit := do
  let startTime ← IO.monoMsNow
  let goal ← Lean.Meta.getMainTarget

  -- Log goal for debugging
  if config.trace then
    Lean.logInfo s!"Uprove: analyzing goal: {goal}"

  -- Get registered patterns and isomorphisms
  let patterns ← unsafeIO getRegisteredPatterns
  let isos ← unsafeIO getRegisteredIsomorphisms

  -- Normalize the goal using isomorphism rewrites
  let normalizedGoal := normalizeExpression goal isos

  -- Try to match against patterns
  match matchUniversalProperty normalizedGoal patterns with
  | some match => do
    if config.trace then
      Lean.logInfo s!"Matched pattern: {match.up.name} (confidence: {match.confidence})"

    -- Execute the proof plan with safety limits
    safePlanProof match config

    -- Record telemetry if enabled
    if config.enableTelemetry then
      let endTime ← IO.monoMsNow
      let executionTime := endTime - startTime
      let goalHash := generateGoalHash goal
      let telemetryData := TelemetryData.mk
        "uprove"
        executionTime
        1 -- step count
        true
        goalHash
        "4.12.0" -- lean version
        "0.1.0" -- mathlib version
        endTime
      unsafeIO (recordTelemetry telemetryData)

  | none => do
    if config.trace then
      Lean.logInfo "No pattern match found, using fallback tactics"

    if config.strict then
      throwError "No matching universal property pattern found and strict mode enabled"
    else
      -- Fall back to configured tactics
      for tacticName in config.fallback do
        if config.trace then
          Lean.logInfo s!"Applying fallback tactic: {tacticName}"
        try
          match tacticName with
          | "simp" =>
            if let some simpSet := config.simpSet then
              Lean.Elab.Tactic.evalTactic (← `(tactic| simp only [$simpSet:ident]))
            else
              Lean.Elab.Tactic.evalTactic (← `(tactic| simp))
          | "aesop" => Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
          | "omega" => Lean.Elab.Tactic.evalTactic (← `(tactic| omega))
          | "linarith" => Lean.Elab.Tactic.evalTactic (← `(tactic| linarith))
          | "sorry" => Lean.Elab.Tactic.evalTactic (← `(tactic| sorry))
          | _ =>
            if config.trace then
              Lean.logInfo s!"Unknown fallback tactic: {tacticName}"
        catch e =>
          if config.trace then
            Lean.logInfo s!"Fallback tactic {tacticName} failed: {e.toMessageData}"

-- Enhanced explainer mode implementation with detailed output
def uproveExplainTactic (config : UproveConfig) : Lean.TacticM Unit := do
  let startTime ← IO.monoMsNow
  let goal ← Lean.Meta.getMainTarget

  -- Always log the goal in explainer mode
  Lean.logInfo s!"🔍 Uprove Analysis for goal: {goal}"

  let patterns ← unsafeIO getRegisteredPatterns
  let isos ← unsafeIO getRegisteredIsomorphisms

  -- Normalize the goal using isomorphism rewrites
  let normalizedGoal := normalizeExpression goal isos
  if normalizedGoal != goal then
    Lean.logInfo s!"📝 Normalized goal: {normalizedGoal}"

  -- Try to match against patterns
  match matchUniversalProperty normalizedGoal patterns with
  | some match => do
    let plan := generateProofPlan match config
    let structuredPlan := generateStructuredPlan match config

    -- Log detailed analysis
    Lean.logInfo s!"🎯 Pattern Match: {match.up.name}"
    Lean.logInfo s!"📊 Confidence: {match.confidence}"
    Lean.logInfo s!"🔧 Substitutions: {match.substitutions}"
    Lean.logInfo s!"📋 Proof Plan:\n{plan}"
    Lean.logInfo s!"📄 Structured Plan: {structuredPlan}"

    -- Execute the proof plan with safety limits
    safePlanProof match config

    -- Record telemetry if enabled
    if config.enableTelemetry then
      let endTime ← IO.monoMsNow
      let executionTime := endTime - startTime
      let goalHash := generateGoalHash goal
      let telemetryData := TelemetryData.mk
        "uprove?"
        executionTime
        1
        true
        goalHash
        "4.12.0"
        "0.1.0"
        endTime
      unsafeIO (recordTelemetry telemetryData)

  | none => do
    Lean.logInfo "❌ No matching universal property pattern found"
    Lean.logInfo s!"🔄 Available patterns: {patterns.map (·.name)}"
    Lean.logInfo "🔧 Falling back to configured tactics"

    -- Create a fallback plan
    let fallbackPlan := s!"Fallback plan: {config.fallback}"
    Lean.logInfo s!"📋 {fallbackPlan}"

    -- Execute fallback tactics
    uproveTactic config

-- Generate human-readable proof plan
def generateProofPlan (match : PatternMatch) (config : UproveConfig) : String :=
  let steps := [
    s!"1. Construct canonical {match.up.name}",
    "2. Apply uniqueness property",
    s!"3. Delegate residual goals to {config.fallback}"
  ]
  steps.foldl (· + "\n" + ·) ""

-- Generate structured proof plan (JSON-like format)
def generateStructuredPlan (match : PatternMatch) (config : UproveConfig) : String :=
  s!"{{\"pattern\": \"{match.up.name}\", \"confidence\": {match.confidence}, \"steps\": [\"construct\", \"uniqueness\", \"delegate\"], \"fallback\": {config.fallback}}}"

-- Helper functions for telemetry
def generateGoalHash (goal : Lean.Expr) : String :=
  goal.toString.hash.toString

-- Record telemetry data
def recordTelemetry (data : TelemetryData) : IO Unit := do
  -- In a real implementation, this would send to configured endpoint
  if System.getEnv "UPROVE_TELEMETRY" == some "1" then
    IO.println s!"[TELEMETRY] {data.tacticName}: {data.executionTime}ms, success: {data.success}, goal: {data.goalHash}"
  pure ()

end Uprove
