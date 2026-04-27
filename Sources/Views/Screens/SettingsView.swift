import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "gear")
          .font(.largeTitle)
          .foregroundColor(.gray)
        Text("Settings")
          .font(.title)
      }
      .navigationTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
