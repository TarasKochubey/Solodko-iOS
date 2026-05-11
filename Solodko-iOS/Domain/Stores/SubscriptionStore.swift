import Observation

enum SubscriptionStatus {
    case loading
    case freeTier
    case premium
    case error
}

@Observable
final class SubscriptionStore {
    var status: SubscriptionStatus = .freeTier
}

