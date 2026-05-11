import SwiftUI

struct ConfidenceGlow: ViewModifier {
    var state: MealCardState

    func body(content: Content) -> some View {
        content
            .shadow(color: state.glowColor, radius: SolodkoTheme.spacing.threeXL, x: SolodkoTheme.spacing.xs - SolodkoTheme.spacing.xs, y: SolodkoTheme.spacing.lg)
    }
}

extension View {
    func confidenceGlow(_ state: MealCardState) -> some View {
        modifier(ConfidenceGlow(state: state))
    }
}

