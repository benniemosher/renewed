#!/bin/bash
# Create all sprint tickets in GitHub Issues
# Usage: ./scripts/create-issues.sh
# Requires: gh CLI installed and authenticated

set -e

REPO="benniemosher/renewed"
MILESTONE="Sprint 1: Foundation"

echo "Creating GitHub Issues for Renewed sprint..."
echo "Target repo: $REPO"
echo ""

# Helper function
create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"

  # Check if issue already exists
  if gh issue list --repo "$REPO" --search "$title" --json title | grep -q "$title" 2>/dev/null; then
    echo "⚠️  Issue exists: $title"
    return
  fi

  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$MILESTONE" 2>/dev/null && echo "✅ Created: $title" || echo "❌ Failed: $title"
}

# Create milestone first
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/$REPO/milestones \
  -f title="Sprint 1: Foundation" \
  -f state="open" \
  -f description="Week 1: Repository setup, data layer, UI foundation, widgets, and distribution prep" 2>/dev/null || echo "Milestone may already exist"

echo "Creating issues..."
echo ""

# === EPIC 1: FOUNDATION ===

create_issue "TICKET-001: Initialize Repository" "## Epic: Foundation

### Description
Set up the GitHub repository with proper structure and documentation.

### Acceptance Criteria
- [ ] Create README.md with project overview
- [ ] Add LICENSE (MIT)
- [ ] Create .gitignore for Swift/Xcode
- [ ] Set up branch protection rules on main
- [ ] Create GitHub milestone 'Sprint 1: Foundation'

### Technical Notes
- Use GitHub web UI for branch protection
- MIT license is standard for open source iOS apps

### Definition of Done
- Repository is cloneable
- Main branch requires PR reviews
- All docs in place" "epic-foundation,ready"

create_issue "TICKET-002: Xcode Project Scaffold" "## Epic: Foundation
**Depends on:** TICKET-001

### Description
Create the initial Xcode project structure for Renewed app.

### Acceptance Criteria
- [ ] Create iOS app project (iOS 16+, SwiftUI)
- [ ] Create Widget Extension target
- [ ] Create App Group: group.com.benniemosher.renewed
- [ ] Set up basic folder structure:
  - Sources/
  - Tests/
  - Widget/

### Technical Notes
- Target iOS 16 for SwiftData availability
- Enable CloudKit capability
- Product bundle ID: com.benniemosher.renewed

### Definition of Done
- Project builds without errors
- Targets: Renewed, RenewedWidget
- App Group entitlements configured" "epic-foundation,blocked"

create_issue "TICKET-003: Taskfile and pre-commit Setup" "## Epic: Foundation
**Depends on:** TICKET-001

### Description
Set up Taskfile and pre-commit hooks for consistent development workflow.

### Acceptance Criteria
- [ ] Create Taskfile.yml with common commands
- [ ] Create .pre-commit-config.yaml
- [ ] Install pre-commit hooks locally
- [ ] Add scripts/ directory for automation
- [ ] Create scripts/create-issues.sh (this file)

### Taskfile Commands
- task bootstrap
- task test
- task lint
- task build
- task ci

### Pre-commit Hooks
- trailing-whitespace
- end-of-file-fixer
- check-yaml
- detect-private-key
- swift-format (if available)
- run tests

### Definition of Done
- task --list shows all commands
- pre-commit install succeeds
- Hooks run on commit
- All files committed" "epic-foundation,blocked"

create_issue "TICKET-004: Documentation Structure" "## Epic: Foundation
**Depends on:** TICKET-001

### Description
Create comprehensive documentation for AI agents and human developers.

### Acceptance Criteria
- [ ] Create AGENT.md (AI developer guide)
- [ ] Create docs/ARCHITECTURE.md
- [ ] Create docs/RUNBOOK.md
- [ ] Create docs/STATUS.md
- [ ] Create .github/PULL_REQUEST_TEMPLATE.md
- [ ] Create CHANGELOG.md

### AGENT.md Contents
- Quick start for agents
- Project philosophy
- Development commands
- Ticket workflow
- Tone guide for UI
- Definition of done

### Definition of Done
- All docs committed
- Links between docs work
- AGENT.md under 200 lines" "epic-foundation,blocked"

create_issue "TICKET-005: GitHub Actions CI Pipeline" "## Epic: Foundation
**Depends on:** TICKET-002, TICKET-003

### Description
Set up CI pipeline that builds and tests on every PR.

### Acceptance Criteria
- [ ] Create .github/workflows/ci.yml
- [ ] Build app on macOS runner
- [ ] Run tests on iOS Simulator
- [ ] Run pre-commit hooks
- [ ] Block PR merge on failure

### CI Steps
1. Checkout code
2. Cache Swift packages
3. Run pre-commit
4. Build project
5. Run tests
6. Post results

### Definition of Done
- CI runs on PR creation
- Failing tests block merge
- Status badge in README

### Notes
GitHub Actions macOS runners are free for public repos (2000 min/month)." "epic-foundation,blocked"

# === EPIC 2: DATA LAYER ===

create_issue "TICKET-006: Tracker Data Model" "## Epic: Data Layer
**Depends on:** TICKET-002

### Description
Define the core data model for recovery trackers using SwiftData.

### Model: Tracker
\`\`\`swift
@Model
class Tracker {
    var id: UUID
    var title: String
    var startDate: Date
    var category: TrackerCategory
    var iconName: String // SF Symbol
    var color: String // semantic color name
    var createdAt: Date
    var updatedAt: Date
}

enum TrackerCategory: String, CaseIterable {
    case sobriety
    case freedom // porn, etc.
    case salvation
    case custom
}
\`\`\`

### Acceptance Criteria
- [ ] Create Tracker model
- [ ] Create TrackerCategory enum
- [ ] Add SwiftData @Model macro
- [ ] Add validation (title non-empty, date valid)

### Definition of Done
- Model compiles
- Unit tests verify creation
- Follows SwiftData patterns" "epic-data,blocked"

create_issue "TICKET-007: Unit Tests for Data Model" "## Epic: Data Layer
**Depends on:** TICKET-006

### Description
Write comprehensive unit tests for Tracker model.

### Test Cases
- [ ] testTrackerCreationStoresAllProperties()
- [ ] testTrackerCategoryRawValues()
- [ ] testTrackerValidationRejectsEmptyTitle()
- [ ] testDaysSinceCalculation()

### Acceptance Criteria
- All tests fail before implementation (TDD)
- All tests pass after implementation
- Tests cover edge cases (leap year, timezone)

### Definition of Done
- Tests committed before model
- 100% coverage on model logic
- CI passes" "epic-data,blocked"

create_issue "TICKET-008: Tracker Repository" "## Epic: Data Layer
**Depends on:** TICKET-006

### Description
Create repository pattern for tracker CRUD operations.

### Repository Protocol
\`\`\`swift
protocol TrackerRepository {
    func fetchAll() async throws -> [Tracker]
    func create(_ tracker: Tracker) async throws
    func update(_ tracker: Tracker) async throws
    func delete(_ tracker: Tracker) async throws
    func fetch(byId: UUID) async throws -> Tracker?
}
\`\`\`

### SwiftData Implementation
\`\`\`swift
class SwiftDataTrackerRepository: TrackerRepository {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    // ...
}
\`\`\`

### Acceptance Criteria
- [ ] Define TrackerRepository protocol
- [ ] Implement SwiftDataTrackerRepository
- [ ] Add error handling with custom errors
- [ ] Support iCloud sync via CloudKit

### Definition of Done
- Repository has tests
- CRUD operations work
- Errors are descriptive" "epic-data,blocked"

create_issue "TICKET-009: Date Calculation Service" "## Epic: Data Layer
**Depends on:** TICKET-006

### Description
Service for calculating days since/between dates with edge cases.

### Functions
\`\`\`swift
protocol DateCalculationService {
    func daysSince(_ date: Date) -> Int
    func daysUntil(_ date: Date) -> Int
    func formattedDuration(from: Date, to: Date) -> String
    func nextMilestone(from: Date) -> Milestone
}

struct Milestone {
    let days: Int
    let description: String // e.g., \"1 week\", \"1 year\"
}
\`\`\`

### Test Cases
- [ ] Leap years handled correctly
- [ ] Timezone boundaries
- [ ] Daylight saving time
- [ ] Milestones: 7, 30, 90, 180, 365, 730 days

### Definition of Done
- Service is pure (no side effects)
- All edge cases tested
- Milestones configurable" "epic-data,blocked"

# === EPIC 3: UI LAYER ===

create_issue "TICKET-010: Main App Structure" "## Epic: UI Layer
**Depends on:** TICKET-002

### Description
Set up the main app navigation and tab structure.

### Structure
\`\`\`
RenewedApp
├── App Entry (RenewedApp.swift)
├── Main TabView
│   ├── Trackers Tab (list)
│   ├── Add Button (center)
│   └── Settings Tab
└── ViewModels
    └── TrackersViewModel
\`\`\`

### Acceptance Criteria
- [ ] Create RenewedApp.swift with SwiftData setup
- [ ] Create MainTabView with tabs
- [ ] Create TrackersView (list placeholder)
- [ ] Create SettingsView (placeholder)
- [ ] Set up dependency injection

### Definition of Done
- App launches without crash
- Tabs switch correctly
- SwiftData container injected" "epic-ui,blocked"

create_issue "TICKET-011: Tracker List View" "## Epic: UI Layer
**Depends on:** TICKET-008, TICKET-010

### Description
Main screen showing all trackers with days counted.

### Design
- List of cards, each showing:
  - Icon (SF Symbol)
  - Title
  - Days count (large, prominent)
  - \"days of freedom\" subtitle
  - Progress to next milestone

### Interactions
- Tap to edit
- Swipe to delete
- Empty state when no trackers

### Tone
- \"Celebrating [X] days of [category]\"
- Empty state: \"Your journey begins with the first step\"

### Definition of Done
- Lists all trackers
- Updates when data changes
- Empty state implemented
- VoiceOver labels correct" "epic-ui,blocked"

create_issue "TICKET-012: Add/Edit Tracker View" "## Epic: UI Layer
**Depends on:** TICKET-011

### Description
Form for creating and editing trackers.

### Fields
- Title (text)
- Start Date (date picker)
- Category (picker)
- Icon (SF Symbol picker)

### Validation
- Title required
- Date cannot be in future
- Show error messages inline

### Tone
- \"What are you celebrating?\"
- \"When did your journey begin?\"

### Definition of Done
- Creates new tracker
- Edits existing tracker
- Validates input
- Saves to repository" "epic-ui,blocked"

create_issue "TICKET-013: Tracker Card Component" "## Epic: UI Layer
**Depends on:** TICKET-011

### Description
Reusable card component for displaying a tracker.

### Visual
\`\`\`
┌─────────────────────────────┐
│ [🕊️]  42                    │
│        days of freedom        │
│        ────────────          │
│        Sobriety              │
└─────────────────────────────┘
\`\`\`

### Features
- Large day count (42)
- Category-specific icon
- Progress bar to next milestone
- Semantic colors (respect dark mode)

### Variants
- Compact (for lists)
- Large (for detail view)
- Square (for widgets)

### Definition of Done
- Component in isolation
- Preview provider with variants
- Dynamic Type support" "epic-ui,blocked"

create_issue "TICKET-014: Empty State View" "## Epic: UI Layer
**Depends on:** TICKET-011

### Description
Encouraging empty state when no trackers exist.

### Content
- Icon: Large heart or dove SF Symbol
- Title: \"Begin Your Journey\"
- Subtitle: \"Track your days of freedom, hope, and renewal\"
- Button: \"Create Your First Tracker\"

### Tone
- Hopeful, inviting
- No guilt or shame
- Celebratory anticipation

### Definition of Done
- Shows when list is empty
- Button navigates to add form
- Tests for state visibility" "epic-ui,blocked"

create_issue "TICKET-015: App Icon and Launch Screen" "## Epic: UI Layer
**Depends on:** TICKET-010

### Description
Create app icon and launch screen with Christian/recovery theme.

### Icon Concept
- Simple, recognizable at small sizes
- Dove, cross, or flame motif
- Works on light and dark backgrounds

### Sizes
- iOS: 1024pt (App Store), 60pt, 40pt, etc.
- Settings: 29pt
- Spotlight: 40pt
- Notifications: 20pt

### Launch Screen
- Logo centered
- \"Renewed\" text
- Clean, minimal

### Definition of Done
- All icon sizes exported
- Launch screen displays
- No warnings in Xcode" "epic-ui,blocked"

# === EPIC 4: WIDGET EXTENSION ===

create_issue "TICKET-016: Widget Extension Setup" "## Epic: Widgets
**Depends on:** TICKET-002

### Description
Set up the WidgetKit extension target.

### Acceptance Criteria
- [ ] Create Widget Extension target
- [ ] Configure App Group sharing
- [ ] Create widget bundle
- [ ] Add widget to test scheme

### Structure
\`\`\`
RenewedWidget/
├── RenewedWidgetBundle.swift
├── RenewedWidget.swift
├── Provider.swift
└── Views/
    ├── SmallWidgetView.swift
    ├── MediumWidgetView.swift
    └── LockScreenWidgetView.swift
\`\`\`

### Definition of Done
- Widget target builds
- Shows in widget gallery
- Can be added to home screen" "epic-widgets,blocked"

create_issue "TICKET-017: Widget Timeline Provider" "## Epic: Widgets
**Depends on:** TICKET-016, TICKET-008

### Description
Timeline provider that refreshes at midnight.

### Implementation
\`\`\`swift
struct Provider: TimelineProvider {
    func timeline(for configuration: ConfigurationIntent,
                  context: Context,
                  completion: @escaping (Timeline<Entry>) -> Void) {
        // Refresh at next midnight
        let nextMidnight = Calendar.current.nextDate(...)
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}
\`\`\`

### Acceptance Criteria
- [ ] Reads trackers from App Group
- [ ] Refreshes at midnight
- [ ] Handles no trackers gracefully
- [ ] Timeline entries for next 7 days

### Definition of Done
- Days increment at midnight
- Battery efficient
- Tests for timeline calculation" "epic-widgets,blocked"

create_issue "TICKET-018: Small Widget (Single Tracker)" "## Epic: Widgets
**Depends on:** TICKET-017

### Description
Small widget showing one tracker.

### Size
- 1 tracker
- Large day count
- Category icon
- \"days\" label

### Configuration
- Intent to select which tracker
- Defaults to first tracker if none selected

### Definition of Done
- Displays correct day count
- Configurable tracker selection
- Respects dark mode" "epic-widgets,blocked"

create_issue "TICKET-019: Medium Widget (Multiple Trackers)" "## Epic: Widgets
**Depends on:** TICKET-017

### Description
Medium widget showing up to 2 trackers side by side.

### Layout
\`\`\`
┌─────────────────────────────┐
│ [icon] 42    │ [icon] 365   │
│ days         │ days         │
│ Sobriety     │ Salvation    │
└─────────────────────────────┘
\`\`\`

### Configuration
- Intent to select which trackers
- Show \"+3 more\" if >2 trackers exist

### Definition of Done
- Fits medium widget size
- Side-by-side layout
- Handles 1 or 2 trackers" "epic-widgets,blocked"

create_issue "TICKET-020: Large Widget" "## Epic: Widgets
**Depends on:** TICKET-017

### Description
Large widget showing up to 4 trackers in a grid.

### Layout
2x2 grid of compact tracker cards

### Definition of Done
- Grid layout
- Up to 4 trackers
- Scroll indicator if more exist" "epic-widgets,blocked"

create_issue "TICKET-021: Lock Screen Widgets" "## Epic: Widgets
**Depends on:** TICKET-017

### Description
Rectangular lock screen widgets (no circles).

### Variants
- Inline (text only): \"🔥 42 days\"
- Rectangular: Small card with icon and count

### Styling
- Uses widgetAccentable() for tint
- System font sizes
- Clear in all wallpaper colors

### Definition of Done
- Inline accessory works
- Rectangular looks good
- Respects lock screen tint" "epic-widgets,blocked"

# === EPIC 5: POLISH ===

create_issue "TICKET-022: Dark Mode Support" "## Epic: Polish
**Depends on:** TICKET-011

### Description
Ensure app looks great in dark mode.

### Checklist
- [ ] All colors use semantic names
- [ ] Test in Simulator dark mode
- [ ] Widgets adapt to dark mode
- [ ] Status bar visible

### Definition of Done
- No hardcoded white/black
- Looks intentional in dark mode" "epic-polish,blocked"

create_issue "TICKET-023: Accessibility Audit" "## Epic: Polish
**Depends on:** TICKET-011

### Description
Full VoiceOver and accessibility pass.

### Checklist
- [ ] VoiceOver reads all elements
- [ ] Dynamic Type support
- [ ] Reduce Motion respected
- [ ] Sufficient color contrast
- [ ] Accessibility labels on icons

### Testing
- Run with VoiceOver enabled
- Test largest font sizes
- Enable Reduce Motion

### Definition of Done
- All VoiceOver tests pass
- No accessibility warnings" "epic-polish,blocked"

create_issue "TICKET-024: iCloud Sync Verification" "## Epic: Polish
**Depends on:** TICKET-008

### Description
Verify CloudKit sync works across devices.

### Test Scenarios
- Create tracker on iPhone → appears on Mac
- Edit on Mac → updates on iPhone
- Delete on one device → gone on other
- Offline → syncs when reconnected

### Definition of Done
- Data syncs within 30 seconds
- Conflict resolution works
- No data loss" "epic-polish,blocked"

create_issue "TICKET-025: Widget Testing" "## Epic: Polish
**Depends:** All widget tickets

### Description
Test widgets in all sizes and locations.

### Test Cases
- [ ] Small on home screen
- [ ] Medium on home screen
- [ ] Large on home screen
- [ ] Inline on lock screen
- [ ] Rectangular on lock screen
- [ ] Multiple widgets of same type
- [ ] Widget refresh at midnight

### Devices to Test
- iPhone (various sizes)
- Simulator fine for most

### Definition of Done
- All widget sizes work
- No truncation
- Refresh correctly" "epic-polish,blocked"

# === EPIC 6: DISTRIBUTION PREP ===

create_issue "TICKET-026: README for Users" "## Epic: Distribution
**Depends:** All implementation

### Description
Write user-facing README.

### Contents
- What is Renewed?
- Who is it for?
- Features
- Privacy (no data collection)
- Open source invitation
- License

### Tone
- Welcoming to people in recovery
- Faith-friendly but inclusive
- Hopeful

### Definition of Done
- README.md in repo root
- Screenshots (can be placeholder)
- Clear value proposition" "epic-distribution,blocked"

create_issue "TICKET-027: App Store Assets" "## Epic: Distribution
**Depends:** All implementation

### Description
Prepare App Store metadata (for future submission).

### Needed
- Screenshots (5.5\", 6.5\", iPad)
- App Store description
- Keywords
- Privacy policy URL
- Support URL

### Definition of Done
- Screenshots captured
- Description written
- Privacy policy drafted" "epic-distribution,blocked"

create_issue "TICKET-028: Build Script for .ipa" "## Epic: Distribution
**Depends:** TICKET-005

### Description
Script to build .ipa for TestFlight distribution.

### Script Tasks
- Archive app
- Export .ipa
- Upload to TestFlight (future)

### Definition of Done
- ./scripts/build-ipa.sh runs successfully
- Outputs Renewed.ipa
- Works in CI" "epic-distribution,blocked"

create_issue "TICKET-029: Integration Testing" "## Epic: Distribution
**Depends:** All implementation

### Description
End-to-end tests for critical user flows.

### Flows
- Create tracker → see in list → see in widget
- Edit tracker → updates everywhere
- Delete tracker → gone from widgets
- Day rolls over → count increments

### Definition of Done
- Tests run in CI
- Cover all critical paths
- Documented in TESTING.md" "epic-distribution,blocked"

create_issue "TICKET-030: Sprint Review and Tag" "## Epic: Distribution
**Depends:** All tickets

### Description
Final review and version tag.

### Checklist
- [ ] All tests passing
- [ ] README complete
- [ ] CHANGELOG updated
- [ ] Version bump
- [ ] Git tag v0.1.0
- [ ] Celebrate!

### Definition of Done
- Repo is ready to share
- Anyone can clone and run
- Tagged release exists" "epic-distribution,blocked"

echo ""
echo "========================================"
echo "All tickets created!"
echo "========================================"
echo ""
echo "View them at: https://github.com/$REPO/issues"
echo ""
echo "Next steps:"
echo "1. Go to GitHub and add the labels:"
echo "   - epic-foundation, epic-data, epic-ui, epic-widgets, epic-polish, epic-distribution"
echo "   - ready, blocked, in-progress"
echo "2. TICKET-001 is ready to start"
echo "3. Update dependencies (remove 'blocked' label) as tickets complete"
