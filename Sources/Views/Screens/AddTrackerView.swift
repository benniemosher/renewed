import SwiftUI

struct AddTrackerView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "plus.circle.fill")
          .font(.largeTitle)
          .foregroundColor(.accentColor)
        Text("Add Tracker")
          .font(.title)
      }
      .navigationTitle("Add Tracker")
    }
  }
}

struct AddTrackerView_Previews: PreviewProvider {
  static var previews: some View {
    AddTrackerView()
  }
}
