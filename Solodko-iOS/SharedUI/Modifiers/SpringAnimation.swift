import SwiftUI

struct SpringAnimation: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var value: Bool

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring, value: value)
    }
}

extension View {
    func solodkoSpringAnimation(value: Bool) -> some View {
        modifier(SpringAnimation(value: value))
    }
}

