import SwiftUI

struct GlassMaterial: ViewModifier {
    var radius: CGFloat
    var surface: Color
    var active: Bool

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(active ? .regularMaterial : .ultraThinMaterial)
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(surface)
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

extension View {
    func glassMaterial(radius: CGFloat, surface: Color, active: Bool = false) -> some View {
        modifier(GlassMaterial(radius: radius, surface: surface, active: active))
    }
}

