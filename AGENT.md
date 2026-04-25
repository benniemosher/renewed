# AGENT.md - AI Developer Guide for Renewed

> **Mission:** Build a Christ-centered recovery tracking app. Celebrate freedom, not shame.
> **Constraint:** Use minimal tokens. Be concise. Reference, don't repeat.

## Quick Start

1. Read `docs/ARCHITECTURE.md` for system overview
2. Read `docs/RUNBOOK.md` for procedures
3. Check GitHub Project for current sprint status
4. Run `task --list` to see available commands

## Core Principles

### Token Efficiency
- **Keep files small** (<200 lines). Split if growing larger.
- **Reference, don't repeat.** Link to existing docs instead of copying.
- **Use standard patterns.** Don't document what Swift/Xcode already does.
- **Ask if unclear.** Better than guessing and burning tokens.

### Documentation Standards
- **Mermaid** for all diagrams (flowcharts, sequence, class diagrams)
- **Markdown** for all docs (no Word/PDF)
- **Links** between docs (no copy-paste content)

### Theology Matters
- Recovery is **grace**, not perfection
- Celebrate **progress**, not just milestones
- Language is **hope-filled**, never shame-based
- Users are **beloved**, not "addicts"

### Code Values
- **TDD:** Tests before implementation
- **Local-first:** Pre-commit hooks catch errors before CI
- **Swift idioms:** Native SwiftUI, avoid clever hacks
- **Accessible:** VoiceOver, Dynamic Type

## Ticket Workflow

1. **Claim:** Comment on issue with "🤖 Taking this"
2. **Branch:** `feature-XXX-short-desc` (kebab-case, no slashes)
3. **TDD:** Red test → Green test → Commit
4. **Commit:** `type: #XXX: Description` (e.g., `feat: #3: Add Taskfile`)
5. **PR:** Title matches commit format, body links with `Closes #XXX`

## Dev Commands

```bash
task bootstrap   # First-time setup
task test        # Run unit tests
task lint        # Run pre-commit
task build       # Build app
task ci          # Full CI check
```

## Architecture

- **MVVM** for SwiftUI views
- **SwiftData** for persistence (CloudKit sync)
- **WidgetKit** for widgets (separate extension)
- **App Groups** for widget data sharing

## Tone Guide for UI Copy

| ✅ Use | ❌ Avoid |
|--------|----------|
| "Days of freedom" | "Clean streak" |
| "Your journey" | "Your problem" |
| "Renewed in hope" | "Finally fixed" |
| "Celebrating [X] days" | "Addicted for X years" |

## When Stuck

1. Check `docs/ARCHITECTURE.md`
2. Check `docs/RUNBOOK.md`
3. Ask in PR with specific question
4. Never commit code you don't understand

## Links

- [Architecture](docs/ARCHITECTURE.md) - System design
- [Runbook](docs/RUNBOOK.md) - Procedures
- [Status](docs/STATUS.md) - Project status
- [Changelog](CHANGELOG.md) - Release history
- [GitHub Project](https://github.com/users/benniemosher/projects/2) - Sprint board
- [Issues](https://github.com/Mosher-Labs/renewed/issues) - Tickets

---
**Reminder:** Be concise. Save tokens. Build with purpose.
