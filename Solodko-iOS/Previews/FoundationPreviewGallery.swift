import SwiftUI

struct FoundationPreviewGallery: View {
    @State private var controller = MealInputController()
    @State private var selectedOrbState: OrbState = .idle
    @State private var selectedMealState: MealCardState = .aiEstimated
    @State private var selectedBucket: TimeOfDayBucket = .morning
    @Namespace private var namespace

    private let demoMeal = MealObject(
        foodName: "Rice bowl with egg",
        carbGrams: 46,
        carbGramsPer100g: 19,
        kcal: 420,
        portion: PortionObject(grams: 240),
        source: .aiEstimated
    )

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .environment(\.timeOfDayProvider, TimeOfDayProvider(now: previewDate))

            ScrollView {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                    TimeOfDayHeader(forcedBucket: selectedBucket)

                    gallerySection("Orb states") {
                        Picker("Orb states", selection: $selectedOrbState) {
                            ForEach(OrbState.allCases) { state in
                                Text(state.rawValue).tag(state)
                            }
                        }
                        .pickerStyle(.segmented)

                        AIOrb(state: selectedOrbState, onTap: {}, namespace: namespace)
                            .frame(maxWidth: .infinity)
                    }

                    gallerySection("Meal card states") {
                        Picker("Meal card states", selection: $selectedMealState) {
                            ForEach(MealCardState.allCases) { state in
                                Text(state.rawValue).tag(state)
                            }
                        }
                        .pickerStyle(.menu)

                        MealCard(
                            meal: demoMealForSelectedState,
                            cardState: selectedMealState,
                            namespace: namespace,
                            onLog: {},
                            onAdjustPortion: {},
                            onSaveToMemory: {},
                            onDismiss: {}
                        )
                    }

                    gallerySection("Time backgrounds") {
                        Picker("Time backgrounds", selection: $selectedBucket) {
                            ForEach(TimeOfDayBucket.allCases) { bucket in
                                Text(bucket.rawValue).tag(bucket)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    gallerySection("Accessibility") {
                        Text("Reduced Motion follows the iOS accessibility setting. Dynamic Type is handled through SwiftUI text scaling; use Xcode previews or device settings to verify AX sizes.")
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)
                    }
                }
                .padding(SolodkoTheme.spacing.xl)
                .padding(.top, SolodkoTheme.spacing.fourXL)
            }
        }
    }

    private func gallerySection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
            Text(title)
                .font(SolodkoTheme.typography.body)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
            content()
        }
    }

    private var demoMealForSelectedState: MealObject {
        var meal = demoMeal
        switch selectedMealState {
        case .exact:
            meal.source = .exact
        case .aiEstimated:
            meal.source = .aiEstimated
        case .fromLibrary:
            meal.source = .fromLibrary
        case .recurring:
            meal.source = .recurring
            meal.inlineSuggestion = SolodkoCopy.Home.recurringTitle
        case .notFound:
            meal.foodName = "Mixed plate"
            meal.source = .notFound
        case .offline:
            meal.source = .offline
        }
        return meal
    }

    private func previewDate() -> Date {
        var components = DateComponents()
        components.calendar = .current
        components.year = 2026
        components.month = 5
        components.day = 11
        switch selectedBucket {
        case .morning: components.hour = 8
        case .afternoon: components.hour = 14
        case .evening: components.hour = 19
        case .night: components.hour = 2
        }
        return components.date ?? Date()
    }
}

#Preview("Foundation Gallery") {
    FoundationPreviewGallery()
}
