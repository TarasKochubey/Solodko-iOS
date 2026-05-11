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
            HomeHubView()
                .tabItem { Label(SolodkoCopy.Tabs.home, systemImage: "house") }
                .tag(AppTab.home)

            TodaysLogView()
                .tabItem { Label(SolodkoCopy.Tabs.log, systemImage: "list.bullet") }
                .tag(AppTab.log)

            MemoryHubView()
                .tabItem { Label(SolodkoCopy.Tabs.memory, systemImage: "bookmark") }
                .tag(AppTab.memory)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                settingsPresented = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .frame(width: SolodkoTheme.spacing.minTouchTarget, height: SolodkoTheme.spacing.minTouchTarget)
                    .background(SolodkoTheme.colors.surface.glassPrimary)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.trailing, SolodkoTheme.spacing.lg)
            .padding(.top, SolodkoTheme.spacing.lg)
            .accessibilityLabel("Settings")
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsHubView()
        }
    }
}

