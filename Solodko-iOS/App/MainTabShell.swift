import SwiftUI

enum AppTab {
    case home
    case log
    case memory
}

struct MainTabShell: View {
    @State private var selectedTab: AppTab = .home
    @State private var settingsPresented = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeHubView(onSettingsTap: { settingsPresented = true })
                .tabItem { Label(SolodkoCopy.Tabs.home, systemImage: "house") }
                .tag(AppTab.home)

            TodaysLogView()
                .tabItem { Label(SolodkoCopy.Tabs.log, systemImage: "list.bullet") }
                .tag(AppTab.log)

            MemoryHubView(onSettingsTap: { settingsPresented = true })
                .tabItem { Label(SolodkoCopy.Tabs.memory, systemImage: "bookmark") }
                .tag(AppTab.memory)
        }
        .sheet(isPresented: $settingsPresented) {
            NavigationStack {
                SettingsHubView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationBackground(.thinMaterial)
            .presentationCornerRadius(SolodkoTheme.radii.xl)
        }
    }
}
