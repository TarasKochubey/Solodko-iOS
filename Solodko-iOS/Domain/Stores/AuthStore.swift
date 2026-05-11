import Observation
import Foundation

enum AuthStatus {
    case loading
    case unauthenticated
    case authenticated
    case error
}

@Observable
final class AuthStore {
    var status: AuthStatus = .unauthenticated
    var userId: String?
}
