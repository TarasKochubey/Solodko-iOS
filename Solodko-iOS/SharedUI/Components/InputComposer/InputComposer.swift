import SwiftUI

struct InputComposer: View {
    @Bindable var controller: MealInputController
    var onTextSubmit: (String) -> Void
    var onVoiceTap: () -> Void
    var onCameraTap: () -> Void
    var onBarcodeTap: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
            if controller.status == .offline {
                Text(SolodkoCopy.Home.offline)
                    .font(SolodkoTheme.typography.microcopy)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    .accessibilityLabel(SolodkoCopy.Home.offline)
            }

            HStack(spacing: SolodkoTheme.spacing.sm) {
                TextField(SolodkoCopy.Home.textPlaceholder, text: $controller.rawInput)
                    .font(SolodkoTheme.typography.body)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .focused($focused)
                    .submitLabel(.done)
                    .onSubmit { submitCurrentText() }
                    .frame(minHeight: SolodkoTheme.spacing.minTouchTarget)
                    .accessibilitySortPriority(2)

                composerButton(systemName: "waveform", label: SolodkoCopy.Accessibility.voiceInput, hint: SolodkoCopy.Accessibility.voiceInputHint, action: onVoiceTap)
                    .accessibilitySortPriority(1)

                composerButton(systemName: "camera", label: SolodkoCopy.Accessibility.cameraInput, hint: SolodkoCopy.Accessibility.cameraInputHint, action: onCameraTap)
                    .accessibilitySortPriority(0.9)

                composerButton(systemName: "barcode.viewfinder", label: SolodkoCopy.Accessibility.barcodeScan, hint: SolodkoCopy.Accessibility.barcodeScanHint, action: onBarcodeTap)
                    .accessibilitySortPriority(0.8)
            }
            .padding(.leading, SolodkoTheme.spacing.lg)
            .padding(.trailing, SolodkoTheme.spacing.sm)
            .padding(.vertical, SolodkoTheme.spacing.sm)
            .glassMaterial(
                radius: SolodkoTheme.radii.pill,
                surface: SolodkoTheme.colors.surface.glassActive,
                active: focused || controller.status == .listening
            )
            .solodkoShadow(SolodkoTheme.shadows.secondary)
        }
        .onChange(of: focused) { _, isFocused in
            if isFocused && controller.status == .idle {
                controller.beginListening()
            }
        }
    }

    private func submitCurrentText() {
        onTextSubmit(controller.rawInput)
    }

    private func composerButton(systemName: String, label: String, hint: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.body.weight(.semibold))
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .frame(width: SolodkoTheme.spacing.minTouchTarget, height: SolodkoTheme.spacing.minTouchTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityHint(hint)
    }
}

