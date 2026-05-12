import SwiftUI

struct TodaysLogView: View {
    var body: some View {
        LogView()
    }
}

struct LogView: View {
    @Environment(LogStore.self) private var logStore
    @AppStorage("debug_preview_data_enabled") private var debugPreviewDataEnabled = false
    @Namespace private var namespace

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

                        if effectiveLog.isEmpty {
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

    private var effectiveLog: [LoggedMeal] {
        debugPreviewDataEnabled ? LogStore.previewTodaysLog : logStore.todaysLog
    }

    private var sections: [LogDaySection] {
        let grouped = Dictionary(grouping: effectiveLog) { meal in
            TimeOfDayProvider().bucket(for: meal.loggedAt)
        }

        return [
            LogDaySection(title: SolodkoCopy.Log.morning, meals: displayMeals(from: grouped[.morning])),
            LogDaySection(title: SolodkoCopy.Log.afternoon, meals: displayMeals(from: grouped[.afternoon])),
            LogDaySection(title: SolodkoCopy.Log.evening, meals: displayMeals(from: (grouped[.evening] ?? []) + (grouped[.night] ?? [])))
        ].filter { !$0.meals.isEmpty }
    }

    private func displayMeals(from meals: [LoggedMeal]?) -> [LogDisplayMeal] {
        (meals ?? [])
            .sorted { $0.loggedAt < $1.loggedAt }
            .map { LogDisplayMeal(time: DateFormatter.solodkoLogTime.string(from: $0.loggedAt), meal: $0.meal) }
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

private extension DateFormatter {
    static let solodkoLogTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
