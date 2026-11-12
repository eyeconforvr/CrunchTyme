import SwiftUI
import SwiftData

/// Shared editor for Home and Calendar. Draft values never mutate a task until Save.
struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var viewModel = TaskViewModel(filterProtocol: FilterUseCase())
    @State private var date: Date
    @State private var taskName: String
    @State private var taskDescription: String
    @State private var saveError: String?
    @State private var selectedDetent: PresentationDetent = .medium
    @FocusState private var focusedField: Field?

    private let taskToEdit: Task?
    @State private var earliestDueDate: Date
    private enum Field: Hashable { case name, description }

    init(taskToEdit: Task? = nil, initialDate: Date? = nil) {
        let now = Date()
        self.taskToEdit = taskToEdit
        _earliestDueDate = State(initialValue: now)
        _date = State(initialValue: taskToEdit?.dueDate ?? max(initialDate ?? now, now))
        _taskName = State(initialValue: taskToEdit?.title ?? "")
        _taskDescription = State(initialValue: taskToEdit?.taskdescription ?? "")
    }

    private var canSave: Bool {
        !taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text(taskToEdit == nil ? "New Task" : "Edit Task")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        GroupBox {
                            Text("Task Name")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                            TextField("Paint the house", text: $taskName)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .description }
                                .accessibilityIdentifier("taskNameField")
                                .accessibilityHint("A task name is required to save.")
                        }

                        GroupBox {
                            Text("Description")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                            TextField("Paint the walls in the kitchen", text: $taskDescription, axis: .vertical)
                                .lineLimit(1...5)
                                .focused($focusedField, equals: .description)
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                                .accessibilityIdentifier("taskDescriptionField")
                        }

                        HStack {
                            if taskToEdit == nil {
                                DatePicker("Due Date", selection: $date, in: earliestDueDate...)
                                    .padding(.bottom, 10)
                            } else {
                                DatePicker("Due Date", selection: $date)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(10)
                    }
                    .padding(15)
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom) {
                HStack(alignment: .center) {
                    Button("Save", action: save)
                        .disabled(!canSave)
                        .accessibilityIdentifier("saveTaskButton")
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Cancel") {
                        focusedField = nil
                        dismiss()
                    }
                    Spacer()
                    Button("Done") { focusedField = nil }
                        .accessibilityLabel("Dismiss keyboard")
                }
            }
            .onChange(of: focusedField) { _, field in
                if field != nil { selectedDetent = .large }
            }
            .accessibilityAction(.escape) {
                focusedField = nil
                dismiss()
            }
            .alert("Couldn't save task", isPresented: Binding(
                get: { saveError != nil },
                set: { if !$0 { saveError = nil } }
            )) {
                Button("OK", role: .cancel) { saveError = nil }
            } message: {
                Text(saveError ?? "Please try again.")
            }
        }
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .presentationSizing(.form)
        .presentationDragIndicator(.visible)
    }

    private func save() {
        guard canSave else { return }
        focusedField = nil
        do {
            if let taskToEdit {
                try viewModel.updateTask(taskToEdit, title: taskName, description: taskDescription,
                                         dueDate: date, context: context)
            } else {
                try viewModel.addTask(title: taskName, description: taskDescription,
                                      dueDate: date, context: context)
            }
            dismiss()
        } catch {
            saveError = error.localizedDescription
        }
    }
}

#Preview {
    AddTaskView()
        .modelContainer(for: Task.self, inMemory: true)
}
