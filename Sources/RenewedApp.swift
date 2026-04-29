import SwiftData
import SwiftUI

@main
struct RenewedApp: App {
  private let modelContainer: ModelContainer

  init() {
    modelContainer = SharedModelContainer.create()
  }

  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
    .modelContainer(modelContainer)
  }
}
