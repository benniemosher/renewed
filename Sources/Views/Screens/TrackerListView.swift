import SwiftUI

struct TrackerListView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "leaf.fill")
          .font(.largeTitle)
          .foregroundColor(.green)
        Text("Renewed")
          .font(.title)
        Text("Your journey begins here")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .navigationTitle("Trackers")
    }
  }
}

struct TrackerListView_Previews: PreviewProvider {
  static var previews: some View {
    TrackerListView()
  }
}
