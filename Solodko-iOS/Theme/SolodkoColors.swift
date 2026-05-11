import SwiftUI

struct SolodkoColors {
    let text = TextColors()
    let surface = SurfaceColors()
    let confidence = ConfidenceColors()
    let background = BackgroundColors()
}

struct TextColors {
    let primary = Color(hex: "1F2422")
    let secondary = Color(hex: "5F6661")
    let tertiary = Color(hex: "8B918C")
    let inverse = Color.white
}

struct SurfaceColors {
    let glassPrimary = Color.white.opacity(0.40)
    let glassActive = Color.white.opacity(0.52)
    let solidSecondary = Color.white.opacity(0.75)
    let solidQuiet = Color(hex: "FFF8F0").opacity(0.82)
}

struct ConfidenceColors {
    let exactGlow = Color(hex: "FFD6B4").opacity(0.24)
    let memoryGlow = Color(hex: "E2B066").opacity(0.26)
    let estimatedGlow = Color(hex: "B0BEC5").opacity(0.24)
    let lowConfidence = Color(hex: "5F6F76").opacity(0.18)
}

struct BackgroundColors {
    let morning = [Color(hex: "FFD6B4"), Color(hex: "FFF3E0"), Color(hex: "C8E6C9")]
    let afternoon = [Color(hex: "FFF8F0"), Color(hex: "F5F0E8"), Color(hex: "E8F5E9")]
    let eveningDusk = [Color(hex: "D1C4E9"), Color(hex: "B0BEC5"), Color(hex: "263238")]
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

