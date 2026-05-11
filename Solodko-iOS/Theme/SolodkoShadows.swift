import SwiftUI

struct SolodkoShadows {
    let z1Soft = SolodkoShadow(color: .black.opacity(0.04), radius: 32, x: 0, y: 12)
    let z2Active = SolodkoShadow(color: .black.opacity(0.05), radius: 40, x: 0, y: 20)
    let secondary = SolodkoShadow(color: .black.opacity(0.03), radius: 12, x: 0, y: 4)
    let memoryGlow = SolodkoShadow(color: Color(hex: "E2B066").opacity(0.18), radius: 40, x: 0, y: 16)
}

struct SolodkoShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func solodkoShadow(_ shadow: SolodkoShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

