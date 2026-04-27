import XCTest

final class TrackerUITests: XCTestCase {
  private var app: XCUIApplication!

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["--uitesting"]
    app.launch()
  }

  override func tearDown() {
    app = nil
    super.tearDown()
  }

  // MARK: - Helpers

  /// Creates a tracker with the default sobriety category and returns to the Trackers tab.
  private func createDefaultTracker() {
    app.tabBars.buttons["Add"].tap()
    app.buttons["Save"].tap()
  }

  /// Creates a tracker with a custom name and returns to the Trackers tab.
  private func createCustomTracker(name: String) {
    app.tabBars.buttons["Add"].tap()

    let categoryPicker = app.segmentedControls["categoryPicker"]
    categoryPicker.buttons["Custom"].tap()

    let nameField = app.textFields["customNameField"]
    nameField.tap()
    nameField.typeText(name)

    app.buttons["Save"].tap()
  }

  /// Asserts the tracker list is showing the empty state.
  private func assertEmptyState() {
    let emptyStateText = app.staticTexts["Your journey begins with the first step"]
    XCTAssertTrue(emptyStateText.waitForExistence(timeout: 5))
  }

  // MARK: - Create

  func testCreateTracker() {
    app.tabBars.buttons["Add"].tap()

    XCTAssertTrue(app.navigationBars["New Tracker"].exists)

    app.buttons["Save"].tap()

    // After save, the app switches to the Trackers tab
    let list = app.collectionViews["trackerList"]
    XCTAssertTrue(list.waitForExistence(timeout: 5))

    // The default category "Sobriety" should appear in the list
    XCTAssertTrue(app.staticTexts["Sobriety"].waitForExistence(timeout: 3))
  }

  func testCreateCustomTracker() {
    createCustomTracker(name: "No Sugar")

    let list = app.collectionViews["trackerList"]
    XCTAssertTrue(list.waitForExistence(timeout: 5))

    XCTAssertTrue(app.staticTexts["No Sugar"].waitForExistence(timeout: 3))
  }

  // MARK: - Edit

  func testEditTracker() {
    createDefaultTracker()

    // Wait for the list to appear and tap the tracker
    let list = app.collectionViews["trackerList"]
    XCTAssertTrue(list.waitForExistence(timeout: 5))

    let sobrietyText = app.staticTexts["Sobriety"]
    XCTAssertTrue(sobrietyText.waitForExistence(timeout: 3))
    sobrietyText.tap()

    // Verify we're in edit mode
    XCTAssertTrue(app.navigationBars["Edit Tracker"].waitForExistence(timeout: 3))

    // Change to Custom category and enter a name
    let categoryPicker = app.segmentedControls["categoryPicker"]
    categoryPicker.buttons["Custom"].tap()

    let nameField = app.textFields["customNameField"]
    nameField.tap()
    nameField.typeText("No Caffeine")

    app.buttons["Save"].tap()

    // Verify the list shows the updated name
    XCTAssertTrue(app.staticTexts["No Caffeine"].waitForExistence(timeout: 3))
    XCTAssertFalse(app.staticTexts["Sobriety"].exists)
  }

  // MARK: - Delete

  func testDeleteTrackerFromEditView() {
    createDefaultTracker()

    let list = app.collectionViews["trackerList"]
    XCTAssertTrue(list.waitForExistence(timeout: 5))

    let sobrietyText = app.staticTexts["Sobriety"]
    XCTAssertTrue(sobrietyText.waitForExistence(timeout: 3))
    sobrietyText.tap()

    XCTAssertTrue(app.navigationBars["Edit Tracker"].waitForExistence(timeout: 3))

    // Scroll down to find and tap delete button
    let deleteButton = app.buttons["deleteButton"]
    app.swipeUp()
    XCTAssertTrue(deleteButton.waitForExistence(timeout: 3))
    deleteButton.tap()

    // Confirm deletion in alert
    let deleteAlert = app.alerts["Delete Tracker"]
    XCTAssertTrue(deleteAlert.waitForExistence(timeout: 3))
    deleteAlert.buttons["Delete"].tap()

    // Wait for navigation back to list and verify empty state
    assertEmptyState()
  }

  func testSwipeToDelete() {
    createDefaultTracker()

    let list = app.collectionViews["trackerList"]
    XCTAssertTrue(list.waitForExistence(timeout: 5))

    // Swipe on the first cell in the list
    let firstCell = list.cells.firstMatch
    XCTAssertTrue(firstCell.waitForExistence(timeout: 3))
    firstCell.swipeLeft()

    let deleteButton = app.buttons["Delete"]
    XCTAssertTrue(deleteButton.waitForExistence(timeout: 3))
    deleteButton.tap()

    // Verify list is now empty
    assertEmptyState()
  }

  // MARK: - Validation

  func testValidationEmptyCustomName() {
    app.tabBars.buttons["Add"].tap()

    // Select Custom category but leave name empty
    // Use buttons query directly - segmented control buttons are accessible this way
    let customSegment = app.buttons["Custom"]
    XCTAssertTrue(customSegment.waitForExistence(timeout: 3))
    customSegment.tap()

    // Verify the custom name text field appeared (confirms category changed)
    let nameField = app.textFields["customNameField"]
    XCTAssertTrue(nameField.waitForExistence(timeout: 3))

    // Tap Save in the navigation bar toolbar
    let saveButton = app.navigationBars["New Tracker"].buttons["Save"]
    XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
    saveButton.tap()

    // Scroll down to find the error message (it appears below the form fields)
    app.swipeUp()

    // Verify error message appears (check by text content)
    let errorText = app.staticTexts["Title must not be empty"]
    XCTAssertTrue(errorText.waitForExistence(timeout: 5))

    // Verify we're still on the form (not navigated away)
    XCTAssertTrue(app.navigationBars["New Tracker"].exists)
  }
}
