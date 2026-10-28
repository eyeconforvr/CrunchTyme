//
//  TaskItem.swift
//  DailyPlanner_ToDo
//

import SwiftUI

struct TaskItem: View {

    let task: Task
    var isCompleted: (Task) -> Void

    private var accentColor: Color {
        let colors: [Color] = [
            Color(red: 0.72, green: 0.66, blue: 0.96), // Lavender
            Color(red: 0.98, green: 0.59, blue: 0.36), // Soft orange
            Color(red: 0.40, green: 0.68, blue: 0.55)  // Sage green
        ]

        // Keep the accent consistent for each task.
        let index = abs(task.title.hashValue % colors.count)
        return colors[index]
    }

    private var timeText: String {
        task.dueDate.formatted(
            date: .omitted,
            time: .shortened
        )
    }

    var body: some View {
        HStack(spacing: 14) {

            // MARK: Time

            Text(timeText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(
                    Color("Text").opacity(task.isCompleted ? 0.35 : 0.55)
                )
                .frame(width: 74, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            // MARK: Colored indicator

            Capsule()
                .fill(accentColor)
                .frame(width: 7, height: 56)

            // MARK: Task details

            VStack(alignment: .leading, spacing: 7) {
                Text(task.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        Color("Text").opacity(task.isCompleted ? 0.45 : 1)
                    )
                    .strikethrough(task.isCompleted, color: Color("Text").opacity(0.5))
                    .lineLimit(2)

                Text(task.taskdescription.isEmpty ? "Task" : task.taskdescription)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color("Text").opacity(0.55))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: Completion button

            Button {
                isCompleted(task)
            } label: {
                Image(
                    systemName: task.isCompleted
                        ? "checkmark"
                        : "circle"
                )
                .font(.system(
                    size: task.isCompleted ? 14 : 28,
                    weight: .medium
                ))
                .foregroundStyle(
                    task.isCompleted
                        ? Color.white
                        : Color(red: 0.79, green: 0.83, blue: 0.81)
                )
                .frame(width: 42, height: 42)
                .background {
                    if task.isCompleted {
                        Circle()
                            .fill(
                                Color(
                                    red: 0.48,
                                    green: 0.63,
                                    blue: 0.58
                                )
                            )
                    }
                }
                .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                task.isCompleted
                    ? "Mark \(task.title) as incomplete"
                    : "Complete \(task.title)"
            )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    let task = Task(
        title: "Design review",
        description: "Mobile flow · Studio",
        isCompleted: false,
        dueDate: Date()
    )

    VStack(spacing: 0) {
        TaskItem(task: task) { selectedTask in
            selectedTask.isCompleted.toggle()
        }

        Divider()

        TaskItem(
            task: Task(
                title: "Team stand-up",
                description: "Weekly sync · 30 min",
                isCompleted: true,
                dueDate: Date()
            )
        ) { selectedTask in
            selectedTask.isCompleted.toggle()
        }
    }
    .padding()
    .background(Color("Container"))
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding()
    .background(Color("Background"))
}

