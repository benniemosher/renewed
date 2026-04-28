import SwiftUI

struct EmptyStateView: View {
  var onCreateTracker: (() -> Void)?

  var body: some View {
    VStack(spacing: 24) {
      Image(systemName: "heart.fill")
        .font(.system(size: 64))
        .foregroundColor(.accentColor)

      VStack(spacing: 8) {
        Text("Begin Your Journey")
          .font(.title2.bold())

        Text("Track your days of freedom, hope, and renewal")
          .font(.body)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }

      if let onCreateTracker {
        Button(action: onCreateTracker) {
          Text("Create Your First Tracker")
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal, 48)
        .accessibilityIdentifier("createFirstTrackerButton")
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityElement(children: .combine)
    .accessibilityIdentifier("emptyStateView")
  }
}

#Preview {
  EmptyStateView(onCreateTracker: {})
}
