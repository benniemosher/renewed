import AppIntents
import WidgetKit

struct SelectTrackerIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Select Tracker"
  static var description: IntentDescription = "Choose which tracker to display."

  @Parameter(title: "Tracker")
  var tracker: TrackerEntity?
}
