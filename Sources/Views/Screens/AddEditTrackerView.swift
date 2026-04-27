import SwiftData
import SwiftUI

struct AddEditTrackerView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  private let tracker: Tracker?
  private let onSave: (() -> Void)?

  @State private var title: String
  @State private var startDate: Date
  @State private var category: TrackerCategory
  @State private var iconName: String
  @State private var color: String
  @State private var errorMessage: String?

  private var isEditMode: Bool { tracker != nil }

  private var selectedColor: Color {
    switch color {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "blue": return .blue
    case "purple": return .purple
    case "pink": return .pink
    case "mint": return .mint
    case "teal": return .teal
    case "indigo": return .indigo
    default: return .accentColor
    }
  }

  init(tracker: Tracker? = nil, onSave: (() -> Void)? = nil) {
    self.tracker = tracker
    self.onSave = onSave
    _title = State(initialValue: tracker?.title ?? "")
    _startDate = State(initialValue: tracker?.startDate ?? Date())
    _category = State(initialValue: tracker?.category ?? .sobriety)
    _iconName = State(initialValue: tracker?.iconName ?? "leaf.fill")
    _color = State(initialValue: tracker?.color ?? "green")
    _errorMessage = State(initialValue: nil)
  }

  var body: some View {
    Form {
      Section("What are you celebrating?") {
        TextField("e.g. Sobriety, New Beginning", text: $title)
      }

      Section("When did your journey begin?") {
        DatePicker(
          "Start Date",
          selection: $startDate,
          in: ...Date(),
          displayedComponents: .date
        )
      }

      Section("Category") {
        Picker("Category", selection: $category) {
          ForEach(TrackerCategory.allCases, id: \.self) { cat in
            Text(cat.rawValue.capitalized).tag(cat)
          }
        }
        .pickerStyle(.segmented)
      }

      Section("Icon") {
        IconPickerView(selectedIcon: $iconName, color: selectedColor)
      }

      Section("Color") {
        ColorPickerGridView(selectedColor: $color)
      }

      if let errorMessage {
        Section {
          Text(errorMessage)
            .foregroundColor(.red)
            .font(.callout)
        }
      }
    }
    .navigationTitle(isEditMode ? "Edit Tracker" : "New Tracker")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if isEditMode {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      ToolbarItem(placement: .confirmationAction) {
        Button("Save") {
          save()
        }
      }
    }
  }

  private func save() {
    errorMessage = nil

    if isEditMode, let tracker {
      // Validate before mutating
      guard !title.isEmpty else {
        errorMessage = TrackerValidationError.emptyTitle.errorDescription
        return
      }
      guard startDate <= Date() else {
        errorMessage = TrackerValidationError.futureDateNotAllowed.errorDescription
        return
      }

      tracker.title = title
      tracker.startDate = startDate
      tracker.category = category
      tracker.iconName = iconName
      tracker.color = color
      tracker.updatedAt = Date()
    } else {
      do {
        let newTracker = try Tracker(
          title: title,
          startDate: startDate,
          category: category,
          iconName: iconName,
          color: color
        )
        modelContext.insert(newTracker)
      } catch let error as TrackerValidationError {
        errorMessage = error.errorDescription
        return
      } catch {
        errorMessage = error.localizedDescription
        return
      }
    }

    if isEditMode {
      dismiss()
    } else {
      resetForm()
      onSave?()
    }
  }

  private func resetForm() {
    title = ""
    startDate = Date()
    category = .sobriety
    iconName = "leaf.fill"
    color = "green"
    errorMessage = nil
  }
}

struct AddEditTrackerView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AddEditTrackerView()
    }
  }
}
