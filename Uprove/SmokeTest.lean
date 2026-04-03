import Lean
import Uprove.Core

namespace Uprove

/-- No registered patterns implies no match (compile-time check). -/
example (g : Lean.Expr) : matchUniversalProperty g [] = none := rfl

end Uprove
