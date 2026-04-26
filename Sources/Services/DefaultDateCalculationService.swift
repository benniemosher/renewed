import Foundation

final class DefaultDateCalculationService: DateCalculationService {
  private let calendar: Calendar
  private let now: () -> Date

  init(calendar: Calendar = .current, now: @escaping () -> Date = { Date() }) {
    self.calendar = calendar
    self.now = now
  }

  func daysSince(_ date: Date) -> Int {
    daysBetween(date, now())
  }

  func daysBetween(_ start: Date, _ end: Date) -> Int {
    let startDay = calendar.startOfDay(for: start)
    let endDay = calendar.startOfDay(for: end)
    let components = calendar.dateComponents([.day], from: startDay, to: endDay)
    return components.day ?? 0
  }

  func nextMilestone(from startDate: Date) -> Milestone? {
    let elapsed = daysSince(startDate)
    return milestones(upTo: elapsed + 365 * 10).first { $0.days > elapsed }
  }

  func milestoneReached(from startDate: Date) -> Milestone? {
    let elapsed = daysSince(startDate)
    return milestones(upTo: elapsed).last { $0.days == elapsed }
  }

  // MARK: - Private

  private func milestones(upTo maxDays: Int) -> [Milestone] {
    var result: [Milestone] = []

    // Monthly milestones: 30, 60, 90 days
    result.append(Milestone(days: 30, label: "1 Month"))
    result.append(Milestone(days: 60, label: "2 Months"))
    result.append(Milestone(days: 90, label: "3 Months"))

    // 4-11 months (approximate days)
    for month in 4...11 {
      let days = month * 30
      result.append(Milestone(days: days, label: "\(month) Months"))
    }

    // Yearly milestones: 1-5 years
    for year in 1...5 {
      let days = year * 365
      let label = year == 1 ? "1 Year" : "\(year) Years"
      result.append(Milestone(days: days, label: label))
    }

    // Every 5 years beyond 5
    var year = 10
    while year * 365 <= maxDays + 365 * 5 {
      result.append(Milestone(days: year * 365, label: "\(year) Years"))
      year += 5
    }

    return result.sorted { $0.days < $1.days }
  }
}
