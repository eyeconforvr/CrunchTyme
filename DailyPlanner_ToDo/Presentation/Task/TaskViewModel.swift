import Foundation
import SwiftData
import SwiftUI

enum TaskValidationError: LocalizedError {
    case emptyTitle

    var errorDescription: String? {
        "Enter a task name before saving."
    }
}

@Observable
class TaskViewModel {
    var taskselection: TaskSelectionSection = .toDo
    private let taskFilterer: TaskFiltering

    init(filterProtocol: TaskFiltering, isFiltered: Bool = false) {
        self.taskFilterer = filterProtocol
    }

    func filterTasks(_ tasks: [Task]) -> [Task] {
        taskFilterer.filter(tasks, by: taskselection)
    }

    func addTask(title: String, description: String, dueDate: Date, context: ModelContext) throws {
        let title = try validatedTitle(title)
        // Persist pending changes first so failure recovery affects only this operation.
        try context.save()
        let task = Task(title: title, description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                        isCompleted: false, dueDate: dueDate)
        context.insert(task)
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func deleteTask(_ task: Task, context: ModelContext) throws {
        try context.save()
        context.delete(task)
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func updateTask(_ task: Task, title: String, description: String, dueDate: Date, context: ModelContext) throws {
        let title = try validatedTitle(title)
        try context.save()
        task.title = title
        task.taskdescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        task.dueDate = dueDate
        // Editing details must not mark a completed task as incomplete.
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    private func validatedTitle(_ title: String) throws -> String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw TaskValidationError.emptyTitle }
        return trimmed
    }
}
