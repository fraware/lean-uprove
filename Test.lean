import Uprove.Version
import Uprove.Core

/--
Lake test driver (`lake test` / `lake exe test`).
Compile-time checks live in [Uprove/SmokeTest.lean](Uprove/SmokeTest.lean); CI also builds `Uprove` and `UproveExamples`.
-/
def main : IO Unit := do
  IO.println s!"lean-uprove test runner (package {Uprove.packageVersion})"
  let pats ← Uprove.getRegisteredPatterns
  if pats.isEmpty then
    IO.eprintln "warning: no patterns registered at startup (expected after full `import Uprove` in user code)"
  else
    IO.println s!"registered patterns (init): {pats.length}"
  IO.println "OK"
