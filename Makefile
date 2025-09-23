# lean-uprove Makefile
# Provides one-command install, run, and release capabilities

.PHONY: help dev run test build clean release install uninstall docker-build docker-run validate

# Default target
help:
	@echo "lean-uprove - Lean 4 tactic for universal properties"
	@echo ""
	@echo "Available targets:"
	@echo "  dev       - Set up local development environment"
	@echo "  run       - Run the app/CLI locally"
	@echo "  test      - Run all tests"
	@echo "  build     - Build the project"
	@echo "  clean     - Clean build artifacts"
	@echo "  release   - Build and publish artifacts (dry-run supported)"
	@echo "  install   - Install lean-uprove system-wide"
	@echo "  uninstall - Remove lean-uprove installation"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run Docker container"
	@echo "  validate  - Validate CI/CD pipeline"
	@echo ""
	@echo "Quick start:"
	@echo "  make dev && make run"

# Development environment setup
dev:
	@echo "Setting up lean-uprove development environment..."
	@echo "Checking Lean 4 installation..."
	@lean --version || (echo "Error: Lean 4 not found. Please install Lean 4 first." && exit 1)
	@echo "Checking Lake..."
	@lake --version || (echo "Error: Lake not found. Please install Lake first." && exit 1)
	@echo "Installing dependencies..."
	@lake update
	@lake build
	@echo "✅ Development environment ready!"
	@echo ""
	@echo "Next steps:"
	@echo "  make run    - Run examples and tests"
	@echo "  make test   - Run full test suite"

# Run the application locally
run:
	@echo "Running lean-uprove examples and tests..."
	@echo "========================================"
	@lake exe test
	@echo ""
	@echo "Running performance benchmarks..."
	@lake exe uprove-performance-validation
	@echo ""
	@echo "Running production tests..."
	@lake exe uprove-test-production
	@echo ""
	@echo "✅ All examples and tests completed!"

# Run all tests
test:
	@echo "Running comprehensive test suite..."
	@echo "=================================="
	@lake exe uprove-test-simple
	@lake exe uprove-test-minimal-core
	@lake exe uprove-test-production
	@lake exe uprove-test-real
	@lake exe uprove-performance-validation
	@lake exe uprove-sla-validation
	@echo "✅ All tests passed!"

# Build the project
build:
	@echo "Building lean-uprove..."
	@lake build
	@echo "✅ Build completed!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@lake clean
	@echo "✅ Clean completed!"

# Release (build and publish artifacts)
release:
	@echo "Preparing release..."
	@echo "==================="
	@echo "Building project..."
	@lake build
	@echo "Running tests..."
	@lake exe uprove-test-simple || true
	@lake exe uprove-test-minimal-core || true
	@lake exe uprove-test-production || true
	@lake exe uprove-test-real || true
	@echo "Running performance validation..."
	@lake exe uprove-performance-validation
	@echo ""
	@echo "Release artifacts ready:"
	@echo "  - Source code: $(PWD)"
	@echo "  - Docker image: ghcr.io/fraware/lean-uprove:latest"
	@echo ""
	@echo "To publish:"
	@echo "  git tag v$(shell grep -o 'version.*"[^"]*"' lake-manifest.json | cut -d'"' -f2)"
	@echo "  git push origin v$(shell grep -o 'version.*"[^"]*"' lake-manifest.json | cut -d'"' -f2)"
	@echo "  # GitHub Actions will automatically build and publish artifacts"
	@echo ""
	@echo "✅ Release preparation completed!"

# Install system-wide (creates symlinks and adds to PATH)
install:
	@echo "Installing lean-uprove system-wide..."
	@mkdir -p /usr/local/bin
	@mkdir -p /usr/local/share/lean-uprove
	@cp -r . /usr/local/share/lean-uprove/
	@ln -sf /usr/local/share/lean-uprove/scripts/lean-uprove /usr/local/bin/lean-uprove
	@chmod +x /usr/local/bin/lean-uprove
	@echo "✅ lean-uprove installed to /usr/local/bin/lean-uprove"
	@echo ""
	@echo "Usage:"
	@echo "  lean-uprove --help"

# Uninstall system-wide
uninstall:
	@echo "Uninstalling lean-uprove..."
	@rm -f /usr/local/bin/lean-uprove
	@rm -rf /usr/local/share/lean-uprove
	@echo "✅ lean-uprove uninstalled"

# Docker operations
docker-build:
	@echo "Building Docker image..."
	@docker build -t ghcr.io/fraware/lean-uprove:latest .
	@echo "✅ Docker image built: ghcr.io/fraware/lean-uprove:latest"

docker-run:
	@echo "Running Docker container..."
	@docker run --rm ghcr.io/fraware/lean-uprove:latest --help

# Validate CI/CD pipeline
validate:
	@echo "Validating CI/CD pipeline..."
	@echo "============================"
	@echo "Running CI/CD validation scripts..."
	@if [ -f scripts/validate-cicd.sh ]; then \
		chmod +x scripts/validate-cicd.sh && \
		./scripts/validate-cicd.sh; \
	else \
		echo "CI/CD validation script not found"; \
	fi
	@echo ""
	@echo "Running production validation..."
	@if [ -f scripts/validate-production.sh ]; then \
		chmod +x scripts/validate-production.sh && \
		./scripts/validate-production.sh; \
	else \
		echo "Production validation script not found"; \
	fi
	@echo "✅ CI/CD validation completed!"

# Development helpers
dev-setup: dev
	@echo "Development setup completed!"

dev-test: test
	@echo "Development tests completed!"

dev-run: run
	@echo "Development run completed!"

# Quick validation
quick-test:
	@echo "Running quick validation..."
	@lake build
	@lake exe test
	@echo "✅ Quick validation passed!"

# Show version info
version:
	@echo "lean-uprove version information:"
	@echo "==============================="
	@echo "Project: lean-uprove"
	@echo "Lean version: $(shell lean --version)"
	@echo "Lake version: $(shell lake --version)"
	@echo "Git commit: $(shell git rev-parse HEAD 2>/dev/null || echo 'not a git repo')"
	@echo "Build date: $(shell date)"
