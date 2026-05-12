import Observation
import Foundation

@Observable
final class FoodMemoryStore {
    var savedFoods: [SavedFood] = []
    var isLoading = false

    func update(with meal: MealObject) {
        guard meal.source != .notFound else { return }

        if let index = savedFoods.firstIndex(where: { $0.foodName.localizedCaseInsensitiveCompare(meal.foodName) == .orderedSame }) {
            savedFoods[index].usualPortion = meal.portion
            savedFoods[index].carbGrams = meal.carbGrams
            savedFoods[index].carbGramsPer100g = meal.carbGramsPer100g
        } else {
            savedFoods.insert(
                SavedFood(
                    foodName: meal.foodName,
                    usualPortion: meal.portion,
                    carbGrams: meal.carbGrams,
                    carbGramsPer100g: meal.carbGramsPer100g
                ),
                at: 0
            )
        }
    }

    static let previewSavedFoods: [SavedFood] = [
        SavedFood(foodName: "Greek yogurt with berries", usualPortion: PortionObject(grams: 220), carbGrams: 26, carbGramsPer100g: 12),
        SavedFood(foodName: "Buckwheat with chicken", usualPortion: PortionObject(grams: 280), carbGrams: 38, carbGramsPer100g: 14),
        SavedFood(foodName: "Apple and peanut butter", usualPortion: PortionObject(grams: 170), carbGrams: 24, carbGramsPer100g: 14)
    ]
}
