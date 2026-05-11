import Foundation

struct LoggedMeal: Identifiable, Equatable {
    let id: UUID
    var meal: MealObject
    var loggedAt: Date

    init(id: UUID = UUID(), meal: MealObject, loggedAt: Date = Date()) {
        self.id = id
        self.meal = meal
        self.loggedAt = loggedAt
    }
}

