import Observation
import SwiftUI

enum MealInputStatus: CaseIterable, Identifiable {
    case idle
    case listening
    case processing
    case clarifying
    case disambiguating
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

struct DisambiguationOption: Identifiable, Equatable {
    let id: String
    var foodName: String
    var descriptor: String
    var carbGramsPer100g: Double
    var defaultPortion: PortionObject
}

@Observable
final class MealInputController {
    var status: MealInputStatus = .idle
    var inputMethod: InputMethod?
    var rawInput: String = ""
    var clarificationContext: ClarificationContext?
    var disambiguationOptions: [DisambiguationOption] = []
    var activeMealCard: MealObject?
    var isLoggingResult = false
    var inlineUnavailableMessage: String?
    private var pendingClarifiedFood: ResolvedMealDraft?

    var orbState: OrbState {
        switch status {
        case .idle: return .idle
        case .listening: return .listening
        case .processing: return .processing
        case .clarifying: return .clarificationNeeded
        case .disambiguating: return .lowConfidence
        case .resultReady: return .resultReady
        case .lowConfidence, .offline: return .lowConfidence
        }
    }

    func beginListening() {
        inputMethod = .text
        status = .listening
        inlineUnavailableMessage = nil
    }

    @MainActor
    func submitText(_ text: String, savedFoods: [SavedFood] = [], reduceMotion: Bool) {
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
            completeFakeResolution(for: trimmed, savedFoods: savedFoods, reduceMotion: reduceMotion)
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
            let portion = PortionObject(grams: parsePortionGrams(from: text) ?? pendingClarifiedFood?.defaultPortion.grams ?? 100)
            let draft = pendingClarifiedFood ?? ResolvedMealDraft(foodName: "Borscht", carbGramsPer100g: 8, source: .aiEstimated)
            activeMealCard = MealObject(
                foodName: draft.foodName,
                carbGrams: draft.carbGramsPer100g * portion.grams / 100,
                carbGramsPer100g: draft.carbGramsPer100g,
                portion: portion,
                source: draft.source,
                inlineSuggestion: SolodkoCopy.Home.estimatedHint
            )
            clarificationContext = nil
            pendingClarifiedFood = nil
            setStatus(.resultReady, reduceMotion: reduceMotion)
        }
    }

    @MainActor
    func startVoiceDemo(reduceMotion: Bool) {
        inputMethod = .voice
        status = .listening
        inlineUnavailableMessage = nil
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.7))
            rawInput = "100g pasta with tomato sauce"
            status = .processing
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.55))
            activeMealCard = MealObject(
                foodName: "Pasta with tomato sauce",
                carbGrams: 21,
                carbGramsPer100g: 21,
                portion: PortionObject(grams: 100),
                source: .aiEstimated,
                inlineSuggestion: SolodkoCopy.Home.estimatedHint
            )
            setStatus(.resultReady, reduceMotion: reduceMotion)
        }
    }

    @MainActor
    func processPhotoInput(reduceMotion: Bool) {
        inputMethod = .photo
        inlineUnavailableMessage = nil
        status = .processing
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.75))
            activeMealCard = MealObject(
                foodName: "Pasta with tomato sauce",
                carbGrams: 52,
                carbGramsPer100g: 21,
                kcal: 340,
                portion: PortionObject(grams: 250),
                source: .aiEstimated,
                inlineSuggestion: SolodkoCopy.Home.estimatedHint
            )
            setStatus(.resultReady, reduceMotion: reduceMotion)
        }
    }

    @MainActor
    func processBarcodeInput(reduceMotion: Bool) {
        inputMethod = .barcode
        inlineUnavailableMessage = nil
        status = .processing
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.15 : 0.45))
            activeMealCard = MealObject(
                foodName: "Packaged kefir",
                carbGrams: 12,
                carbGramsPer100g: 4,
                portion: PortionObject(grams: 300),
                source: .exact
            )
            setStatus(.resultReady, reduceMotion: reduceMotion)
        }
    }

    func showUnavailableInput(_ message: String, method: InputMethod) {
        inputMethod = method
        activeMealCard = nil
        clarificationContext = nil
        inlineUnavailableMessage = message
        status = .listening
    }

    func useRecurringMeal(_ meal: RecurringMeal) {
        inputMethod = .recurring
        activeMealCard = meal.mealObject
        status = .resultReady
    }

    func selectDisambiguationOption(_ option: DisambiguationOption, reduceMotion: Bool) {
        activeMealCard = MealObject(
            foodName: option.foodName,
            carbGrams: option.carbGramsPer100g * option.defaultPortion.grams / 100,
            carbGramsPer100g: option.carbGramsPer100g,
            portion: option.defaultPortion,
            source: .fromLibrary
        )
        disambiguationOptions = []
        setStatus(.resultReady, reduceMotion: reduceMotion)
    }

    func rejectDisambiguationOptions() {
        disambiguationOptions = []
        activeMealCard = nil
        status = .listening
    }

    func adjustActivePortion() {
        guard let meal = activeMealCard else { return }
        pendingClarifiedFood = ResolvedMealDraft(
            foodName: meal.foodName,
            carbGramsPer100g: meal.carbGramsPer100g,
            source: meal.source,
            defaultPortion: meal.portion
        )
        activeMealCard = nil
        clarificationContext = ClarificationContext(question: SolodkoCopy.Home.clarification, resolvedFoodId: meal.foodName.lowercased(), attemptCount: 0)
        status = .clarifying
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
        case .disambiguating:
            disambiguationOptions = MealInputController.demoDisambiguationOptions
            status = .disambiguating
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
        disambiguationOptions = []
        activeMealCard = nil
        isLoggingResult = false
        inlineUnavailableMessage = nil
        pendingClarifiedFood = nil
    }

    private func completeFakeResolution(for text: String, savedFoods: [SavedFood], reduceMotion: Bool) {
        if let savedFood = savedFoods.first(where: { text.localizedCaseInsensitiveContains($0.foodName) || $0.foodName.localizedCaseInsensitiveContains(text) }) {
            activeMealCard = MealObject(
                foodName: savedFood.foodName,
                carbGrams: savedFood.carbGrams,
                carbGramsPer100g: savedFood.carbGramsPer100g,
                portion: savedFood.usualPortion,
                source: .fromLibrary
            )
            setStatus(.resultReady, reduceMotion: reduceMotion)
        } else if text.localizedCaseInsensitiveContains("borscht") && parsePortionGrams(from: text) == nil {
            pendingClarifiedFood = ResolvedMealDraft(foodName: "Borscht", carbGramsPer100g: 8, source: .aiEstimated, defaultPortion: PortionObject(grams: 300))
            clarificationContext = ClarificationContext(question: SolodkoCopy.Home.clarification, resolvedFoodId: "borscht", attemptCount: 0)
            setStatus(.clarifying, reduceMotion: reduceMotion)
        } else if text.localizedCaseInsensitiveContains("apple") || text.localizedCaseInsensitiveContains("soup") {
            disambiguationOptions = MealInputController.demoDisambiguationOptions
            setStatus(.disambiguating, reduceMotion: reduceMotion)
        } else if text.localizedCaseInsensitiveContains("unknown") {
            activeMealCard = MealInputController.lowConfidenceResult
            setStatus(.lowConfidence, reduceMotion: reduceMotion)
        } else {
            let portion = PortionObject(grams: parsePortionGrams(from: text) ?? 230)
            let carbsPer100g = text.localizedCaseInsensitiveContains("banana") ? 23.0 : 18.0
            activeMealCard = MealObject(
                foodName: text.capitalized,
                carbGrams: carbsPer100g * portion.grams / 100,
                carbGramsPer100g: carbsPer100g,
                portion: portion,
                source: .aiEstimated,
                inlineSuggestion: SolodkoCopy.Home.estimatedHint
            )
            setStatus(.resultReady, reduceMotion: reduceMotion)
        }
    }

    private func parsePortionGrams(from text: String) -> Double? {
        let pattern = #"(\d+(?:[\.,]\d+)?)\s*(g|gram|grams|гр|г|грам|грамів)?"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return nil }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, range: range), let numberRange = Range(match.range(at: 1), in: text) else { return nil }
        guard let value = Double(text[numberRange].replacingOccurrences(of: ",", with: ".")) else { return nil }
        if match.range(at: 2).location != NSNotFound || value >= 20 {
            return value
        }
        return nil
    }

    private func setStatus(_ newStatus: MealInputStatus, reduceMotion: Bool) {
        withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
            status = newStatus
        }
    }

    static let fakeResult = MealObject(
        foodName: "Rice bowl with egg",
        carbGrams: 46,
        carbGramsPer100g: 19,
        kcal: 420,
        portion: PortionObject(grams: 240),
        source: .aiEstimated,
        inlineSuggestion: SolodkoCopy.Home.estimatedHint
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

    static let demoDisambiguationOptions: [DisambiguationOption] = [
        DisambiguationOption(id: "apple-raw", foodName: "Apple", descriptor: "Fresh, raw", carbGramsPer100g: 14, defaultPortion: PortionObject(grams: 180)),
        DisambiguationOption(id: "apple-pie", foodName: "Apple pie", descriptor: "Baked dessert", carbGramsPer100g: 34, defaultPortion: PortionObject(grams: 120)),
        DisambiguationOption(id: "apple-sauce", foodName: "Apple sauce", descriptor: "Unsweetened", carbGramsPer100g: 11, defaultPortion: PortionObject(grams: 150))
    ]
}

private struct ResolvedMealDraft {
    var foodName: String
    var carbGramsPer100g: Double
    var source: MealSource
    var defaultPortion: PortionObject = PortionObject(grams: 100)
}
