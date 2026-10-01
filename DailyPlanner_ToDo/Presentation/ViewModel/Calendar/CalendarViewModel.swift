

import SwiftUI


protocol CalendarTask: Identifiable {
    var title: String { get }
    var date: Date { get }
    var notes: String { get }
}


struct WeekPage: Identifiable, Hashable {
  
    let id: Date
    let days: [Date]
}


@Observable
final class CalendarViewModel<Task: CalendarTask> {

    
    var selectedDate: Date

    private(set) var scrollAnchorDate: Date

  
    let weekPages: [WeekPage]

    private let calendar: Calendar

    init(
        referenceDate: Date = Date(),
        calendar: Calendar = .current,
        monthsBefore: Int = 6,
        monthsAfter: Int = 6
    ) {
        var cal = calendar
        cal.firstWeekday = 2 // Monday
        self.calendar = cal
        let today = cal.startOfDay(for: referenceDate)
        self.selectedDate = today
        self.scrollAnchorDate = today
        self.weekPages = Self.weekPages(
            around: today,
            monthsBefore: monthsBefore,
            monthsAfter: monthsAfter,
            calendar: cal
        )
    }

    func hasTasks(on date: Date, in tasks: [Task]) -> Bool {
        tasks.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

  
    func weekPageID(for date: Date) -> Date {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return calendar.startOfDay(for: date)
        }
        return calendar.startOfDay(for: interval.start)
    }

  
    func tasksForSelectedDay(from tasks: [Task]) -> [Task] {
        tasks
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.date < $1.date }
    }

    func currentTaskID(from tasks: [Task]) -> Task.ID? {
        guard calendar.isDateInToday(selectedDate) else { return nil }
        let now = Date()
        return tasksForSelectedDay(from: tasks).first(where: { $0.date >= now })?.id
    }

    var isToday: (Date) -> Bool {
        { [calendar] date in calendar.isDateInToday(date) }
    }

    var isSelected: (Date) -> Bool {
        { [calendar, selectedDate] date in calendar.isDate(date, inSameDayAs: selectedDate) }
    }


    func select(_ date: Date) {
        let day = calendar.startOfDay(for: date)
        selectedDate = day
        scrollAnchorDate = day
    }

    
    func updateScrollAnchor(to date: Date?) {
        guard let date else { return }
        scrollAnchorDate = calendar.startOfDay(for: date)
    }

   

    func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "EEE" // Mon, Tue, ...
        return formatter.string(from: date)
    }

    func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }

    
    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: scrollAnchorDate)
    }

    func timeLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

   

    private static func weekPages(
        around date: Date,
        monthsBefore: Int,
        monthsAfter: Int,
        calendar: Calendar
    ) -> [WeekPage] {
        guard
            let rangeStart = calendar.date(byAdding: .month, value: -monthsBefore, to: date),
            let rangeEnd = calendar.date(byAdding: .month, value: monthsAfter, to: date),
            let startWeek = calendar.dateInterval(of: .weekOfYear, for: rangeStart),
            let endWeek = calendar.dateInterval(of: .weekOfYear, for: rangeEnd)
        else {
            return []
        }

        var pages: [WeekPage] = []
        var weekStart = calendar.startOfDay(for: startWeek.start)
        let lastWeekStart = calendar.startOfDay(for: endWeek.start)

        while weekStart <= lastWeekStart {
            let days = (0..<7).compactMap {
                calendar.date(byAdding: .day, value: $0, to: weekStart)
            }
            pages.append(WeekPage(id: weekStart, days: days))
            guard let nextWeekStart = calendar.date(byAdding: .day, value: 7, to: weekStart) else { break }
            weekStart = nextWeekStart
        }
        return pages
    }
}

