import AppIntents
import SwiftData

struct TrackerQuery: EntityQuery {
  private static let container: ModelContainer = SharedModelContainer.create()

  func entities(for identifiers: [TrackerEntity.ID]) -> [TrackerEntity] {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false
    let descriptor = FetchDescriptor<Tracker>()
    guard let trackers = try? context.fetch(descriptor) else { return [] }

    let idSet = Set(identifiers)
    return
      trackers
      .filter { idSet.contains($0.id.uuidString) }
      .map { TrackerEntity(id: $0.id.uuidString, title: $0.title, iconName: $0.iconName) }
  }

  func defaultResult() -> TrackerEntity? {
    suggestedEntities().first
  }

  func suggestedEntities() -> [TrackerEntity] {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false
    let descriptor = FetchDescriptor<Tracker>(
      sortBy: [SortDescriptor(\.startDate, order: .reverse)]
    )
    guard let trackers = try? context.fetch(descriptor) else { return [] }

    return trackers.map {
      TrackerEntity(id: $0.id.uuidString, title: $0.title, iconName: $0.iconName)
    }
  }
}
