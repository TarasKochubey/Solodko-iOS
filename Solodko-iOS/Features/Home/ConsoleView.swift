import SwiftUI

struct ConsoleView: View {
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: SolodkoTheme.spacing.lg) {
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
                onVoiceTap: { controller.startVoiceDemo() },
                onCameraTap: { controller.startPhotoDemo(reduceMotion: reduceMotion) },
                onBarcodeTap: { controller.startBarcodeDemo() }
            )
            .accessibilitySortPriority(2)
        }
    }
}

