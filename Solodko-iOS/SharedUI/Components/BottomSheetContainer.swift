import SwiftUI

struct BottomSheetContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: SolodkoTheme.spacing.lg) {
            Capsule()
                .fill(SolodkoTheme.colors.text.tertiary.opacity(0.35))
                .frame(width: SolodkoTheme.spacing.fourXL, height: SolodkoTheme.spacing.xs)
                .accessibilityHidden(true)

            content
        }
        .frame(maxWidth: .infinity)
        .padding(SolodkoTheme.spacing.xl)
        .glassMaterial(
            radius: SolodkoTheme.radii.xl,
            surface: SolodkoTheme.colors.surface.glassActive,
            active: true
        )
        .solodkoShadow(SolodkoTheme.shadows.z2Active)
    }
}

