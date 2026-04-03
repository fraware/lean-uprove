import Lean
import Lean.Elab.Tactic
import Lean.Meta
import Lean.Elab.Command
import Lean.Expr

open Lean Elab Tactic

namespace Uprove

/-- Discriminator for planner routing (avoids stringly-typed `name` checks). -/
inductive UniversalPropertyKind where
  | generic
  | product | coproduct | equalizer | coequalizer | pullback | pushout
  | terminal | initial | exponential | isomorphism | functor | naturalTransformation
  deriving Inhabited, Repr, BEq

-- Core types for universal properties
structure UniversalProperty where
  name : String
  pattern : Lean.Expr
  constructor : Lean.Expr
  uniqueness : Lean.Expr
  naturality : Option Lean.Expr := none
  kind : UniversalPropertyKind := .generic
  deriving Inhabited, Repr

structure PatternMatch where
  goal : Lean.Expr
  up : UniversalProperty
  substitutions : List (Lean.Expr × Lean.Expr)
  confidence : Float := 1.0
  deriving Inhabited, Repr

-- Configuration for the tactic
structure UproveConfig where
  maxSteps : Nat := 64
  timeout : Nat := 2000 -- milliseconds
  simpSet : Option String := none
  trace : Bool := false
  strict : Bool := false
  fallback : List String := ["simp", "aesop"]
  enableTelemetry : Bool := false
  deriving Inhabited, Repr

-- State for the tactic execution
structure UproveState where
  config : UproveConfig
  stepCount : Nat := 0
  startTime : Nat := 0
  patterns : List UniversalProperty := []
  isomorphisms : List (Lean.Expr × Lean.Expr) := []
  goalHistory : List Lean.Expr := []
  deriving Inhabited, Repr

-- Global registries for patterns and isomorphisms
structure UproveRegistry where
  patterns : List UniversalProperty := []
  isomorphisms : List (Lean.Expr × Lean.Expr) := []
  deriving Inhabited

-- Simple global state management using module initialization
builtin_initialize globalRegistry : IO.Ref UproveRegistry ←
  IO.mkRef { patterns := [], isomorphisms := [] }

-- Registry management functions
def registerPattern (up : UniversalProperty) : IO Unit := do
  let reg ← globalRegistry.get
  globalRegistry.set { reg with patterns := up :: reg.patterns }

def registerIsomorphism (fromExpr toExpr : Lean.Expr) : IO Unit := do
  let reg ← globalRegistry.get
  globalRegistry.set { reg with isomorphisms := (fromExpr, toExpr) :: reg.isomorphisms }

def getRegisteredPatterns : IO (List UniversalProperty) := do
  let reg ← globalRegistry.get
  pure reg.patterns

def getRegisteredIsomorphisms : IO (List (Lean.Expr × Lean.Expr)) := do
  let reg ← globalRegistry.get
  pure reg.isomorphisms

/-- True when `goal` and `pat` share the same constant head (after stripping apps). -/
def sameHeadConst (goal pat : Lean.Expr) : Bool :=
  goal.getAppFn.constName? == pat.getAppFn.constName?

/-- Pairwise args when heads match `prop.pattern`; otherwise empty. -/
def extractSubstitutions (goal : Lean.Expr) (prop : UniversalProperty) : List (Lean.Expr × Lean.Expr) :=
  if !sameHeadConst goal prop.pattern then []
  else
    let gArgs := goal.getAppArgs.toList
    let pArgs := prop.pattern.getAppArgs.toList
    gArgs.zip pArgs

def scoreMatch (goal : Lean.Expr) (prop : UniversalProperty) (subs : List (Lean.Expr × Lean.Expr)) : Float :=
  let base := if sameHeadConst goal prop.constructor then 1.0 else 0.85
  base + (subs.length.toFloat * 0.02)

-- Pattern matching: first pattern whose head constant matches the goal head.
def matchUniversalProperty (goal : Lean.Expr) (patterns : List UniversalProperty) : Option PatternMatch :=
  patterns.find? (fun prop => sameHeadConst goal prop.pattern)
  |>.map (fun prop =>
    let subs := extractSubstitutions goal prop
    { goal := goal, up := prop, substitutions := subs
      confidence := scoreMatch goal prop subs })

/-- If `expr` is defeq to a registered iso left-hand side, return the right-hand side (first hit). -/
def normalizeExpression (expr : Lean.Expr) (isos : List (Lean.Expr × Lean.Expr)) : Lean.Expr :=
  isos.foldl (fun e (fromE, toE) =>
    if e == fromE then toE else e) expr

def normalizeComposition (expr : Lean.Expr) : Lean.Expr :=
  expr

end Uprove
