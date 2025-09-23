#!/bin/bash
# Comprehensive test script for lean-uprove installation
# Tests all installation methods and functionality

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="lean-uprove"
TEST_DIR="/tmp/lean-uprove-test"
DOCKER_IMAGE="ghcr.io/fraware/lean-uprove:latest"

# Print colored output
print_info() {
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

# Test Docker installation
test_docker() {
    print_info "Testing Docker installation..."
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        print_warning "Docker not available, skipping Docker tests"
        return 0
    fi
    
    # Test Docker image
    print_info "Testing Docker image: $DOCKER_IMAGE"
    if docker run --rm "$DOCKER_IMAGE" --help > /dev/null 2>&1; then
        print_success "Docker image works"
    else
        print_error "Docker image failed"
        return 1
    fi
    
    # Test Docker commands
    print_info "Testing Docker commands..."
    docker run --rm "$DOCKER_IMAGE" --version > /dev/null 2>&1
    docker run --rm "$DOCKER_IMAGE" validate > /dev/null 2>&1
    docker run --rm "$DOCKER_IMAGE" test > /dev/null 2>&1
    docker run --rm "$DOCKER_IMAGE" examples > /dev/null 2>&1
    docker run --rm "$DOCKER_IMAGE" benchmark > /dev/null 2>&1
    
    print_success "All Docker tests passed"
}

# Test source installation
test_source() {
    print_info "Testing source installation..."
    
    # Check if Lean 4 is available
    if ! command -v lean &> /dev/null; then
        print_warning "Lean 4 not available, skipping source tests"
        return 0
    fi
    
    # Check if Lake is available
    if ! command -v lake &> /dev/null; then
        print_warning "Lake not available, skipping source tests"
        return 0
    fi
    
    # Test Makefile
    print_info "Testing Makefile..."
    make help > /dev/null 2>&1
    make build > /dev/null 2>&1
    make test > /dev/null 2>&1
    make clean > /dev/null 2>&1
    
    print_success "All Makefile tests passed"
    
    # Test Lake commands
    print_info "Testing Lake commands..."
    lake build > /dev/null 2>&1
    lake test > /dev/null 2>&1
    lake exe test > /dev/null 2>&1
    lake exe uprove-test-simple > /dev/null 2>&1
    lake exe uprove-test-production > /dev/null 2>&1
    lake exe uprove-performance-validation > /dev/null 2>&1
    
    print_success "All Lake tests passed"
}

# Test installation script
test_install_script() {
    print_info "Testing installation script..."
    
    # Test script syntax
    if bash -n scripts/install.sh; then
        print_success "Installation script syntax is valid"
    else
        print_error "Installation script syntax is invalid"
        return 1
    fi
    
    # Test script help
    if scripts/install.sh --help > /dev/null 2>&1; then
        print_success "Installation script help works"
    else
        print_error "Installation script help failed"
        return 1
    fi
    
    # Test script version
    if scripts/install.sh --version > /dev/null 2>&1; then
        print_success "Installation script version works"
    else
        print_error "Installation script version failed"
        return 1
    fi
    
    print_success "All installation script tests passed"
}

# Test example files
test_examples() {
    print_info "Testing example files..."
    
    # Check if example files exist
    if [ -f "examples/BasicExamples.lean" ]; then
        print_success "BasicExamples.lean exists"
    else
        print_error "BasicExamples.lean missing"
        return 1
    fi
    
    if [ -f "examples/ExampleProject.lean" ]; then
        print_success "ExampleProject.lean exists"
    else
        print_error "ExampleProject.lean missing"
        return 1
    fi
    
    if [ -f "examples/QuickStart.lean" ]; then
        print_success "QuickStart.lean exists"
    else
        print_error "QuickStart.lean missing"
        return 1
    fi
    
    print_success "All example files exist"
}

# Test documentation
test_documentation() {
    print_info "Testing documentation..."
    
    # Check if documentation files exist
    if [ -f "README.md" ]; then
        print_success "README.md exists"
    else
        print_error "README.md missing"
        return 1
    fi
    
    if [ -f "CHANGELOG.md" ]; then
        print_success "CHANGELOG.md exists"
    else
        print_error "CHANGELOG.md missing"
        return 1
    fi
    
    if [ -f "LICENSE" ]; then
        print_success "LICENSE exists"
    else
        print_error "LICENSE missing"
        return 1
    fi
    
    # Check if docs directory exists
    if [ -d "docs" ]; then
        print_success "docs directory exists"
    else
        print_error "docs directory missing"
        return 1
    fi
    
    print_success "All documentation files exist"
}

# Test CI/CD files
test_cicd() {
    print_info "Testing CI/CD files..."
    
    # Check if GitHub Actions workflows exist
    if [ -f ".github/workflows/ci.yml" ]; then
        print_success "CI workflow exists"
    else
        print_error "CI workflow missing"
        return 1
    fi
    
    if [ -f ".github/workflows/release.yml" ]; then
        print_success "Release workflow exists"
    else
        print_error "Release workflow missing"
        return 1
    fi
    
    # Check if Dockerfile exists
    if [ -f "Dockerfile" ]; then
        print_success "Dockerfile exists"
    else
        print_error "Dockerfile missing"
        return 1
    fi
    
    # Check if .dockerignore exists
    if [ -f ".dockerignore" ]; then
        print_success ".dockerignore exists"
    else
        print_error ".dockerignore missing"
        return 1
    fi
    
    print_success "All CI/CD files exist"
}

# Test project structure
test_structure() {
    print_info "Testing project structure..."
    
    # Check if core files exist
    if [ -f "lakefile.lean" ]; then
        print_success "lakefile.lean exists"
    else
        print_error "lakefile.lean missing"
        return 1
    fi
    
    if [ -f "lean-toolchain" ]; then
        print_success "lean-toolchain exists"
    else
        print_error "lean-toolchain missing"
        return 1
    fi
    
    if [ -f "lake-manifest.json" ]; then
        print_success "lake-manifest.json exists"
    else
        print_error "lake-manifest.json missing"
        return 1
    fi
    
    # Check if Uprove directory exists
    if [ -d "Uprove" ]; then
        print_success "Uprove directory exists"
    else
        print_error "Uprove directory missing"
        return 1
    fi
    
    # Check if scripts directory exists
    if [ -d "scripts" ]; then
        print_success "scripts directory exists"
    else
        print_error "scripts directory missing"
        return 1
    fi
    
    print_success "All project structure tests passed"
}

# Test performance
test_performance() {
    print_info "Testing performance..."
    
    # Check if performance tests exist
    if [ -f "Uprove/Performance.lean" ]; then
        print_success "Performance.lean exists"
    else
        print_error "Performance.lean missing"
        return 1
    fi
    
    if [ -f "Uprove/PerformanceReal.lean" ]; then
        print_success "PerformanceReal.lean exists"
    else
        print_error "PerformanceReal.lean missing"
        return 1
    fi
    
    if [ -f "Uprove/PerformanceValidation.lean" ]; then
        print_success "PerformanceValidation.lean exists"
    else
        print_error "PerformanceValidation.lean missing"
        return 1
    fi
    
    print_success "All performance tests exist"
}

# Main test function
main() {
    echo "lean-uprove Installation Test Suite"
    echo "===================================="
    echo ""
    
    local failed_tests=0
    
    # Run all tests
    test_structure || ((failed_tests++))
    test_examples || ((failed_tests++))
    test_documentation || ((failed_tests++))
    test_cicd || ((failed_tests++))
    test_install_script || ((failed_tests++))
    test_source || ((failed_tests++))
    test_docker || ((failed_tests++))
    test_performance || ((failed_tests++))
    
    echo ""
    echo "Test Summary"
    echo "============"
    
    if [ $failed_tests -eq 0 ]; then
        print_success "All tests passed! lean-uprove is ready for distribution."
        echo ""
        echo "Next steps:"
        echo "  1. Commit and push changes"
        echo "  2. Create a release tag"
        echo "  3. GitHub Actions will automatically build and publish artifacts"
        echo ""
        echo "Installation commands for users:"
        echo "  Docker: docker run --rm ghcr.io/fraware/lean-uprove:latest --help"
        echo "  Script: curl -fsSL https://raw.githubusercontent.com/fraware/lean-uprove/main/scripts/install.sh | bash"
        echo "  Source: git clone https://github.com/fraware/lean-uprove.git && cd lean-uprove && make dev && make run"
    else
        print_error "$failed_tests test(s) failed. Please fix issues before distribution."
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
  --help|-h)
    echo "lean-uprove Installation Test Suite"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version information"
    echo ""
    echo "This script tests all aspects of the lean-uprove installation:"
    echo "  - Project structure"
    echo "  - Example files"
    echo "  - Documentation"
    echo "  - CI/CD files"
    echo "  - Installation scripts"
    echo "  - Source compilation"
    echo "  - Docker images"
    echo "  - Performance tests"
    exit 0
    ;;
  --version|-v)
    echo "lean-uprove installation test suite version 0.1.0"
    exit 0
    ;;
  "")
    main
    ;;
  *)
    print_error "Unknown option: $1"
    echo "Run '$0 --help' for usage information"
    exit 1
    ;;
esac
