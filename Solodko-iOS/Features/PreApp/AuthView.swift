import SwiftUI

struct AuthView: View {
    @Environment(AuthStore.self) private var authStore
    @AppStorage("onboarding_complete") private var onboardingComplete = false

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                    Text("Solodko")
                        .font(SolodkoTheme.typography.screenTitle)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .accessibilityAddTraits(.isHeader)

                    Text("Create an account to sync later, or keep using Solodko on this device.")
                        .font(SolodkoTheme.typography.body)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                }

                VStack(spacing: SolodkoTheme.spacing.md) {
                    authButton(title: "Continue with Apple", systemImage: "apple.logo") {
                        finishAuth { authStore.completeMockSignIn(provider: "apple") }
                    }

                    authButton(title: "Continue with Google", systemImage: "g.circle") {
                        finishAuth { authStore.completeMockSignIn(provider: "google") }
                    }

                    authButton(title: "Continue with email", systemImage: "envelope") {
                        finishAuth { authStore.completeMockSignIn(provider: "email") }
                    }
                }

                Spacer()

                Button {
                    finishAuth { authStore.continueWithoutAccount() }
                } label: {
                    VStack(spacing: SolodkoTheme.spacing.xs) {
                        Text("Continue without account")
                            .font(SolodkoTheme.typography.body)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                        Text("Data won't sync across devices.")
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: SolodkoTheme.spacing.minTouchTarget)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Continue without account")
                .accessibilityHint("Data will not sync across devices")
            }
            .padding(SolodkoTheme.spacing.xl)
            .padding(.top, SolodkoTheme.spacing.fourXL)
            .padding(.bottom, SolodkoTheme.spacing.threeXL)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }

    private func authButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: SolodkoTheme.spacing.md) {
                Image(systemName: systemImage)
                    .font(.body.weight(.semibold))
                    .frame(width: SolodkoTheme.spacing.minTouchTarget, height: SolodkoTheme.spacing.minTouchTarget)

                Text(title)
                    .font(SolodkoTheme.typography.body)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()
            }
            .foregroundStyle(SolodkoTheme.colors.text.primary)
            .padding(.horizontal, SolodkoTheme.spacing.lg)
            .frame(maxWidth: .infinity, minHeight: SolodkoTheme.spacing.minTouchTarget)
            .glassMaterial(
                radius: SolodkoTheme.radii.pill,
                surface: SolodkoTheme.colors.surface.glassActive,
                active: true
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private func finishAuth(_ action: () -> Void) {
        action()
        onboardingComplete = true
    }
}
