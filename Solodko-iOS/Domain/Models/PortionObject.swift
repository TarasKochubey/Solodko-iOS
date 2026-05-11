import Foundation

struct PortionObject: Identifiable, Equatable {
    let id = UUID()
    var grams: Double

    var displayText: String {
        "\(Int(grams))g"
    }
}

