//
//  TaskItem.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI

struct TaskItem: View {
    
//    @Composable fun TaskItem( NAME : STRING, description, String){}
   
//    let task : TaskModel
    
    var body: some View {
        ZStack{
            
            HStack{
                
                Image(systemName: "circle").frame(alignment:.leading)
                Text("Task name").frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
            }.padding(15)
            
        }.frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding(15)
    }
}

#Preview {
    TaskItem()
}
