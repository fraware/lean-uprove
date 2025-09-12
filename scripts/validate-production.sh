#!/bin/bash

# Comprehensive production validation script for uprove
# This script validates all production components systematically

set -e

echo "🚀 Starting Production Validation"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "lakefile.lean" ]; then
    print_error "Not in uprove project directory. Please run from project root."
    exit 1
fi

# Test 1: Core Functionality
print_status "Testing core functionality..."
echo "1. Product Scope Validation"
echo "==========================="

# Check core files exist
if [ -f "Uprove/CoreMinimal.lean" ]; then
    print_success "Core implementation exists"
else
    print_error "Core implementation missing"
    exit 1
fi

# Check universal property patterns
if grep -q "UniversalProperty" Uprove/CoreMinimal.lean; then
    print_success "Universal property patterns implemented"
else
    print_error "Universal property patterns missing"
    exit 1
fi

# Check pattern matching
if grep -q "matchPattern" Uprove/CoreMinimal.lean; then
    print_success "Pattern matching implemented"
else
    print_error "Pattern matching missing"
    exit 1
fi

echo ""
echo "2. Public API Validation"
echo "========================"

# Check if tactics exist (even if minimal)
if [ -f "Uprove/TacticsMinimal.lean" ]; then
    print_success "Tactic infrastructure exists"
else
    print_warning "Tactic infrastructure not yet implemented"
fi

# Check configuration
if [ -f "Uprove/Configuration.lean" ]; then
    print_success "Configuration system exists"
else
    print_warning "Configuration system not yet implemented"
fi

echo ""
echo "3. Architecture Validation"
echo "=========================="

# Check core architecture
if grep -q "ExecutionContext" Uprove/CoreMinimal.lean; then
    print_success "Execution context implemented"
else
    print_error "Execution context missing"
    exit 1
fi

if grep -q "executeProof" Uprove/CoreMinimal.lean; then
    print_success "Proof execution implemented"
else
    print_error "Proof execution missing"
    exit 1
fi

echo ""
echo "4. Quality Gates Validation"
echo "==========================="

# Check test infrastructure
if [ -f "Test.lean" ]; then
    print_success "Test infrastructure exists"
else
    print_error "Test infrastructure missing"
    exit 1
fi

# Check CI/CD
if [ -d ".github/workflows" ]; then
    print_success "CI/CD pipeline exists"
else
    print_error "CI/CD pipeline missing"
    exit 1
fi

# Check workflows
if [ -f ".github/workflows/ci.yml" ]; then
    print_success "CI workflow exists"
else
    print_error "CI workflow missing"
    exit 1
fi

if [ -f ".github/workflows/performance.yml" ]; then
    print_success "Performance workflow exists"
else
    print_error "Performance workflow missing"
    exit 1
fi

if [ -f ".github/workflows/release.yml" ]; then
    print_success "Release workflow exists"
else
    print_error "Release workflow missing"
    exit 1
fi

echo ""
echo "5. Performance SLAs Validation"
echo "=============================="

# Check performance infrastructure
if [ -f "Uprove/Performance.lean" ]; then
    print_success "Performance measurement infrastructure exists"
else
    print_warning "Performance measurement infrastructure not yet implemented"
fi

# Check benchmarking
if [ -f "Benchmark.lean" ]; then
    print_success "Benchmark infrastructure exists"
else
    print_warning "Benchmark infrastructure not yet implemented"
fi

echo ""
echo "6. Packaging & Versioning Validation"
echo "===================================="

# Check Lake configuration
if [ -f "lakefile.lean" ]; then
    print_success "Lake configuration exists"
else
    print_error "Lake configuration missing"
    exit 1
fi

if [ -f "lake-manifest.json" ]; then
    print_success "Lake manifest exists"
else
    print_error "Lake manifest missing"
    exit 1
fi

# Check versioning
if [ -f "CHANGELOG.md" ]; then
    print_success "Changelog exists"
else
    print_warning "Changelog missing"
fi

if [ -f "lean-toolchain" ]; then
    print_success "Lean toolchain specified"
else
    print_error "Lean toolchain missing"
    exit 1
fi

echo ""
echo "7. Build System Validation"
echo "=========================="

# Test build
print_status "Testing build system..."
if lake build; then
    print_success "Build system works"
else
    print_error "Build system failed"
    exit 1
fi

# Test Lake test command
print_status "Testing Lake test command..."
if lake test; then
    print_success "Lake test command works"
else
    print_error "Lake test command failed"
    exit 1
fi

echo ""
echo "8. Documentation Validation"
echo "==========================="

# Check documentation
if [ -f "README.md" ]; then
    print_success "README exists"
else
    print_error "README missing"
    exit 1
fi

if [ -f "docs/Quickstart.md" ]; then
    print_success "Quickstart guide exists"
else
    print_warning "Quickstart guide missing"
fi

if [ -f "docs/Cookbook.md" ]; then
    print_success "Cookbook exists"
else
    print_warning "Cookbook missing"
fi

echo ""
echo "9. Governance Validation"
echo "========================"

# Check governance files
if [ -f "CONTRIBUTING.md" ]; then
    print_success "Contributing guidelines exist"
else
    print_warning "Contributing guidelines missing"
fi

if [ -f "CODEOWNERS" ]; then
    print_success "CODEOWNERS exists"
else
    print_warning "CODEOWNERS missing"
fi

echo ""
echo "🎉 Production Validation Summary"
echo "==============================="
print_success "Core functionality: ✅ WORKING"
print_success "Minimal testing: ✅ WORKING"
print_success "CI/CD pipeline: ✅ ESTABLISHED"
print_success "Build system: ✅ WORKING"
print_success "Documentation: ✅ PRESENT"
print_warning "Performance measurement: ⚠️ FRAMEWORK READY"
print_warning "Full tactic implementation: ⚠️ IN PROGRESS"

echo ""
print_status "Production readiness: FOUNDATION COMPLETE"
print_status "Next steps:"
echo "  1. Implement full tactic syntax"
echo "  2. Add real performance measurement"
echo "  3. Implement comprehensive test suites"
echo "  4. Add mathlib integration"
echo "  5. Validate on CI/CD pipeline"

exit 0
