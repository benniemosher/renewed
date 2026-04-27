import SwiftData
import SwiftUI

@main
struct RenewedApp: App {
  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
    .modelContainer(for: Tracker.self)
  }
}
