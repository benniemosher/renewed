import Foundation
import SwiftData

enum TrackerRepositoryError: LocalizedError, Equatable {
  case notFound(UUID)
  case saveFailed(String)

  var errorDescription: String? {
    switch self {
    case .notFound(let id):
      return "Tracker with id \(id) not found"
    case .saveFailed(let reason):
      return "Failed to save: \(reason)"
    }
  }
}

final class SwiftDataTrackerRepository: TrackerRepository {
  private let modelContext: ModelContext

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }

  func fetchAll() async throws -> [Tracker] {
    let descriptor = FetchDescriptor<Tracker>(
      sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
    )
    return try modelContext.fetch(descriptor)
  }

  func create(_ tracker: Tracker) async throws {
    modelContext.insert(tracker)
    do {
      try modelContext.save()
    } catch {
      throw TrackerRepositoryError.saveFailed(error.localizedDescription)
    }
  }

  func update(_ tracker: Tracker) async throws {
    tracker.updatedAt = Date()
    do {
      try modelContext.save()
    } catch {
      throw TrackerRepositoryError.saveFailed(error.localizedDescription)
    }
  }

  func delete(_ tracker: Tracker) async throws {
    modelContext.delete(tracker)
    do {
      try modelContext.save()
    } catch {
      throw TrackerRepositoryError.saveFailed(error.localizedDescription)
    }
  }

  func fetch(byId id: UUID) async throws -> Tracker? {
    let descriptor = FetchDescriptor<Tracker>(
      predicate: #Predicate { $0.id == id }
    )
    return try modelContext.fetch(descriptor).first
  }
}
