import SwiftData
import SwiftUI

struct AddEditTrackerView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  private let tracker: Tracker?
  private let onSave: (() -> Void)?

  @State private var customName: String
  @State private var startDate: Date
  @State private var category: TrackerCategory
  @State private var iconName: String
  @State private var color: String
  @State private var errorMessage: String?
  @State private var showDeleteConfirmation = false

  private var isEditMode: Bool { tracker != nil }

  private var resolvedTitle: String {
    if category == .custom {
      return customName
    }
    return category.rawValue.capitalized
  }

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
    _customName = State(initialValue: tracker?.category == .custom ? (tracker?.title ?? "") : "")
    _startDate = State(initialValue: tracker?.startDate ?? Date())
    _category = State(initialValue: tracker?.category ?? .sobriety)
    _iconName = State(initialValue: tracker?.iconName ?? "leaf.fill")
    _color = State(initialValue: tracker?.color ?? "green")
    _errorMessage = State(initialValue: nil)
  }

  var body: some View {
    Form {
      Section("What are you celebrating?") {
        Picker("Category", selection: $category) {
          ForEach(TrackerCategory.allCases, id: \.self) { cat in
            Text(cat.rawValue.capitalized).tag(cat)
          }
        }
        .pickerStyle(.segmented)

        if category == .custom {
          TextField("Give it a name", text: $customName)
        }
      }

      Section("When did your journey begin?") {
        DatePicker(
          "Start Date",
          selection: $startDate,
          in: ...Date(),
          displayedComponents: .date
        )
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

      if isEditMode {
        Section {
          Button("Delete Tracker", role: .destructive) {
            showDeleteConfirmation = true
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
    .confirmationDialog(
      "Delete Tracker",
      isPresented: $showDeleteConfirmation,
      titleVisibility: .visible
    ) {
      Button("Delete", role: .destructive) {
        deleteTracker()
      }
    } message: {
      Text("Are you sure? This cannot be undone.")
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

    let titleToSave = resolvedTitle

    if isEditMode, let tracker {
      guard !titleToSave.isEmpty else {
        errorMessage = TrackerValidationError.emptyTitle.errorDescription
        return
      }
      guard startDate <= Date() else {
        errorMessage = TrackerValidationError.futureDateNotAllowed.errorDescription
        return
      }

      tracker.title = titleToSave
      tracker.startDate = startDate
      tracker.category = category
      tracker.iconName = iconName
      tracker.color = color
      tracker.updatedAt = Date()

      do {
        try modelContext.save()
      } catch {
        errorMessage = error.localizedDescription
        return
      }
    } else {
      do {
        let newTracker = try Tracker(
          title: titleToSave,
          startDate: startDate,
          category: category,
          iconName: iconName,
          color: color
        )
        modelContext.insert(newTracker)
        try modelContext.save()
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

  private func deleteTracker() {
    guard let tracker else { return }
    modelContext.delete(tracker)
    try? modelContext.save()
    dismiss()
  }

  private func resetForm() {
    customName = ""
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
