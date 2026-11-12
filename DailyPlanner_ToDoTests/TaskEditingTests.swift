import XCTest
import SwiftData
@testable import DailyPlanner_ToDo

@MainActor
final class TaskEditingTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(for: Task.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = ModelContext(container)
        context.autosaveEnabled = false
        return context
    }

    func testEmptyAndWhitespaceNamesCannotCreateTasks() throws {
        let context = try makeContext()
        let viewModel = TaskViewModel(filterProtocol: FilterUseCase())
        for title in ["", "   ", "\n\t "] {
            XCTAssertThrowsError(try viewModel.addTask(title: title, description: "Details alone are not a task name",
                                                      dueDate: Date(), context: context)) {
                guard case TaskValidationError.emptyTitle = $0 else { return XCTFail("Unexpected error: \($0)") }
            }
        }
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<Task>()), 0)
        XCTAssertFalse(context.hasChanges)
    }

    func testTaskNameIsTrimmedAndDescriptionMayBeEmpty() throws {
        let context = try makeContext()
        let viewModel = TaskViewModel(filterProtocol: FilterUseCase())
        try viewModel.addTask(title: "  A real task\n", description: "  ", dueDate: Date(), context: context)
        let saved = try XCTUnwrap(context.fetch(FetchDescriptor<Task>()).first)
        XCTAssertEqual(saved.title, "A real task")
        XCTAssertEqual(saved.taskdescription, "")
        XCTAssertFalse(saved.isCompleted)
        XCTAssertFalse(context.hasChanges)
    }

    func testEditPreservesIdentityAndCompletionAndMovesCalendarDay() throws {
        let context = try makeContext()
        let viewModel = TaskViewModel(filterProtocol: FilterUseCase())
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: 1, to: today))
        let task = Task(title: "Original", description: "Before", isCompleted: true, dueDate: today)
        context.insert(task)
        try context.save()
        let originalID = task.id
        try viewModel.updateTask(task, title: " Updated ", description: " After ", dueDate: tomorrow, context: context)
        let calendar = CalendarViewModel<Task>(referenceDate: today)
        XCTAssertTrue(calendar.tasksForSelectedDay(from: [task]).isEmpty)
        calendar.select(tomorrow)
        XCTAssertEqual(calendar.tasksForSelectedDay(from: [task]).map(\.id), [originalID])
        let freshContext = ModelContext(context.container)
        let saved = try XCTUnwrap(freshContext.fetch(FetchDescriptor<Task>()).first)
        XCTAssertEqual(saved.id, originalID)
        XCTAssertEqual(saved.title, "Updated")
        XCTAssertEqual(saved.taskdescription, "After")
        XCTAssertEqual(saved.dueDate, tomorrow)
        XCTAssertTrue(saved.isCompleted)
    }

    func testInvalidEditDoesNotMutateExistingTask() throws {
        let context = try makeContext()
        let viewModel = TaskViewModel(filterProtocol: FilterUseCase())
        let date = Date()
        let task = Task(title: "Keep me", description: "Keep details", isCompleted: true, dueDate: date)
        context.insert(task)
        try context.save()
        XCTAssertThrowsError(try viewModel.updateTask(task, title: " \n", description: "Changed",
                                                     dueDate: date.addingTimeInterval(3600), context: context))
        XCTAssertEqual(task.title, "Keep me")
        XCTAssertEqual(task.taskdescription, "Keep details")
        XCTAssertEqual(task.dueDate, date)
        XCTAssertTrue(task.isCompleted)
        XCTAssertFalse(context.hasChanges)
    }

    func testDeletionPersistsAndLeavesOtherTasksIntact() throws {
        let context = try makeContext()
        let viewModel = TaskViewModel(filterProtocol: FilterUseCase())
        let remove = Task(title: "Delete", description: "", isCompleted: false, dueDate: Date())
        let keep = Task(title: "Keep", description: "", isCompleted: false, dueDate: Date())
        context.insert(remove)
        context.insert(keep)
        try context.save()
        try viewModel.deleteTask(remove, context: context)
        let freshContext = ModelContext(context.container)
        XCTAssertEqual(try freshContext.fetch(FetchDescriptor<Task>()).map(\.title), ["Keep"])
    }
}
