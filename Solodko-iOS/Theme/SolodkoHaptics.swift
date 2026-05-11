import UIKit

struct SolodkoHaptics {
    func orbTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func quickAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func mealLogged() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

