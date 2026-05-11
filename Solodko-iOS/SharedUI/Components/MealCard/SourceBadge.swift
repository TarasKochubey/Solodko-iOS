import SwiftUI

struct SourceBadge: View {
    var state: MealCardState

    var body: some View {
        if let text = state.badgeText {
            Text(text)
                .font(SolodkoTheme.typography.badge)
                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                .lineLimit(nil)
                .padding(.horizontal, SolodkoTheme.spacing.md)
                .padding(.vertical, SolodkoTheme.spacing.sm)
                .background(SolodkoTheme.colors.surface.solidSecondary)
                .clipShape(Capsule())
                .accessibilityHidden(true)
        }
    }
}

