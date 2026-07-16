//
//  DailyPlanner_ToDoApp.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import SwiftUI
import SwiftData

@main
struct DailyPlanner_ToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Task.self)
    }
}
