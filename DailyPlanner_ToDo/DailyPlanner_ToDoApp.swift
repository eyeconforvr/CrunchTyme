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
    @State private var locationService = LocationService()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    RootTabView()
                } else {
                    OnboardingView()
                }
            }
            .environment(locationService)   
        }.modelContainer(for: Task.self)
    }
}
