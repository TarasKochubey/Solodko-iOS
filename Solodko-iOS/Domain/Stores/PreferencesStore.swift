import Observation

enum CarbUnit: Hashable {
    case grams
    case ounces
}

enum InsulinType: Hashable {
    case rapid
    case slow
    case pump
}

@Observable
final class PreferencesStore {
    var carbUnit: CarbUnit = .grams
    var insulinType: InsulinType?
    var language: String = "system"
    var appleHealthConnected = false
}
