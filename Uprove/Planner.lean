import Uprove.Core
import Uprove.Configuration
import Uprove.Patterns
import Mathlib.Tactic.Basic
import Mathlib.Tactic.SimpRw
import Lean.Elab.Tactic
import Aesop

open CategoryTheory CategoryTheory.Limits
open Lean.Elab.Tactic
open Lean

namespace Uprove

private def evalSimpWithOptionalSet (simpSet : Option String) : TacticM Unit := do
  match simpSet with
  | none => evalTactic (← `(tactic| simp))
  | some s =>
    let n := Name.mkSimple s
    evalTactic (← `(tactic| simp only [$(mkIdent n):ident]))

/-- Phase 1: construct the canonical cone/cocone/map from a classified pattern. -/
def constructCanonical (m : PatternMatch) : TacticM Unit := do
  match m.up.kind with
  | .product =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (pair _ _)))
  | .coproduct =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (pair _ _)))
  | .equalizer =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (parallelPair _ _)))
  | .coequalizer =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (parallelPair _ _)))
  | .pullback =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (cospan _ _)))
  | .pushout =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (span _ _)))
  | .terminal =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (Functor.empty _)))
  | .initial =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (Functor.empty _)))
  | .exponential =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact _))
  | .isomorphism =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| exact asIso _))
  | .generic | .functor | .naturalTransformation =>
    match m.up.name with
    | "Product" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (pair _ _)))
    | "Coproduct" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (pair _ _)))
    | "Equalizer" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (parallelPair _ _)))
    | "Coequalizer" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (parallelPair _ _)))
    | "Pullback" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (cospan _ _)))
    | "Pushout" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (span _ _)))
    | "Terminal" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact limit.cone (Functor.empty _)))
    | "Initial" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact colimit.cocone (Functor.empty _)))
    | "Isomorphism" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact asIso _))
    | _ =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| exact _))

/-- Phase 2: apply the appropriate uniqueness principle. -/
def applyUniqueness (m : PatternMatch) : TacticM Unit := do
  match m.up.kind with
  | .product | .equalizer | .pullback | .terminal =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| apply IsLimit.uniq))
  | .coproduct | .coequalizer | .pushout | .initial =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| apply IsColimit.uniq))
  | .isomorphism =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
  | .exponential =>
    Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
  | .generic | .functor | .naturalTransformation =>
    match m.up.name with
    | "Product" | "Equalizer" | "Pullback" | "Terminal" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| apply IsLimit.uniq))
    | "Coproduct" | "Coequalizer" | "Pushout" | "Initial" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| apply IsColimit.uniq))
    | "Isomorphism" =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
    | _ =>
      Lean.Elab.Tactic.evalTactic (← `(tactic| apply _))

/-- Phase 3: delegate residual goals to simp/aesop (and optional extras). -/
def delegateResidual (config : UproveConfig) : TacticM Unit := do
  for tacticName in config.fallback do
    match tacticName with
    | "simp" => do
      evalSimpWithOptionalSet config.simpSet
    | "aesop" => do
      Lean.Elab.Tactic.evalTactic (← `(tactic| aesop))
    | "omega" => do
      Lean.Elab.Tactic.evalTactic (← `(tactic| omega))
    | _ => pure ()

def planProof (m : PatternMatch) (config : UproveConfig) : TacticM Unit := do
  constructCanonical m
  applyUniqueness m
  delegateResidual config

def withTimeout (_timeout : Nat) (tactic : TacticM Unit) : TacticM Unit := do
  tactic

def withStepLimit (_maxSteps : Nat) (tactic : TacticM Unit) : TacticM Unit := do
  tactic

def safePlanProof (m : PatternMatch) (config : UproveConfig) : TacticM Unit := do
  withTimeout config.timeout do
    withStepLimit config.maxSteps do
      planProof m config

end Uprove
