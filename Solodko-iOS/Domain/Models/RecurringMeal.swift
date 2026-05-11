import Foundation

struct RecurringMeal: Identifiable, Equatable {
    let id: UUID
    var foodName: String
    var lastPortion: PortionObject
    var carbGrams: Double
    var carbGramsPer100g: Double
    var timeOfDayBucket: TimeOfDayBucket

    init(
        id: UUID = UUID(),
        foodName: String,
        lastPortion: PortionObject,
        carbGrams: Double,
        carbGramsPer100g: Double,
        timeOfDayBucket: TimeOfDayBucket
    ) {
        self.id = id
        self.foodName = foodName
        self.lastPortion = lastPortion
        self.carbGrams = carbGrams
        self.carbGramsPer100g = carbGramsPer100g
        self.timeOfDayBucket = timeOfDayBucket
    }

    var mealObject: MealObject {
        MealObject(
            foodName: foodName,
            carbGrams: carbGrams,
            carbGramsPer100g: carbGramsPer100g,
            portion: lastPortion,
            source: .recurring,
            inlineSuggestion: SolodkoCopy.Home.recurringTitle
        )
    }
}

