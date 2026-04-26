import XCTest

@testable import Renewed

final class TrackerTests: XCTestCase {
  func testTrackerCreationStoresAllProperties() throws {
    let now = Date()
    let id = UUID()
    let tracker = try Tracker(
      id: id,
      title: "My Recovery",
      startDate: now,
      category: .sobriety,
      iconName: "heart.fill",
      color: "blue",
      createdAt: now,
      updatedAt: now
    )

    XCTAssertEqual(tracker.id, id)
    XCTAssertEqual(tracker.title, "My Recovery")
    XCTAssertEqual(tracker.startDate, now)
    XCTAssertEqual(tracker.category, .sobriety)
    XCTAssertEqual(tracker.iconName, "heart.fill")
    XCTAssertEqual(tracker.color, "blue")
    XCTAssertEqual(tracker.createdAt, now)
    XCTAssertEqual(tracker.updatedAt, now)
  }

  func testTrackerDefaultValues() throws {
    let before = Date()
    let tracker = try Tracker(
      title: "Test",
      startDate: Date(),
      category: .freedom,
      iconName: "star",
      color: "green"
    )
    let after = Date()

    XCTAssertNotEqual(tracker.id, UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    XCTAssertGreaterThanOrEqual(tracker.createdAt, before)
    XCTAssertLessThanOrEqual(tracker.createdAt, after)
    XCTAssertGreaterThanOrEqual(tracker.updatedAt, before)
    XCTAssertLessThanOrEqual(tracker.updatedAt, after)
  }

  func testTrackerCategoryAllCases() {
    let cases = TrackerCategory.allCases
    XCTAssertEqual(cases.count, 4)
    XCTAssertTrue(cases.contains(.sobriety))
    XCTAssertTrue(cases.contains(.freedom))
    XCTAssertTrue(cases.contains(.salvation))
    XCTAssertTrue(cases.contains(.custom))
  }

  func testTrackerCategoryRawValues() {
    XCTAssertEqual(TrackerCategory.sobriety.rawValue, "sobriety")
    XCTAssertEqual(TrackerCategory.freedom.rawValue, "freedom")
    XCTAssertEqual(TrackerCategory.salvation.rawValue, "salvation")
    XCTAssertEqual(TrackerCategory.custom.rawValue, "custom")
  }

  func testTrackerValidationRejectsEmptyTitle() {
    XCTAssertThrowsError(
      try Tracker(
        title: "",
        startDate: Date(),
        category: .sobriety,
        iconName: "heart.fill",
        color: "blue"
      )
    ) { error in
      XCTAssertEqual(error as? TrackerValidationError, .emptyTitle)
    }
  }

  func testTrackerValidationRejectsFutureStartDate() {
    let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    XCTAssertThrowsError(
      try Tracker(
        title: "Future Tracker",
        startDate: futureDate,
        category: .freedom,
        iconName: "star",
        color: "green"
      )
    ) { error in
      XCTAssertEqual(error as? TrackerValidationError, .futureDateNotAllowed)
    }
  }

  func testTrackerValidationAcceptsPastStartDate() throws {
    let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    let tracker = try Tracker(
      title: "Past Tracker",
      startDate: pastDate,
      category: .salvation,
      iconName: "cross",
      color: "purple"
    )

    XCTAssertEqual(tracker.startDate, pastDate)
  }

  func testTrackerValidationAcceptsTodayStartDate() throws {
    let tracker = try Tracker(
      title: "Today Tracker",
      startDate: Date(),
      category: .custom,
      iconName: "flame",
      color: "orange"
    )

    XCTAssertEqual(tracker.title, "Today Tracker")
  }

  func testTrackerCategoryCodable() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for category in TrackerCategory.allCases {
      let data = try encoder.encode(category)
      let decoded = try decoder.decode(TrackerCategory.self, from: data)
      XCTAssertEqual(decoded, category)
    }
  }

  func testTrackerValidationErrorDescriptions() {
    XCTAssertEqual(
      TrackerValidationError.emptyTitle.errorDescription,
      "Title must not be empty"
    )
    XCTAssertEqual(
      TrackerValidationError.futureDateNotAllowed.errorDescription,
      "Start date must not be in the future"
    )
  }
}
