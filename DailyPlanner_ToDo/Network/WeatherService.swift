//
//  WeatherService.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import Foundation
import Combine

private enum APIKEY {
    static let key = "0ba33315517d4c50b2461546261407" // put this in the info.plist
}

class WeatherService {

    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(for city: String) async throws -> WeatherResponse {
        guard let url = URL(string: "http://api.weatherapi.com/v1/current.json?key=0ba33315517d4c50b2461546261407&q=London&aqi=no") else {
            fatalError("Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(WeatherResponse.self, from: data)

        
    }
}
