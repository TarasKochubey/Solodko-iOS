import SwiftUI

struct OnboardingWelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                Spacer()

                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                    Text(SolodkoCopy.PreApp.welcomeTitle)
                        .font(SolodkoTheme.typography.timeHeader)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .lineLimit(nil)
                        .accessibilityAddTraits(.isHeader)

                    Text(SolodkoCopy.PreApp.welcomeBody)
                        .font(SolodkoTheme.typography.body)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                }

                Spacer()

                QuickActionChip(label: SolodkoCopy.PreApp.welcomeContinue, prominent: true, action: onContinue)
                    .accessibilityHint(SolodkoCopy.PreApp.welcomeBody)
            }
            .padding(SolodkoTheme.spacing.xl)
            .padding(.bottom, SolodkoTheme.spacing.threeXL)
        }
    }
}
