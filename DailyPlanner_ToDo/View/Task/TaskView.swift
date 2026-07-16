//
//  TaskView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import SwiftUI

struct TaskView: View {
    
    @State private var isSheetPresented = false
    var taskViewModel : TaskViewModel
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading){
                
                WeatherTray().frame(alignment: .topLeading).padding(.leading, 6).padding(.top, 5)
                
                Text("What's the gameplan today?").frame(maxWidth:.infinity,alignment: .leading).font(.headline).padding(.top, 10).padding(.leading,15)
                
                
                TasksContainer()
                
                HStack(){
                    Spacer()
                    Button(action: {
                        isSheetPresented = true
                    }) {
                        Circle()
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.trailing, 15)
                    
                }.frame(maxWidth: .infinity)
                    .task {
                        do {
                            let  weather = try await WeatherService().getWeather(for: "London")
                            debugPrint(weather)
                                       } catch {
                                           print("Error fetching weather: \(error)")
                                       }
                    }
                
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .navigationBarTitle("Hello AJ!")
                .sheet(isPresented: $isSheetPresented) {
                            AddTaskView()
                        .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                        }
            
        }.background()
        
    }
}


#Preview {
//    TaskView()
}
