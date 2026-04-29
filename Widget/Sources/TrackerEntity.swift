import AppIntents
import SwiftUI

struct TrackerEntity: AppEntity {
  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Tracker"
  static var defaultQuery = TrackerQuery()

  var id: String
  var title: String
  var iconName: String

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(
      title: "\(title)",
      image: .init(systemName: iconName)
    )
  }
}
