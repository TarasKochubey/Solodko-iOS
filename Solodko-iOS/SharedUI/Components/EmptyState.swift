import SwiftUI

struct EmptyState: View {
    var text: String

    var body: some View {
        Text(text)
            .font(SolodkoTheme.typography.body)
            .foregroundStyle(SolodkoTheme.colors.text.secondary)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityLabel(text)
    }
}

