import SwiftUI

struct EmptyStateView: View {
  var iconName: String = "leaf.fill"
  var message: String = "Your journey begins with the first step"

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: iconName)
        .font(.system(size: 64))
        .foregroundColor(.green)

      Text(message)
        .font(.title3)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityElement(children: .combine)
    .accessibilityIdentifier("emptyStateView")
  }
}
