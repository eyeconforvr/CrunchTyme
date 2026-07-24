//
//  FilterUseCase.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/22.
//

import Foundation

protocol TaskFiltering {
    func filter(_ tasks: [Task], by category: TaskSelectionSection) -> [Task]
    func filterTasksByCategory(unfilteredTasks : [Task], taskselection: TaskSelectionSection) -> [Task]
}

enum TaskSelectionSection: String, CaseIterable{
    case toDo = "To Do"
    case completed = "Completed"
    case today = "Today"
    case upcoming = "Upcoming"
}


class FilterUseCase : TaskFiltering {
    
    func filter(_ tasks: [Task], by category: TaskSelectionSection) -> [Task] {
        var filteredTasks: [Task] {
            
            switch category {
            case .toDo:
                return tasks
            case .completed:
                return tasks.filter{$0.isCompleted}
            case .today:
                return tasks.filter{Calendar.current.isDateInToday($0.dueDate)}
            case .upcoming:
                return tasks.filter{($0.dueDate > Date.now) && (!$0.isCompleted)}
            }
        }
        
        return filteredTasks
    }
    
    func filterTasksByCategory(unfilteredTasks : [Task], taskselection: TaskSelectionSection) -> [Task] {
        var filteredTasks: [Task] {
            
            switch taskselection {
            case .toDo:
                return unfilteredTasks
            case .completed:
                return unfilteredTasks.filter{$0.isCompleted}
            case .today:
                return  unfilteredTasks.filter{Calendar.current.isDateInToday($0.dueDate)}
            case .upcoming:
                return unfilteredTasks.filter{($0.dueDate > Date.now) && (!$0.isCompleted)}
            }
        }
        
        
        return filteredTasks
        
    }
    
}
