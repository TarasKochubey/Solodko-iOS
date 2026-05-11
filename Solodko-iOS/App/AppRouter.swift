import SwiftUI

struct AppRouter: View {
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        switch authStore.status {
        case .loading:
            SplashView()
        case .unauthenticated, .error:
            AuthView()
        case .authenticated:
            MainTabShell()
        }
    }
}

