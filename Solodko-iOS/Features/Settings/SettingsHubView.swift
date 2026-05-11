import SwiftUI

struct SettingsHubView: View {
    var body: some View {
        ZStack {
            AtmosphericBackground()
            BottomSheetContainer {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                    Text("Settings")
                        .font(SolodkoTheme.typography.screenTitle)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                    Text("Phase 10 keeps settings as a shell only.")
                        .font(SolodkoTheme.typography.body)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(SolodkoTheme.spacing.xl)
        }
        .presentationDetents([.medium])
    }
}

