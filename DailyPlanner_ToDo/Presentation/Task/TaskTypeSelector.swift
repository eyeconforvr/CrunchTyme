//
//  TaskTypeSelector.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/15.
//

import SwiftUI

enum TaskSelectionSection: String, CaseIterable{
    case toDo = "To Do"
    case completed = "Completed"
    case today = "Today"
    case upcoming = "Upcoming"
}


struct TaskTypeSelector: View {
    
    @State var taskselection: TaskSelectionSection = .toDo
    var selectedTask : (TaskSelectionSection) -> Void
    
    var body: some View {
        
        Picker("", selection: $taskselection){
            
            ForEach(TaskSelectionSection.allCases, id: \.self)
            {
                option in
                Text(option.rawValue)
            }
            
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.leading, 5).padding(.trailing, 5)
        .onChange(of: taskselection) { oldValue, newValue in
            selectedTask(newValue)
        }
    }
}

#Preview {
    TaskTypeSelector(){_ in}
}
