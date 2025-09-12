import Lean
import System.IO

namespace Uprove

-- License scanning for production compliance
def main : IO Unit := do
  IO.println "🔍 Running License Scan"
  IO.println "====================="

  -- Check for license headers in source files
  let sourceFiles := [
    "Uprove.lean",
    "Uprove/Core.lean",
    "Uprove/Tactics.lean",
    "Uprove/Patterns.lean",
    "Uprove/Planner.lean"
  ]

  let mut licenseCompliant := true

  for file in sourceFiles do
    match ← IO.FS.readFile file with
    | .ok content =>
      if content.contains "Copyright" && content.contains "MIT" then
        IO.println s!"✅ {file}: License header found"
      else
        IO.println s!"❌ {file}: Missing license header"
        licenseCompliant := false
    | .error _ =>
      IO.println s!"⚠️  {file}: Could not read file"

  -- Check LICENSE file
  match ← IO.FS.readFile "LICENSE" with
  | .ok _ => IO.println "✅ LICENSE file found"
  | .error _ =>
    IO.println "❌ LICENSE file missing"
    licenseCompliant := false

  if licenseCompliant then
    IO.println "\n🎉 All license checks passed!"
    IO.Process.exit 0
  else
    IO.println "\n⚠️  Some license checks failed!"
    IO.Process.exit 1

end Uprove
