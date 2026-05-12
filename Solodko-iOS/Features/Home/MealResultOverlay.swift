import SwiftUI

struct MealResultOverlay: View {
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    var onLogged: (MealObject) -> Void
    var onSaveToMemory: (MealObject) -> Void
    var onAdjustPortion: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var cardFocused: Bool

    var body: some View {
        if let meal = controller.activeMealCard {
            VStack {
                Spacer()
                MealCard(
                    meal: meal,
                    cardState: MealCardState(source: meal.source),
                    namespace: namespace,
                    isOverlay: true,
                    onLog: { log(meal) },
                    onAdjustPortion: onAdjustPortion,
                    onSaveToMemory: { onSaveToMemory(meal) },
                    onDismiss: { dismiss() }
                )
                .scaleEffect(controller.isLoggingResult && !reduceMotion ? 0.95 : 1)
                .opacity(controller.isLoggingResult ? 0 : 1)
                .accessibilityFocused($cardFocused)
                .padding(.horizontal, SolodkoTheme.spacing.xl)
                .padding(.bottom, SolodkoTheme.spacing.fourXL * 2 + SolodkoTheme.spacing.twoXL)
            }
            .transition(reduceMotion ? .opacity : .identity)
            .onAppear { cardFocused = true }
        }
    }

    private func log(_ meal: MealObject) {
        SolodkoTheme.haptics.mealLogged()
        onLogged(meal)
        controller.beginLogAnimation()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? SolodkoTheme.motion.fast : SolodkoTheme.motion.normal))
            withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
                controller.finishLogAnimation()
            }
        }
    }

    private func dismiss() {
        withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
            controller.reset()
        }
    }
}
