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
    var weatherViewModel : WeatherViewModel
    
    var body: some View {
        
        NavigationStack{
            
            
                VStack(alignment: .leading){
                    
                    MainWeatherView(viewModel: weatherViewModel).frame(alignment: .topLeading).padding(.leading, 10).padding(.top, 5).padding(.trailing, 10)
                    
                    
                    Text("What's the gameplan today?").frame(maxWidth:.infinity,alignment: .leading).font(.headline).padding(.top, 10).padding(.leading,15).foregroundColor(Color("Text"))
                    
                    
                    TasksContainer(viewModel: taskViewModel)
                    
                    HStack(){
                        Spacer()
                        Button(action: {
                            isSheetPresented = true
                        }) {
                            Circle()
                                .fill(Color("Button"))
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                        }
                        .padding(.trailing, 15)
                        
                    }.frame(maxWidth: .infinity)
                    
                    
                    Spacer()
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                    .navigationBarTitle("Hello AJ!").foregroundColor(Color("Text"))
                    .sheet(isPresented: $isSheetPresented) {
                        AddTaskView()
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
            
            
        }.background()
        
    }
}


#Preview {
    TaskView(taskViewModel: TaskViewModel(filterProtocol: FilterUseCase()), weatherViewModel: WeatherViewModel(weatherRepository: WeatherRepository(weatherService: WeatherService())))
}
