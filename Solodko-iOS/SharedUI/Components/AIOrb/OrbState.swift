import Foundation

enum OrbState: String, CaseIterable, Identifiable {
    case idle
    case listening
    case processing
    case clarificationNeeded
    case resultReady
    case lowConfidence

    var id: String { rawValue }

    var accessibilityValue: String {
        switch self {
        case .idle: return ""
        case .listening: return SolodkoCopy.Accessibility.listening
        case .processing: return SolodkoCopy.Accessibility.identifyingFood
        case .clarificationNeeded: return SolodkoCopy.Accessibility.portionNeeded
        case .resultReady: return SolodkoCopy.Accessibility.mealIdentified
        case .lowConfidence: return SolodkoCopy.Accessibility.moreInformationNeeded
        }
    }
}

