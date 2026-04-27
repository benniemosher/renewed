import SwiftUI

struct IconPickerView: View {
  @Binding var selectedIcon: String
  let color: Color

  private let icons = [
    "leaf.fill", "heart.fill", "star.fill", "flame.fill", "drop.fill",
    "sun.max.fill", "moon.fill", "bolt.fill", "shield.fill", "hand.raised.fill",
    "figure.walk", "brain.head.profile", "lungs.fill", "cross.fill", "sparkles",
    "trophy.fill", "flag.fill", "mountain.2.fill", "sunrise.fill", "bird.fill",
  ]

  private let columns = Array(repeating: GridItem(.flexible()), count: 5)

  var body: some View {
    LazyVGrid(columns: columns, spacing: 12) {
      ForEach(icons, id: \.self) { icon in
        Image(systemName: icon)
          .font(.title2)
          .frame(width: 44, height: 44)
          .foregroundColor(selectedIcon == icon ? .white : color)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(selectedIcon == icon ? color : color.opacity(0.1))
          )
          .onTapGesture {
            selectedIcon = icon
          }
          .accessibilityLabel(icon)
          .accessibilityAddTraits(selectedIcon == icon ? .isSelected : [])
      }
    }
  }
}
