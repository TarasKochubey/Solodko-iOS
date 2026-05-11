import SwiftUI

struct TimeOfDayHeader: View {
    @Environment(\.timeOfDayProvider) private var provider
    var forcedBucket: TimeOfDayBucket?

    private var bucket: TimeOfDayBucket {
        forcedBucket ?? provider.bucket()
    }

    var body: some View {
        Text(provider.label(for: bucket))
            .font(SolodkoTheme.typography.timeHeader)
            .foregroundStyle(SolodkoTheme.colors.text.primary)
            .lineLimit(nil)
            .accessibilityLabel(provider.label(for: bucket))
            .accessibilityAddTraits(.isHeader)
    }
}

