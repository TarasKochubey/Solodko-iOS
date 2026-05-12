import Observation

@Observable
final class FoodMemoryStore {
    var savedFoods: [SavedFood] = []
    var isLoading = false

    static let previewSavedFoods: [SavedFood] = [
        SavedFood(foodName: "Greek yogurt with berries", usualPortion: PortionObject(grams: 220), carbGrams: 26, carbGramsPer100g: 12),
        SavedFood(foodName: "Buckwheat with chicken", usualPortion: PortionObject(grams: 280), carbGrams: 38, carbGramsPer100g: 14),
        SavedFood(foodName: "Apple and peanut butter", usualPortion: PortionObject(grams: 170), carbGrams: 24, carbGramsPer100g: 14)
    ]
}
