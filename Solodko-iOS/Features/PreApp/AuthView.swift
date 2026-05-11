import SwiftUI

struct AuthView: View {
    var body: some View {
        ZStack {
            AtmosphericBackground()
            GlassCard {
                Text("Solodko")
                    .font(SolodkoTheme.typography.screenTitle)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
            }
            .padding(SolodkoTheme.spacing.xl)
        }
    }
}

