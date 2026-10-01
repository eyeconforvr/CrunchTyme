//
//  CalendarTask.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/12.
//

import Foundation

extension Task: CalendarTask {
    var date: Date { dueDate }
    var notes: String { taskdescription }
}
