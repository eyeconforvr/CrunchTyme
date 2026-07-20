//
//  TaskViewModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/15.
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

//enum TaskSelectionSection: String, CaseIterable{
//    case toDo = "To Do"
//    case completed = "Completed"
//    case today = "Today"
//    case upcoming = "Upcoming"
//}


@Observable
class TaskViewModel {
    

//    @Binding var taskselection: TaskSelectionSection
//    
//        
//    init(taskselection: TaskSelectionSection = .toDo) {
//        self.taskselection = taskselection
//    }

    //@Query private var tasks: [Task]

    
    
//    // Read all tasks
//    @Query private var tasks : [Task]
//    
//    func readTask(context: ModelContext) -> [Task]
//    {
        
//        return tasks
//    }
    
    
    
    // Create Tasks
    
    func addTask(title: String, description: String, dueDate: Date, context : ModelContext)
    {
        // create task
        
        let task = Task(title: title, description: description, isCompleted: false, dueDate: dueDate)
        
        context.insert(task)
        
        try? context.save()
        
    }
    
    // Delete task
    
    func deleteTask(_ task: Task , context : ModelContext)
    {
        context.delete(task)
    }
    
    
    // Update Task
    
    func updateTask(_ task: Task, title: String, description: String, dueDate: Date, context : ModelContext)
    {
        task.title = title
        task.taskdescription = description
        task.dueDate = dueDate
        task.isCompleted = false
        
        try? context.save()
    }
    
    
}
