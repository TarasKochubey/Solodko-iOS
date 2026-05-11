import Observation
import SwiftUI

enum MealInputStatus: CaseIterable, Identifiable {
    case idle
    case listening
    case processing
    case clarifying
    case resultReady
    case lowConfidence
    case offline

    var id: String {
        String(describing: self)
    }
}

enum InputMethod {
    case text
    case voice
    case photo
    case barcode
    case recurring
}

struct ClarificationContext: Equatable {
    let question: String
    let resolvedFoodId: String
    var attemptCount: Int
}

@Observable
final class MealInputController {
    var status: MealInputStatus = .idle
    var inputMethod: InputMethod?
    var rawInput: String = ""
    var clarificationContext: ClarificationContext?
    var activeMealCard: MealObject?
    var isLoggingResult = false

    var orbState: OrbState {
        switch status {
        case .idle: return .idle
        case .listening: return .listening
        case .processing: return .processing
        case .clarifying: return .clarificationNeeded
        case .resultReady: return .resultReady
        case .lowConfidence, .offline: return .lowConfidence
        }
    }

    func beginListening() {
        inputMethod = .text
        status = .listening
    }

    @MainActor
    func submitText(_ text: String, reduceMotion: Bool) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            beginListening()
            return
        }

        rawInput = trimmed
        inputMethod = .text
        status = .processing

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.65))
            completeFakeResolution(for: trimmed)
        }
    }

    @MainActor
    func submitClarification(_ text: String, reduceMotion: Bool) {
        guard clarificationContext != nil else {
            submitText(text, reduceMotion: reduceMotion)
            return
        }

        status = .processing
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.45))
            activeMealCard = MealObject(
                foodName: "Borscht",
                carbGrams: 24,
                carbGramsPer100g: 8,
                portion: PortionObject(grams: 300),
                source: .aiEstimated
            )
            clarificationContext = nil
            status = .resultReady
        }
    }

    func startVoiceDemo() {
        inputMethod = .voice
        status = .listening
    }

    @MainActor
    func startPhotoDemo(reduceMotion: Bool) {
        inputMethod = .photo
        status = .processing
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.75))
            activeMealCard = MealObject(
                foodName: "Pasta with tomato sauce",
                carbGrams: 52,
                carbGramsPer100g: 21,
                kcal: 340,
                portion: PortionObject(grams: 250),
                source: .aiEstimated
            )
            status = .resultReady
        }
    }

    func startBarcodeDemo() {
        inputMethod = .barcode
        activeMealCard = MealObject(
            foodName: "Packaged kefir",
            carbGrams: 12,
            carbGramsPer100g: 4,
            portion: PortionObject(grams: 300),
            source: .exact
        )
        status = .resultReady
    }

    func useRecurringMeal(_ meal: RecurringMeal) {
        inputMethod = .recurring
        activeMealCard = meal.mealObject
        status = .resultReady
    }

    func showDemoState(_ demoState: MealInputStatus) {
        switch demoState {
        case .idle:
            reset()
        case .listening:
            status = .listening
        case .processing:
            status = .processing
        case .clarifying:
            clarificationContext = ClarificationContext(question: SolodkoCopy.Home.clarification, resolvedFoodId: "borscht", attemptCount: 0)
            status = .clarifying
        case .resultReady:
            activeMealCard = MealInputController.fakeResult
            status = .resultReady
        case .lowConfidence:
            activeMealCard = MealInputController.lowConfidenceResult
            status = .lowConfidence
        case .offline:
            activeMealCard = MealInputController.offlineResult
            status = .offline
        }
    }

    func beginLogAnimation() {
        isLoggingResult = true
    }

    func finishLogAnimation() {
        reset()
    }

    func reset() {
        status = .idle
        inputMethod = nil
        rawInput = ""
        clarificationContext = nil
        activeMealCard = nil
        isLoggingResult = false
    }

    private func completeFakeResolution(for text: String) {
        if text.localizedCaseInsensitiveContains("borscht") {
            clarificationContext = ClarificationContext(question: SolodkoCopy.Home.clarification, resolvedFoodId: "borscht", attemptCount: 0)
            status = .clarifying
        } else if text.localizedCaseInsensitiveContains("unknown") {
            activeMealCard = MealInputController.lowConfidenceResult
            status = .lowConfidence
        } else {
            activeMealCard = MealObject(
                foodName: text.capitalized,
                carbGrams: 42,
                carbGramsPer100g: 18,
                portion: PortionObject(grams: 230),
                source: .aiEstimated
            )
            status = .resultReady
        }
    }

    static let fakeResult = MealObject(
        foodName: "Rice bowl with egg",
        carbGrams: 46,
        carbGramsPer100g: 19,
        kcal: 420,
        portion: PortionObject(grams: 240),
        source: .aiEstimated
    )

    static let lowConfidenceResult = MealObject(
        foodName: "Mixed plate",
        carbGrams: 35,
        carbGramsPer100g: 16,
        portion: PortionObject(grams: 220),
        source: .notFound
    )

    static let offlineResult = MealObject(
        foodName: "Saved toast",
        carbGrams: 28,
        carbGramsPer100g: 23,
        portion: PortionObject(grams: 120),
        source: .offline
    )
}

