#!/bin/bash
# lean-uprove installation script
# Provides one-command installation and setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/usr/local/share/lean-uprove"
BIN_DIR="/usr/local/bin"
PROJECT_NAME="lean-uprove"
VERSION="0.1.0"

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

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root. This is not recommended for security reasons."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check for Lean 4
    if ! command -v lean &> /dev/null; then
        print_error "Lean 4 is not installed. Please install Lean 4 first."
        print_info "Visit: https://leanprover.github.io/lean4/doc/setup.html"
        exit 1
    fi
    
    # Check for Lake
    if ! command -v lake &> /dev/null; then
        print_error "Lake is not installed. Please install Lake first."
        print_info "Lake should be installed with Lean 4."
        exit 1
    fi
    
    # Check Lean version
    LEAN_VERSION=$(lean --version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    print_info "Found Lean 4 version: $LEAN_VERSION"
    
    # Check Lake version
    LAKE_VERSION=$(lake --version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    print_info "Found Lake version: $LAKE_VERSION"
    
    print_success "System requirements satisfied"
}

# Install dependencies
install_dependencies() {
    print_info "Installing dependencies..."
    
    # Update package lists
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git curl wget
    elif command -v yum &> /dev/null; then
        sudo yum update -y
        sudo yum install -y git curl wget
    elif command -v brew &> /dev/null; then
        brew install git curl wget
    else
        print_warning "Package manager not detected. Please ensure git, curl, and wget are installed."
    fi
    
    print_success "Dependencies installed"
}

# Download and install lean-uprove
install_uprove() {
    print_info "Installing lean-uprove..."
    
    # Create installation directory
    sudo mkdir -p "$INSTALL_DIR"
    
    # Copy project files
    sudo cp -r . "$INSTALL_DIR/"
    
    # Create executable script
    sudo tee "$INSTALL_DIR/lean-uprove" > /dev/null << 'EOF'
#!/bin/bash
# lean-uprove CLI wrapper

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

case "$1" in
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
    echo "  examples       Run examples"
    echo "  validate       Validate installation"
    echo "  build          Build the project"
    echo "  clean          Clean build artifacts"
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
    echo "lean-uprove version 0.1.0"
    echo "Lean 4 version: $(lean --version)"
    echo "Lake version: $(lake --version)"
    exit 0
    ;;
  test)
    echo "Running lean-uprove test suite..."
    cd "$PROJECT_DIR"
    lake exe test
    lake exe uprove-test-simple
    lake exe uprove-test-production
    echo "✅ All tests passed!"
    exit 0
    ;;
  benchmark)
    echo "Running lean-uprove performance benchmarks..."
    cd "$PROJECT_DIR"
    lake exe uprove-performance-validation
    echo "✅ Benchmarks completed!"
    exit 0
    ;;
  examples)
    echo "Running lean-uprove examples..."
    cd "$PROJECT_DIR"
    lake exe test
    echo "✅ Examples completed!"
    exit 0
    ;;
  validate)
    echo "Validating lean-uprove installation..."
    cd "$PROJECT_DIR"
    lake build
    lake exe test
    echo "✅ Installation validated!"
    exit 0
    ;;
  build)
    echo "Building lean-uprove..."
    cd "$PROJECT_DIR"
    lake build
    echo "✅ Build completed!"
    exit 0
    ;;
  clean)
    echo "Cleaning lean-uprove build artifacts..."
    cd "$PROJECT_DIR"
    lake clean
    echo "✅ Clean completed!"
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
EOF

    # Make executable
    sudo chmod +x "$INSTALL_DIR/lean-uprove"
    
    # Create symlink
    sudo ln -sf "$INSTALL_DIR/lean-uprove" "$BIN_DIR/lean-uprove"
    
    print_success "lean-uprove installed to $INSTALL_DIR"
}

# Build the project
build_project() {
    print_info "Building lean-uprove..."
    
    cd "$INSTALL_DIR"
    lake update
    lake build
    
    print_success "Build completed"
}

# Run validation tests
validate_installation() {
    print_info "Validating installation..."
    
    cd "$INSTALL_DIR"
    lake exe test
    
    print_success "Installation validated"
}

# Main installation function
main() {
    echo "lean-uprove Installation Script"
    echo "================================"
    echo ""
    
    check_root
    check_requirements
    install_dependencies
    install_uprove
    build_project
    validate_installation
    
    echo ""
    print_success "lean-uprove installation completed successfully!"
    echo ""
    echo "Usage:"
    echo "  lean-uprove --help     # Show help"
    echo "  lean-uprove test       # Run tests"
    echo "  lean-uprove benchmark  # Run benchmarks"
    echo "  lean-uprove examples   # Run examples"
    echo ""
    echo "For more information, visit: https://github.com/fraware/lean-uprove"
}

# Uninstall function
uninstall() {
    print_info "Uninstalling lean-uprove..."
    
    # Remove symlink
    sudo rm -f "$BIN_DIR/lean-uprove"
    
    # Remove installation directory
    sudo rm -rf "$INSTALL_DIR"
    
    print_success "lean-uprove uninstalled"
}

# Handle command line arguments
case "${1:-}" in
  --help|-h)
    echo "lean-uprove Installation Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version information"
    echo "  --uninstall   Uninstall lean-uprove"
    echo ""
    echo "Examples:"
    echo "  $0              # Install lean-uprove"
    echo "  $0 --uninstall  # Uninstall lean-uprove"
    exit 0
    ;;
  --version|-v)
    echo "lean-uprove installation script version $VERSION"
    exit 0
    ;;
  --uninstall)
    uninstall
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
