# Contributing to lean-uprove

Thank you for your interest in contributing to `lean-uprove`! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/lean-uprove.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Install dependencies: `lake update && lake build`

## Development Setup

### Prerequisites

- Lean 4.12.0 or later
- Lake package manager
- Git

### Building

```bash
lake build
```

### Running Tests

```bash
lake test
lake exe uprove-test
```

### Running Benchmarks

```bash
lake exe uprove-benchmark
```

### Building Documentation

```bash
lake build docs
```

## Contribution Guidelines

### Code Style

- Follow Lean 4 style guidelines
- Use meaningful variable and function names
- Add docstrings for public functions
- Keep functions focused and small
- Use type annotations where helpful

### Testing Requirements

**All contributions must include tests:**

1. **Golden Tests**: Add tests to `Test.lean` for new patterns or functionality
2. **Performance Tests**: Add benchmarks to `Benchmark.lean` for performance-critical changes
3. **Nondeterminism Tests**: Ensure tests are deterministic and don't flake

### Performance Requirements

**Performance-critical changes must meet SLAs:**

- P50 ≤ 150ms per `uprove` call
- P95 ≤ 800ms per `uprove` call
- Memory ≤ 256MB per process
- No regression > 10% from baseline

### Documentation Requirements

**All user-facing changes must include documentation:**

1. Update relevant documentation in `docs/`
2. Add examples to `docs/Cookbook.md` if applicable
3. Update `CHANGELOG.md` with your changes
4. Ensure all public APIs are documented

## Types of Contributions

### Bug Fixes

1. Create an issue describing the bug
2. Fix the bug with appropriate tests
3. Ensure no performance regression
4. Update documentation if needed

### New Features

1. Create an issue describing the feature
2. Implement the feature with comprehensive tests
3. Add performance benchmarks
4. Update documentation
5. Add examples to cookbook

### New Universal Property Patterns

1. Add pattern to `Uprove/Patterns.lean`
2. Register with `@[uprove]` attribute
3. Add comprehensive tests
4. Add performance benchmarks
5. Add examples to cookbook
6. Update documentation

### Performance Improvements

1. Identify performance bottleneck
2. Implement improvement
3. Add benchmarks to verify improvement
4. Ensure no functionality regression
5. Update performance documentation

## Pull Request Process

### Before Submitting

1. **Run all tests**: `lake test && lake exe uprove-test`
2. **Run benchmarks**: `lake exe uprove-benchmark`
3. **Check performance**: Ensure no regression > 10%
4. **Build documentation**: `lake build docs`
5. **Check code style**: Follow Lean 4 guidelines

### PR Requirements

1. **Clear description** of what the PR does
2. **Reference to issue** if applicable
3. **Tests included** for all new functionality
4. **Performance benchmarks** for performance-critical changes
5. **Documentation updated** for user-facing changes
6. **CHANGELOG.md updated** with changes

### Review Process

1. **Automated checks** must pass (CI/CD)
2. **Code review** by maintainers
3. **Performance review** for performance-critical changes
4. **Documentation review** for user-facing changes

## Code Organization

### Core Components

- `Uprove/Core.lean`: Core types and pattern matching
- `Uprove/Tactics.lean`: Main tactic implementations
- `Uprove/Planner.lean`: Three-phase proof planner
- `Uprove/Patterns.lean`: Universal property patterns
- `Uprove/Attributes.lean`: Attribute system for registration
- `Uprove/Configuration.lean`: Configuration management
- `Uprove/Telemetry.lean`: Performance monitoring

### Testing

- `Test.lean`: Comprehensive test suite
- `Benchmark.lean`: Performance benchmarks
- `examples/`: Example usage patterns

### Documentation

- `docs/Quickstart.md`: 90-second quickstart guide
- `docs/Cookbook.md`: 20 common patterns
- `docs/Troubleshooting.md`: Common issues and solutions

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to tactic behavior or flags
- **MINOR**: New universal property patterns/lemmas or options
- **PATCH**: Performance improvements and bug fixes

### Release Checklist

1. **Update version** in `lakefile.lean`
2. **Update CHANGELOG.md** with all changes
3. **Run full test suite** and benchmarks
4. **Verify performance** meets SLAs
5. **Build documentation** and verify
6. **Create release** with proper tag
7. **Update compatibility matrix** in docs

## Support Policy

- **Last two minor versions** receive patches
- **Security fixes** for all supported versions
- **Performance fixes** for all supported versions
- **New features** only in latest version

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/fraware/lean-uprove/issues)
- **Discussions**: [GitHub Discussions](https://github.com/fraware/lean-uprove/discussions)
- **Documentation**: [Project Docs](https://fraware.github.io/lean-uprove/)

## Code of Conduct

Please be respectful and constructive in all interactions. We follow the [Lean Community Code of Conduct](https://leanprover-community.github.io/contribute/code_of_conduct.html).

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Recognition

Contributors will be recognized in:
- `CONTRIBUTORS.md` file
- Release notes
- Project documentation

Thank you for contributing to `lean-uprove`!