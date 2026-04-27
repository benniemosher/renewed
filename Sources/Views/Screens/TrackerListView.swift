import SwiftData
import SwiftUI

struct TrackerListView: View {
  @Query(sort: \Tracker.createdAt, order: .reverse) private var trackers: [Tracker]
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    NavigationStack {
      Group {
        if trackers.isEmpty {
          EmptyStateView()
        } else {
          List {
            ForEach(trackers) { tracker in
              NavigationLink(value: tracker.id) {
                TrackerCardView(tracker: tracker)
              }
              .listRowSeparator(.hidden)
              .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete(perform: deleteTrackers)
          }
          .listStyle(.plain)
          .accessibilityIdentifier("trackerList")
        }
      }
      .navigationTitle("Trackers")
      .navigationDestination(for: UUID.self) { trackerId in
        if let tracker = trackers.first(where: { $0.id == trackerId }) {
          AddEditTrackerView(tracker: tracker)
        }
      }
    }
  }

  private func deleteTrackers(at offsets: IndexSet) {
    for index in offsets {
      modelContext.delete(trackers[index])
    }
  }
}

struct TrackerListView_Previews: PreviewProvider {
  static var previews: some View {
    TrackerListView()
  }
}
