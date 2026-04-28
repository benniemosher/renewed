import SwiftUI

extension TrackerCardView {
  enum CardStyle {
    case compact
    case large
    case square
  }
}

struct TrackerCardView: View {
  @Environment(\.colorScheme) private var colorScheme
  let tracker: Tracker
  var style: CardStyle = .compact
  private let dateService: DateCalculationService = DefaultDateCalculationService()

  @ScaledMetric(relativeTo: .largeTitle) private var dayCountSize: CGFloat = 48
  @ScaledMetric(relativeTo: .largeTitle) private var largeDayCountSize: CGFloat = 64
  @ScaledMetric(relativeTo: .title) private var squareDayCountSize: CGFloat = 36

  private var dayCount: Int {
    dateService.daysSince(tracker.startDate)
  }

  private var nextMilestone: Milestone? {
    dateService.nextMilestone(from: tracker.startDate)
  }

  private var milestoneProgress: Double {
    guard let milestone = nextMilestone else { return 1.0 }
    guard milestone.days > 0 else { return 1.0 }
    return min(Double(dayCount) / Double(milestone.days), 1.0)
  }

  private var trackerColor: Color {
    switch tracker.color {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "blue": return .blue
    case "purple": return .purple
    case "pink": return .pink
    case "mint": return .mint
    case "teal": return .teal
    case "indigo": return .indigo
    default: return .accentColor
    }
  }

  private var categoryText: String {
    switch tracker.category {
    case .sobriety: return "sobriety"
    case .freedom: return "freedom"
    case .salvation: return "salvation"
    case .custom: return "progress"
    }
  }

  private var dayLabel: String {
    dayCount == 1 ? "day" : "days"
  }

  private var formattedStartDate: String {
    tracker.startDate.formatted(date: .long, time: .omitted)
  }

  var body: some View {
    Group {
      switch style {
      case .compact:
        compactBody
      case .large:
        largeBody
      case .square:
        squareBody
      }
    }
    .background(Color(.secondarySystemBackground))
    .cornerRadius(12)
    .shadow(
      color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.1),
      radius: 4, x: 0, y: 2
    )
    .accessibilityElement(children: .combine)
    .accessibilityLabel(
      "\(tracker.title), \(dayCount) \(dayLabel) of \(categoryText)"
    )
  }

  // MARK: - Compact

  private var compactBody: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: tracker.iconName)
          .font(.title2)
          .foregroundColor(trackerColor)

        Text(tracker.title)
          .font(.headline)

        Spacer()
      }

      HStack(alignment: .firstTextBaseline) {
        Text("\(dayCount)")
          .font(.system(size: dayCountSize, weight: .bold, design: .rounded))
          .foregroundColor(trackerColor)

        Text(dayLabel)
          .font(.title3)
          .foregroundColor(.secondary)
      }

      Text("Celebrating \(dayCount) \(dayLabel) of \(categoryText)")
        .font(.subheadline)
        .foregroundColor(.secondary)

      if let milestone = nextMilestone {
        VStack(alignment: .leading, spacing: 4) {
          ProgressView(value: milestoneProgress)
            .tint(trackerColor)

          Text("Next: \(milestone.label)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding()
  }

  // MARK: - Large

  private var largeBody: some View {
    VStack(spacing: 16) {
      Image(systemName: tracker.iconName)
        .font(.largeTitle)
        .foregroundColor(trackerColor)

      Text(tracker.title)
        .font(.title2.bold())
        .multilineTextAlignment(.center)

      HStack(alignment: .firstTextBaseline, spacing: 4) {
        Text("\(dayCount)")
          .font(.system(size: largeDayCountSize, weight: .bold, design: .rounded))
          .foregroundColor(trackerColor)

        Text(dayLabel)
          .font(.title2)
          .foregroundColor(.secondary)
      }

      Text("Celebrating \(dayCount) \(dayLabel) of \(categoryText)")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)

      Text("Since \(formattedStartDate)")
        .font(.caption)
        .foregroundColor(.secondary)

      if let milestone = nextMilestone {
        VStack(spacing: 6) {
          ProgressView(value: milestoneProgress)
            .tint(trackerColor)

          Text("Next milestone: \(milestone.label)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
  }

  // MARK: - Square

  private var squareBody: some View {
    VStack(spacing: 8) {
      Image(systemName: tracker.iconName)
        .font(.title2)
        .foregroundColor(trackerColor)

      Text("\(dayCount)")
        .font(.system(size: squareDayCountSize, weight: .bold, design: .rounded))
        .foregroundColor(trackerColor)
        .minimumScaleFactor(0.5)

      Text(dayLabel)
        .font(.caption)
        .foregroundColor(.secondary)

      Text(tracker.title)
        .font(.caption2.bold())
        .lineLimit(1)
        .minimumScaleFactor(0.7)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

// MARK: - Previews

#Preview("Compact") {
  let tracker = try! Tracker(
    title: "Alcohol Free",
    startDate: Calendar.current.date(byAdding: .day, value: -42, to: Date())!,
    category: .sobriety,
    iconName: "drop.fill",
    color: "blue"
  )
  TrackerCardView(tracker: tracker, style: .compact)
    .padding()
}

#Preview("Large") {
  let tracker = try! Tracker(
    title: "Alcohol Free",
    startDate: Calendar.current.date(byAdding: .day, value: -42, to: Date())!,
    category: .sobriety,
    iconName: "drop.fill",
    color: "blue"
  )
  TrackerCardView(tracker: tracker, style: .large)
    .padding()
}

#Preview("Square") {
  let tracker = try! Tracker(
    title: "Alcohol Free",
    startDate: Calendar.current.date(byAdding: .day, value: -42, to: Date())!,
    category: .sobriety,
    iconName: "drop.fill",
    color: "blue"
  )
  TrackerCardView(tracker: tracker, style: .square)
    .frame(width: 155, height: 155)
    .padding()
}

#Preview("Dynamic Type - Large Accessibility") {
  let tracker = try! Tracker(
    title: "Smoke Free",
    startDate: Calendar.current.date(byAdding: .day, value: -100, to: Date())!,
    category: .freedom,
    iconName: "wind",
    color: "green"
  )
  VStack(spacing: 20) {
    TrackerCardView(tracker: tracker, style: .compact)
    TrackerCardView(tracker: tracker, style: .large)
    TrackerCardView(tracker: tracker, style: .square)
      .frame(width: 200, height: 200)
  }
  .padding()
  .environment(\.dynamicTypeSize, .accessibility3)
}
