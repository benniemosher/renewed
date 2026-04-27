import SwiftUI

struct TrackerCardView: View {
  let tracker: Tracker
  private let dateService: DateCalculationService = DefaultDateCalculationService()

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

  var body: some View {
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
          .font(.system(size: 48, weight: .bold, design: .rounded))
          .foregroundColor(trackerColor)

        Text(dayCount == 1 ? "day" : "days")
          .font(.title3)
          .foregroundColor(.secondary)
      }

      Text("Celebrating \(dayCount) \(dayCount == 1 ? "day" : "days") of \(categoryText)")
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
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(
      "\(tracker.title), \(dayCount) \(dayCount == 1 ? "day" : "days") of \(categoryText)"
    )
  }
}
