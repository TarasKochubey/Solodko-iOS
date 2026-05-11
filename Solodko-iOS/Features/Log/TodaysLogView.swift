import SwiftUI

struct TodaysLogView: View {
    @Environment(LogStore.self) private var logStore
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ZStack {
                AtmosphericBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: SolodkoTheme.spacing.threeXL) {
                        Text("Today")
                            .font(SolodkoTheme.typography.screenTitle)
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .lineLimit(nil)

                        if logStore.todaysLog.isEmpty {
                            EmptyState(text: "Logged meals will appear here.")
                        } else {
                            ForEach(logStore.todaysLog) { loggedMeal in
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
                    .padding(SolodkoTheme.spacing.xl)
                    .padding(.top, SolodkoTheme.spacing.fourXL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

