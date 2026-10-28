//
//  TasksContainer.swift
//  DailyPlanner_ToDo
//

import SwiftUI
import SwiftData

struct TasksContainer: View {

    @Query(sort: \Task.dueDate)
    private var tasks: [Task]

    @Environment(\.modelContext)
    private var context

    var viewModel: TaskViewModel

    private var filteredTasks: [Task] {
        viewModel.filterTasks(tasks)
    }

    private var completedCount: Int {
        filteredTasks.filter(\.isCompleted).count
    }

    private var remainingCount: Int {
        filteredTasks.count - completedCount
    }

    private var progress: Double {
        guard !filteredTasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(filteredTasks.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // MARK: Today's Focus

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(
                            Color("Border").opacity(0.6),
                            lineWidth: 9
                        )

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.orange.opacity(0.85),
                            style: StrokeStyle(
                                lineWidth: 9,
                                lineCap: .butt
                            )
                        )
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 1) {
                        Text("\(completedCount)")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundStyle(Color("Text"))

                        Text("of \(filteredTasks.count)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color("Text").opacity(0.6))
                    }
                }
                .frame(width: 76, height: 76)

                VStack(alignment: .leading, spacing: 7) {
                    Label("TODAY'S FOCUS", systemImage: "sparkles")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1.4)
                        .foregroundStyle(Color.orange)

                    Text("\(remainingCount) tasks left to flow through")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color("Text"))
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )

                    Text(
                        remainingCount == 0
                            ? "Everything is taken care of."
                            : "One step at a time."
                    )
                    .font(.system(size: 13))
                    .foregroundStyle(Color("Text").opacity(0.6))
                }

                Spacer(minLength: 0)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("Container"))
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .overlay {
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color("Border"), lineWidth: 1)
            }

            // MARK: Your Rhythm

            VStack(alignment: .leading, spacing: 16) {
                Text("YOUR RHYTHM")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2.2)
                    .foregroundStyle(Color("Text").opacity(0.5))
                    .padding(.leading, 2)

                HStack {
                    Text("Today")
                        .font(.system(
                            size: 29,
                            weight: .medium,
                            design: .rounded
                        ))
                        .tracking(-1)
                        .foregroundStyle(Color("Text"))

                    Spacer()

                    Label(
                        Date.now.formatted(
                            .dateTime.month(.abbreviated).day()
                        ),
                        systemImage: "calendar"
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color("Text").opacity(0.75))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 11)
                    .background(Color("Container"))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(Color("Border"), lineWidth: 1)
                    }
                }

                TaskTypeSelector { selection in
                    viewModel.taskselection = selection
                }

                // MARK: Task list

                VStack(spacing: 0) {
                    if filteredTasks.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 34))
                                .foregroundStyle(
                                    Color.accentColor.opacity(0.65)
                                )

                            Text("A little room to breathe")
                                .font(.system(
                                    size: 16,
                                    weight: .semibold
                                ))
                                .foregroundStyle(Color("Text"))

                            Text("Your tasks will appear here.")
                                .font(.system(size: 13))
                                .foregroundStyle(
                                    Color("Text").opacity(0.55)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 36)
                    } else {
                        ForEach(
                            Array(filteredTasks.enumerated()),
                            id: \.element.persistentModelID
                        ) { index, task in
                            TaskItem(task: task) { selectedTask in
                                selectedTask.isCompleted.toggle()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)

                            if index < filteredTasks.count - 1 {
                                Divider()
                                    .overlay(Color("Border").opacity(0.65))
                            }
                        }
                    }
                }
                .background(Color("Container"))
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .overlay {
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color("Border"), lineWidth: 1)
                }
            }
        }
    }
}

#Preview {
    TasksContainer(
        viewModel: TaskViewModel(
            filterProtocol: FilterUseCase()
        )
    )
    .padding()
    .background(Color("Background"))
}

