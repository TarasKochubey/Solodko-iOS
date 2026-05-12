import SwiftUI

struct ConsoleView: View {
    @Environment(FoodMemoryStore.self) private var foodMemoryStore
    @Bindable var controller: MealInputController
    var namespace: Namespace.ID
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var cameraMode: CameraInputMode?

    var body: some View {
        VStack(spacing: SolodkoTheme.spacing.sm) {
            AIOrb(state: controller.orbState, onTap: {
                if controller.status == .idle {
                    withAnimation(reduceMotion ? .easeOut(duration: SolodkoTheme.motion.fast) : .solodkoSpring) {
                        controller.beginListening()
                    }
                }
            }, namespace: namespace)
            .accessibilitySortPriority(3)

            InputComposer(
                controller: controller,
                onTextSubmit: { text in
                    if controller.status == .clarifying {
                        controller.submitClarification(text, reduceMotion: reduceMotion)
                    } else {
                        controller.submitText(text, savedFoods: foodMemoryStore.savedFoods, reduceMotion: reduceMotion)
                    }
                },
                onVoiceTap: { handleVoiceTap() },
                onCameraTap: { handleCameraTap() },
                onBarcodeTap: { handleBarcodeTap() }
            )
            .accessibilitySortPriority(2)
        }
        .padding(.top, SolodkoTheme.spacing.md)
        .fullScreenCover(item: $cameraMode) { mode in
            CameraInputModal(mode: mode) {
                cameraMode = nil
            } onCapture: {
                cameraMode = nil
                switch mode {
                case .photo:
                    controller.processPhotoInput(reduceMotion: reduceMotion)
                case .barcode:
                    controller.processBarcodeInput(reduceMotion: reduceMotion)
                }
            }
        }
    }

    private func handleVoiceTap() {
        controller.startVoiceDemo(reduceMotion: reduceMotion)
    }

    private func handleCameraTap() {
        cameraMode = .photo
    }

    private func handleBarcodeTap() {
        cameraMode = .barcode
    }
}

enum CameraInputMode: Identifiable {
    case photo
    case barcode

    var id: String {
        switch self {
        case .photo: return "photo"
        case .barcode: return "barcode"
        }
    }

    var title: String {
        switch self {
        case .photo: return SolodkoCopy.Home.cameraTitle
        case .barcode: return SolodkoCopy.Home.barcodeTitle
        }
    }

    var iconName: String {
        switch self {
        case .photo: return "camera.viewfinder"
        case .barcode: return "barcode.viewfinder"
        }
    }

    var actionTitle: String {
        switch self {
        case .photo: return SolodkoCopy.Actions.usePhoto
        case .barcode: return SolodkoCopy.Actions.useBarcode
        }
    }
}

struct CameraInputModal: View {
    var mode: CameraInputMode
    var onCancel: () -> Void
    var onCapture: () -> Void

    var body: some View {
        ZStack {
            AtmosphericBackground()

            VStack(spacing: SolodkoTheme.spacing.twoXL) {
                HStack {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(SolodkoTheme.colors.text.primary)
                            .frame(width: SolodkoTheme.spacing.minTouchTarget, height: SolodkoTheme.spacing.minTouchTarget)
                            .background(SolodkoTheme.colors.surface.glassPrimary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(SolodkoCopy.Actions.dismiss)

                    Spacer()
                }

                Spacer()

                Image(systemName: mode.iconName)
                    .font(.system(size: 58, weight: .medium))
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .frame(width: 132, height: 132)
                    .background(SolodkoTheme.colors.surface.glassPrimary)
                    .clipShape(Circle())
                    .accessibilityHidden(true)

                Text(mode.title)
                    .font(SolodkoTheme.typography.screenTitle)
                    .foregroundStyle(SolodkoTheme.colors.text.primary)
                    .multilineTextAlignment(.center)

                Spacer()

                QuickActionChip(label: mode.actionTitle, prominent: true, action: onCapture)
                    .padding(.bottom, SolodkoTheme.spacing.fourXL)
            }
            .padding(SolodkoTheme.spacing.xl)
        }
    }
}
