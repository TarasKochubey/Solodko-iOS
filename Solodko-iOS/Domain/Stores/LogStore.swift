import Observation
import Foundation

@Observable
final class LogStore {
    var todaysLog: [LoggedMeal] = []
    var isLoading = false
    var isOfflineMode = false

    func log(_ meal: MealObject) {
        todaysLog.insert(LoggedMeal(meal: meal), at: 0)
    }

    static let previewTodaysLog: [LoggedMeal] = [
        LoggedMeal(
            meal: MealObject(
                foodName: "Oatmeal",
                carbGrams: 34,
                carbGramsPer100g: 17,
                portion: PortionObject(grams: 200),
                source: .fromLibrary
            )
        )
    ]
}
