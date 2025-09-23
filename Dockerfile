# lean-uprove Dockerfile
# Multi-stage build for optimal image size

# Build stage
FROM leanprover/lean4:v4.12.0 AS builder

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build
RUN lake update && lake build

# Production stage
FROM leanprover/lean4:v4.12.0 AS production

# Set working directory
WORKDIR /app

# Copy built artifacts from builder stage
COPY --from=builder /app/build /app/build
COPY --from=builder /app/lake-packages /app/lake-packages
COPY --from=builder /app/lakefile.lean /app/lakefile.lean
COPY --from=builder /app/lake-manifest.json /app/lake-manifest.json
COPY --from=builder /app/lean-toolchain /app/lean-toolchain
COPY --from=builder /app/Uprove /app/Uprove
COPY --from=builder /app/examples /app/examples
COPY --from=builder /app/Test.lean /app/Test.lean
COPY --from=builder /app/Benchmark.lean /app/Benchmark.lean
COPY --from=builder /app/README.md /app/README.md
COPY --from=builder /app/LICENSE /app/LICENSE

# Create entrypoint script
RUN echo '#!/bin/bash\n\
    set -e\n\
    \n\
    case "$1" in\n\
    --help|-h)\n\
    echo "lean-uprove - Lean 4 tactic for universal properties"\n\
    echo ""\n\
    echo "Usage: lean-uprove [COMMAND] [OPTIONS]"\n\
    echo ""\n\
    echo "Commands:"\n\
    echo "  --help, -h     Show this help message"\n\
    echo "  --version, -v  Show version information"\n\
    echo "  test           Run test suite"\n\
    echo "  benchmark      Run performance benchmarks"\n\
    echo "  examples       Run examples"\n\
    echo "  validate       Validate installation"\n\
    echo ""\n\
    echo "Examples:"\n\
    echo "  lean-uprove test\n\
    echo "  lean-uprove benchmark\n\
    echo "  lean-uprove examples"\n\
    echo ""\n\
    echo "For more information, visit: https://github.com/fraware/lean-uprove"\n\
    exit 0\n\
    ;;\n\
    --version|-v)\n\
    echo "lean-uprove version 0.1.0"\n\
    echo "Lean 4 version: $(lean --version)"\n\
    echo "Lake version: $(lake --version)"\n\
    exit 0\n\
    ;;\n\
    test)\n\
    echo "Running lean-uprove test suite..."\n\
    lake exe test\n\
    lake exe uprove-test-simple\n\
    lake exe uprove-test-production\n\
    echo "✅ All tests passed!"\n\
    exit 0\n\
    ;;\n\
    benchmark)\n\
    echo "Running lean-uprove performance benchmarks..."\n\
    lake exe uprove-performance-validation\n\
    echo "✅ Benchmarks completed!"\n\
    exit 0\n\
    ;;\n\
    examples)\n\
    echo "Running lean-uprove examples..."\n\
    lake exe test\n\
    echo "✅ Examples completed!"\n\
    exit 0\n\
    ;;\n\
    validate)\n\
    echo "Validating lean-uprove installation..."\n\
    lake build\n\
    lake exe test\n\
    echo "✅ Installation validated!"\n\
    exit 0\n\
    ;;\n\
    "")\n\
    echo "lean-uprove - Lean 4 tactic for universal properties"\n\
    echo "Run '\''lean-uprove --help'\'' for usage information"\n\
    exit 0\n\
    ;;\n\
    *)\n\
    echo "Unknown command: $1"\n\
    echo "Run '\''lean-uprove --help'\'' for usage information"\n\
    exit 1\n\
    ;;\n\
    esac' > /usr/local/bin/lean-uprove

RUN chmod +x /usr/local/bin/lean-uprove

# Set entrypoint
ENTRYPOINT ["lean-uprove"]

# Default command
CMD ["--help"]

# Metadata
LABEL org.opencontainers.image.title="lean-uprove"
LABEL org.opencontainers.image.description="A Lean 4 tactic for automating proofs involving universal properties in category theory"
LABEL org.opencontainers.image.version="0.1.0"
LABEL org.opencontainers.image.authors="fraware"
LABEL org.opencontainers.image.url="https://github.com/fraware/lean-uprove"
LABEL org.opencontainers.image.source="https://github.com/fraware/lean-uprove"
LABEL org.opencontainers.image.licenses="MIT"
