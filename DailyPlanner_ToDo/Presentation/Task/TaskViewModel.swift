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
    
    var tasks: [Task] = []
    var filteredTasks : [Task] = []
    var displayedTasks : [Task] = []
    var isFiltered: Bool

    var taskselection: TaskSelectionSection = .toDo
    
    private let filterProtocol : FilterUseCaseProtocol
    
    init(filterProtocol: FilterUseCaseProtocol, isFiltered : Bool = false) {
        self.filterProtocol = filterProtocol
        self.isFiltered = isFiltered
    }

    func fetchTasks(context : ModelContext) {
            let descriptor = FetchDescriptor<Task>(
                sortBy: [SortDescriptor(\.dueDate, order: .reverse)]
            )
        
            
            do {
                self.tasks = try context.fetch(descriptor)
                
            
            } catch {
                print("Failed to fetch items: \(error.localizedDescription)")
            }
    }
    
    func filterTasks()
    {
        self.filteredTasks = self.tasks
        self.filteredTasks = filterProtocol.filterTasksByCategory(unfilteredTasks: self.filteredTasks, taskselection: self.taskselection)
    }
    
    func isFilteredTasks() -> Bool
    {
        if self.taskselection == .toDo
        {
            self.isFiltered = false
        }
        else
        {
            self.isFiltered = true
        }
        
        return self.isFiltered
    }
    
    func fetchTasks() -> [Task]
    {
        if self.isFilteredTasks(){
            self.displayedTasks = self.filteredTasks
        }
        else
        {
            self.displayedTasks = self.tasks
        }
        
        return self.displayedTasks
    }
    
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
