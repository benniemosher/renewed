import SwiftData
import SwiftUI

@main
struct RenewedApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Tracker.self)
  }
}
