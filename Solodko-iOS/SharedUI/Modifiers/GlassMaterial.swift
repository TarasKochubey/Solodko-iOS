import SwiftUI

struct GlassMaterial: ViewModifier {
    var radius: CGFloat
    var surface: Color
    var active: Bool

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(active ? .thinMaterial : .ultraThinMaterial)
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(surface)
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                SolodkoTheme.colors.surface.edgeHighlight,
                                Color.white.opacity(0.10),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.screen)
                    .opacity(active ? 0.62 : 0.46)
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(active ? 0.74 : 0.58),
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

extension View {
    func glassMaterial(radius: CGFloat, surface: Color, active: Bool = false) -> some View {
        modifier(GlassMaterial(radius: radius, surface: surface, active: active))
    }
}
