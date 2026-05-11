import SwiftUI

enum PermissionRecoveryKind {
    case camera
    case microphone

    var message: String {
        switch self {
        case .camera: return SolodkoCopy.PermissionRecovery.photoUnavailable
        case .microphone: return SolodkoCopy.PermissionRecovery.voiceUnavailable
        }
    }

    var announcement: String {
        switch self {
        case .camera: return SolodkoCopy.PermissionRecovery.cameraAnnouncement
        case .microphone: return SolodkoCopy.PermissionRecovery.microphoneAnnouncement
        }
    }
}

struct PermissionRecoveryInline: View {
    var kind: PermissionRecoveryKind
    var onTypeInstead: () -> Void = {}
    var onOpenSettings: () -> Void = {}

    var body: some View {
        GlassCard(radius: SolodkoTheme.radii.lg) {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.md) {
                Text(kind.message)
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .lineLimit(nil)

                FlowLayout(spacing: SolodkoTheme.spacing.sm) {
                    QuickActionChip(label: SolodkoCopy.PermissionRecovery.typeInstead, prominent: true, action: onTypeInstead)
                    QuickActionChip(label: SolodkoCopy.PermissionRecovery.openSettings, action: onOpenSettings)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(kind.message)
        .accessibilityHint(SolodkoCopy.PermissionRecovery.typeInstead)
    }
}
