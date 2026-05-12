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
                    .fill(.thinMaterial)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                SolodkoTheme.colors.surface.pearl,
                                SolodkoTheme.colors.surface.glassActive,
                                SolodkoTheme.colors.surface.glassPrimary
                            ],
                            center: .topLeading,
                            startRadius: SolodkoTheme.spacing.xs,
                            endRadius: SolodkoTheme.spacing.fourXL * 2
                        )
                    )
                Circle()
                    .fill(
                        RadialGradient(
                            colors: glowColors,
                            center: .center,
                            startRadius: SolodkoTheme.spacing.xs,
                            endRadius: SolodkoTheme.spacing.fourXL * 1.8
                        )
                    )
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .opacity(innerOpacity)
                    .blur(radius: SolodkoTheme.spacing.xs)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.72),
                                Color.white.opacity(0.18),
                                .clear
                            ],
                            center: .topLeading,
                            startRadius: SolodkoTheme.spacing.xs,
                            endRadius: SolodkoTheme.spacing.fourXL * 1.5
                        )
                    )
                    .blendMode(.screen)
                    .opacity(highlightOpacity)
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.86),
                                Color.white.opacity(0.26),
                                Color.white.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: SolodkoTheme.spacing.xs / 2
                    )
            }
            .frame(width: SolodkoTheme.spacing.fourXL * 2.2, height: SolodkoTheme.spacing.fourXL * 2.2)
            .scaleEffect(scale)
            .opacity(opacity)
            .matchedGeometryEffect(id: "mealCard", in: namespace, isSource: state != .resultReady)
            .contentShape(Circle())
            .shadow(color: haloColor, radius: haloRadius, x: 0, y: SolodkoTheme.spacing.md)
            .solodkoShadow(SolodkoTheme.shadows.pearlHalo)
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

    private var opacity: CGFloat {
        if state == .resultReady { return reduceMotion ? 0 : 0.08 }
        return reduceMotion ? reducedMotionOpacity : 1
    }

    private var innerOpacity: CGFloat {
        switch state {
        case .idle: return breath ? 0.80 : 0.58
        case .listening, .resultReady: return 0.92
        case .processing: return 0.82
        case .clarificationNeeded: return 0.52
        case .lowConfidence: return 0.38
        }
    }

    private var highlightOpacity: CGFloat {
        switch state {
        case .listening, .resultReady: return 0.82
        case .processing: return 0.68
        case .lowConfidence: return 0.34
        default: return breath ? 0.68 : 0.50
        }
    }

    private var haloRadius: CGFloat {
        switch state {
        case .listening, .processing, .resultReady: return SolodkoTheme.spacing.fourXL
        case .lowConfidence: return SolodkoTheme.spacing.twoXL
        default: return SolodkoTheme.spacing.threeXL
        }
    }

    private var haloColor: Color {
        switch state {
        case .lowConfidence:
            return SolodkoTheme.colors.confidence.lowConfidence
        case .processing:
            return SolodkoTheme.colors.background.peachGlow.opacity(0.26)
        default:
            return SolodkoTheme.colors.background.peachLight.opacity(0.34)
        }
    }

    private var glowColors: [Color] {
        switch state {
        case .lowConfidence:
            return [SolodkoTheme.colors.confidence.lowConfidence, .clear]
        case .processing:
            return [Color.white.opacity(0.72), SolodkoTheme.colors.background.peachGlow.opacity(0.36), .clear]
        case .clarificationNeeded:
            return [SolodkoTheme.colors.background.peachLight.opacity(0.42), .clear]
        default:
            return [Color.white.opacity(0.58), SolodkoTheme.colors.confidence.exactGlow, .clear]
        }
    }
}
