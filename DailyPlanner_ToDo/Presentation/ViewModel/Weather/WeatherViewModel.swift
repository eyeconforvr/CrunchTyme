//
//  WeatherViewModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import Foundation
import Combine

@Observable
class WeatherViewModel {
    
    
    private let weatherService = WeatherRepository(weatherResponse: WeatherService())
    
    var weather: WeatherModel = WeatherModel()
    
    func fetchWeather(city: String) async throws {
        
        weather = try await weatherService.getWeather(for: city)
    }
    
}
