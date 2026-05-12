import SwiftUI

struct SolodkoShadows {
    let z1Soft = SolodkoShadow(color: Color(hex: "8A6046").opacity(0.075), radius: 34, x: 0, y: 18)
    let z2Active = SolodkoShadow(color: Color(hex: "80543C").opacity(0.09), radius: 46, x: 0, y: 24)
    let secondary = SolodkoShadow(color: Color(hex: "9A6B4D").opacity(0.055), radius: 18, x: 0, y: 8)
    let memoryGlow = SolodkoShadow(color: Color(hex: "E2B066").opacity(0.18), radius: 44, x: 0, y: 18)
    let pearlHalo = SolodkoShadow(color: Color(hex: "FFD8BE").opacity(0.36), radius: 52, x: 0, y: 18)
    let tabBar = SolodkoShadow(color: Color(hex: "8A6046").opacity(0.10), radius: 30, x: 0, y: 14)
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
