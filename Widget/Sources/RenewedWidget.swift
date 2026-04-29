import SwiftData
import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
  let date: Date
  let trackerTitle: String?
  let days: Int
  let iconName: String?
  let color: String?
}

struct RenewedWidgetEntryView: View {
  var entry: SimpleEntry

  private var themeColor: Color {
    switch entry.color {
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
    default: return .green
    }
  }

  var body: some View {
    Group {
      if let title = entry.trackerTitle {
        trackerView(title: title)
      } else {
        emptyStateView
      }
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private func trackerView(title: String) -> some View {
    VStack(spacing: 4) {
      if let iconName = entry.iconName {
        Image(systemName: iconName)
          .font(.title2)
          .foregroundStyle(themeColor)
      }

      Text("\(entry.days)")
        .font(.system(.largeTitle, design: .rounded, weight: .bold))
        .foregroundStyle(themeColor)

      Text(entry.days == 1 ? "day" : "days")
        .font(.caption)
        .foregroundStyle(.secondary)

      Text(title)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
  }

  private var emptyStateView: some View {
    VStack(spacing: 4) {
      Image(systemName: "plus.circle")
        .font(.title2)
        .foregroundStyle(.secondary)

      Text("Add a tracker")
        .font(.caption)
        .foregroundStyle(.secondary)

      Text("in Renewed")
        .font(.caption2)
        .foregroundStyle(.tertiary)
    }
  }
}

struct RenewedWidget: Widget {
  let kind: String = "RenewedWidget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind, intent: SelectTrackerIntent.self, provider: ConfigurableProvider()
    ) { entry in
      RenewedWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Renewed")
    .description("Track your journey.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

struct RenewedWidget_Previews: PreviewProvider {
  static var previews: some View {
    RenewedWidgetEntryView(
      entry: SimpleEntry(
        date: Date(),
        trackerTitle: "Sobriety",
        days: 42,
        iconName: "leaf.fill",
        color: "green"
      )
    )
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
