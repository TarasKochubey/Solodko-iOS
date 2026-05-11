import SwiftUI

struct AIOrb: View {
    var state: OrbState
    var onTap: () -> Void
    var namespace: Namespace.ID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false
    @State private var rotate = false

    var body: some View {
        Button(action: {
            SolodkoTheme.haptics.orbTap()
            onTap()
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                Circle()
                    .fill(SolodkoTheme.colors.surface.glassActive)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: glowColors,
                            center: .topLeading,
                            startRadius: SolodkoTheme.spacing.xs,
                            endRadius: SolodkoTheme.spacing.fourXL
                        )
                    )
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .opacity(innerOpacity)
                Circle()
                    .strokeBorder(Color.white.opacity(0.58), lineWidth: SolodkoTheme.spacing.xs / 2)
            }
            .frame(width: SolodkoTheme.spacing.fourXL * 2.2, height: SolodkoTheme.spacing.fourXL * 2.2)
            .scaleEffect(scale)
            .opacity(reduceMotion ? reducedMotionOpacity : 1)
            .matchedGeometryEffect(id: "mealCard", in: namespace, isSource: state != .resultReady)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .frame(minWidth: SolodkoTheme.spacing.minTouchTarget, minHeight: SolodkoTheme.spacing.minTouchTarget)
        .accessibilityLabel(SolodkoCopy.Accessibility.foodInput)
        .accessibilityHint(SolodkoCopy.Accessibility.foodInputHint)
        .accessibilityValue(state.accessibilityValue)
        .onAppear {
            breath = true
            rotate = state == .processing
        }
        .onChange(of: state) { _, newValue in
            rotate = newValue == .processing
        }
        .animation(reduceMotion ? .easeInOut(duration: 2).repeatForever(autoreverses: true) : .easeInOut(duration: 2).repeatForever(autoreverses: true), value: breath)
        .animation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring, value: state)
        .animation(state == .processing && !reduceMotion ? .linear(duration: 1.4).repeatForever(autoreverses: false) : nil, value: rotate)
    }

    private var scale: CGFloat {
        if reduceMotion { return 1 }
        switch state {
        case .idle: return breath ? 1.03 : 1
        case .listening: return 1.1
        case .processing, .resultReady: return 1
        case .clarificationNeeded: return breath ? 0.98 : 1
        case .lowConfidence: return 0.95
        }
    }

    private var reducedMotionOpacity: CGFloat {
        switch state {
        case .processing: return breath ? 1 : 0.72
        case .clarificationNeeded: return breath ? 0.85 : 0.75
        case .lowConfidence: return 0.82
        default: return breath ? 1 : 0.88
        }
    }

    private var innerOpacity: CGFloat {
        switch state {
        case .idle: return breath ? 0.72 : 0.52
        case .listening, .resultReady: return 0.88
        case .processing: return 0.76
        case .clarificationNeeded: return 0.48
        case .lowConfidence: return 0.42
        }
    }

    private var glowColors: [Color] {
        switch state {
        case .lowConfidence:
            return [SolodkoTheme.colors.confidence.lowConfidence, .clear]
        case .processing:
            return [SolodkoTheme.colors.confidence.estimatedGlow, SolodkoTheme.colors.confidence.exactGlow, .clear]
        case .clarificationNeeded:
            return [SolodkoTheme.colors.confidence.memoryGlow, .clear]
        default:
            return [SolodkoTheme.colors.confidence.exactGlow, .clear]
        }
    }
}

