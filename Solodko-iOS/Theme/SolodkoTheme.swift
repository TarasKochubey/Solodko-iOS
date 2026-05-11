import SwiftUI

struct SolodkoTheme {
    static let colors = SolodkoColors()
    static let typography = SolodkoTypography()
    static let spacing = SolodkoSpacing()
    static let radii = SolodkoRadii()
    static let blur = SolodkoBlur()
    static let shadows = SolodkoShadows()
    static let motion = SolodkoMotion()
    static let haptics = SolodkoHaptics()
}

private struct SolodkoThemeKey: EnvironmentKey {
    static let defaultValue = SolodkoTheme()
}

extension EnvironmentValues {
    var solodkoTheme: SolodkoTheme {
        get { self[SolodkoThemeKey.self] }
        set { self[SolodkoThemeKey.self] = newValue }
    }
}

