//
//  TasksContainer.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI
import SwiftData

struct TasksContainer: View {
    @Query(sort: \Task.dueDate) private var tasks: [Task]
    @Environment(\.modelContext) private var context
    
    var viewModel : TaskViewModel
    
    
    var body: some View {
        
        
        ZStack{
            
            ZStack{
                
                VStack
                {
                    Text("Tasks")
                        .padding(.leading, 5)
                        .padding(.top, 10)
                        .font(Font.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color("Text"))
                    
                    TaskTypeSelector{ selection in
                        viewModel.taskselection = selection
                    }
                    
                    
                    
                    List{
                        
                        
                        ForEach(viewModel.filterTasks(tasks), id: \.self){ task in
                            
                            TaskItem(task: task){ task in
                                task.isCompleted.toggle()
                            }
                            
                        }
                        .onMove(perform: moveTask)
                        .onDelete{ indexSet in
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
                        
                        
                    }.scrollContentBackground(.hidden)
                    
                    Spacer()
                }.padding(10)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Container"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20).strokeBorder(Color("Border"), lineWidth: 1)
            )
            .onAppear{
//                viewModel.fetchTasks(context: context)
            }
        }.padding(10)
    }
    
    func moveTask(from: IndexSet, to: Int) {
//        tasks.move(fromOffsets: from, toOffset: to)
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
