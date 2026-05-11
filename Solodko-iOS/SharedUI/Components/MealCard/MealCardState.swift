import SwiftUI

enum MealCardState: String, CaseIterable, Identifiable {
    case exact
    case aiEstimated
    case fromLibrary
    case recurring
    case notFound
    case offline

    var id: String { rawValue }

    init(source: MealSource) {
        switch source {
        case .exact: self = .exact
        case .aiEstimated: self = .aiEstimated
        case .fromLibrary: self = .fromLibrary
        case .recurring: self = .recurring
        case .notFound: self = .notFound
        case .offline: self = .offline
        }
    }

    var badgeText: String? {
        switch self {
        case .exact, .recurring:
            return nil
        case .aiEstimated:
            return SolodkoCopy.Badges.estimated
        case .fromLibrary:
            return SolodkoCopy.Badges.yourFood
        case .notFound:
            return SolodkoCopy.Badges.notFound
        case .offline:
            return SolodkoCopy.Badges.offline
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .exact: return "Exact match"
        case .aiEstimated: return SolodkoCopy.Badges.estimated
        case .fromLibrary: return "From your food memory"
        case .recurring: return "Recurring meal"
        case .notFound: return SolodkoCopy.Badges.notFound
        case .offline: return SolodkoCopy.Home.offline
        }
    }

    var glowColor: Color {
        switch self {
        case .exact:
            return SolodkoTheme.colors.confidence.exactGlow
        case .fromLibrary, .recurring:
            return SolodkoTheme.colors.confidence.memoryGlow
        case .aiEstimated:
            return SolodkoTheme.colors.confidence.estimatedGlow
        case .notFound, .offline:
            return SolodkoTheme.colors.confidence.lowConfidence
        }
    }
}

