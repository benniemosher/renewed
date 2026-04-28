import SwiftUI

struct MainTabView: View {
  @State private var selectedTab = 0

  var body: some View {
    TabView(selection: $selectedTab) {
      TrackerListView(onCreateTracker: { selectedTab = 1 })
        .tabItem {
          Label("Trackers", systemImage: "list.bullet")
        }
        .tag(0)

      AddTrackerView(onSave: { selectedTab = 0 })
        .tabItem {
          Label("Add", systemImage: "plus.circle.fill")
        }
        .tag(1)

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
        .tag(2)
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
