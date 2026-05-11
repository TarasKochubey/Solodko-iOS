import SwiftUI

struct MemoryHubView: View {
    @Environment(\.timeOfDayProvider) private var provider
    @Namespace private var namespace

    private let usuallyAroundNow = MemoryHubMockData.usuallyAroundNow
    private let recurringMeals = MemoryHubMockData.recurringMeals
    private let savedFoods = MemoryHubMockData.savedFoods
    private let recipes = MemoryHubMockData.recipes
    private let recentRepeats = MemoryHubMockData.recentRepeats

    var body: some View {
        NavigationStack {
            ZStack {
                AtmosphericBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        TimeOfDayHeader()

                        MemorySection(title: SolodkoCopy.Memory.usuallyAroundNow) {
                            memoryMealCards(usuallyAroundNow, state: .recurring)
                        }

                        MemorySection(title: SolodkoCopy.Memory.recurringMeals) {
                            memoryMealCards(recurringMeals, state: .recurring)
                        }

                        MemorySection(title: SolodkoCopy.Memory.savedFoods) {
                            memoryMealCards(savedFoods, state: .fromLibrary)
                        }

                        MemorySection(title: SolodkoCopy.Memory.recipes) {
                            recipeCards
                        }

                        MemorySection(title: SolodkoCopy.Memory.recentRepeats) {
                            memoryMealCards(recentRepeats, state: .fromLibrary)
                        }
                    }
                    .padding(SolodkoTheme.spacing.xl)
                    .padding(.top, SolodkoTheme.spacing.fourXL)
                    .padding(.bottom, SolodkoTheme.spacing.fourXL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .accessibilityLabel("\(SolodkoCopy.Tabs.memory), \(provider.label(for: provider.bucket()))")
    }

    @ViewBuilder
    private func memoryMealCards(_ meals: [MealObject], state: MealCardState) -> some View {
        if meals.isEmpty {
            EmptyState(text: SolodkoCopy.Memory.empty)
        } else {
            VStack(spacing: SolodkoTheme.spacing.lg) {
                ForEach(meals) { meal in
                    MealCard(
                        meal: meal,
                        cardState: state,
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

    @ViewBuilder
    private var recipeCards: some View {
        if recipes.isEmpty {
            EmptyState(text: SolodkoCopy.Memory.empty)
        } else {
            VStack(spacing: SolodkoTheme.spacing.lg) {
                ForEach(recipes) { recipe in
                    MemoryRecipeCard(recipe: recipe)
                }
            }
        }
    }
}

private struct MemorySection<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
            Text(title)
                .font(SolodkoTheme.typography.mealName)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .lineLimit(nil)
                .accessibilityAddTraits(.isHeader)

            content
        }
    }
}

private struct MemoryRecipeCard: View {
    var recipe: MemoryRecipe

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                HStack(alignment: .top, spacing: SolodkoTheme.spacing.md) {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
                        Text(recipe.name)
                            .font(SolodkoTheme.typography.mealName)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(nil)

                        Text(recipe.portion)
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)
                    }

                    Spacer(minLength: SolodkoTheme.spacing.sm)

                    VStack(alignment: .trailing, spacing: SolodkoTheme.spacing.xs) {
                        Text("\(recipe.carbGrams)g")
                            .font(SolodkoTheme.typography.screenTitle)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text("Carbs")
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    }
                    .accessibilityLabel("\(recipe.carbGrams) grams of carbohydrates")
                }

                QuickActionChip(label: SolodkoCopy.Actions.useAgain, prominent: true) {}
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(recipe.name), \(recipe.carbGrams) grams of carbohydrates, \(recipe.portion)")
    }
}

private struct MemoryRecipe: Identifiable {
    let id = UUID()
    var name: String
    var portion: String
    var carbGrams: Int
}

private enum MemoryHubMockData {
    static let usuallyAroundNow = [
        MealObject(
            foodName: "Greek yogurt with berries",
            carbGrams: 26,
            carbGramsPer100g: 12,
            kcal: 210,
            portion: PortionObject(grams: 220),
            source: .recurring,
            inlineSuggestion: SolodkoCopy.Memory.usuallyAroundNow
        )
    ]

    static let recurringMeals = [
        MealObject(
            foodName: "Buckwheat with chicken",
            carbGrams: 38,
            carbGramsPer100g: 14,
            kcal: 430,
            portion: PortionObject(grams: 280),
            source: .recurring
        ),
        MealObject(
            foodName: "Toast with cottage cheese",
            carbGrams: 31,
            carbGramsPer100g: 22,
            kcal: 290,
            portion: PortionObject(grams: 140),
            source: .recurring
        )
    ]

    static let savedFoods = [
        MealObject(
            foodName: "Apple and peanut butter",
            carbGrams: 24,
            carbGramsPer100g: 14,
            kcal: 265,
            portion: PortionObject(grams: 170),
            source: .fromLibrary
        ),
        MealObject(
            foodName: "Lentil soup",
            carbGrams: 32,
            carbGramsPer100g: 11,
            kcal: 310,
            portion: PortionObject(grams: 300),
            source: .fromLibrary
        )
    ]

    static let recipes = [
        MemoryRecipe(name: "Cottage cheese pancakes", portion: "2 pieces", carbGrams: 29),
        MemoryRecipe(name: "Turkey rice bowl", portion: "1 bowl", carbGrams: 46)
    ]

    static let recentRepeats = [
        MealObject(
            foodName: "Banana kefir smoothie",
            carbGrams: 35,
            carbGramsPer100g: 15,
            kcal: 240,
            portion: PortionObject(grams: 240),
            source: .fromLibrary
        )
    ]
}
