import SwiftUI

struct MemoryHubView: View {
    @Environment(FoodMemoryStore.self) private var memoryStore
    @Environment(\.timeOfDayProvider) private var provider
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ZStack {
                AtmosphericBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        TimeOfDayHeader()

                        Text("\(SolodkoCopy.Home.recurringTitle) - \(provider.label(for: provider.bucket()))")
                            .font(SolodkoTheme.typography.microcopy)
                            .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            .lineLimit(nil)

                        ForEach(memoryStore.savedFoods) { food in
                            let meal = MealObject(
                                foodName: food.foodName,
                                carbGrams: food.carbGrams,
                                carbGramsPer100g: food.carbGramsPer100g,
                                portion: food.usualPortion,
                                source: .fromLibrary
                            )
                            MealCard(
                                meal: meal,
                                cardState: .fromLibrary,
                                namespace: namespace,
                                onLog: {},
                                onAdjustPortion: {},
                                onSaveToMemory: {},
                                onDismiss: {}
                            )
                        }
                    }
                    .padding(SolodkoTheme.spacing.xl)
                    .padding(.top, SolodkoTheme.spacing.fourXL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

