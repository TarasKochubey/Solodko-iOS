import SwiftUI

struct HomeHubView: View {
    @Environment(LogStore.self) private var logStore
    @Environment(FoodMemoryStore.self) private var foodMemoryStore
    @Environment(RecurringMealsStore.self) private var recurringMealsStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("debug_preview_data_enabled") private var debugPreviewDataEnabled = false
    @State private var controller = MealInputController()
    @Namespace private var mealNamespace
    var onSettingsTap: () -> Void = {}

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(spacing: SolodkoTheme.spacing.stageGap) {
                StageView(
                    controller: controller,
                    namespace: mealNamespace,
                    todaysLogIsEmpty: effectiveTodaysLog.isEmpty,
                    onSettingsTap: onSettingsTap
                )
                    .frame(maxHeight: .infinity, alignment: .top)

                ConsoleView(controller: controller, namespace: mealNamespace)
            }
            .padding(.horizontal, SolodkoTheme.spacing.xl)
            .padding(.top, SolodkoTheme.spacing.fourXL)
            .padding(.bottom, SolodkoTheme.spacing.xl)

            if controller.status == .resultReady || controller.status == .lowConfidence || controller.status == .offline {
                MealResultOverlay(
                    controller: controller,
                    namespace: mealNamespace,
                    onLogged: { meal in logMeal(meal) },
                    onSaveToMemory: { meal in foodMemoryStore.update(with: meal) },
                    onAdjustPortion: { controller.adjustActivePortion() }
                )
                .zIndex(2)
                .transition(reduceMotion ? .opacity : .identity)
            }

            if controller.status == .disambiguating {
                DisambiguationCard(
                    options: controller.disambiguationOptions,
                    onSelect: { option in controller.selectDisambiguationOption(option, reduceMotion: reduceMotion) },
                    onReject: { controller.rejectDisambiguationOptions() }
                )
                .zIndex(2)
                .transition(.opacity)
            }

            if controller.status == .clarifying {
                ClarificationPromptView(controller: controller)
                    .zIndex(3)
            }
        }
    }

    private var effectiveTodaysLog: [LoggedMeal] {
        debugPreviewDataEnabled ? LogStore.previewTodaysLog : logStore.todaysLog
    }

    private func logMeal(_ meal: MealObject) {
        logStore.log(meal)
        foodMemoryStore.update(with: meal)
        recurringMealsStore.update(with: meal)
    }
}

private struct DisambiguationCard: View {
    var options: [DisambiguationOption]
    var onSelect: (DisambiguationOption) -> Void
    var onReject: () -> Void

    var body: some View {
        VStack {
            Spacer()

            GlassCard(active: true) {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
                    Text(SolodkoCopy.Home.chooseMatch)
                        .font(SolodkoTheme.typography.mealName)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)

                    ForEach(options) { option in
                        Button {
                            onSelect(option)
                        } label: {
                            HStack(alignment: .firstTextBaseline, spacing: SolodkoTheme.spacing.md) {
                                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.xs) {
                                    Text(option.foodName)
                                        .font(SolodkoTheme.typography.body)
                                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                                    Text(option.descriptor)
                                        .font(SolodkoTheme.typography.microcopy)
                                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                                }

                                Spacer(minLength: SolodkoTheme.spacing.md)

                                Text("\(Int(option.carbGramsPer100g))g / 100g")
                                    .font(SolodkoTheme.typography.badge)
                                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
                            }
                            .padding(.vertical, SolodkoTheme.spacing.sm)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    QuickActionChip(label: SolodkoCopy.Actions.noneOfThese, action: onReject)
                }
            }
            .padding(.horizontal, SolodkoTheme.spacing.xl)
            .padding(.bottom, SolodkoTheme.spacing.fourXL * 2 + SolodkoTheme.spacing.twoXL)
        }
        .accessibilityElement(children: .contain)
    }
}
