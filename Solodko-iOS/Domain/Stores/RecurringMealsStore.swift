import Observation

@Observable
final class RecurringMealsStore {
    var meals: [RecurringMeal] = []
    var timeOfDayBucket: TimeOfDayBucket = TimeOfDayProvider().bucket()

    func mealsForCurrentMoment() -> [RecurringMeal] {
        let matches = meals.filter { $0.timeOfDayBucket == timeOfDayBucket }
        return Array((matches.isEmpty ? meals : matches).prefix(3))
    }

    static let previewMeals: [RecurringMeal] = [
        RecurringMeal(foodName: "Greek yogurt with berries", lastPortion: PortionObject(grams: 220), carbGrams: 26, carbGramsPer100g: 12, timeOfDayBucket: .morning),
        RecurringMeal(foodName: "Buckwheat bowl", lastPortion: PortionObject(grams: 280), carbGrams: 38, carbGramsPer100g: 14, timeOfDayBucket: .afternoon),
        RecurringMeal(foodName: "Vegetable soup", lastPortion: PortionObject(grams: 300), carbGrams: 18, carbGramsPer100g: 6, timeOfDayBucket: .evening),
        RecurringMeal(foodName: "Toast with avocado", lastPortion: PortionObject(grams: 120), carbGrams: 28, carbGramsPer100g: 23, timeOfDayBucket: .morning)
    ]
}
