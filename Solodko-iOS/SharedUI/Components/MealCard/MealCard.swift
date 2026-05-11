import SwiftUI

struct MealCard: View {
    var meal: MealObject
    var cardState: MealCardState
    var namespace: Namespace.ID
    var isOverlay = false
    var onLog: () -> Void
    var onAdjustPortion: () -> Void
    var onSaveToMemory: () -> Void
    var onDismiss: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var showActions = false

    var body: some View {
        GlassCard(active: isOverlay) {
            ViewThatFits(in: .vertical) {
                fullLayout
                compactLayout
            }
        }
        .opacity(cardState == .notFound ? 0.86 : 1)
        .confidenceGlow(cardState)
        .matchedGeometryEffect(id: isOverlay ? "mealCard" : meal.id.uuidString, in: namespace, isSource: false)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Tap Log meal to confirm, or use actions to adjust")
        .onAppear {
            if reduceMotion {
                showContent = true
                showActions = true
            } else {
                withAnimation(.solodkoSpring.delay(0.15)) { showContent = true }
                withAnimation(.solodkoSpring.delay(0.25)) { showActions = true }
            }
        }
    }

    private var fullLayout: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.lg) {
            header
            values
            suggestion
            actions
        }
    }

    private var compactLayout: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.md) {
            header
            values
            actions
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SolodkoTheme.spacing.sm) {
            HStack(alignment: .top, spacing: SolodkoTheme.spacing.md) {
                Text(meal.foodName)
                    .font(SolodkoTheme.typography.mealName)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: SolodkoTheme.spacing.sm)
                SourceBadge(state: cardState)
            }
            Text("Serving \(meal.portion.displayText) - \(Int(meal.carbGramsPer100g))g per 100g")
                .font(SolodkoTheme.typography.microcopy)
                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                .lineLimit(nil)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: reduceMotion || showContent ? 0 : SolodkoTheme.spacing.sm)
    }

    private var values: some View {
        HStack(alignment: .firstTextBaseline, spacing: SolodkoTheme.spacing.xl) {
            VStack(alignment: .leading, spacing: SolodkoTheme.spacing.xs) {
                Text("\(Int(meal.carbGrams))g")
                    .font(SolodkoTheme.typography.carbValue)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .accessibilityLabel("\(Int(meal.carbGrams)) grams of carbohydrates")
                Text("Carbs")
                    .font(SolodkoTheme.typography.microcopy)
                    .foregroundStyle(SolodkoTheme.colors.text.secondary)
            }

            if let kcal = meal.kcal {
                VStack(alignment: .leading, spacing: SolodkoTheme.spacing.xs) {
                    Text("\(Int(kcal))")
                        .font(SolodkoTheme.typography.screenTitle)
                        .foregroundStyle(SolodkoTheme.colors.text.primary)
                    Text("kcal")
                        .font(SolodkoTheme.typography.microcopy)
                        .foregroundStyle(SolodkoTheme.colors.text.secondary)
                }
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    @ViewBuilder
    private var suggestion: some View {
        if let inlineSuggestion = meal.inlineSuggestion {
            Text(inlineSuggestion)
                .font(SolodkoTheme.typography.microcopy)
                .foregroundStyle(SolodkoTheme.colors.text.secondary)
                .lineLimit(nil)
                .opacity(showContent ? 1 : 0)
        }
    }

    private var actions: some View {
        FlowLayout(spacing: SolodkoTheme.spacing.sm) {
            QuickActionChip(label: primaryActionTitle, prominent: true, action: onLog)
            QuickActionChip(label: SolodkoCopy.Actions.adjustPortion, action: onAdjustPortion)
            if cardState == .notFound {
                QuickActionChip(label: SolodkoCopy.Actions.addManually, action: onDismiss)
                QuickActionChip(label: SolodkoCopy.Actions.searchAI, action: onSaveToMemory)
            } else if cardState == .offline {
                QuickActionChip(label: SolodkoCopy.Actions.openMemory, action: onDismiss)
                QuickActionChip(label: SolodkoCopy.Actions.addManually, action: onSaveToMemory)
            } else {
                QuickActionChip(label: SolodkoCopy.Actions.saveToMemory, action: onSaveToMemory)
            }
        }
        .opacity(showActions ? 1 : 0)
        .offset(y: reduceMotion || showActions ? 0 : SolodkoTheme.spacing.sm)
    }

    private var primaryActionTitle: String {
        cardState == .recurring ? "Log \(meal.portion.displayText)" : SolodkoCopy.Actions.logMeal
    }

    private var accessibilityLabel: String {
        "\(meal.foodName), \(Int(meal.carbGrams)) grams of carbohydrates, \(meal.portion.displayText), \(cardState.accessibilityLabel)"
    }
}

