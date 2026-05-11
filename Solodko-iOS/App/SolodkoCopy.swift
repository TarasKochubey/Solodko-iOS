import Foundation

enum SolodkoCopy {
    enum TimeOfDay {
        static let morning = String(localized: "Morning")
        static let afternoon = String(localized: "Afternoon")
        static let evening = String(localized: "Dinner")
        static let night = String(localized: "Late")
    }

    enum Tabs {
        static let home = String(localized: "Home")
        static let log = String(localized: "Log")
        static let memory = String(localized: "Memory")
    }

    enum Home {
        static let recurringTitle = String(localized: "Usually around now")
        static let recurringEmpty = String(localized: "Your familiar meals will appear here.")
        static let textPlaceholder = String(localized: "Describe your meal")
        static let clarification = String(localized: "How much?")
        static let offline = String(localized: "Offline - using saved foods")
        static let estimatedHint = String(localized: "A soft estimate. Adjust the portion if needed.")
    }

    enum Actions {
        static let logMeal = String(localized: "Log meal")
        static let adjustPortion = String(localized: "Adjust portion")
        static let saveToMemory = String(localized: "Save to Memory")
        static let useAgain = String(localized: "Use again")
        static let addManually = String(localized: "Add manually")
        static let openMemory = String(localized: "Open Memory")
        static let searchAI = String(localized: "Search AI")
        static let submit = String(localized: "Submit")
        static let dismiss = String(localized: "Dismiss")
    }

    enum Badges {
        static let yourFood = String(localized: "Your food")
        static let estimated = String(localized: "Estimated")
        static let notFound = String(localized: "Not found")
        static let offline = String(localized: "Offline")
    }

    enum Accessibility {
        static let foodInput = String(localized: "Food input")
        static let foodInputHint = String(localized: "Tap to start logging a meal using text, voice, or camera")
        static let voiceInput = String(localized: "Voice input")
        static let voiceInputHint = String(localized: "Dictate the food name and portion")
        static let cameraInput = String(localized: "Camera input")
        static let cameraInputHint = String(localized: "Photograph your food or nutrition label")
        static let barcodeScan = String(localized: "Barcode scan")
        static let barcodeScanHint = String(localized: "Scan a food product barcode")
        static let mealLogged = String(localized: "Meal logged")
        static let identifyingFood = String(localized: "Identifying food")
        static let portionNeeded = String(localized: "Portion needed")
        static let moreInformationNeeded = String(localized: "More information needed")
        static let mealIdentified = String(localized: "Meal identified")
        static let listening = String(localized: "Listening")
    }
}
