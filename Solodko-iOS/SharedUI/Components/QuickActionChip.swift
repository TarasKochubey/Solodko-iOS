import SwiftUI

struct QuickActionChip: View {
    var label: String
    var prominent = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            SolodkoTheme.haptics.quickAction()
            action()
        }) {
            Text(label)
                .font(SolodkoTheme.typography.badge)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .lineLimit(nil)
                .frame(minHeight: SolodkoTheme.spacing.minTouchTarget)
                .padding(.horizontal, SolodkoTheme.spacing.lg)
                .background(prominent ? SolodkoTheme.colors.surface.solidSecondary : SolodkoTheme.colors.surface.glassPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
    }
}

