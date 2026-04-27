import SwiftUI

struct AddTrackerView: View {
  var body: some View {
    NavigationStack {
      AddEditTrackerView()
    }
  }
}

struct AddTrackerView_Previews: PreviewProvider {
  static var previews: some View {
    AddTrackerView()
  }
}
