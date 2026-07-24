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



@Observable
class TaskViewModel {
    
    var taskselection: TaskSelectionSection = .toDo
    
    private let taskFilterer : TaskFiltering
    
    init(filterProtocol: TaskFiltering, isFiltered : Bool = false) {
        self.taskFilterer = filterProtocol
    }
    
    func filterTasks(_ tasks: [Task]) -> [Task] {
        taskFilterer.filter(tasks, by: taskselection)
    }
    
    // Create Tasks
    
    func addTask(title: String, description: String, dueDate: Date, context : ModelContext)
    {
        // create task
        do {
            let task = Task(title: title, description: description, isCompleted: false, dueDate: dueDate)
            
            context.insert(task)
            
            try context.save()
            
        }
        catch
        {
            debugPrint(error.localizedDescription)
        }
        
        
    }
    
    // Delete task
    
    func deleteTask(_ task: Task , context : ModelContext)
    {
        context.delete(task)
        try? context.save()
        
        
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
