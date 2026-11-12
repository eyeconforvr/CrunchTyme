//
//  SharedWeatherData.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import Foundation

struct SharedWeatherData: Codable {
    let currentTemp: String
    let highTemp: String
    let lowTemp: String
    let condition: String
    let icon: String
    let sunrise: String
    let sunset: String
    let dailyForecast: [SharedDailyForecast]
    var locationName: String?
    var timeZoneIdentifier: String?
    var sunriseDate: Date?
    var sunsetDate: Date?
}

struct SharedDailyForecast: Codable {
    let day: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
}
