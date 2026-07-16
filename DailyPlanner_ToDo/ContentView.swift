//
//  ContentView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import SwiftUI

struct ContentView: View
{
    var taskViewModel = TaskViewModel()
    var body: some View {
        
        TaskView(taskViewModel: taskViewModel)
    }
}

#Preview {
    ContentView()
}
