import SwiftUI

struct ConsoleView: View {
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("debug_preview_data_enabled") private var debugPreviewDataEnabled = false

    var body: some View {
        VStack(spacing: SolodkoTheme.spacing.sm) {
            AIOrb(state: controller.orbState, onTap: {
                if controller.status == .idle {
                    withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
                        controller.beginListening()
                    }
                }
            }, namespace: namespace)
            .accessibilitySortPriority(3)

            InputComposer(
                controller: controller,
                onTextSubmit: { text in
                    if controller.status == .clarifying {
                        controller.submitClarification(text, reduceMotion: reduceMotion)
                    } else {
                        controller.submitText(text, reduceMotion: reduceMotion)
                    }
                },
                onVoiceTap: { handleVoiceTap() },
                onCameraTap: { handleCameraTap() },
                onBarcodeTap: { handleBarcodeTap() }
            )
            .accessibilitySortPriority(2)
        }
        .padding(.top, SolodkoTheme.spacing.md)
    }

    private func handleVoiceTap() {
        if debugPreviewDataEnabled {
            controller.startVoiceDemo()
        } else {
            controller.showUnavailableInput(SolodkoCopy.Home.voiceUnavailable, method: .voice)
        }
    }

    private func handleCameraTap() {
        if debugPreviewDataEnabled {
            controller.startPhotoDemo(reduceMotion: reduceMotion)
        } else {
            controller.showUnavailableInput(SolodkoCopy.Home.cameraUnavailable, method: .photo)
        }
    }

    private func handleBarcodeTap() {
        if debugPreviewDataEnabled {
            controller.startBarcodeDemo(reduceMotion: reduceMotion)
        } else {
            controller.showUnavailableInput(SolodkoCopy.Home.barcodeUnavailable, method: .barcode)
        }
    }
}
