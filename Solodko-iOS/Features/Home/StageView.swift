import SwiftUI

struct StageView: View {
    @Environment(RecurringMealsStore.self) private var recurringMealsStore
    @Environment(\.timeOfDayProvider) private var provider
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("debug_preview_data_enabled") private var debugPreviewDataEnabled = false
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    var todaysLogIsEmpty: Bool
    var onSettingsTap: () -> Void
    @State private var loaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
            HStack(alignment: .center) {
                TimeOfDayHeader()
                    .accessibilitySortPriority(5)

                Spacer()

                SettingsIconButton(onTap: onSettingsTap)
            }

            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                let meals = effectiveRecurringMeals()
                if meals.isEmpty && todaysLogIsEmpty {
                    Text(emptyPrompt)
                        .font(SolodkoTheme.typography.body)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, SolodkoTheme.spacing.fourXL)
                        .accessibilityLabel(emptyPrompt)
                } else {
                    Text(SolodkoCopy.Home.recurringTitle)
                        .font(SolodkoTheme.typography.microcopy)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                        .lineLimit(nil)

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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { loaded = true }
    }

    private var emptyPrompt: String {
        switch provider.bucket() {
        case .morning:
            return "What are you eating this morning?"
        case .afternoon:
            return "What's for lunch today?"
        case .evening, .night:
            return "What are you having tonight?"
        }
    }

    private func effectiveRecurringMeals() -> [RecurringMeal] {
        if debugPreviewDataEnabled {
            let matches = RecurringMealsStore.previewMeals.filter { $0.timeOfDayBucket == provider.bucket() }
            return Array((matches.isEmpty ? RecurringMealsStore.previewMeals : matches).prefix(3))
        }
        return recurringMealsStore.mealsForCurrentMoment()
    }
}

struct SettingsIconButton: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: "gearshape")
                .font(.body.weight(.semibold))
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .frame(width: SolodkoTheme.spacing.minTouchTarget, height: SolodkoTheme.spacing.minTouchTarget)
                .background(SolodkoTheme.colors.surface.glassPrimary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Settings")
    }
}
