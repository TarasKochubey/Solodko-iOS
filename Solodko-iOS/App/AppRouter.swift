import SwiftUI

struct AppRouter: View {
    @AppStorage("onboarding_complete") private var onboardingComplete = false

    var body: some View {
        if onboardingComplete {
            MainTabShell()
        } else {
            PreAppFlowView()
        }
    }
}
