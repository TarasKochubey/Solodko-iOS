import Observation

enum CarbUnit {
    case grams
}

@Observable
final class PreferencesStore {
    var carbUnit: CarbUnit = .grams
    var language: String = "system"
    var appleHealthConnected = false
}

