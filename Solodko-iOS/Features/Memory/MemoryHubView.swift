import SwiftUI

struct MemoryHubView: View {
    @Environment(FoodMemoryStore.self) private var foodMemoryStore
    @Environment(RecurringMealsStore.self) private var recurringMealsStore
    @Environment(\.timeOfDayProvider) private var provider
    @AppStorage("debug_preview_data_enabled") private var debugPreviewDataEnabled = false
    @Namespace private var namespace
    var onSettingsTap: () -> Void = {}

    var body: some View {
        NavigationStack {
            ZStack {
                AtmosphericBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        HStack(alignment: .center) {
                            TimeOfDayHeader()
                            Spacer()
                            SettingsIconButton(onTap: onSettingsTap)
                        }

                        if memoryIsEmpty {
                            EmptyState(text: SolodkoCopy.Memory.empty)
                        } else {
                            MemorySection(title: SolodkoCopy.Memory.usuallyAroundNow) {
                                recurringMemoryRows(usuallyAroundNow)
                            }

                            MemorySection(title: SolodkoCopy.Memory.recurringMeals) {
                                recurringMemoryRows(effectiveRecurringMeals)
                            }

                            MemorySection(title: SolodkoCopy.Memory.savedFoods) {
                                savedFoodRows(effectiveSavedFoods)
                            }

                            MemorySection(title: SolodkoCopy.Memory.recipes) {
                                recipeCards
                            }

                            MemorySection(title: SolodkoCopy.Memory.recentRepeats) {
                                savedFoodRows(effectiveSavedFoods)
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
        .accessibilityLabel("\(SolodkoCopy.Tabs.memory), \(provider.label(for: provider.bucket()))")
    }

    @ViewBuilder
    private func recurringMemoryRows(_ meals: [RecurringMeal]) -> some View {
        if meals.isEmpty {
            EmptyState(text: SolodkoCopy.Memory.empty)
        } else {
            VStack(spacing: SolodkoTheme.spacing.lg) {
                ForEach(meals) { meal in
                    MemoryFoodRow(
                        title: meal.foodName,
                        detail: meal.lastPortion.displayText,
                        carbGrams: meal.carbGrams
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func savedFoodRows(_ foods: [SavedFood]) -> some View {
        if foods.isEmpty {
            EmptyState(text: SolodkoCopy.Memory.empty)
        } else {
            VStack(spacing: SolodkoTheme.spacing.lg) {
                ForEach(foods) { food in
                    MemoryFoodRow(
                        title: food.foodName,
                        detail: food.usualPortion.displayText,
                        carbGrams: food.carbGrams
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var recipeCards: some View {
        if effectiveRecipes.isEmpty {
            EmptyState(text: SolodkoCopy.Memory.empty)
        } else {
            VStack(spacing: SolodkoTheme.spacing.lg) {
                ForEach(effectiveRecipes) { recipe in
                    MemoryRecipeCard(recipe: recipe)
                }
            }
        }
    }

    private var memoryIsEmpty: Bool {
        effectiveSavedFoods.isEmpty && effectiveRecurringMeals.isEmpty && effectiveRecipes.isEmpty
    }

    private var effectiveSavedFoods: [SavedFood] {
        debugPreviewDataEnabled ? FoodMemoryStore.previewSavedFoods : foodMemoryStore.savedFoods
    }

    private var effectiveRecurringMeals: [RecurringMeal] {
        debugPreviewDataEnabled ? RecurringMealsStore.previewMeals : recurringMealsStore.meals
    }

    private var usuallyAroundNow: [RecurringMeal] {
        let bucket = provider.bucket()
        let matches = effectiveRecurringMeals.filter { $0.timeOfDayBucket == bucket }
        return Array(matches.prefix(3))
    }

    private var effectiveRecipes: [MemoryRecipe] {
        debugPreviewDataEnabled ? MemoryHubPreviewData.recipes : []
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

private struct MemoryFoodRow: View {
    var title: String
    var detail: String
    var carbGrams: Double

    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: SolodkoTheme.spacing.md) {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
                    Text(title)
                        .font(SolodkoTheme.typography.mealName)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .lineLimit(nil)

                    Text(detail)
                        .font(SolodkoTheme.typography.microcopy)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                }

                Spacer(minLength: SolodkoTheme.spacing.sm)

                VStack(alignment: .trailing, spacing: SolodkoTheme.spacing.xs) {
                    Text("\(carbGrams, specifier: "%.0f")g")
                        .font(SolodkoTheme.typography.screenTitle)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("Carbs")
                        .font(SolodkoTheme.typography.microcopy)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                }
                .accessibilityLabel("\(carbGrams, specifier: "%.0f") grams of carbohydrates")
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(carbGrams, specifier: "%.0f") grams of carbohydrates, \(detail)")
    }
}

private struct MemoryRecipe: Identifiable {
    let id = UUID()
    var name: String
    var portion: String
    var carbGrams: Int
}

private enum MemoryHubPreviewData {
    static let recipes = [
        MemoryRecipe(name: "Cottage cheese pancakes", portion: "2 pieces", carbGrams: 29),
        MemoryRecipe(name: "Turkey rice bowl", portion: "1 bowl", carbGrams: 46)
    ]
}
