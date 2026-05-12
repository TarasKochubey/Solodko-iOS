import Foundation
import SwiftUI

enum TimeOfDayBucket: String, CaseIterable, Identifiable {
    case morning
    case afternoon
    case evening
    case night

    var id: String { rawValue }
}

struct TimeOfDayProvider {
    var now: () -> Date = Date.init
    var calendar: Calendar = .current

    func bucket(for date: Date? = nil) -> TimeOfDayBucket {
        let hour = calendar.component(.hour, from: date ?? now())
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<24: return .evening
        default: return .night
        }
    }

    func label(for bucket: TimeOfDayBucket) -> String {
        switch bucket {
        case .morning: return SolodkoCopy.TimeOfDay.morning
        case .afternoon: return SolodkoCopy.TimeOfDay.afternoon
        case .evening: return SolodkoCopy.TimeOfDay.evening
        case .night: return SolodkoCopy.TimeOfDay.night
        }
    }

    func gradientColors(for bucket: TimeOfDayBucket) -> [Color] {
        switch bucket {
        case .morning: return SolodkoTheme.colors.background.morning
        case .afternoon: return SolodkoTheme.colors.background.afternoon
        case .evening: return SolodkoTheme.colors.background.eveningDusk
        case .night: return [SolodkoTheme.colors.background.eveningDusk[1], SolodkoTheme.colors.background.warmPlum, SolodkoTheme.colors.background.ivoryBase]
        }
    }
}

private struct TimeOfDayProviderKey: EnvironmentKey {
    static let defaultValue = TimeOfDayProvider()
}

extension EnvironmentValues {
    var timeOfDayProvider: TimeOfDayProvider {
        get { self[TimeOfDayProviderKey.self] }
        set { self[TimeOfDayProviderKey.self] = newValue }
    }
}
