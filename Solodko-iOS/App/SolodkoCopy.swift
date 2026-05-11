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

    enum PreApp {
        static let welcomeTitle = String(localized: "Food logging, softened")
        static let welcomeBody = String(localized: "Solodko helps you turn a meal into a clear carb estimate without making the moment feel clinical.")
        static let welcomeContinue = String(localized: "Begin")
        static let setupTitle = String(localized: "Set only what helps")
        static let setupBody = String(localized: "These details are optional. You can leave them blank and still log meals with text.")
        static let setupInsulin = String(localized: "Insulin type")
        static let setupInsulinValue = String(localized: "Not set")
        static let setupCarbUnit = String(localized: "Carb unit")
        static let setupCarbUnitValue = String(localized: "Grams")
        static let setupAllergens = String(localized: "Foods to avoid")
        static let setupAllergensValue = String(localized: "Add later")
        static let continueAction = String(localized: "Continue")
        static let skipAction = String(localized: "Skip")
        static let permissionsTitle = String(localized: "Optional inputs")
        static let permissionsBody = String(localized: "Photo, voice, reminders, and health connection can make Solodko easier to use, but none of them are required.")
        static let permissionsFootnote = String(localized: "Skipped permissions stay available later and won't limit logging.")
        static let cameraTitle = String(localized: "Camera")
        static let cameraBody = String(localized: "Use photos for meals or nutrition labels.")
        static let microphoneTitle = String(localized: "Microphone")
        static let microphoneBody = String(localized: "Speak a meal when typing is awkward.")
        static let notificationsTitle = String(localized: "Notifications")
        static let notificationsBody = String(localized: "Receive gentle reminders when you want them.")
        static let appleHealthTitle = String(localized: "Apple Health")
        static let appleHealthBody = String(localized: "Connect later if you want health context in one place.")
        static let enableAction = String(localized: "Enable")
        static let enabledValue = String(localized: "Enabled")
        static let skippedValue = String(localized: "Skipped")
        static let authTitle = String(localized: "Solodko")
        static let authBody = String(localized: "Mock sign-in for this local build. No account is created and no data leaves the device.")
        static let authContinue = String(localized: "Enter Solodko")
    }

    enum PermissionRecovery {
        static let photoUnavailable = String(localized: "Photo input unavailable. Type your meal instead.")
        static let voiceUnavailable = String(localized: "Voice input unavailable. Type your meal instead.")
        static let typeInstead = String(localized: "Type instead")
        static let openSettings = String(localized: "Open Settings")
        static let cameraAnnouncement = String(localized: "Camera unavailable. Type your meal instead.")
        static let microphoneAnnouncement = String(localized: "Microphone unavailable. Type your meal instead.")
    }

    enum Log {
        static let today = String(localized: "Today")
        static let morning = String(localized: "Morning")
        static let afternoon = String(localized: "Afternoon")
        static let evening = String(localized: "Evening")
        static let empty = String(localized: "Logged meals will appear here.")
    }

    enum Memory {
        static let usuallyAroundNow = String(localized: "Usually around now")
        static let recurringMeals = String(localized: "Recurring meals")
        static let savedFoods = String(localized: "Saved foods")
        static let recipes = String(localized: "Recipes")
        static let recentRepeats = String(localized: "Recent repeats")
        static let empty = String(localized: "Saved foods and recipes will appear here.")
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
