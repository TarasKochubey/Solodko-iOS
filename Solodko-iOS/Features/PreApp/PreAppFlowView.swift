import SwiftUI

private enum OnboardingStep: Equatable {
    case welcome
    case setup
    case permissions
    case auth
}

struct PreAppFlowView: View {
    @State private var step: OnboardingStep = .welcome
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            switch step {
            case .welcome:
                OnboardingWelcomeView {
                    advance(to: .setup)
                }
            case .setup:
                OnboardingSetupView(
                    onContinue: { advance(to: .permissions) },
                    onSkip: { advance(to: .permissions) }
                )
            case .permissions:
                OnboardingPermissionsView {
                    advance(to: .auth)
                }
            case .auth:
                AuthView()
            }
        }
        .animation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring, value: step)
    }

    private func advance(to nextStep: OnboardingStep) {
        withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
            step = nextStep
        }
    }
}

struct OnboardingWelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        OnboardingPageShell {
            Spacer()

            Text("Everything you need to count carbs. Nothing you don't.")
                .font(SolodkoTheme.typography.screenTitle)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            PrimaryOnboardingButton(title: "Get started", action: onContinue)
        }
    }
}

struct OnboardingSetupView: View {
    @Environment(PreferencesStore.self) private var preferencesStore
    @State private var selectedCarbUnit: CarbUnit = .grams
    @State private var selectedInsulinType: InsulinType?
    var onContinue: () -> Void
    var onSkip: () -> Void

    var body: some View {
        OnboardingPageShell {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                Text("Quick setup")
                    .font(SolodkoTheme.typography.screenTitle)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .lineLimit(nil)
                    .accessibilityAddTraits(.isHeader)

                Text("Optional preferences. Defaults work fine.")
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    .lineLimit(nil)
            }

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                Text("Carb unit")
                    .font(SolodkoTheme.typography.mealName)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)

                Picker("Carb unit", selection: $selectedCarbUnit) {
                    Text("Grams").tag(CarbUnit.grams)
                    Text("Ounces").tag(CarbUnit.ounces)
                }
                .pickerStyle(.segmented)

                Text("Insulin type")
                    .font(SolodkoTheme.typography.mealName)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)

                VStack(spacing: SolodkoTheme.spacing.sm) {
                    setupOption("Rapid", value: InsulinType.rapid)
                    setupOption("Slow", value: InsulinType.slow)
                    setupOption("Pump", value: InsulinType.pump)
                }
            }

            Spacer()

            VStack(spacing: SolodkoTheme.spacing.sm) {
                PrimaryOnboardingButton(title: "Continue") {
                    preferencesStore.carbUnit = selectedCarbUnit
                    preferencesStore.insulinType = selectedInsulinType
                    onContinue()
                }

                SecondaryOnboardingButton(title: "Skip for now", action: onSkip)
            }
        }
    }

    private func setupOption(_ title: String, value: InsulinType) -> some View {
        Button {
            selectedInsulinType = selectedInsulinType == value ? nil : value
        } label: {
            HStack {
                Text(title)
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                Spacer()
                Image(systemName: selectedInsulinType == value ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
            }
            .frame(minHeight: SolodkoTheme.spacing.minTouchTarget)
            .padding(.horizontal, SolodkoTheme.spacing.lg)
            .glassMaterial(
                radius: SolodkoTheme.radii.lg,
                surface: SolodkoTheme.colors.surface.glassPrimary,
                active: selectedInsulinType == value
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selectedInsulinType == value ? [.isButton, .isSelected] : .isButton)
    }
}

struct OnboardingPermissionsView: View {
    @State private var cameraMarked = false
    @State private var notificationsMarked = false
    @State private var healthMarked = false
    var onContinue: () -> Void

    var body: some View {
        OnboardingPageShell {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                Text("Permissions")
                    .font(SolodkoTheme.typography.screenTitle)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .lineLimit(nil)
                    .accessibilityAddTraits(.isHeader)

                Text("Choose what helps. Text input works either way.")
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    .lineLimit(nil)
            }

            VStack(spacing: SolodkoTheme.spacing.md) {
                PermissionRequestRow(
                    title: "Camera",
                    benefit: "Photograph meals and nutrition labels.",
                    marked: cameraMarked,
                    onAllow: { cameraMarked = true },
                    onSkip: { cameraMarked = false }
                )

                PermissionRequestRow(
                    title: "Notifications",
                    benefit: "Gentle reminders when it's mealtime.",
                    marked: notificationsMarked,
                    onAllow: { notificationsMarked = true },
                    onSkip: { notificationsMarked = false }
                )

                PermissionRequestRow(
                    title: "Apple Health",
                    benefit: "Connect your health data if you want.",
                    marked: healthMarked,
                    onAllow: { healthMarked = true },
                    onSkip: { healthMarked = false }
                )
            }

            Spacer()

            PrimaryOnboardingButton(title: "Continue", action: onContinue)
        }
    }
}

private struct OnboardingPageShell<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                content
            }
            .padding(SolodkoTheme.spacing.xl)
            .padding(.top, SolodkoTheme.spacing.fourXL)
            .padding(.bottom, SolodkoTheme.spacing.threeXL)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

private struct PermissionRequestRow: View {
    var title: String
    var benefit: String
    var marked: Bool
    var onAllow: () -> Void
    var onSkip: () -> Void

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.md) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.xs) {
                        Text(title)
                            .font(SolodkoTheme.typography.mealName)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                        Text(benefit)
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)
                    }

                    Spacer()

                    Image(systemName: marked ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                }

                HStack(spacing: SolodkoTheme.spacing.sm) {
                    QuickActionChip(label: "Allow", prominent: true, action: onAllow)
                    QuickActionChip(label: "Not now", prominent: false, action: onSkip)
                }
            }
        }
    }
}

private struct PrimaryOnboardingButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(SolodkoTheme.typography.body)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .frame(maxWidth: .infinity, minHeight: SolodkoTheme.spacing.minTouchTarget)
                .padding(.horizontal, SolodkoTheme.spacing.lg)
                .background(SolodkoTheme.colors.surface.solidSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

private struct SecondaryOnboardingButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(SolodkoTheme.typography.body)
                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                .frame(maxWidth: .infinity, minHeight: SolodkoTheme.spacing.minTouchTarget)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
