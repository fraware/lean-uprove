import Lean

namespace Uprove

/-- Semantic version of this package (single source of truth). -/
def packageVersion : String := "0.2.0"

/-- Mathlib git revision pinned in [lakefile.lean](lakefile.lean); update when bumping the pin. -/
def mathlibPinRev : String := "v4.31.0-rc1"

/-- Lean toolchain string from the compiler (runtime). -/
def leanToolchainString : String :=
  s!"{Lean.version.major}.{Lean.version.minor}.{Lean.version.patch}"

end Uprove
