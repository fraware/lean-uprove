#!/bin/bash
# Installation smoke checks for lean-uprove (structure, docs, scripts, optional build/Docker).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOCKER_IMAGE="ghcr.io/fraware/lean-uprove:latest"

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

test_docker() {
  print_info "Testing Docker..."
  if ! command -v docker &> /dev/null; then
    print_warning "Docker not available, skipping"
    return 0
  fi
  if docker run --rm "$DOCKER_IMAGE" --help > /dev/null 2>&1; then
    print_success "Docker image responds"
  else
    print_error "Docker image failed"
    return 1
  fi
}

test_source() {
  print_info "Testing Lake / Makefile (optional)..."
  if ! command -v lake &> /dev/null; then
    print_warning "Lake not available, skipping"
    return 0
  fi
  lake build > /dev/null 2>&1
  lake build UproveExamples > /dev/null 2>&1
  print_success "Lake build OK"
}

test_install_script() {
  print_info "Testing install script syntax..."
  if bash -n scripts/install.sh; then
    print_success "install.sh syntax OK"
  else
    print_error "install.sh syntax error"
    return 1
  fi
}

test_examples() {
  print_info "Testing example files..."
  for f in examples/BasicExamples.lean examples/ExampleProject.lean examples/QuickStart.lean; do
    if [ -f "$f" ]; then
      print_success "$f exists"
    else
      print_error "$f missing"
      return 1
    fi
  done
}

test_documentation() {
  print_info "Testing documentation..."
  for f in README.md LICENSE; do
    if [ -f "$f" ]; then
      print_success "$f exists"
    else
      print_error "$f missing"
      return 1
    fi
  done
  if [ -d "docs" ]; then
    print_success "docs/ exists"
  else
    print_error "docs/ missing"
    return 1
  fi
}

test_cicd() {
  print_info "Testing CI files..."
  for f in .github/workflows/ci.yml .github/workflows/release.yml Dockerfile .dockerignore; do
    if [ -f "$f" ]; then
      print_success "$f exists"
    else
      print_error "$f missing"
      return 1
    fi
  done
}

test_structure() {
  print_info "Testing project structure..."
  for f in lakefile.lean lean-toolchain lake-manifest.json; do
    if [ -f "$f" ]; then
      print_success "$f exists"
    else
      print_error "$f missing"
      return 1
    fi
  done
  if [ -f "bench/Benchmark.lean" ]; then
    print_success "bench/Benchmark.lean exists"
  else
    print_error "bench/Benchmark.lean missing"
    return 1
  fi
  [ -d "Uprove" ] || { print_error "Uprove/ missing"; return 1; }
  [ -d "scripts" ] || { print_error "scripts/ missing"; return 1; }
  print_success "Core layout OK"
}

test_performance() {
  print_info "Checking performance modules..."
  for f in Uprove/Performance.lean Uprove/PerformanceReal.lean Uprove/PerformanceValidation.lean; do
    if [ -f "$f" ]; then
      print_success "$f exists"
    else
      print_error "$f missing"
      return 1
    fi
  done
}

main() {
  echo "lean-uprove installation smoke tests"
  echo "====================================="
  failed=0
  test_structure || ((failed++))
  test_examples || ((failed++))
  test_documentation || ((failed++))
  test_cicd || ((failed++))
  test_install_script || ((failed++))
  test_source || ((failed++))
  test_docker || ((failed++))
  test_performance || ((failed++))
  echo ""
  if [ "$failed" -eq 0 ]; then
    print_success "All checks passed."
  else
    print_error "$failed check(s) failed."
    exit 1
  fi
}

case "${1:-}" in
  --help|-h)
    echo "Usage: $0 [--help]"
    echo "Runs repository smoke checks."
    exit 0
    ;;
  --version|-v)
    echo "test-installation.sh (lean-uprove)"
    exit 0
    ;;
  ""|*)
    main
    ;;
esac
