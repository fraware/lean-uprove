import Lean
import Uprove.Core
import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.Shapes.Products
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback
import Mathlib.CategoryTheory.Limits.Shapes.Terminal
import Mathlib.CategoryTheory.Iso

open Lean

namespace Uprove

initialize registerBuiltinAttribute {
  name := `uproveLemma
  descr := "Register a universal property lemma for the uprove tactic (use @[uproveLemma])"
  add := fun declName stx _kind => do
    Lean.Attribute.Builtin.ensureNoArgs stx
    let decl ← Lean.getConstInfo declName
    let up : UniversalProperty := {
      name := declName.toString
      pattern := decl.type
      constructor := decl.type
      uniqueness := decl.type
      naturality := none
      kind := .generic
    }
    let _ ← liftM (registerPattern up)
}

initialize registerBuiltinAttribute {
  name := `uprove.iso
  descr := "Register a canonical isomorphism pair for uprove normalization"
  add := fun declName stx _kind => do
    Lean.Attribute.Builtin.ensureNoArgs stx
    let decl ← Lean.getConstInfo declName
    let src := decl.type
    let tgt := decl.type
    let _ ← liftM (registerIsomorphism src tgt)
}

def registerUniversalProperty (name : String) (pattern constructor uniqueness : Lean.Expr)
    (kind : UniversalPropertyKind := .generic) : IO Unit := do
  let up : UniversalProperty := { name, pattern, constructor, uniqueness, naturality := none, kind }
  registerPattern up

def registerCanonicalIso (srcExpr tgtExpr : Lean.Expr) : IO Unit :=
  registerIsomorphism srcExpr tgtExpr

initialize do
  registerUniversalProperty "Product"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.limit.cone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)
    .product
  registerUniversalProperty "Coproduct"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.colimit.cocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)
    .coproduct
  registerUniversalProperty "Equalizer"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.limit.cone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)
    .equalizer
  registerUniversalProperty "Coequalizer"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.colimit.cocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)
    .coequalizer
  registerUniversalProperty "Pullback"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.limit.cone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)
    .pullback
  registerUniversalProperty "Pushout"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.colimit.cocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)
    .pushout
  registerUniversalProperty "Terminal"
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit)
    (Lean.mkConst ``CategoryTheory.Limits.limit.cone)
    (Lean.mkConst ``CategoryTheory.Limits.IsLimit.uniq)
    .terminal
  registerUniversalProperty "Initial"
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit)
    (Lean.mkConst ``CategoryTheory.Limits.colimit.cocone)
    (Lean.mkConst ``CategoryTheory.Limits.IsColimit.uniq)
    .initial
  registerUniversalProperty "Isomorphism"
    (Lean.mkConst ``CategoryTheory.IsIso)
    (Lean.mkConst ``CategoryTheory.asIso)
    (Lean.mkConst ``CategoryTheory.IsIso.hom_inv_id)
    .isomorphism

initialize do
  registerCanonicalIso
    (Lean.mkConst ``CategoryTheory.CategoryStruct.id)
    (Lean.mkConst ``CategoryTheory.CategoryStruct.id)
  registerCanonicalIso
    (Lean.mkConst ``CategoryTheory.CategoryStruct.comp)
    (Lean.mkConst ``CategoryTheory.CategoryStruct.comp)

end Uprove
