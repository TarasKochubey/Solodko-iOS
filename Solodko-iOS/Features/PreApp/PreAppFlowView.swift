import SwiftUI

enum OnboardingStep {
    case welcome
    case setup
    case permissions
    case auth
}

struct PreAppFlowView: View {
    @Environment(AuthStore.self) private var authStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var step: OnboardingStep = .welcome

    var body: some View {
        ZStack {
            switch step {
            case .welcome:
                OnboardingWelcomeView {
                    move(to: .setup)
                }
                .transition(.opacity)
            case .setup:
                OnboardingSetupView(
                    onContinue: { move(to: .permissions) },
                    onSkip: { move(to: .permissions) }
                )
                .transition(.opacity)
            case .permissions:
                OnboardingPermissionsView {
                    move(to: .auth)
                }
                .transition(.opacity)
            case .auth:
                AuthView {
                    authStore.userId = "local-onboarding-demo"
                    authStore.status = .authenticated
                }
                .transition(.opacity)
            }
        }
        .animation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring, value: step)
    }

    private func move(to nextStep: OnboardingStep) {
        step = nextStep
    }
}
