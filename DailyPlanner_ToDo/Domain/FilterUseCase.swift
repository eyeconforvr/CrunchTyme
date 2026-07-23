//
//  FilterUseCase.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/22.
//

import Foundation

protocol FilterUseCaseProtocol {
    func filterTasksByCategory(unfilteredTasks : [Task], taskselection: TaskSelectionSection) -> [Task]
}

enum TaskSelectionSection: String, CaseIterable{
    case toDo = "To Do"
    case completed = "Completed"
    case today = "Today"
    case upcoming = "Upcoming"
}


class FilterUseCase : FilterUseCaseProtocol {
    
    
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
