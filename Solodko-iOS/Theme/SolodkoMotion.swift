import SwiftUI

struct SolodkoMotion {
    let fast = 0.150
    let normal = 0.300
    let slow = 0.450
    let backgroundBlend = 300.0
}

extension Animation {
    static var solodkoSpring: Animation {
        .spring(response: 0.4, dampingFraction: 0.95)
    }

    static var solodkoFastSpring: Animation {
        .spring(response: 0.25, dampingFraction: 0.90)
    }
}

