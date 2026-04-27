import SwiftUI

struct ColorPickerGridView: View {
  @Binding var selectedColor: String

  private let colorOptions: [(name: String, color: Color)] = [
    ("red", .red),
    ("orange", .orange),
    ("yellow", .yellow),
    ("green", .green),
    ("blue", .blue),
    ("purple", .purple),
    ("pink", .pink),
    ("mint", .mint),
    ("teal", .teal),
    ("indigo", .indigo),
  ]

  private let columns = Array(repeating: GridItem(.flexible()), count: 5)

  var body: some View {
    LazyVGrid(columns: columns, spacing: 12) {
      ForEach(colorOptions, id: \.name) { option in
        Circle()
          .fill(option.color)
          .frame(width: 36, height: 36)
          .overlay(
            Group {
              if selectedColor == option.name {
                Image(systemName: "checkmark")
                  .font(.caption.bold())
                  .foregroundColor(.white)
              }
            }
          )
          .onTapGesture {
            selectedColor = option.name
          }
          .accessibilityLabel(option.name)
          .accessibilityAddTraits(selectedColor == option.name ? .isSelected : [])
      }
    }
  }
}
