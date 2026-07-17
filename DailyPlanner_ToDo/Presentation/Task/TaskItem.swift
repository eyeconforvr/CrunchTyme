//
//  TaskItem.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI

struct TaskItem: View {
    
   
    
    let task : Task
    var isCompleted : (Task) -> Void
    
    var body: some View {
        ZStack{
            
            HStack{
                
                Image(systemName: task.isCompleted ? "checkmark.circle" : "circle").frame(alignment:.leading).onTapGesture {
                    isCompleted(task)
                }
                Text(task.title).frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
            }
            
        }.frame(maxWidth: .infinity)
            .cornerRadius(15)
            
    }
}

#Preview {
    var task = Task( title: "Example of a task", description: "Blah blah blah", isCompleted: false, dueDate: Date())
    TaskItem(task: task){_ in }
}
