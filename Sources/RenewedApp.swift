import SwiftData
import SwiftUI

@main
struct RenewedApp: App {
  private let modelContainer: ModelContainer

  init() {
    if CommandLine.arguments.contains("--uitesting") {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      modelContainer = try! ModelContainer(for: Tracker.self, configurations: config)
    } else {
      modelContainer = try! ModelContainer(for: Tracker.self)
    }
  }

  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
    .modelContainer(modelContainer)
  }
}
