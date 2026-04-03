import Uprove.PerformanceReal
import Uprove.Version

structure BenchmarkCli where
  checkSla : Bool := false
  checkRegression : Bool := false
  iterations : Nat := 0
  configFast : Bool := false
  deriving Inhabited

partial def parseBenchmarkCli (args : List String) : BenchmarkCli :=
  let rec go (args : List String) (acc : BenchmarkCli) : BenchmarkCli :=
    match args with
    | [] => acc
    | "--check-sla" :: rest => go rest { acc with checkSla := true }
    | "--check-regression" :: rest => go rest { acc with checkRegression := true }
    | "--config=fast" :: rest => go rest { acc with configFast := true }
    | s :: rest =>
      if s.startsWith "--iterations=" then
        let n := (s.drop 13).toNat?.getD 0
        go rest { acc with iterations := n }
      else
        go rest acc
  go args {}

/--
Performance benchmark entrypoint (`lake exe uprove-benchmark`).
Use `--check-sla` to exit with code 1 when SLA validation fails.
-/
def main (args : List String) : IO Unit := do
  let cli := parseBenchmarkCli args
  if cli.iterations > 0 then
    IO.println s!"note: --iterations={cli.iterations} reserved for future timed harnesses"
  if cli.configFast then
    IO.println "note: --config=fast reserved for future benchmark profiles"
  if cli.checkRegression then
    IO.println "note: --check-regression reserved for baseline comparison (see baselines/)"

  IO.println s!"Uprove benchmark (lean-uprove {Uprove.packageVersion})"
  IO.println "=========================================="

  let results ← Uprove.runPerformanceSuite
  let report := Uprove.generateReport results
  IO.println report

  let slaPassed ← Uprove.validateSLAs results
  if cli.checkSla && !slaPassed then
    IO.Process.exit 1
  if !slaPassed then
    IO.eprintln "warning: some SLAs not met (re-run with --check-sla to fail)."
