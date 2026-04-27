import Foundation
import SwiftData

enum TrackerValidationError: LocalizedError, Equatable {
  case emptyTitle
  case futureDateNotAllowed

  var errorDescription: String? {
    switch self {
    case .emptyTitle:
      return "Title must not be empty"
    case .futureDateNotAllowed:
      return "Start date must not be in the future"
    }
  }
}

@Model
final class Tracker {
  var id: UUID = UUID()
  var title: String = ""
  var startDate: Date = Date()
  var category: TrackerCategory = TrackerCategory.sobriety
  var iconName: String = "leaf.fill"
  var color: String = "green"
  var createdAt: Date = Date()
  var updatedAt: Date = Date()

  init(
    id: UUID = UUID(),
    title: String,
    startDate: Date,
    category: TrackerCategory,
    iconName: String,
    color: String,
    createdAt: Date = Date(),
    updatedAt: Date = Date()
  ) throws {
    guard !title.isEmpty else {
      throw TrackerValidationError.emptyTitle
    }
    guard startDate <= Date() else {
      throw TrackerValidationError.futureDateNotAllowed
    }

    self.id = id
    self.title = title
    self.startDate = startDate
    self.category = category
    self.iconName = iconName
    self.color = color
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
