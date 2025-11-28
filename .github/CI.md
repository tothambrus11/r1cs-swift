# Continuous Integration

This project uses GitHub Actions for continuous integration. The CI pipeline runs automatically on:

- Every push to the `main` branch
- Every pull request to the `main` branch
- Scheduled runs for dependency checks

## Workflows

### 1. Main CI Pipeline (`ci.yml`)
- **Builds and tests** on multiple Ubuntu versions (20.04, 22.04)
- **Swift versions** tested: 5.9, 5.10, 6.0
- **Features:**
  - Code coverage collection and reporting to Codecov
  - Release build validation
  - Swift format checking with SwiftFormat
  - Package validation and diagnostics

### 2. Linux Compatibility (`linux-compatibility.yml`)
- **Container-based testing** using official Swift Docker images
- **Cross-platform validation** to ensure Linux compatibility
- **Daily scheduled runs** to catch compatibility regressions
- **Architecture verification** for platform-specific code detection

### 3. Security and Dependencies (`security-deps.yml`)
- **Dependency security scanning**
- **Weekly scheduled runs** for dependency updates
- **Extended build matrix** with debug/release configurations
- **Performance validation** (when performance tests are available)

## Status Badges

Add these badges to your README to show CI status:

```markdown
[![CI](https://github.com/tothambrus11/r1cs-swift/actions/workflows/ci.yml/badge.svg)](https://github.com/tothambrus11/r1cs-swift/actions/workflows/ci.yml)
[![Linux](https://github.com/tothambrus11/r1cs-swift/actions/workflows/linux-compatibility.yml/badge.svg)](https://github.com/tothambrus11/r1cs-swift/actions/workflows/linux-compatibility.yml)
```

## Development Guidelines

### Before Submitting a PR:
1. Ensure your code builds locally: `swift build`
2. Run tests locally: `swift test`
3. Check formatting (if SwiftFormat is available): `swiftformat --lint Sources/ Tests/`

### CI Requirements:
- All tests must pass on all supported Swift versions
- Code must build successfully on both Ubuntu 20.04 and 22.04
- No platform-specific code without proper guards
- Package validation must succeed

## Local Development Setup

To replicate the CI environment locally:

```bash
# Build the package
swift build

# Run tests
swift test

# Run tests with coverage (requires additional setup)
swift test --enable-code-coverage

# Build release version
swift build -c release
```

## Troubleshooting

### Common CI Issues:

1. **Test failures on Linux but not macOS**: Usually Foundation/platform differences
2. **Build failures with newer Swift**: Check Swift version compatibility in Package.swift
3. **Dependency resolution issues**: Update Package.resolved or add explicit version constraints

### Getting Help:
- Check the Actions tab for detailed error logs
- Review the workflow files in `.github/workflows/`
- Ensure your local Swift version matches the CI versions being tested