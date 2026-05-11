import SwiftUI

struct OnboardingPermissionsView: View {
    var onContinue: () -> Void

    @State private var options = PermissionOption.mockOptions

    var body: some View {
        ZStack {
            AtmosphericBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                        Text(SolodkoCopy.PreApp.permissionsTitle)
                            .font(SolodkoTheme.typography.screenTitle)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(nil)
                            .accessibilityAddTraits(.isHeader)

                        Text(SolodkoCopy.PreApp.permissionsBody)
                            .font(SolodkoTheme.typography.body)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)
                    }

                    VStack(spacing: SolodkoTheme.spacing.lg) {
                        ForEach($options) { $option in
                            PermissionOptionRow(option: $option)
                        }
                    }

                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                        Text(SolodkoCopy.PreApp.permissionsFootnote)
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)

                        PermissionRecoveryInline(kind: .camera)
                        PermissionRecoveryInline(kind: .microphone)
                    }

                    QuickActionChip(label: SolodkoCopy.PreApp.continueAction, prominent: true, action: onContinue)
                        .accessibilityHint(SolodkoCopy.PreApp.permissionsFootnote)
                }
                .padding(SolodkoTheme.spacing.xl)
                .padding(.top, SolodkoTheme.spacing.fourXL)
                .padding(.bottom, SolodkoTheme.spacing.fourXL)
            }
        }
    }
}

private struct PermissionOption: Identifiable {
    let id = UUID()
    var title: String
    var body: String
    var isEnabled: Bool

    static let mockOptions = [
        PermissionOption(title: SolodkoCopy.PreApp.cameraTitle, body: SolodkoCopy.PreApp.cameraBody, isEnabled: false),
        PermissionOption(title: SolodkoCopy.PreApp.microphoneTitle, body: SolodkoCopy.PreApp.microphoneBody, isEnabled: false),
        PermissionOption(title: SolodkoCopy.PreApp.notificationsTitle, body: SolodkoCopy.PreApp.notificationsBody, isEnabled: false),
        PermissionOption(title: SolodkoCopy.PreApp.appleHealthTitle, body: SolodkoCopy.PreApp.appleHealthBody, isEnabled: false)
    ]
}

private struct PermissionOptionRow: View {
    @Binding var option: PermissionOption

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.md) {
                HStack(alignment: .top, spacing: SolodkoTheme.spacing.lg) {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
                        Text(option.title)
                            .font(SolodkoTheme.typography.body)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(nil)

                        Text(option.body)
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)
                    }

                    Spacer(minLength: SolodkoTheme.spacing.sm)

                    Text(option.isEnabled ? SolodkoCopy.PreApp.enabledValue : SolodkoCopy.PreApp.skippedValue)
                        .font(SolodkoTheme.typography.badge)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                }

                Button {
                    option.isEnabled.toggle()
                } label: {
                    Text(option.isEnabled ? SolodkoCopy.PreApp.skipAction : SolodkoCopy.PreApp.enableAction)
                        .font(SolodkoTheme.typography.badge)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .frame(minHeight: SolodkoTheme.spacing.minTouchTarget)
                        .padding(.horizontal, SolodkoTheme.spacing.lg)
                        .background(SolodkoTheme.colors.surface.solidSecondary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(option.isEnabled ? SolodkoCopy.PreApp.skipAction : SolodkoCopy.PreApp.enableAction)
                .accessibilityHint(option.body)
            }
        }
        .accessibilityElement(children: .contain)
    }
}
