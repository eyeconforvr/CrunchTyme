//
//  TasksContainer.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI
import SwiftData

struct TasksContainer: View {
    
    @Environment(\.modelContext) private var context
    @State var taskselection: TaskSelectionSection = .toDo
    
    @Query private var tasks: [Task]
    
    var filteredTasks: [Task] {
        tasks.filter { task in
            switch taskselection {
            case .toDo:
                return !task.isCompleted
            case .completed:
                return task.isCompleted
            case .today:
                return Calendar.current.isDateInToday(task.dueDate)
            case .upcoming:
                return (task.dueDate > Date.now) && (!task.isCompleted)
            }
        }
    }

    var viewModel : TaskViewModel
    
    var body: some View {
        
        
        
        VStack
        {
            Text("Tasks")
                .padding(.leading, 5)
                .padding(.top, 10)
                .font(Font.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TaskTypeSelector{ selection in
                 taskselection = selection
                
            }
            
            
            List{
                
                ForEach(filteredTasks){ task in
                    
                    TaskItem(task: task){ task in
                        task.isCompleted.toggle()
                    }
                    
                }.onDelete{ indexSet in
                    for index in indexSet{
                        let itemsToDelete = tasks[index]
                        viewModel.deleteTask(itemsToDelete, context: context)
                    }
                    
                }
                .listRowBackground(Color.white)
                .lineLimit(1)
                .listRowBackground(Color.white)
                .alignmentGuide(.listRowSeparatorLeading) { d in
                                   return 0
                               }
                               .alignmentGuide(.listRowSeparatorTrailing) { d in
                                   return d[.trailing]
                               }
                
                
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
    List{
        
        ForEach(0..<10){
           Text("Trying to style list item \($0)")
        }
            
        }
        .listRowBackground(Color.white)
        .listRowSeparator(.hidden)
        
    
}
