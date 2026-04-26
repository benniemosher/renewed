import SwiftData
import XCTest

@testable import Renewed

final class TrackerRepositoryTests: XCTestCase {
  private var container: ModelContainer!
  private var context: ModelContext!
  private var repository: SwiftDataTrackerRepository!

  override func setUp() async throws {
    try await super.setUp()
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    container = try ModelContainer(for: Tracker.self, configurations: config)
    context = ModelContext(container)
    repository = SwiftDataTrackerRepository(modelContext: context)
  }

  override func tearDown() async throws {
    repository = nil
    context = nil
    container = nil
    try await super.tearDown()
  }

  // MARK: - Create

  func testCreateInsertsTracker() async throws {
    let tracker = try Tracker(
      title: "Test Tracker",
      startDate: Date(),
      category: .sobriety,
      iconName: "heart.fill",
      color: "blue"
    )

    try await repository.create(tracker)

    let results = try await repository.fetchAll()
    XCTAssertEqual(results.count, 1)
    XCTAssertEqual(results.first?.title, "Test Tracker")
  }

  // MARK: - FetchAll

  func testFetchAllReturnsEmpty() async throws {
    let results = try await repository.fetchAll()
    XCTAssertTrue(results.isEmpty)
  }

  func testFetchAllReturnsMultipleTrackers() async throws {
    let tracker1 = try Tracker(
      title: "First",
      startDate: Date(),
      category: .sobriety,
      iconName: "heart.fill",
      color: "blue"
    )
    let tracker2 = try Tracker(
      title: "Second",
      startDate: Date(),
      category: .freedom,
      iconName: "star",
      color: "green"
    )

    try await repository.create(tracker1)
    try await repository.create(tracker2)

    let results = try await repository.fetchAll()
    XCTAssertEqual(results.count, 2)
  }

  // MARK: - Fetch by ID

  func testFetchByIdReturnsTracker() async throws {
    let id = UUID()
    let tracker = try Tracker(
      id: id,
      title: "Find Me",
      startDate: Date(),
      category: .salvation,
      iconName: "cross",
      color: "purple"
    )

    try await repository.create(tracker)

    let found = try await repository.fetch(byId: id)
    XCTAssertNotNil(found)
    XCTAssertEqual(found?.title, "Find Me")
  }

  func testFetchByIdReturnsNilForNonExistent() async throws {
    let result = try await repository.fetch(byId: UUID())
    XCTAssertNil(result)
  }

  // MARK: - Update

  func testUpdateSetsUpdatedAt() async throws {
    let tracker = try Tracker(
      title: "Original",
      startDate: Date(),
      category: .custom,
      iconName: "flame",
      color: "orange"
    )
    let originalUpdatedAt = tracker.updatedAt

    try await repository.create(tracker)

    // Small delay so updatedAt differs
    try await Task.sleep(nanoseconds: 10_000_000)

    tracker.title = "Modified"
    try await repository.update(tracker)

    XCTAssertEqual(tracker.title, "Modified")
    XCTAssertGreaterThan(tracker.updatedAt, originalUpdatedAt)
  }

  // MARK: - Delete

  func testDeleteRemovesTracker() async throws {
    let tracker = try Tracker(
      title: "Delete Me",
      startDate: Date(),
      category: .sobriety,
      iconName: "heart.fill",
      color: "red"
    )

    try await repository.create(tracker)
    XCTAssertEqual(try await repository.fetchAll().count, 1)

    try await repository.delete(tracker)
    XCTAssertEqual(try await repository.fetchAll().count, 0)
  }

  // MARK: - Error descriptions

  func testTrackerRepositoryErrorDescriptions() {
    let id = UUID()
    XCTAssertEqual(
      TrackerRepositoryError.notFound(id).errorDescription,
      "Tracker with id \(id) not found"
    )
    XCTAssertEqual(
      TrackerRepositoryError.saveFailed("disk full").errorDescription,
      "Failed to save: disk full"
    )
  }
}
