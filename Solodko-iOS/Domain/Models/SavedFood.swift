import Foundation

struct SavedFood: Identifiable, Equatable {
    let id: UUID
    var foodName: String
    var usualPortion: PortionObject
    var carbGrams: Double
    var carbGramsPer100g: Double

    init(
        id: UUID = UUID(),
        foodName: String,
        usualPortion: PortionObject,
        carbGrams: Double,
        carbGramsPer100g: Double
    ) {
        self.id = id
        self.foodName = foodName
        self.usualPortion = usualPortion
        self.carbGrams = carbGrams
        self.carbGramsPer100g = carbGramsPer100g
    }
}
