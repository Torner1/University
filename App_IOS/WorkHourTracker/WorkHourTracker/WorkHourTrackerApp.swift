import SwiftUI

@main
struct WorkHourTrackerApp: App {
    @StateObject private var store = WorkHourStore()
    @StateObject private var userProfileStore = UserProfileStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(store)
                    .environmentObject(userProfileStore)
                    .tabItem {
                        Label("Work Tracker", systemImage: "clock")
                    }

                ProfileView()
                    .environmentObject(userProfileStore)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        }
    }
}
