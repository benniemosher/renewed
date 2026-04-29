import Foundation
import SwiftData

enum SharedModelContainer {
  static let appGroupIdentifier = "group.com.benniemosher.renewed"
  static let storeFilename = "Renewed.store"

  static func create() -> ModelContainer {
    if CommandLine.arguments.contains("--uitesting") {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      return try! ModelContainer(for: Tracker.self, configurations: config)
    }

    let appGroupURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupIdentifier
    )!

    let storeURL = appGroupURL.appendingPathComponent(storeFilename)
    let config = ModelConfiguration(url: storeURL)
    return try! ModelContainer(for: Tracker.self, configurations: config)
  }

  static func createInMemory() -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try! ModelContainer(for: Tracker.self, configurations: config)
  }
}
