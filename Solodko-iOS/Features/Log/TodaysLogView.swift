import SwiftUI

struct TodaysLogView: View {
    var body: some View {
        LogView()
    }
}

struct LogView: View {
    @Namespace private var namespace

    private let sections = LogMockData.sections

    var body: some View {
        NavigationStack {
            ZStack {
                AtmosphericBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        Text(SolodkoCopy.Log.today)
                            .font(SolodkoTheme.typography.screenTitle)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(nil)
                            .accessibilityAddTraits(.isHeader)

                        if sections.flatMap(\.meals).isEmpty {
                            EmptyState(text: SolodkoCopy.Log.empty)
                        } else {
                            ForEach(sections) { section in
                                LogChronologySection(section: section, namespace: namespace)
                            }
                        }
                    }
                    .padding(SolodkoTheme.spacing.xl)
                    .padding(.top, SolodkoTheme.spacing.fourXL)
                    .padding(.bottom, SolodkoTheme.spacing.fourXL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct LogChronologySection: View {
    var section: LogDaySection
    var namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
            Text(section.title)
                .font(SolodkoTheme.typography.mealName)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .lineLimit(nil)
                .accessibilityAddTraits(.isHeader)

            if section.meals.isEmpty {
                EmptyState(text: SolodkoCopy.Log.empty)
            } else {
                VStack(spacing: SolodkoTheme.spacing.lg) {
                    ForEach(section.meals) { loggedMeal in
                        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
                            Text(loggedMeal.time)
                                .font(SolodkoTheme.typography.microcopy)
                                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                                .lineLimit(1)
                                .accessibilityLabel("Logged at \(loggedMeal.time)")

                            MealCard(
                                meal: loggedMeal.meal,
                                cardState: MealCardState(source: loggedMeal.meal.source),
                                namespace: namespace,
                                onLog: {},
                                onAdjustPortion: {},
                                onSaveToMemory: {},
                                onDismiss: {}
                            )
                        }
                    }
                }
            }
        }
    }
}

private struct LogDaySection: Identifiable {
    let id = UUID()
    var title: String
    var meals: [LogDisplayMeal]
}

private struct LogDisplayMeal: Identifiable {
    let id = UUID()
    var time: String
    var meal: MealObject
}

private enum LogMockData {
    static let sections = [
        LogDaySection(
            title: SolodkoCopy.Log.morning,
            meals: [
                LogDisplayMeal(
                    time: "08:15",
                    meal: MealObject(
                        foodName: "Oatmeal with apple",
                        carbGrams: 39,
                        carbGramsPer100g: 18,
                        kcal: 330,
                        portion: PortionObject(grams: 220),
                        source: .fromLibrary
                    )
                ),
                LogDisplayMeal(
                    time: "10:40",
                    meal: MealObject(
                        foodName: "Greek yogurt",
                        carbGrams: 14,
                        carbGramsPer100g: 7,
                        kcal: 150,
                        portion: PortionObject(grams: 200),
                        source: .exact
                    )
                )
            ]
        ),
        LogDaySection(
            title: SolodkoCopy.Log.afternoon,
            meals: [
                LogDisplayMeal(
                    time: "13:20",
                    meal: MealObject(
                        foodName: "Buckwheat with chicken",
                        carbGrams: 38,
                        carbGramsPer100g: 14,
                        kcal: 430,
                        portion: PortionObject(grams: 280),
                        source: .recurring,
                        inlineSuggestion: SolodkoCopy.Memory.recurringMeals
                    )
                )
            ]
        ),
        LogDaySection(
            title: SolodkoCopy.Log.evening,
            meals: [
                LogDisplayMeal(
                    time: "18:45",
                    meal: MealObject(
                        foodName: "Lentil soup",
                        carbGrams: 32,
                        carbGramsPer100g: 11,
                        kcal: 310,
                        portion: PortionObject(grams: 300),
                        source: .fromLibrary
                    )
                ),
                LogDisplayMeal(
                    time: "21:10",
                    meal: MealObject(
                        foodName: "Banana kefir smoothie",
                        carbGrams: 35,
                        carbGramsPer100g: 15,
                        kcal: 240,
                        portion: PortionObject(grams: 240),
                        source: .aiEstimated,
                        inlineSuggestion: SolodkoCopy.Home.estimatedHint
                    )
                )
            ]
        )
    ]
}
