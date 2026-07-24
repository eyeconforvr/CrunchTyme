//
//  WeatherMapper.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

// TODO: GET SPECIFIC FORECAST FOR DAY
// TODO: CREATE AN ENUM THAT HAS ALL WEATHER CONDITIONS, USE ENUM TO DO SWITCH CASE FOR ICONS





struct WeatherMapper
{
    private static let icons: [String: String] = [
        "Sunny": "sun.max.fill",
        "Clear": "moon.stars.fill",
        "Partly cloudy": "cloud.sun.fill",
        "Cloudy": "cloud.fill",
        "Overcast": "smoke.fill",
        "Mist": "cloud.fog.fill",
        "Fog": "cloud.fog.fill",
        "Freezing fog": "cloud.fog.fill",
        "Light rain": "cloud.rain.fill",
        "Moderate rain": "cloud.rain.fill",
        "Heavy rain": "cloud.heavyrain.fill",
        "Light drizzle": "cloud.drizzle.fill",
        "Light snow": "cloud.snow.fill",
        "Moderate snow": "snow",
        "Heavy snow": "snowflake",
        "Blizzard": "wind.snow"
    ]
    
    static func map(from : WeatherResponse) -> WeatherModel
    {
        WeatherModel(
            sunrise: from.forecast.forecastday.first?.astro.sunrise ?? "",
            sunset: from.forecast.forecastday.first?.astro.sunset ?? "",
            currentTemp: String(from.current.tempC),
            highTemp: String(from.forecast.forecastday.first?.day.maxtempC ?? 0.0),
            lowTemp: String(from.forecast.forecastday.first?.day.mintempC ?? 0.0),
            icon: createIcon(condition: from.current.condition.text),
            condition: from.current.condition.text
        )
    }
    
    private static func createIcon(condition: String) -> String {
        icons[condition] ?? "cloud"
    }
}
