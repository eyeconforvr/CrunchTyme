//
//  TaskModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/15.
//

import Foundation
import SwiftData

@Model
class Task : Identifiable {
    
    var id : String
    var taskdescription: String
    var title : String
    var isCompleted : Bool
    var dueDate : Date
    
    init(title: String, description: String,  isCompleted: Bool, dueDate: Date) {
        self.id = UUID().uuidString
        self.taskdescription = description
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
    
}
