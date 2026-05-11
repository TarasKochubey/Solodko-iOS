import SwiftUI

struct ClarificationPromptView: View {
    @Bindable var controller: MealInputController
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visible = false

    var body: some View {
        VStack {
            Spacer()
            Text(controller.clarificationContext?.question ?? SolodkoCopy.Home.clarification)
                .font(SolodkoTheme.typography.screenTitle)
                .foregroundStyle(SolodkoTheme.colors.text.primary)
                .lineLimit(nil)
                .padding(SolodkoTheme.spacing.xl)
                .background(SolodkoTheme.colors.surface.glassPrimary)
                .clipShape(RoundedRectangle(cornerRadius: SolodkoTheme.radii.xl, style: .continuous))
                .opacity(visible ? 1 : 0)
                .offset(y: reduceMotion || visible ? 0 : SolodkoTheme.spacing.xl)
                .accessibilityLabel(SolodkoCopy.Accessibility.portionNeeded)
                .accessibilityAddTraits(.isStaticText)

            Spacer()
                .frame(height: SolodkoTheme.spacing.fourXL * 4)
        }
        .onAppear {
            withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
                visible = true
            }
        }
    }
}

