import Lean
import Lean.Elab.Tactic
import Lean.Meta
import Lean.Elab.Command
import Mathlib.Tactic.Linarith
import Uprove.Core
import Uprove.Configuration
import Uprove.Planner
import Uprove.Version
import Uprove.Telemetry

open Lean Elab Tactic Meta

namespace Uprove

private unsafe def evalAsUproveOptions (e : Expr) : MetaM UproveOptions :=
  Lean.Meta.evalExpr UproveOptions (mkConst ``Uprove.UproveOptions) e

private def evalSimpWithOptionalSet (simpSet : Option String) : TacticM Unit := do
  match simpSet with
  | none => Lean.Elab.Tactic.evalTactic (← `(tactic| simp))
  | some s =>
    let n := Lean.Name.mkSimple s
    Lean.Elab.Tactic.evalTactic (← `(tactic| simp only [$(Lean.mkIdent n):ident]))

syntax "uprove" : tactic
syntax "uprove" "[" term "]" : tactic
syntax "uprove?" : tactic
syntax "uprove?" "[" term "]" : tactic

/-- Human-readable proof plan for explainer mode. -/
def generateProofPlan (patternMatch : PatternMatch) (config : UproveOptions) : String :=
  let steps := [
    s!"1. Construct canonical {patternMatch.up.name}",
    "2. Apply uniqueness property",
    s!"3. Delegate residual goals to {config.fallback}"
  ]
  steps.foldl (fun acc s => if acc.isEmpty then s else acc ++ "\n" ++ s) ""

/-- Compact structured summary (no fragile JSON escaping). -/
def generateStructuredPlan (patternMatch : PatternMatch) (config : UproveOptions) : String :=
  "pattern=" ++ patternMatch.up.name ++
    ", confidence=" ++ toString patternMatch.confidence ++
    ", fallback=[" ++ String.intercalate ", " config.fallback ++ "]"

def uproveTactic (config : UproveOptions) : TacticM Unit := do
  let startTime ← IO.monoMsNow
  let goal ← instantiateMVars (← getMainTarget)

  if config.trace then
    Lean.logInfo s!"Uprove: analyzing goal: {goal}"

  let patterns ← getRegisteredPatterns
  let isos ← getRegisteredIsomorphisms

  let normalizedGoal := normalizeExpression goal isos

  match matchUniversalProperty normalizedGoal patterns with
  | some patternMatch => do
    if config.trace then
      Lean.logInfo s!"Matched pattern: {patternMatch.up.name} (confidence: {patternMatch.confidence})"

    safePlanProof patternMatch {
      maxSteps := config.maxSteps,
      timeout := config.timeout,
      simpSet := config.simpSet,
      trace := config.trace,
      strict := config.strict,
      fallback := config.fallback,
      enableTelemetry := config.enableTelemetry
    }

    if config.enableTelemetry then
      let endTime ← IO.monoMsNow
      let executionTime := endTime - startTime
      let goalHash := Uprove.generateGoalHash goal
      let telemetryData := TelemetryData.mk
        "uprove"
        executionTime
        1
        true
        goalHash
        Uprove.leanToolchainString
        Uprove.mathlibPinRev
        endTime
      recordTelemetry telemetryData

  | none => do
    if config.trace then
      Lean.logInfo "No pattern match found, using fallback tactics"

    if config.strict then
      throwError "No matching universal property pattern found and strict mode enabled"
    else
      for tacticName in config.fallback do
        if config.trace then
          Lean.logInfo s!"Applying fallback tactic: {tacticName}"
        try
          match tacticName with
          | "simp" =>
            evalSimpWithOptionalSet config.simpSet
          | "aesop" => Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
          | "omega" => Lean.Elab.Tactic.evalTactic (← `(tactic| omega))
          | "linarith" => Lean.Elab.Tactic.evalTactic (← `(tactic| linarith))
          | "sorry" => Lean.Elab.Tactic.evalTactic (← `(tactic| sorry))
          | _ =>
            if config.trace then
              Lean.logInfo s!"Unknown fallback tactic: {tacticName}"
        catch e =>
          if config.trace then
            Lean.logInfo e.toMessageData

def uproveExplainTactic (config : UproveOptions) : TacticM Unit := do
  let startTime ← IO.monoMsNow
  let goal ← instantiateMVars (← getMainTarget)

  Lean.logInfo s!"Uprove analysis for goal: {goal}"

  let patterns ← getRegisteredPatterns
  let isos ← getRegisteredIsomorphisms

  let normalizedGoal := normalizeExpression goal isos
  if normalizedGoal != goal then
    Lean.logInfo s!"Normalized goal: {normalizedGoal}"

  match matchUniversalProperty normalizedGoal patterns with
  | some patternMatch => do
    let plan := generateProofPlan patternMatch config
    let structuredPlan := generateStructuredPlan patternMatch config

    Lean.logInfo s!"Pattern match: {patternMatch.up.name}"
    Lean.logInfo s!"Confidence: {patternMatch.confidence}"
    Lean.logInfo s!"Substitutions: {patternMatch.substitutions}"
    Lean.logInfo s!"Proof plan:\n{plan}"
    Lean.logInfo s!"Structured plan: {structuredPlan}"

    safePlanProof patternMatch {
      maxSteps := config.maxSteps,
      timeout := config.timeout,
      simpSet := config.simpSet,
      trace := true,
      strict := config.strict,
      fallback := config.fallback,
      enableTelemetry := config.enableTelemetry
    }

    if config.enableTelemetry then
      let endTime ← IO.monoMsNow
      let executionTime := endTime - startTime
      let goalHash := Uprove.generateGoalHash goal
      let telemetryData := TelemetryData.mk
        "uprove?"
        executionTime
        1
        true
        goalHash
        Uprove.leanToolchainString
        Uprove.mathlibPinRev
        endTime
      recordTelemetry telemetryData

  | none => do
    Lean.logInfo "No matching universal property pattern found"
    Lean.logInfo s!"Available patterns: {patterns.map (·.name)}"
    Lean.logInfo "Falling back to configured tactics"

    let fallbackPlan := s!"Fallback plan: {config.fallback}"
    Lean.logInfo s!"{fallbackPlan}"

    uproveTactic config

elab_rules : tactic
| `(tactic| uprove) =>
  Uprove.uproveTactic Uprove.defaultConfig
| `(tactic| uprove [$cfg:term]) =>
  Lean.Elab.Tactic.withMainContext do
    let e ← Lean.Elab.Term.elabTermAndSynthesize cfg none
    let e ← liftMetaM (instantiateMVars e)
    if e.hasMVar then
      throwError "expected UproveOptions without metavariables"
    let opts ← liftMetaM (unsafe evalAsUproveOptions e)
    Uprove.uproveTactic opts

elab_rules : tactic
| `(tactic| uprove?) =>
  Uprove.uproveExplainTactic Uprove.defaultConfig
| `(tactic| uprove? [$cfg:term]) =>
  Lean.Elab.Tactic.withMainContext do
    let e ← Lean.Elab.Term.elabTermAndSynthesize cfg none
    let e ← liftMetaM (instantiateMVars e)
    if e.hasMVar then
      throwError "expected UproveOptions without metavariables"
    let opts ← liftMetaM (unsafe evalAsUproveOptions e)
    Uprove.uproveExplainTactic opts

end Uprove
