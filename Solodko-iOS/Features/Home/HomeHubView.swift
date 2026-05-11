import SwiftUI

struct HomeHubView: View {
    @Environment(LogStore.self) private var logStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var controller = MealInputController()
    @Namespace private var mealNamespace

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(spacing: SolodkoTheme.spacing.stageGap) {
                StageView(controller: controller, namespace: mealNamespace)
                    .frame(maxHeight: .infinity, alignment: .top)

                ConsoleView(controller: controller, namespace: mealNamespace)
            }
            .padding(.horizontal, SolodkoTheme.spacing.xl)
            .padding(.top, SolodkoTheme.spacing.fourXL)
            .padding(.bottom, SolodkoTheme.spacing.xl)

            if controller.status == .resultReady || controller.status == .lowConfidence || controller.status == .offline {
                MealResultOverlay(
                    controller: controller,
                    namespace: mealNamespace,
                    onLogged: { meal in logStore.log(meal) }
                )
                .zIndex(2)
                .transition(reduceMotion ? .opacity : .identity)
            }

            if controller.status == .clarifying {
                ClarificationPromptView(controller: controller)
                    .zIndex(3)
            }
        }
    }
}
