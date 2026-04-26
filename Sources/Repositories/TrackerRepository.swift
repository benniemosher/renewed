protocol TrackerRepository {
  func fetchAll() async throws -> [Tracker]
  func create(_ tracker: Tracker) async throws
  func update(_ tracker: Tracker) async throws
  func delete(_ tracker: Tracker) async throws
  func fetch(byId: UUID) async throws -> Tracker?
}
