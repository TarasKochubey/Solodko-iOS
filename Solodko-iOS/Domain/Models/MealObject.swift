import Foundation

enum MealSource: String, CaseIterable {
    case exact
    case aiEstimated
    case fromLibrary
    case recurring
    case notFound
    case offline
}

struct MealObject: Identifiable, Equatable {
    let id: UUID
    var foodName: String
    var carbGrams: Double
    var carbGramsPer100g: Double
    var kcal: Double?
    var portion: PortionObject
    var source: MealSource
    var inlineSuggestion: String?

    init(
        id: UUID = UUID(),
        foodName: String,
        carbGrams: Double,
        carbGramsPer100g: Double,
        kcal: Double? = nil,
        portion: PortionObject,
        source: MealSource,
        inlineSuggestion: String? = nil
    ) {
        self.id = id
        self.foodName = foodName
        self.carbGrams = carbGrams
        self.carbGramsPer100g = carbGramsPer100g
        self.kcal = kcal
        self.portion = portion
        self.source = source
        self.inlineSuggestion = inlineSuggestion
    }
}

