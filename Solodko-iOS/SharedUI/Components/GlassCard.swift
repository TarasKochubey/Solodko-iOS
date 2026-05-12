import SwiftUI

struct GlassCard<Content: View>: View {
    var radius: CGFloat = SolodkoTheme.radii.xl
    var active = false
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(SolodkoTheme.spacing.twoXL)
            .glassMaterial(
                radius: radius,
                surface: active ? SolodkoTheme.colors.surface.glassActive : SolodkoTheme.colors.surface.glassPrimary,
                active: active
            )
            .solodkoShadow(active ? SolodkoTheme.shadows.z2Active : SolodkoTheme.shadows.z1Soft)
            .shadow(color: SolodkoTheme.colors.background.peachLight.opacity(active ? 0.24 : 0.16), radius: active ? SolodkoTheme.spacing.fourXL : SolodkoTheme.spacing.threeXL, x: 0, y: SolodkoTheme.spacing.lg)
    }
}
