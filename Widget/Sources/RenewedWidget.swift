import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  private static let container: ModelContainer = SharedModelContainer.create()

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(
      date: Date(),
      trackerTitle: "Sobriety",
      days: 42,
      iconName: "leaf.fill",
      color: "green"
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    if context.isPreview {
      completion(placeholder(in: context))
      return
    }

    let entry = fetchCurrentEntry(at: Date())
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let calendar = Calendar.current
    let now = Date()
    let startOfToday = calendar.startOfDay(for: now)
    let featured = fetchFeaturedTracker()

    var entries: [SimpleEntry] = []
    for dayOffset in 0..<7 {
      let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday)!
      let entry = makeEntry(for: featured, at: entryDate, calendar: calendar)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }

  private func fetchFeaturedTracker() -> Tracker? {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false
    let descriptor = FetchDescriptor<Tracker>(
      sortBy: [SortDescriptor(\.startDate, order: .forward)]
    )
    return try? context.fetch(descriptor).first
  }

  private func fetchCurrentEntry(at date: Date) -> SimpleEntry {
    makeEntry(for: fetchFeaturedTracker(), at: date, calendar: .current)
  }

  private func makeEntry(for tracker: Tracker?, at date: Date, calendar: Calendar) -> SimpleEntry {
    guard let tracker else {
      return SimpleEntry(
        date: date,
        trackerTitle: nil,
        days: 0,
        iconName: nil,
        color: nil
      )
    }

    let startDay = calendar.startOfDay(for: tracker.startDate)
    let entryDay = calendar.startOfDay(for: date)
    let days = calendar.dateComponents([.day], from: startDay, to: entryDay).day ?? 0

    return SimpleEntry(
      date: date,
      trackerTitle: tracker.title,
      days: days,
      iconName: tracker.iconName,
      color: tracker.color
    )
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let trackerTitle: String?
  let days: Int
  let iconName: String?
  let color: String?
}

struct RenewedWidgetEntryView: View {
  var entry: Provider.Entry

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
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
