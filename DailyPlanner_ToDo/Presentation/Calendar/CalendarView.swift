//
//  CalendarTimelineView.swift
//
//

import SwiftUI



struct TaskColorSet {
    let background: Color
    let foreground: Color
}

extension TaskColorSet {
    static let palette: [TaskColorSet] = [
        TaskColorSet(background: Color(hex: "FBE9E7"), foreground: Color(hex: "B5453D")), // clay
        TaskColorSet(background: Color(hex: "EAEAF6"), foreground: Color(hex: "4B4A78")), // periwinkle
        TaskColorSet(background: Color(hex: "FBF3DD"), foreground: Color(hex: "93762E")), // butter
        TaskColorSet(background: Color(hex: "E5F3EC"), foreground: Color(hex: "3D7A5C")), // mint
        TaskColorSet(background: Color(hex: "F6E9EE"), foreground: Color(hex: "9C4A67")), // blush
    ]

    static func forIndex(_ index: Int) -> TaskColorSet {
        palette[index % palette.count]
    }
}

// MARK: - Design tokens

enum Theme {
    static let appBackground = Color(hex: "F5F5FA")
    static let ink           = Color(hex: "1B1A26")
    static let inkSoft       = Color(hex: "8A889B")
    static let line          = Color(hex: "E4E3ED")
    static let accent        = Color(hex: "5B4FE9")
    static let accentSoft    = Color(hex: "EDEBFC")
}

// MARK: - Root view

struct CalendarView<Task: CalendarTask>: View {

    let tasks: [Task]
    @State private var viewModel = CalendarViewModel<Task>()
    @State private var scrolledWeekID: Date?
    @State private var isSheetPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.bottom, 22)

                Text(viewModel.headerTitle)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Theme.ink)
                    .padding(.bottom, 18)

                weekStrip
                    .padding(.bottom, 26)

                timeline
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Theme.appBackground.ignoresSafeArea())
        .onChange(of: viewModel.selectedDate) { _, newValue in
            // TEMPORARY — remove once the mismatch is found.
            print("Selected date: \(newValue)")
            let matches = viewModel.tasksForSelectedDay(from: tasks)
            print("Matching tasks: \(matches.count)")
            for task in tasks {
                print("  task \(task.title): due \(task.date), sameDay? \(Calendar.current.isDate(task.date, inSameDayAs: newValue))")
            }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.ink)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Theme.ink.opacity(0.06), radius: 3, x: 0, y: 1)
            }
            

            Spacer()

            Button(action: {
                isSheetPresented = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 20, height: 20)
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(Theme.accent)
                .clipShape(Capsule())
                .shadow(
                    color: Theme.accent.opacity(0.28),
                    radius: 10,
                    x: 0,
                    y: 8
                )
            }
            .sheet(isPresented: $isSheetPresented) {
                AddTaskView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: Week strip

    private var weekStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.weekPages) { page in
                    weekPageRow(page.days)
                        .containerRelativeFrame(.horizontal)
                        .id(page.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrolledWeekID)
        .onChange(of: scrolledWeekID) { _, newValue in
            viewModel.updateScrollAnchor(to: newValue)
        }
        .onAppear {
            // Open on the week containing today/selectedDate rather than
            // the very first page in the whole multi-month range.
            if scrolledWeekID == nil {
                scrolledWeekID = viewModel.weekPageID(for: viewModel.selectedDate)
            }
        }
    }

    private func weekPageRow(_ days: [Date]) -> some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { date in
                dayCell(for: date)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected = viewModel.isSelected(date)
        let isToday = viewModel.isToday(date)
        let hasTasks = viewModel.hasTasks(on: date, in: tasks)

        return VStack(spacing: 8) {
            Text(viewModel.weekdayLabel(for: date))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(isSelected ? Theme.accent : Theme.inkSoft)

            Text("\(viewModel.dayNumber(for: date))")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : Theme.ink)
                .frame(width: 30, height: 30)
                .background(isSelected ? Theme.accent : Color.clear)
                .clipShape(Circle())

            HStack(spacing: 3) {
                // Solid dot: today. Lighter dot: something's scheduled.
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 4, height: 4)
                    .opacity(isToday ? 1 : 0)

                Circle()
                    .fill(isSelected ? Color.white : Theme.accent.opacity(0.4))
                    .frame(width: 4, height: 4)
                    .opacity(hasTasks ? 1 : 0)
            }
            .frame(height: 4)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.15)) {
                viewModel.select(date)
            }
        }
    }

    // MARK: Timeline

    private var timeline: some View {
        let dayTasks = viewModel.tasksForSelectedDay(from: tasks)
        let currentID = viewModel.currentTaskID(from: tasks)

        return Group {
            if dayTasks.isEmpty {
                emptyState
            } else {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Theme.line)
                        .frame(width: 2)
                        .padding(.vertical, 10)
                        .padding(.leading, 7)

                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(dayTasks.enumerated()), id: \.element.id) { index, task in
                            TimelineRow(
                                title: task.title,
                                time: viewModel.timeLabel(for: task.date),
                                description: task.notes,
                                colorSet: .forIndex(index),
                                isCurrent: task.id == currentID
                            )
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 28, weight: .light))
                .foregroundColor(Theme.inkSoft)
            Text("Nothing scheduled")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Theme.ink)
            Text("Tasks for this day will show up here.")
                .font(.system(size: 13))
                .foregroundColor(Theme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Timeline row (node + card)

private struct TimelineRow: View {
    let title: String
    let time: String
    let description: String
    let colorSet: TaskColorSet
    let isCurrent: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                if isCurrent {
                    Circle()
                        .fill(colorSet.foreground.opacity(0.12))
                        .frame(width: 24, height: 24)
                    Circle()
                        .strokeBorder(colorSet.foreground, lineWidth: 3)
                        .background(Circle().fill(Color.white))
                        .frame(width: 18, height: 18)
                    Circle()
                        .fill(colorSet.foreground)
                        .frame(width: 8, height: 8)
                } else {
                    Circle()
                        .strokeBorder(Theme.line, lineWidth: 2)
                        .background(Circle().fill(Color.white))
                        .frame(width: 16, height: 16)
                }
            }
            .frame(width: 16)
            .padding(.top, 20)

            TaskCard(title: title, time: time, description: description, colorSet: colorSet)
        }
    }
}

// MARK: - Task card

private struct TaskCard: View {
    let title: String
    let time: String
    let description: String
    let colorSet: TaskColorSet

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text(time)
                    .font(.system(size: 13, weight: .semibold))
                    .opacity(0.75)
            }
            .foregroundColor(colorSet.foreground)

            Text(description)
                .font(.system(size: 13.5))
                .foregroundColor(colorSet.foreground.opacity(0.8))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorSet.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Hex color helper

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

struct CalendarView_Previews: PreviewProvider {
    struct PreviewTask: CalendarTask {
        let id = UUID()
        let title: String
        let date: Date
        let notes: String
    }

    static var previews: some View {
        let cal = Calendar.current
        let today = Date()
        let sample: [PreviewTask] = [
            PreviewTask(title: "Wireframing", date: cal.date(bySettingHour: 12, minute: 0, second: 0, of: today)!, notes: "Sketch early ideas and rough layouts."),
            PreviewTask(title: "UI Design", date: cal.date(bySettingHour: 13, minute: 30, second: 0, of: today)!, notes: "Turn the wireframe into visuals."),
            PreviewTask(title: "Prototyping", date: cal.date(bySettingHour: 15, minute: 0, second: 0, of: today)!, notes: "Build the interactive prototype."),
        ]
        CalendarView(tasks: sample)
    }
}
