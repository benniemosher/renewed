import Foundation

struct Milestone: Equatable {
  let days: Int
  let label: String
}

protocol DateCalculationService {
  func daysSince(_ date: Date) -> Int
  func daysBetween(_ start: Date, _ end: Date) -> Int
  func nextMilestone(from startDate: Date) -> Milestone?
  func milestoneReached(from startDate: Date) -> Milestone?
}
