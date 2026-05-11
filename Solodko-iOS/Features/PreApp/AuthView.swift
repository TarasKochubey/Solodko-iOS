import SwiftUI

struct AuthView: View {
    var onContinue: () -> Void = {}

    var body: some View {
        ZStack {
            AtmosphericBackground()

            GlassCard {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                    Text(SolodkoCopy.PreApp.authTitle)
                        .font(SolodkoTheme.typography.screenTitle)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .lineLimit(nil)
                        .accessibilityAddTraits(.isHeader)

                    Text(SolodkoCopy.PreApp.authBody)
                        .font(SolodkoTheme.typography.body)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)

                    QuickActionChip(label: SolodkoCopy.PreApp.authContinue, prominent: true, action: onContinue)
                        .accessibilityHint(SolodkoCopy.PreApp.authBody)
                }
            }
            .padding(SolodkoTheme.spacing.xl)
        }
    }
}
