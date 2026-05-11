import SwiftUI

struct OnboardingSetupView: View {
    var onContinue: () -> Void
    var onSkip: () -> Void

    private let rows = [
        SetupRow(title: SolodkoCopy.PreApp.setupInsulin, value: SolodkoCopy.PreApp.setupInsulinValue),
        SetupRow(title: SolodkoCopy.PreApp.setupCarbUnit, value: SolodkoCopy.PreApp.setupCarbUnitValue),
        SetupRow(title: SolodkoCopy.PreApp.setupAllergens, value: SolodkoCopy.PreApp.setupAllergensValue)
    ]

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(spacing: SolodkoTheme.spacing.lg) {
                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                            Text(SolodkoCopy.PreApp.setupTitle)
                                .font(SolodkoTheme.typography.screenTitle)
                                .foregroundStyle(SolodkoTheme.colors.text.primary)
                                .lineLimit(nil)
                                .accessibilityAddTraits(.isHeader)

                            Text(SolodkoCopy.PreApp.setupBody)
                                .font(SolodkoTheme.typography.body)
                                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                                .lineLimit(nil)
                        }

                        VStack(spacing: SolodkoTheme.spacing.lg) {
                            ForEach(rows) { row in
                                SetupOptionRow(row: row)
                            }
                        }
                    }
                    .padding(SolodkoTheme.spacing.xl)
                    .padding(.top, SolodkoTheme.spacing.fourXL)
                    .padding(.bottom, SolodkoTheme.spacing.lg)
                }

                VStack(spacing: SolodkoTheme.spacing.md) {
                    QuickActionChip(label: SolodkoCopy.PreApp.continueAction, prominent: true, action: onContinue)
                        .accessibilityHint(SolodkoCopy.PreApp.setupBody)

                    Button(action: onSkip) {
                        Text(SolodkoCopy.PreApp.skipAction)
                            .font(SolodkoTheme.typography.badge)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .frame(minHeight: SolodkoTheme.spacing.minTouchTarget)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(SolodkoCopy.PreApp.skipAction)
                    .accessibilityHint(SolodkoCopy.PreApp.setupBody)
                }
                .padding(SolodkoTheme.spacing.xl)
            }
        }
    }
}

private struct SetupRow: Identifiable {
    let id = UUID()
    var title: String
    var value: String
}

private struct SetupOptionRow: View {
    var row: SetupRow

    var body: some View {
        GlassCard {
            HStack(alignment: .firstTextBaseline, spacing: SolodkoTheme.spacing.lg) {
                Text(row.title)
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .lineLimit(nil)

                Spacer(minLength: SolodkoTheme.spacing.sm)

                Text(row.value)
                    .font(SolodkoTheme.typography.microcopy)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    .lineLimit(nil)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(row.title), \(row.value)")
    }
}
