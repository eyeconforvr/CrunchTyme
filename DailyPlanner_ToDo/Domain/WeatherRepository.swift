//
//  WeatherRepository.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

struct WeatherRepository: WeatherRepositoryProtocol {
    
    let weatherService : WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func getWeather(for city: String) async throws -> WeatherModel {
        let weatherService = try await weatherService.getWeather(for: city)
        return WeatherMapper.map(from: weatherService)
    }
    
    
   
}
