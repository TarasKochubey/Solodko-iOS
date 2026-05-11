import SwiftUI

struct StageView: View {
    @Environment(RecurringMealsStore.self) private var recurringMealsStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    @State private var loaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
            TimeOfDayHeader()
                .accessibilitySortPriority(5)

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                Text(SolodkoCopy.Home.recurringTitle)
                    .font(SolodkoTheme.typography.microcopy)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                    .lineLimit(nil)

                let meals = recurringMealsStore.mealsForCurrentMoment()
                if meals.isEmpty {
                    EmptyState(text: SolodkoCopy.Home.recurringEmpty)
                } else {
                    ForEach(Array(meals.enumerated()), id: \.element.id) { index, meal in
                        RecurringMealCard(meal: meal, namespace: namespace) {
                            withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
                                controller.useRecurringMeal(meal)
                            }
                        }
                        .opacity(loaded ? 1 : 0)
                        .offset(y: reduceMotion || loaded ? 0 : SolodkoTheme.spacing.sm)
                        .animation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring.delay(Double(index) * 0.1), value: loaded)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { loaded = true }
    }
}

