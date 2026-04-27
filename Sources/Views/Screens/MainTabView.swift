import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      TrackerListView()
        .tabItem {
          Label("Trackers", systemImage: "list.bullet")
        }

      AddTrackerView()
        .tabItem {
          Label("Add", systemImage: "plus.circle.fill")
        }

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
