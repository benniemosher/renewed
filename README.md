# Renewed

[![CI](https://github.com/Mosher-Labs/renewed/actions/workflows/ci.yml/badge.svg)](https://github.com/Mosher-Labs/renewed/actions/workflows/ci.yml)
[![Pre-Commit](https://github.com/Mosher-Labs/renewed/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Mosher-Labs/renewed/actions/workflows/pre-commit.yml)

A Christ-centered recovery tracking app. Celebrate freedom, not shame.

## Prerequisites

- **Xcode** 15+ with iOS 16+ SDK
- **Homebrew** for package management
- **go-task** - Task runner (`brew install go-task`)
- **xcodegen** - Project generation (`brew install xcodegen`)
- **swift-format** - Swift formatting (`brew install swift-format`)
- **pre-commit** - Git hooks (`brew install pre-commit`)

## Quick Start

```bash
# 1. Bootstrap development environment
task bootstrap

# 2. Build the project
task build

# 3. Run tests
task test

# 4. Run full CI check
task ci
```

## Development

See [AGENT.md](AGENT.md) for AI developer guidelines and [docs/RUNBOOK.md](docs/RUNBOOK.md) for operational procedures.

## License

[MIT](LICENSE)
