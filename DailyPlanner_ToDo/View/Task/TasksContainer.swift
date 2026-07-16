//
//  TasksContainer.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI
import SwiftData

struct TasksContainer: View {
    
    @Query var tasks: [Task]
    
    var body: some View {
        
        
        
        VStack
        {
            Text("Tasks")
                .padding(.leading, 5)
                .padding(.top, 10)
                .font(Font.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TaskTypeSelector()
            
            List(tasks) { task in
                
                Text(task.title)
                
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .padding(10)
        .cornerRadius(20)
    }
}

#Preview {
    TasksContainer()
}
