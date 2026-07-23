//
//  AddTaskView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/15.
//

import SwiftUI
import SwiftData


struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @State var date = Date()
    @State var showDatePicker: Bool = false
    @State private var taskname: String = ""
    @State private var taskdescription: String = ""
    
    @Environment(\.modelContext) private var context
    @State private var viewModel = TaskViewModel(filterProtocol: FilterUseCase())
    
    
    var body: some View {
        
        
        ZStack{
            
            VStack(alignment: .leading){
                
                HStack(alignment : .center){
                    Text("New Task")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 5).padding(.bottom, 10)
                }.frame(maxWidth : .infinity)
                
               
                VStack{
                    
                    GroupBox{
                        Text("Task Name").frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center)).font(.caption)
                        TextField(
                            "Paint the house",
                            text: $taskname
                        )
                    }
                    
                    GroupBox{
                        Text("Description").frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center)).font(.caption)
                        TextField(
                            "Paint the walls in the kitchen",
                            text: $taskdescription, axis: .vertical
                        ).lineLimit(1...5)
                        
                        
                    }
                    
                    HStack{
                        DatePicker("Due Date", selection: $date, in: Date.now...).padding(.bottom, 10)
                    }.padding(10)
                    
                }.padding(15).padding(.top, 20)
                
                Spacer()
                
                HStack(alignment: .center){
                    
                    Button(action: {
                        viewModel.addTask(title: taskname, description: taskdescription, dueDate: date, context: context)
                        dismiss()
                        
                    } ,
                           label:
                            {
                        Text("Save")
                    }
                    )
                }.frame(maxWidth: .infinity)
                
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding(20)
    }
}


#Preview {
//    var taskViewModel : TaskViewModel
//    AddTaskView(taskViewModel)
}
