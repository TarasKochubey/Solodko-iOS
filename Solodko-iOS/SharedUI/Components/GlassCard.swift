import SwiftUI

struct GlassCard<Content: View>: View {
    var radius: CGFloat = SolodkoTheme.radii.xl
    var active = false
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(SolodkoTheme.spacing.xl)
            .glassMaterial(
                radius: radius,
                surface: active ? SolodkoTheme.colors.surface.glassActive : SolodkoTheme.colors.surface.glassPrimary,
                active: active
            )
            .solodkoShadow(active ? SolodkoTheme.shadows.z2Active : SolodkoTheme.shadows.z1Soft)
    }
}

