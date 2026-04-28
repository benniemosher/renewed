import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), days: 42)
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), days: 42)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []
    let currentDate = Date()
    for dayOffset in 0..<7 {
      let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, days: 42)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let days: Int
}

struct RenewedWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Text("\(entry.days)")
        .font(.largeTitle)
      Text("days")
        .font(.caption)
    }
    .containerBackground(.fill.tertiary, for: .widget)
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
    RenewedWidgetEntryView(entry: SimpleEntry(date: Date(), days: 42))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
