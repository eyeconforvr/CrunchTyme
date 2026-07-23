//
//  ContentView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import SwiftUI

struct ContentView: View
{
    var taskViewModel = TaskViewModel(filterProtocol: FilterUseCase())
    var weatherViewModel = WeatherViewModel(weatherRepository: WeatherRepository(weatherService: WeatherService()))
    var body: some View {
        
        TaskView(taskViewModel: taskViewModel, weatherViewModel: weatherViewModel)
    }
}

#Preview {
    ContentView()
}
