//
//  WeatherViewModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import Foundation
import Combine

// TODO: IMPLEMENT PROPER DEPEDENCY INJECTION

class WeatherViewModel: ObservableObject {
    
    
    private let weatherService = WeatherRepository(weatherResponse: WeatherService())
    
    @Published var weather: WeatherModel?
    
    func fetchWeather(city: String) async throws {
        
        self.weather = try await weatherService.getWeather(for: city)
    }
    
}
