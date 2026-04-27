import SwiftData
import SwiftUI

@main
struct RenewedApp: App {
  let container: ModelContainer

  init() {
    let config = ModelConfiguration(cloudKitDatabase: .none)
    container = try! ModelContainer(for: Tracker.self, configurations: config)
  }

  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
    .modelContainer(container)
  }
}
