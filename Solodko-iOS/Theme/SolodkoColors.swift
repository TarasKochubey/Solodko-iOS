import SwiftUI

struct SolodkoColors {
    let text = TextColors()
    let surface = SurfaceColors()
    let confidence = ConfidenceColors()
    let background = BackgroundColors()
    let accent = AccentColors()
}

struct TextColors {
    let primary = Color(hex: "30251F")
    let secondary = Color(hex: "6B5C53")
    let tertiary = Color(hex: "9B8F86")
    let inverse = Color.white
}

struct SurfaceColors {
    let glassPrimary = Color(hex: "FFFDF8").opacity(0.48)
    let glassActive = Color(hex: "FFF9EF").opacity(0.62)
    let solidSecondary = Color(hex: "FFF8EC").opacity(0.82)
    let solidQuiet = Color(hex: "FFF6EA").opacity(0.88)
    let pearl = Color(hex: "FFFDF8").opacity(0.72)
    let edgeHighlight = Color.white.opacity(0.72)
}

struct ConfidenceColors {
    let exactGlow = Color(hex: "FFD7BA").opacity(0.30)
    let memoryGlow = Color(hex: "E6B66E").opacity(0.24)
    let estimatedGlow = Color(hex: "D8D0C6").opacity(0.22)
    let lowConfidence = Color(hex: "8E8178").opacity(0.16)
}

struct BackgroundColors {
    let morning = [Color(hex: "FFE1C8"), Color(hex: "FFF8EA"), Color(hex: "DCECCF")]
    let afternoon = [Color(hex: "FFF8EF"), Color(hex: "F8E9D8"), Color(hex: "EAF2DC")]
    let eveningDusk = [Color(hex: "F2D3C9"), Color(hex: "F8E7D8"), Color(hex: "DCD7B8")]
    let ivoryBase = Color(hex: "FFF8EC")
    let peachLight = Color(hex: "FFDCC7")
    let peachGlow = Color(hex: "F5B88F")
    let paleSage = Color(hex: "DDECCF")
    let warmPlum = Color(hex: "E7C8C8")
}

struct AccentColors {
    let peach = Color(hex: "F0A978")
    let amber = Color(hex: "DFA95F")
    let pearl = Color(hex: "FFFDF8")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
