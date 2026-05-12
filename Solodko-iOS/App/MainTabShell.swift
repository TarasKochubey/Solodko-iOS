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
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeHubView()
                    .tag(AppTab.home)

                TodaysLogView()
                    .tag(AppTab.log)

                MemoryHubView()
                    .tag(AppTab.memory)
            }
            .toolbar(.hidden, for: .tabBar)

            FloatingTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, SolodkoTheme.spacing.xl)
                .padding(.bottom, SolodkoTheme.spacing.lg)
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
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(SolodkoTheme.radii.xl)
        }
    }
}

private struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: SolodkoTheme.spacing.sm) {
            tabButton(.home, title: SolodkoCopy.Tabs.home, systemImage: "house")
            tabButton(.log, title: SolodkoCopy.Tabs.log, systemImage: "list.bullet")
            tabButton(.memory, title: SolodkoCopy.Tabs.memory, systemImage: "bookmark")
        }
        .padding(SolodkoTheme.spacing.sm)
        .glassMaterial(
            radius: SolodkoTheme.radii.pill,
            surface: SolodkoTheme.colors.surface.glassActive,
            active: true
        )
        .solodkoShadow(SolodkoTheme.shadows.tabBar)
        .accessibilityElement(children: .contain)
    }

    private func tabButton(_ tab: AppTab, title: String, systemImage: String) -> some View {
        let selected = selectedTab == tab
        return Button {
            withAnimation(.solodkoSpring) {
                selectedTab = tab
            }
        } label: {
            Label(title, systemImage: systemImage)
                .font(SolodkoTheme.typography.badge)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .labelStyle(.iconOnly)
                .frame(minWidth: SolodkoTheme.spacing.minTouchTarget, minHeight: SolodkoTheme.spacing.minTouchTarget)
                .padding(.horizontal, SolodkoTheme.spacing.sm)
                .background(selected ? SolodkoTheme.colors.surface.solidSecondary : Color.clear)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}
