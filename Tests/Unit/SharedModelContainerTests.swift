import SwiftData
import XCTest

@testable import Renewed

final class SharedModelContainerTests: XCTestCase {
  func testInMemoryContainerCreatesSuccessfully() {
    let container = SharedModelContainer.createInMemory()
    XCTAssertNotNil(container)
  }

  func testInMemoryContainerCanInsertAndFetch() throws {
    let container = SharedModelContainer.createInMemory()
    let context = ModelContext(container)

    let tracker = try Tracker(
      title: "Test",
      startDate: Date(),
      category: .sobriety,
      iconName: "leaf.fill",
      color: "green"
    )
    context.insert(tracker)
    try context.save()

    let descriptor = FetchDescriptor<Tracker>()
    let fetched = try context.fetch(descriptor)
    XCTAssertEqual(fetched.count, 1)
    XCTAssertEqual(fetched.first?.title, "Test")
  }

  func testAppGroupIdentifierIsCorrect() {
    XCTAssertEqual(SharedModelContainer.appGroupIdentifier, "group.com.benniemosher.renewed")
  }

  func testStoreFilenameIsCorrect() {
    XCTAssertEqual(SharedModelContainer.storeFilename, "Renewed.store")
  }
}
