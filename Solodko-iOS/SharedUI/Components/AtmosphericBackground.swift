import SwiftUI

struct AtmosphericBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.timeOfDayProvider) private var provider
    @State private var bucket = TimeOfDayProvider().bucket()
    @State private var drift = false

    var body: some View {
        ZStack {
            SolodkoTheme.colors.background.ivoryBase
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    provider.gradientColors(for: bucket)[0].opacity(0.66),
                    provider.gradientColors(for: bucket)[1].opacity(0.32),
                    .clear
                ],
                center: drift ? .topLeading : .topTrailing,
                startRadius: SolodkoTheme.spacing.fourXL,
                endRadius: SolodkoTheme.spacing.fourXL * 8
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    provider.gradientColors(for: bucket)[2].opacity(0.38),
                    SolodkoTheme.colors.background.ivoryBase.opacity(0.18),
                    .clear
                ],
                center: drift ? .bottomTrailing : .bottomLeading,
                startRadius: SolodkoTheme.spacing.fourXL,
                endRadius: SolodkoTheme.spacing.fourXL * 9
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    SolodkoTheme.colors.background.peachGlow.opacity(0.18),
                    .clear
                ],
                center: drift ? .center : .bottom,
                startRadius: SolodkoTheme.spacing.fourXL,
                endRadius: SolodkoTheme.spacing.fourXL * 6
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.white.opacity(0.28),
                    SolodkoTheme.colors.background.ivoryBase.opacity(0.10),
                    Color.white.opacity(0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .accessibilityHidden(true)
        .onAppear {
            bucket = provider.bucket()
            if !reduceMotion {
                withAnimation(.linear(duration: SolodkoTheme.motion.backgroundBlend).repeatForever(autoreverses: true)) {
                    drift.toggle()
                }
            }
        }
    }
}
