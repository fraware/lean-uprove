#!/usr/bin/env bash
set -euo pipefail

LEAN_UPROVE_VERSION="${LEAN_UPROVE_VERSION:-0.2.0}"

case "${1:-}" in
  --help|-h)
    echo "lean-uprove - Lean 4 tactic for universal properties"
    echo ""
    echo "Usage: lean-uprove [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version information"
    echo "  test           Run test suite"
    echo "  benchmark      Run performance benchmarks"
    echo "  examples       Run examples (smoke)"
    echo "  validate       Validate installation"
    echo ""
    echo "Examples:"
    echo "  lean-uprove test"
    echo "  lean-uprove benchmark"
    echo "  lean-uprove examples"
    echo ""
    echo "For more information, visit: https://github.com/fraware/lean-uprove"
    exit 0
    ;;
  --version|-v)
    echo "lean-uprove version ${LEAN_UPROVE_VERSION}"
    lean --version
    lake --version
    exit 0
    ;;
  test)
    echo "Running lean-uprove test suite..."
    lake test
    lake exe uprove-test-simple
    lake exe uprove-test-production
    echo "All tests passed."
    exit 0
    ;;
  benchmark)
    echo "Running lean-uprove performance benchmarks..."
    lake exe uprove-benchmark
    echo "Benchmarks completed."
    exit 0
    ;;
  examples)
    echo "Running lean-uprove examples smoke..."
    lake build UproveExamples
    echo "Examples completed."
    exit 0
    ;;
  validate)
    echo "Validating lean-uprove installation..."
    lake build
    lake test
    echo "Installation validated."
    exit 0
    ;;
  "")
    echo "lean-uprove - Lean 4 tactic for universal properties"
    echo "Run 'lean-uprove --help' for usage information"
    exit 0
    ;;
  *)
    echo "Unknown command: $1"
    echo "Run 'lean-uprove --help' for usage information"
    exit 1
    ;;
esac
