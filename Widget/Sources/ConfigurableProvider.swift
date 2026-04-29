import SwiftData
import WidgetKit

struct ConfigurableProvider: AppIntentTimelineProvider {
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

  func snapshot(for configuration: SelectTrackerIntent, in context: Context) async -> SimpleEntry {
    if context.isPreview {
      return placeholder(in: context)
    }

    return fetchEntry(for: configuration, at: Date())
  }

  func timeline(
    for configuration: SelectTrackerIntent, in context: Context
  ) async -> Timeline<SimpleEntry> {
    let calendar = Calendar.current
    let now = Date()
    let startOfToday = calendar.startOfDay(for: now)
    let tracker = fetchTracker(for: configuration)

    var entries: [SimpleEntry] = []
    for dayOffset in 0..<7 {
      let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday)!
      let entry = makeEntry(for: tracker, at: entryDate, calendar: calendar)
      entries.append(entry)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }

  private func fetchTracker(for configuration: SelectTrackerIntent) -> Tracker? {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false

    if let selectedID = configuration.tracker?.id,
      let uuid = UUID(uuidString: selectedID)
    {
      let predicate = #Predicate<Tracker> { $0.id == uuid }
      var descriptor = FetchDescriptor<Tracker>(predicate: predicate)
      descriptor.fetchLimit = 1
      if let tracker = try? context.fetch(descriptor).first {
        return tracker
      }
    }

    let descriptor = FetchDescriptor<Tracker>(
      sortBy: [SortDescriptor(\.startDate, order: .reverse)]
    )
    return try? context.fetch(descriptor).first
  }

  private func fetchEntry(for configuration: SelectTrackerIntent, at date: Date) -> SimpleEntry {
    makeEntry(for: fetchTracker(for: configuration), at: date, calendar: .current)
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
