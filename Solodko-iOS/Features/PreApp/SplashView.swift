import SwiftUI

struct SplashView: View {
    @Namespace private var namespace

    var body: some View {
        ZStack {
            AtmosphericBackground()
            AIOrb(state: .processing, onTap: {}, namespace: namespace)
        }
    }
}
