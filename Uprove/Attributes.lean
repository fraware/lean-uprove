import Uprove.Core
import Uprove.Tactics
import Mathlib.CategoryTheory.Limits.Basic
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Coproducts
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Coequalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullbacks
import Mathlib.CategoryTheory.Limits.Shapes.Pushouts
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Limits.Shapes.Initial
import Mathlib.CategoryTheory.Closed.Cartesian
import Mathlib.CategoryTheory.Isomorphism

namespace Uprove

-- Attribute for registering universal property lemmas
syntax "uprove" : attr

-- Attribute for registering canonical isomorphisms
syntax "uprove.iso" : attr

-- Implementation of the @[uprove] attribute
initialize uproveAttr : Lean.Attr where
  name := `uprove
  descr := "Register a universal property lemma for uprove tactic"
  add declName _ := do
    let decl ← Lean.getConstInfo declName
    let up := UniversalProperty.mk
      declName.toString
      decl.type
      decl.type -- This would be more sophisticated in practice
      decl.type -- This would be more sophisticated in practice
      none -- naturality
    unsafeIO (registerPattern up)

-- Implementation of the @[uprove.iso] attribute
initialize uproveIsoAttr : Lean.Attr where
  name := `uprove.iso
  descr := "Register a canonical isomorphism for uprove normalization"
  add declName _ := do
    let decl ← Lean.getConstInfo declName
    -- This would extract the isomorphism from the declaration
    -- For now, we'll use a placeholder
    let fromExpr := decl.type
    let toExpr := decl.type
    unsafeIO (registerIsomorphism fromExpr toExpr)

-- Helper functions for attribute registration
def registerUniversalProperty (name : String) (pattern constructor uniqueness : Lean.Expr) : IO Unit := do
  let up := UniversalProperty.mk name pattern constructor uniqueness none
  registerPattern up

def registerCanonicalIso (from to : Lean.Expr) : IO Unit := do
  registerIsomorphism from to

-- Pre-register common universal property patterns
initialize uprovePatterns : IO Unit := do
  -- Product patterns
  registerUniversalProperty "Product"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.limitCone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)

  -- Coproduct patterns
  registerUniversalProperty "Coproduct"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.colimitCocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)

  -- Equalizer patterns
  registerUniversalProperty "Equalizer"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.equalizerCone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)

  -- Coequalizer patterns
  registerUniversalProperty "Coequalizer"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.coequalizerCocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)

  -- Pullback patterns
  registerUniversalProperty "Pullback"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.pullbackCone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)

  -- Pushout patterns
  registerUniversalProperty "Pushout"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.pushoutCocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)

  -- Terminal object patterns
  registerUniversalProperty "Terminal"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.terminalCone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)

  -- Initial object patterns
  registerUniversalProperty "Initial"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.initialCocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)

  -- Exponential patterns
  registerUniversalProperty "Exponential"
    (Lean.mkConst ``CategoryTheory.Closed.Cartesian.IsExponential)
    (Lean.mkConst ``CategoryTheory.Closed.Cartesian.exponentialCone)
    (Lean.mkConst ``CategoryTheory.Closed.Cartesian.IsExponential.uniq)

  -- Isomorphism patterns
  registerUniversalProperty "Isomorphism"
    (Lean.mkConst ``CategoryTheory.IsIso)
    (Lean.mkConst ``CategoryTheory.asIso)
    (Lean.mkConst ``CategoryTheory.IsIso.uniq)

-- Pre-register common isomorphisms
initialize uproveIsomorphisms : IO Unit := do
  -- Identity isomorphism
  registerCanonicalIso
    (Lean.mkConst ``CategoryTheory.CategoryStruct.id)
    (Lean.mkConst ``CategoryTheory.CategoryStruct.id)

  -- Composition isomorphism
  registerCanonicalIso
    (Lean.mkConst ``CategoryTheory.CategoryStruct.comp)
    (Lean.mkConst ``CategoryTheory.CategoryStruct.comp)

end Uprove
