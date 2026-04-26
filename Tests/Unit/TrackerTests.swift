import XCTest

@testable import Renewed

final class TrackerTests: XCTestCase {
  func testTrackerCreationWithValidData() {
    let now = Date()
    let tracker = Tracker(
      title: "My Recovery",
      startDate: now,
      category: .sobriety,
      iconName: "heart.fill",
      color: "blue"
    )

    XCTAssertEqual(tracker.title, "My Recovery")
    XCTAssertEqual(tracker.startDate, now)
    XCTAssertEqual(tracker.category, .sobriety)
    XCTAssertEqual(tracker.iconName, "heart.fill")
    XCTAssertEqual(tracker.color, "blue")
  }

  func testTrackerDefaultValues() {
    let before = Date()
    let tracker = Tracker(
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
}
