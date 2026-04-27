import SwiftUI

struct AddTrackerView: View {
  var onSave: (() -> Void)?

  var body: some View {
    NavigationStack {
      AddEditTrackerView(onSave: onSave)
    }
  }
}

struct AddTrackerView_Previews: PreviewProvider {
  static var previews: some View {
    AddTrackerView()
  }
}
