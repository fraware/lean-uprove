#!/usr/bin/env bash
# Gate 1: modernization and extraction acceptance (see docs/EXTRACTION_LEDGER.md)
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Gate 1 — modernization verification"
echo "==================================="

run() {
  echo "+ $*"
  "$@"
}

# `lake update` is run in CI; skip locally unless LAKE_UPDATE=1
if [ "${LAKE_UPDATE:-0}" = "1" ]; then
  run lake update
fi

run lake build Uprove
run lake build UproveExamples
run lake test
run lake exe uprove-test-simple
run lake exe uprove-test-real

echo ""
echo "Gate 1 passed."
