import Uprove.Core

/-!
Test-only pattern registration (no Mathlib import).

Registers synthetic patterns using core constants so smoke executables link without
pulling in Mathlib (avoids Windows PE export limits). Production registration lives
in `UproveRegisterInit.lean`.
-/

namespace Uprove

private def registerUP (name : String) (head : Lean.Name) (kind : UniversalPropertyKind) : IO Unit := do
  let pat := Lean.mkConst head
  let up : UniversalProperty := {
    name, pattern := pat, constructor := pat, uniqueness := pat, naturality := none, kind
  }
  registerPattern up

/-- Register a minimal pattern set for smoke/integration executables. -/
def registerTestPatterns : IO Unit := do
  registerUP "Product" ``List .product
  registerUP "Coproduct" ``Array .coproduct
  registerUP "Equalizer" ``Nat .equalizer

end Uprove
