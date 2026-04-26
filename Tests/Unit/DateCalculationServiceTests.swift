import XCTest

@testable import Renewed

final class DateCalculationServiceTests: XCTestCase {
  private var calendar: Calendar!
  private var service: DefaultDateCalculationService!

  override func setUp() {
    super.setUp()
    calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/New_York")!
  }

  override func tearDown() {
    service = nil
    calendar = nil
    super.tearDown()
  }

  // MARK: - Helpers

  private func makeService(now: Date) -> DefaultDateCalculationService {
    DefaultDateCalculationService(calendar: calendar, now: { now })
  }

  private func date(year: Int, month: Int, day: Int, hour: Int = 0) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    return calendar.date(from: components)!
  }

  // MARK: - daysSince

  func testDaysSinceKnownDate() {
    let now = date(year: 2025, month: 1, day: 11)
    let service = makeService(now: now)

    let start = date(year: 2025, month: 1, day: 1)
    XCTAssertEqual(service.daysSince(start), 10)
  }

  func testDaysSinceSameDay() {
    let now = date(year: 2025, month: 6, day: 15)
    let service = makeService(now: now)

    XCTAssertEqual(service.daysSince(now), 0)
  }

  // MARK: - daysBetween

  func testDaysBetweenStartAndEnd() {
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let start = date(year: 2025, month: 3, day: 1)
    let end = date(year: 2025, month: 3, day: 15)
    XCTAssertEqual(service.daysBetween(start, end), 14)
  }

  func testDaysBetweenReversed() {
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let start = date(year: 2025, month: 3, day: 15)
    let end = date(year: 2025, month: 3, day: 1)
    XCTAssertEqual(service.daysBetween(start, end), -14)
  }

  func testDaysBetweenSameDay() {
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let d = date(year: 2025, month: 5, day: 10)
    XCTAssertEqual(service.daysBetween(d, d), 0)
  }

  // MARK: - Leap year handling

  func testDaysBetweenAcrossLeapYear() {
    let service = makeService(now: date(year: 2024, month: 1, day: 1))

    let start = date(year: 2024, month: 2, day: 28)
    let end = date(year: 2024, month: 3, day: 1)
    // 2024 is a leap year: Feb 28 -> Feb 29 -> Mar 1 = 2 days
    XCTAssertEqual(service.daysBetween(start, end), 2)
  }

  func testDaysBetweenAcrossNonLeapYear() {
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let start = date(year: 2025, month: 2, day: 28)
    let end = date(year: 2025, month: 3, day: 1)
    // 2025 is not a leap year: Feb 28 -> Mar 1 = 1 day
    XCTAssertEqual(service.daysBetween(start, end), 1)
  }

  // MARK: - DST transitions

  func testDaysBetweenAcrossDSTSpringForward() {
    // Spring forward 2025: March 9 in America/New_York
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let start = date(year: 2025, month: 3, day: 8)
    let end = date(year: 2025, month: 3, day: 10)
    XCTAssertEqual(service.daysBetween(start, end), 2)
  }

  func testDaysBetweenAcrossDSTFallBack() {
    // Fall back 2025: November 2 in America/New_York
    let service = makeService(now: date(year: 2025, month: 1, day: 1))

    let start = date(year: 2025, month: 11, day: 1)
    let end = date(year: 2025, month: 11, day: 3)
    XCTAssertEqual(service.daysBetween(start, end), 2)
  }

  // MARK: - Monthly milestones

  func testNextMilestoneAt29Days() {
    let start = date(year: 2025, month: 1, day: 1)
    let now = date(year: 2025, month: 1, day: 30)  // 29 days elapsed
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertEqual(milestone?.days, 30)
    XCTAssertEqual(milestone?.label, "1 Month")
  }

  func testNextMilestoneAt30Days() {
    let start = date(year: 2025, month: 1, day: 1)
    let now = date(year: 2025, month: 1, day: 31)  // 30 days elapsed
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertEqual(milestone?.days, 60)
    XCTAssertEqual(milestone?.label, "2 Months")
  }

  func testNextMilestoneAt90Days() {
    let start = date(year: 2025, month: 1, day: 1)
    let now = date(year: 2025, month: 4, day: 1)  // 90 days elapsed
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertEqual(milestone?.days, 120)
    XCTAssertEqual(milestone?.label, "4 Months")
  }

  // MARK: - Yearly milestones

  func testNextMilestoneAtOneYear() {
    let start = date(year: 2024, month: 1, day: 1)
    let now = date(year: 2024, month: 12, day: 31)  // 365 days (leap year)
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertNotNil(milestone)
    XCTAssertTrue(milestone!.days > 365)
  }

  func testNextMilestoneBeyondFiveYears() {
    let start = date(year: 2020, month: 1, day: 1)
    let now = date(year: 2025, month: 1, day: 2)  // just over 5 years
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertNotNil(milestone)
    // Should be the 10-year milestone (3650 days)
    XCTAssertEqual(milestone?.days, 3650)
    XCTAssertEqual(milestone?.label, "10 Years")
  }

  func testNextMilestoneBeyondTenYears() {
    let start = date(year: 2010, month: 1, day: 1)
    let now = date(year: 2020, month: 1, day: 2)  // just over 10 years
    let service = makeService(now: now)

    let milestone = service.nextMilestone(from: start)
    XCTAssertNotNil(milestone)
    XCTAssertEqual(milestone?.days, 5475)
    XCTAssertEqual(milestone?.label, "15 Years")
  }

  // MARK: - milestoneReached

  func testMilestoneReachedOnExactDay() {
    let start = date(year: 2025, month: 1, day: 1)
    let now = date(year: 2025, month: 1, day: 31)  // exactly 30 days
    let service = makeService(now: now)

    let milestone = service.milestoneReached(from: start)
    XCTAssertEqual(milestone?.days, 30)
    XCTAssertEqual(milestone?.label, "1 Month")
  }

  func testMilestoneReachedReturnsNilOnNonMilestoneDay() {
    let start = date(year: 2025, month: 1, day: 1)
    let now = date(year: 2025, month: 1, day: 20)  // 19 days, not a milestone
    let service = makeService(now: now)

    let milestone = service.milestoneReached(from: start)
    XCTAssertNil(milestone)
  }

  func testMilestoneReachedAtOneYear() {
    let start = date(year: 2025, month: 1, day: 1)
    // 365 days later
    let now = calendar.date(byAdding: .day, value: 365, to: start)!
    let service = makeService(now: now)

    let milestone = service.milestoneReached(from: start)
    XCTAssertEqual(milestone?.days, 365)
    XCTAssertEqual(milestone?.label, "1 Year")
  }

  func testMilestoneReachedAtDayZero() {
    let start = date(year: 2025, month: 6, day: 1)
    let service = makeService(now: start)

    let milestone = service.milestoneReached(from: start)
    XCTAssertNil(milestone)
  }
}
