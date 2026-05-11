import SwiftUI

struct AtmosphericBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.timeOfDayProvider) private var provider
    @State private var bucket = TimeOfDayProvider().bucket()
    @State private var drift = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: provider.gradientColors(for: bucket),
                startPoint: drift ? .topLeading : .leading,
                endPoint: drift ? .bottomTrailing : .trailing
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [SolodkoTheme.colors.surface.glassPrimary, .clear],
                center: drift ? .topTrailing : .bottomLeading,
                startRadius: SolodkoTheme.spacing.fourXL,
                endRadius: SolodkoTheme.spacing.fourXL * 7
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

