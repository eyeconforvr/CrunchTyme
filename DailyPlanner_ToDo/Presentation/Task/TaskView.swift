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
                    
//                    HStack(){
//                        Spacer()
//                        
//                        
//                    }.frame(maxWidth: .infinity)
                    
                   
                    Spacer()
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                    .navigationBarTitle("Hello AJ!").foregroundColor(Color("Text"))
                    .navigationBarItems(leading: EditButton(),
                                                trailing:
                    Button(action: {
                        isSheetPresented = true
                    }) {
                        Circle()
                            .foregroundColor(Color("Background"))
    
                            .overlay(
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .renderingMode(.original)
                                    .font(.title)
                                    .frame(alignment: .center)
                            )
                    }
                    )
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
