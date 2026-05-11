import SwiftUI

struct RecurringMealCard: View {
    var meal: RecurringMeal
    var namespace: Namespace.ID
    var onTap: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var floating = false

    var body: some View {
        Button(action: {
            SolodkoTheme.haptics.quickAction()
            onTap()
        }) {
            MealCard(
                meal: meal.mealObject,
                cardState: .recurring,
                namespace: namespace,
                onLog: onTap,
                onAdjustPortion: {},
                onSaveToMemory: {},
                onDismiss: {}
            )
            .scaleEffect(floating && !reduceMotion ? 1.01 : 1)
            .offset(y: floating && !reduceMotion ? -SolodkoTheme.spacing.xs : 0)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(meal.foodName), \(SolodkoCopy.Home.recurringTitle)")
        .accessibilityHint("Tap to log \(meal.lastPortion.displayText) of \(meal.foodName)")
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    floating = true
                }
            }
        }
    }
}

