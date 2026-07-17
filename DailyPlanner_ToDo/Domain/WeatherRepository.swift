//
//  WeatherRepository.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

struct WeatherRepository: WeatherRepositoryProtocol {
    
    let weatherResponse : WeatherServiceProtocol
    
    init(weatherResponse: WeatherServiceProtocol) {
        self.weatherResponse = weatherResponse
    }
    
    func getWeather(for city: String) async throws -> WeatherModel {
        let weatherResponse = try await weatherResponse.getWeather(for: city)
        return WeatherMapper.map(from: weatherResponse )
    }
    
    
   
}
